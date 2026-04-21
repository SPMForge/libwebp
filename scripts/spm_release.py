#!/usr/bin/env python3

from __future__ import annotations

import argparse
import dataclasses
import json
import os
import plistlib
import re
import shutil
import subprocess
import sys
import tempfile
import textwrap
import zipfile
from pathlib import Path
from typing import Iterable


if sys.version_info < (3, 10):
    raise SystemExit("spm_release.py requires Python 3.10 or newer.")


STABLE_TAG_PATTERN = re.compile(r"^v(\d+)\.(\d+)\.(\d+)$")
PACKAGE_RELEASE_TAG_PATTERN = re.compile(r"^v(\d+)\.(\d+)\.(\d+)-alpha\.(\d+)$")
CHECKSUM_PATTERN = re.compile(r"^[0-9a-f]{64}$")
RELEASE_METADATA_ASSETS: tuple[str, ...] = ("checksums.json",)
REPO_ROOT = Path(__file__).resolve().parents[1]
SOURCE_ACQUISITION_CONFIG_PATH = REPO_ROOT / "config" / "source-acquisition.json"


@dataclasses.dataclass(frozen=True)
class SourceAcquisitionConfig:
    strategy: str
    upstream_repository_url: str
    upstream_tag_namespace: str
    upstream_tag_refspec: str
    source_snapshot_directory: str

    def upstream_ref_for_tag(self, tag: str) -> str:
        require_stable_tag(tag)
        return f"{self.upstream_tag_namespace}/{tag}"


@dataclasses.dataclass(frozen=True)
class CompilerWrapperPaths:
    cc: Path
    cxx: Path


@dataclasses.dataclass(frozen=True)
class ArtifactDefinition:
    target_name: str
    cmake_target: str
    library_name: str
    public_headers: tuple[str, ...]
    linked_binary_dependencies: tuple[str, ...]
    consumer_source: str

    def archive_name_for_tag(self, tag: str) -> str:
        return f"{self.target_name}-{tag}.xcframework.zip"

    @property
    def xcframework_name(self) -> str:
        return f"{self.target_name}.xcframework"


@dataclasses.dataclass(frozen=True)
class ReleaseArtifact:
    target_name: str
    library_name: str
    archive_name: str
    xcframework_name: str


@dataclasses.dataclass(frozen=True)
class ReleasePublicationPlan:
    mode: str
    required_assets: tuple[str, ...]
    missing_assets: tuple[str, ...]


@dataclasses.dataclass(frozen=True)
class PlatformGroup:
    name: str
    identifier: str
    supported_platform: str
    sdk: str
    cmake_system_name: str | None
    deployment_setting: str
    minimum_version: str
    architectures: tuple[str, ...]
    expected_vtool_platform: str
    simulator: bool = False
    catalyst: bool = False
    supported_platform_variant: str | None = None
    destination: str | None = None

    @property
    def cmake_architectures(self) -> str:
        return ";".join(self.architectures)

    def build_settings(self) -> list[str]:
        settings = [
            f"SDKROOT={self.sdk}",
            f"{self.deployment_setting}={self.minimum_version}",
            f"ARCHS={' '.join(self.architectures)}",
            "ONLY_ACTIVE_ARCH=NO",
            "MERGEABLE_LIBRARY=YES",
            "CODE_SIGNING_ALLOWED=NO",
            "CODE_SIGNING_REQUIRED=NO",
            "SKIP_INSTALL=NO",
        ]
        return settings

    def to_dict(self) -> dict[str, object]:
        return {
            "name": self.name,
            "identifier": self.identifier,
            "supported_platform": self.supported_platform,
            "supported_platform_variant": self.supported_platform_variant,
            "sdk": self.sdk,
            "cmake_system_name": self.cmake_system_name,
            "deployment_setting": self.deployment_setting,
            "minimum_version": self.minimum_version,
            "architectures": list(self.architectures),
            "cmake_architectures": self.cmake_architectures,
            "expected_vtool_platform": self.expected_vtool_platform,
            "simulator": self.simulator,
            "catalyst": self.catalyst,
            "destination": self.destination,
        }


@dataclasses.dataclass(frozen=True)
class BuiltSlice:
    platform_group: PlatformGroup
    archive_path: Path
    binary_path: Path


ARTIFACT_DEFINITIONS: tuple[ArtifactDefinition, ...] = (
    ArtifactDefinition(
        target_name="WebP",
        cmake_target="webp",
        library_name="libwebp.dylib",
        public_headers=(
            "src/webp/decode.h",
            "src/webp/encode.h",
            "src/webp/types.h",
        ),
        linked_binary_dependencies=("SharpYuv",),
        consumer_source=textwrap.dedent(
            """\
            #include "webp/decode.h"
            #include "webp/encode.h"

            int main(void) {
              return (WebPGetDecoderVersion() > 0 && WebPGetEncoderVersion() > 0) ? 0 : 1;
            }
            """
        ),
    ),
    ArtifactDefinition(
        target_name="WebPDecoder",
        cmake_target="webpdecoder",
        library_name="libwebpdecoder.dylib",
        public_headers=(
            "src/webp/decode.h",
            "src/webp/types.h",
        ),
        linked_binary_dependencies=(),
        consumer_source=textwrap.dedent(
            """\
            #include "webp/decode.h"

            int main(void) {
              return WebPGetDecoderVersion() > 0 ? 0 : 1;
            }
            """
        ),
    ),
    ArtifactDefinition(
        target_name="WebPDemux",
        cmake_target="webpdemux",
        library_name="libwebpdemux.dylib",
        public_headers=(
            "src/webp/decode.h",
            "src/webp/types.h",
            "src/webp/mux_types.h",
            "src/webp/demux.h",
        ),
        linked_binary_dependencies=("WebP", "SharpYuv"),
        consumer_source=textwrap.dedent(
            """\
            #include <stdint.h>
            #include "webp/demux.h"

            int main(void) {
              const WebPDemuxer* demux = NULL;
              return WebPDemuxGetI(demux, WEBP_FF_CANVAS_WIDTH) == 0 ? 0 : 1;
            }
            """
        ),
    ),
    ArtifactDefinition(
        target_name="WebPMux",
        cmake_target="libwebpmux",
        library_name="libwebpmux.dylib",
        public_headers=(
            "src/webp/types.h",
            "src/webp/mux.h",
            "src/webp/mux_types.h",
        ),
        linked_binary_dependencies=("WebP", "SharpYuv"),
        consumer_source=textwrap.dedent(
            """\
            #include "webp/mux.h"

            int main(void) {
              WebPMux* mux = WebPMuxNew();
              if (mux == NULL) return 1;
              WebPMuxDelete(mux);
              return 0;
            }
            """
        ),
    ),
    ArtifactDefinition(
        target_name="SharpYuv",
        cmake_target="sharpyuv",
        library_name="libsharpyuv.dylib",
        public_headers=(
            "sharpyuv/sharpyuv.h",
            "sharpyuv/sharpyuv_csp.h",
        ),
        linked_binary_dependencies=(),
        consumer_source=textwrap.dedent(
            """\
            #include "sharpyuv/sharpyuv.h"
            #include "sharpyuv/sharpyuv_csp.h"

            int main(void) {
              return SharpYuvGetVersion() > 0 ? 0 : 1;
            }
            """
        ),
    ),
)


PLATFORM_GROUPS: tuple[PlatformGroup, ...] = (
    PlatformGroup(
        name="iOS",
        identifier="ios",
        supported_platform="ios",
        sdk="iphoneos",
        cmake_system_name="iOS",
        deployment_setting="IPHONEOS_DEPLOYMENT_TARGET",
        minimum_version="13.0",
        architectures=("arm64",),
        expected_vtool_platform="IOS",
        destination="generic/platform=iOS",
    ),
    PlatformGroup(
        name="iOS Simulator",
        identifier="ios-simulator",
        supported_platform="ios",
        supported_platform_variant="simulator",
        sdk="iphonesimulator",
        cmake_system_name="iOS",
        deployment_setting="IPHONEOS_DEPLOYMENT_TARGET",
        minimum_version="13.0",
        architectures=("arm64", "x86_64"),
        expected_vtool_platform="IOSSIMULATOR",
        simulator=True,
        destination="generic/platform=iOS Simulator",
    ),
    PlatformGroup(
        name="macOS",
        identifier="macos",
        supported_platform="macos",
        sdk="macosx",
        cmake_system_name=None,
        deployment_setting="MACOSX_DEPLOYMENT_TARGET",
        minimum_version="10.15",
        architectures=("arm64", "x86_64"),
        expected_vtool_platform="MACOS",
        destination="generic/platform=macOS",
    ),
    PlatformGroup(
        name="Mac Catalyst",
        identifier="mac-catalyst",
        supported_platform="ios",
        supported_platform_variant="maccatalyst",
        sdk="macosx",
        cmake_system_name=None,
        deployment_setting="IPHONEOS_DEPLOYMENT_TARGET",
        minimum_version="14.0",
        architectures=("arm64", "x86_64"),
        expected_vtool_platform="MACCATALYST",
        catalyst=True,
        destination="generic/platform=macOS,variant=Mac Catalyst",
    ),
    PlatformGroup(
        name="tvOS",
        identifier="tvos",
        supported_platform="tvos",
        sdk="appletvos",
        cmake_system_name="tvOS",
        deployment_setting="TVOS_DEPLOYMENT_TARGET",
        minimum_version="13.0",
        architectures=("arm64",),
        expected_vtool_platform="TVOS",
        destination="generic/platform=tvOS",
    ),
    PlatformGroup(
        name="tvOS Simulator",
        identifier="tvos-simulator",
        supported_platform="tvos",
        supported_platform_variant="simulator",
        sdk="appletvsimulator",
        cmake_system_name="tvOS",
        deployment_setting="TVOS_DEPLOYMENT_TARGET",
        minimum_version="13.0",
        architectures=("arm64", "x86_64"),
        expected_vtool_platform="TVOSSIMULATOR",
        simulator=True,
        destination="generic/platform=tvOS Simulator",
    ),
    PlatformGroup(
        name="watchOS",
        identifier="watchos",
        supported_platform="watchos",
        sdk="watchos",
        cmake_system_name="watchOS",
        deployment_setting="WATCHOS_DEPLOYMENT_TARGET",
        minimum_version="8.0",
        architectures=("arm64", "arm64_32"),
        expected_vtool_platform="WATCHOS",
        destination="generic/platform=watchOS",
    ),
    PlatformGroup(
        name="watchOS Simulator",
        identifier="watchos-simulator",
        supported_platform="watchos",
        supported_platform_variant="simulator",
        sdk="watchsimulator",
        cmake_system_name="watchOS",
        deployment_setting="WATCHOS_DEPLOYMENT_TARGET",
        minimum_version="8.0",
        architectures=("arm64", "x86_64"),
        expected_vtool_platform="WATCHOSSIMULATOR",
        simulator=True,
        destination="generic/platform=watchOS Simulator",
    ),
    PlatformGroup(
        name="visionOS",
        identifier="visionos",
        supported_platform="xros",
        sdk="xros",
        cmake_system_name="visionOS",
        deployment_setting="XROS_DEPLOYMENT_TARGET",
        minimum_version="1.0",
        architectures=("arm64",),
        expected_vtool_platform="VISIONOS",
        destination="generic/platform=visionOS",
    ),
    PlatformGroup(
        name="visionOS Simulator",
        identifier="visionos-simulator",
        supported_platform="xros",
        supported_platform_variant="simulator",
        sdk="xrsimulator",
        cmake_system_name="visionOS",
        deployment_setting="XROS_DEPLOYMENT_TARGET",
        minimum_version="1.0",
        architectures=("arm64", "x86_64"),
        expected_vtool_platform="VISIONOSSIMULATOR",
        simulator=True,
        destination="generic/platform=visionOS Simulator",
    ),
)


CMAKE_CONFIGURATION_ARGS: tuple[str, ...] = (
    "-DBUILD_SHARED_LIBS=ON",
    "-DWEBP_LINK_STATIC=OFF",
    "-DWEBP_BUILD_LIBWEBPMUX=ON",
    "-DWEBP_BUILD_ANIM_UTILS=OFF",
    "-DWEBP_BUILD_CWEBP=OFF",
    "-DWEBP_BUILD_DWEBP=OFF",
    "-DWEBP_BUILD_GIF2WEBP=OFF",
    "-DWEBP_BUILD_IMG2WEBP=OFF",
    "-DWEBP_BUILD_VWEBP=OFF",
    "-DWEBP_BUILD_WEBPINFO=OFF",
    "-DWEBP_BUILD_WEBPMUX=OFF",
    "-DWEBP_BUILD_EXTRAS=OFF",
    "-DWEBP_BUILD_WEBP_JS=OFF",
    "-DWEBP_BUILD_FUZZTEST=OFF",
    "-DCMAKE_XCODE_GENERATE_SCHEME=YES",
)


def require_stable_tag(tag: str) -> tuple[int, int, int]:
    match = STABLE_TAG_PATTERN.fullmatch(tag)
    if match is None:
        raise ValueError(f"Expected a stable release tag like v1.6.0, got: {tag}")
    return tuple(int(component) for component in match.groups())


def require_package_release_tag(tag: str) -> tuple[int, int, int, int]:
    match = PACKAGE_RELEASE_TAG_PATTERN.fullmatch(tag)
    if match is None:
        raise ValueError(f"Expected a package release tag like v1.6.0-alpha.1, got: {tag}")
    return tuple(int(component) for component in match.groups())


def require_package_distribution_tag(tag: str) -> str:
    if STABLE_TAG_PATTERN.fullmatch(tag) is not None:
        return tag
    if PACKAGE_RELEASE_TAG_PATTERN.fullmatch(tag) is not None:
        return tag
    raise ValueError(f"Expected a package tag like v1.6.0 or v1.6.0-alpha.1, got: {tag}")


def package_release_tag_for_upstream_tag(
    upstream_tag: str,
    *,
    channel: str = "alpha",
    sequence: int = 1,
) -> str:
    major, minor, patch = require_stable_tag(upstream_tag)
    if channel == "stable":
        if sequence != 1:
            raise ValueError("Stable package releases do not use a prerelease sequence.")
        return f"v{major}.{minor}.{patch}"
    if channel != "alpha":
        raise ValueError(f"Unsupported release channel: {channel}")
    if sequence < 1:
        raise ValueError(f"Expected alpha release sequence >= 1, got: {sequence}")
    return f"v{major}.{minor}.{patch}-alpha.{sequence}"


def package_release_tags_for_upstream_tag(
    upstream_tag: str,
    tags: Iterable[str],
) -> list[tuple[int, str]]:
    major, minor, patch = require_stable_tag(upstream_tag)
    matching_tags: list[tuple[int, str]] = []
    for raw_tag in tags:
        tag = raw_tag.strip()
        if not tag:
            continue
        match = PACKAGE_RELEASE_TAG_PATTERN.fullmatch(tag)
        if match is None:
            continue
        candidate_major, candidate_minor, candidate_patch, sequence = (
            int(component) for component in match.groups()
        )
        if (candidate_major, candidate_minor, candidate_patch) != (major, minor, patch):
            continue
        matching_tags.append((sequence, tag))

    matching_tags.sort()
    return matching_tags


def latest_package_release_tag_for_upstream_tag(
    upstream_tag: str,
    tags: Iterable[str],
) -> str | None:
    matching_tags = package_release_tags_for_upstream_tag(upstream_tag, tags)
    if not matching_tags:
        return None
    return matching_tags[-1][1]


def next_package_release_tag_for_upstream_tag(
    upstream_tag: str,
    tags: Iterable[str],
) -> str:
    matching_tags = package_release_tags_for_upstream_tag(upstream_tag, tags)
    next_sequence = matching_tags[-1][0] + 1 if matching_tags else 1
    return package_release_tag_for_upstream_tag(upstream_tag, sequence=next_sequence)


def select_latest_stable_tag(tags: Iterable[str]) -> str:
    stable_tags: list[tuple[tuple[int, int, int], str]] = []
    for raw_tag in tags:
        tag = raw_tag.strip()
        if not tag:
            continue
        match = STABLE_TAG_PATTERN.fullmatch(tag)
        if match is None:
            continue
        stable_tags.append((tuple(int(component) for component in match.groups()), tag))

    if not stable_tags:
        raise ValueError("No stable release tag found in the provided input.")

    stable_tags.sort(key=lambda item: item[0], reverse=True)
    return stable_tags[0][1]


def release_artifacts_for_tag(tag: str) -> list[ReleaseArtifact]:
    require_package_distribution_tag(tag)
    return [
        ReleaseArtifact(
            target_name=definition.target_name,
            library_name=definition.library_name,
            archive_name=definition.archive_name_for_tag(tag),
            xcframework_name=definition.xcframework_name,
        )
        for definition in ARTIFACT_DEFINITIONS
    ]


def required_release_asset_names(tag: str) -> tuple[str, ...]:
    artifacts = release_artifacts_for_tag(tag)
    return tuple(
        [*(artifact.archive_name for artifact in artifacts), *RELEASE_METADATA_ASSETS]
    )


def plan_release_publication(
    *,
    tag: str,
    remote_tag_exists: bool,
    release_asset_names: Iterable[str],
) -> ReleasePublicationPlan:
    required_assets = required_release_asset_names(tag)
    published_assets = {asset_name for asset_name in release_asset_names if asset_name}
    missing_assets = tuple(asset_name for asset_name in required_assets if asset_name not in published_assets)
    if not remote_tag_exists:
        return ReleasePublicationPlan(
            mode="fresh",
            required_assets=required_assets,
            missing_assets=required_assets,
        )
    if missing_assets:
        return ReleasePublicationPlan(
            mode="repair",
            required_assets=required_assets,
            missing_assets=missing_assets,
        )
    return ReleasePublicationPlan(
        mode="skip",
        required_assets=required_assets,
        missing_assets=(),
    )


def render_package_swift(
    *,
    owner: str,
    repository: str,
    tag: str,
    checksums: dict[str, str],
) -> str:
    require_package_distribution_tag(tag)
    if not owner:
        raise ValueError("Owner must not be empty.")
    if not repository:
        raise ValueError("Repository must not be empty.")

    artifact_map = {artifact.target_name: artifact for artifact in release_artifacts_for_tag(tag)}
    missing_checksums = sorted(set(artifact_map) - set(checksums))
    if missing_checksums:
        raise ValueError(
            "Missing checksum values for required binary targets: "
            + ", ".join(missing_checksums)
        )

    invalid_checksums = sorted(
        target_name
        for target_name, checksum in checksums.items()
        if target_name in artifact_map and CHECKSUM_PATTERN.fullmatch(checksum) is None
    )
    if invalid_checksums:
        raise ValueError(
            "Invalid SHA-256 checksum values for binary targets: "
            + ", ".join(invalid_checksums)
        )

    product_lines = [
        "        .library("
        + f'name: "{definition.target_name}", '
        + "targets: ["
        + ", ".join(f'"{target_name}"' for target_name in swiftpm_product_targets(definition))
        + "]"
        + ")"
        for definition in ARTIFACT_DEFINITIONS
    ]
    target_lines = [
        "\n".join(
            [
                "        .binaryTarget(",
                f'            name: "{artifact.target_name}",',
                f'            url: "https://github.com/{owner}/{repository}/releases/download/{tag}/{artifact.archive_name}",',
                f'            checksum: "{checksums[artifact.target_name]}"',
                "        )",
            ]
        )
        for artifact in artifact_map.values()
    ]
    products_block = ",\n".join(product_lines)
    targets_block = ",\n".join(target_lines)

    return "\n".join(
        [
            "// swift-tools-version: 5.9",
            "import PackageDescription",
            "",
            "let package = Package(",
            '    name: "libwebp",',
            "    platforms: [",
            "        .iOS(.v13),",
            "        .macOS(.v10_15),",
            "        .tvOS(.v13),",
            "        .watchOS(.v8),",
            "        .visionOS(.v1)",
            "    ],",
            "    products: [",
            products_block,
            "    ],",
            "    targets: [",
            targets_block,
            "    ]",
            ")",
            "",
        ]
    )


def swift_string_literal(value: str) -> str:
    return json.dumps(value)


def render_local_binary_package_swift(
    *,
    package_name: str,
    xcframework_paths: dict[str, Path],
) -> str:
    if not package_name:
        raise ValueError("Package name must not be empty.")

    missing_targets = sorted(
        definition.target_name
        for definition in ARTIFACT_DEFINITIONS
        if definition.target_name not in xcframework_paths
    )
    if missing_targets:
        raise ValueError(
            "Missing XCFramework paths for binary targets: " + ", ".join(missing_targets)
        )

    product_lines = [
        "        .library("
        + f'name: "{definition.target_name}", '
        + "targets: ["
        + ", ".join(f'"{target_name}"' for target_name in swiftpm_product_targets(definition))
        + "]"
        + ")"
        for definition in ARTIFACT_DEFINITIONS
    ]
    target_lines = [
        "\n".join(
            [
                "        .binaryTarget(",
                f'            name: "{definition.target_name}",',
                "            path: "
                + swift_string_literal(str(xcframework_paths[definition.target_name]))
                ,
                "        )",
            ]
        )
        for definition in ARTIFACT_DEFINITIONS
    ]

    return "\n".join(
        [
            "// swift-tools-version: 5.9",
            "import PackageDescription",
            "",
            "let package = Package(",
            f"    name: {swift_string_literal(package_name)},",
            "    platforms: [",
            "        .iOS(.v13),",
            "        .macOS(.v10_15),",
            "        .tvOS(.v13),",
            "        .watchOS(.v8),",
            "        .visionOS(.v1)",
            "    ],",
            "    products: [",
            ",\n".join(product_lines),
            "    ],",
            "    targets: [",
            ",\n".join(target_lines),
            "    ]",
            ")",
            "",
        ]
    )


def render_spm_consumer_package_swift(
    *,
    binary_package_name: str,
    binary_package_path: str,
) -> str:
    if not binary_package_name:
        raise ValueError("Binary package name must not be empty.")
    if not binary_package_path:
        raise ValueError("Binary package path must not be empty.")

    dependency_lines = [
        f'                .product(name: "{definition.target_name}", package: "{binary_package_name}")'
        for definition in ARTIFACT_DEFINITIONS
    ]

    return "\n".join(
        [
            "// swift-tools-version: 5.9",
            "import PackageDescription",
            "",
            "let package = Package(",
            '    name: "libwebp-consumer",',
            "    platforms: [",
            "        .macOS(.v10_15)",
            "    ],",
            "    dependencies: [",
            "        .package("
            + f"name: {swift_string_literal(binary_package_name)}, "
            + f"path: {swift_string_literal(binary_package_path)}"
            + ")",
            "    ],",
            "    targets: [",
            "        .executableTarget(",
            '            name: "SpmSmokeConsumer",',
            "            dependencies: [",
            ",\n".join(dependency_lines),
            "            ]",
            "        )",
            "    ]",
            ")",
            "",
        ]
    )


def render_spm_consumer_sources() -> dict[str, str]:
    return {
        "App.swift": "\n".join(
            [
                "@main",
                "struct SpmSmokeConsumer {",
                "    static func main() {",
                "        runWebPProbe()",
                "        runWebPDecoderProbe()",
                "        runWebPDemuxProbe()",
                "        runWebPMuxProbe()",
                "        runSharpYuvProbe()",
                "    }",
                "}",
                "",
            ]
        ),
        "WebPProbe.swift": "\n".join(
            [
                "import WebP",
                "",
                "func runWebPProbe() {",
                "    precondition(WebPGetDecoderVersion() > 0)",
                "    precondition(WebPGetEncoderVersion() > 0)",
                "}",
                "",
            ]
        ),
        "WebPDecoderProbe.swift": "\n".join(
            [
                "import WebPDecoder",
                "",
                "func runWebPDecoderProbe() {",
                "    precondition(WebPGetDecoderVersion() > 0)",
                "}",
                "",
            ]
        ),
        "WebPDemuxProbe.swift": "\n".join(
            [
                "import WebPDemux",
                "",
                "func runWebPDemuxProbe() {",
                "    precondition(WebPDemuxGetI(nil, WEBP_FF_CANVAS_WIDTH) == 0)",
                "}",
                "",
            ]
        ),
        "WebPMuxProbe.swift": "\n".join(
            [
                "import WebPMux",
                "",
                "func runWebPMuxProbe() {",
                "    guard let mux = WebPMuxNew() else {",
                '        fatalError("Expected WebPMuxNew to return a mux instance")',
                "    }",
                "    WebPMuxDelete(mux)",
                "}",
                "",
            ]
        ),
        "SharpYuvProbe.swift": "\n".join(
            [
                "import SharpYuv",
                "",
                "func runSharpYuvProbe() {",
                "    precondition(SharpYuvGetVersion() > 0)",
                "}",
                "",
            ]
        ),
    }


def validate_checksums_payload(raw_checksums: object) -> dict[str, str]:
    if not isinstance(raw_checksums, dict):
        raise ValueError("Checksum JSON must be an object mapping target names to checksum strings.")

    invalid_entries = sorted(
        str(target_name)
        for target_name, checksum in raw_checksums.items()
        if not isinstance(target_name, str) or not isinstance(checksum, str)
    )
    if invalid_entries:
        raise ValueError(
            "Checksum JSON values must be string pairs keyed by target name. Invalid entries: "
            + ", ".join(invalid_entries)
        )

    return raw_checksums


def build_plan_payload() -> dict[str, object]:
    return {
        "platform_groups": [group.to_dict() for group in PLATFORM_GROUPS],
        "artifacts": [
            {
                "target_name": definition.target_name,
                "cmake_target": definition.cmake_target,
                "xcframework_name": definition.xcframework_name,
                "library_name": definition.library_name,
                "public_headers": list(definition.public_headers),
            }
            for definition in ARTIFACT_DEFINITIONS
        ],
    }


def load_source_acquisition_config(path: Path = SOURCE_ACQUISITION_CONFIG_PATH) -> SourceAcquisitionConfig:
    raw_config = json.loads(path.read_text(encoding="utf-8"))
    if not isinstance(raw_config, dict):
        raise ValueError("Source acquisition config must be a JSON object.")

    strategy = str(raw_config.get("strategy", "")).strip()
    upstream_repository_url = str(raw_config.get("upstream_repository_url", "")).strip()
    upstream_tag_namespace = str(raw_config.get("upstream_tag_namespace", "")).strip()
    upstream_tag_refspec = str(raw_config.get("upstream_tag_refspec", "")).strip()
    source_snapshot_directory = str(raw_config.get("source_snapshot_directory", "")).strip()

    if strategy != "git-tag-export":
        raise ValueError("Unsupported source acquisition strategy. Expected git-tag-export.")
    if not upstream_repository_url:
        raise ValueError("Source acquisition config is missing upstream_repository_url.")
    if not upstream_tag_namespace.startswith("refs/"):
        raise ValueError("Source acquisition config upstream_tag_namespace must start with refs/.")
    if not upstream_tag_refspec.startswith("refs/tags/") or ":" not in upstream_tag_refspec:
        raise ValueError(
            "Source acquisition config upstream_tag_refspec must map refs/tags/* into a dedicated namespace."
        )
    if not source_snapshot_directory:
        raise ValueError("Source acquisition config is missing source_snapshot_directory.")

    return SourceAcquisitionConfig(
        strategy=strategy,
        upstream_repository_url=upstream_repository_url,
        upstream_tag_namespace=upstream_tag_namespace,
        upstream_tag_refspec=upstream_tag_refspec,
        source_snapshot_directory=source_snapshot_directory,
    )


def read_tags_from_cli_or_stdin(tags: list[str]) -> list[str]:
    if tags:
        return tags
    return [line.strip() for line in sys.stdin if line.strip()]


def fetch_upstream_tags(
    remote_name: str,
    config: SourceAcquisitionConfig | None = None,
) -> None:
    config = config or load_source_acquisition_config()

    try:
        command_output(["git", "remote", "get-url", remote_name])
        run_command(["git", "remote", "set-url", remote_name, config.upstream_repository_url])
    except RuntimeError:
        run_command(["git", "remote", "add", remote_name, config.upstream_repository_url])

    run_command(["git", "fetch", "--no-tags", "--force", remote_name, config.upstream_tag_refspec])


def latest_fetched_upstream_stable_tag(config: SourceAcquisitionConfig | None = None) -> str:
    config = config or load_source_acquisition_config()
    tags_output = command_output(
        ["git", "for-each-ref", "--format=%(refname:lstrip=2)", config.upstream_tag_namespace]
    )
    tags = [line.strip() for line in tags_output.splitlines() if line.strip()]
    return select_latest_stable_tag(tags)


def export_upstream_source_tree(
    tag: str,
    output_dir: Path,
    config: SourceAcquisitionConfig | None = None,
) -> Path:
    config = config or load_source_acquisition_config()
    require_stable_tag(tag)
    output_dir = output_dir.resolve()
    output_dir.parent.mkdir(parents=True, exist_ok=True)
    archive_path = output_dir.parent / f".{tag}.tar"

    if output_dir.exists():
        shutil.rmtree(output_dir)
    output_dir.mkdir(parents=True, exist_ok=True)

    upstream_ref = config.upstream_ref_for_tag(tag)
    command_output(["git", "rev-parse", "--verify", "--quiet", f"{upstream_ref}^{{commit}}"])
    try:
        run_command(
            [
                "git",
                "archive",
                "--format=tar",
                "--output",
                str(archive_path),
                upstream_ref,
            ]
        )
        run_command(["tar", "-xf", str(archive_path), "-C", str(output_dir)])
    finally:
        if archive_path.exists():
            archive_path.unlink()

    return output_dir


def artifact_definition_by_name(target_name: str) -> ArtifactDefinition:
    for definition in ARTIFACT_DEFINITIONS:
        if definition.target_name == target_name:
            return definition
    raise RuntimeError(f"Unknown artifact target: {target_name}")


def swiftpm_product_targets(definition: ArtifactDefinition) -> tuple[str, ...]:
    ordered_targets: list[str] = []
    seen_targets: set[str] = set()

    def visit(target_name: str) -> None:
        if target_name in seen_targets:
            return
        seen_targets.add(target_name)
        ordered_targets.append(target_name)
        for dependency_name in artifact_definition_by_name(target_name).linked_binary_dependencies:
            visit(dependency_name)

    visit(definition.target_name)
    return tuple(ordered_targets)


def ensure_command_exists(command: str) -> None:
    if shutil.which(command) is None:
        raise RuntimeError(f"Required command not found in PATH: {command}")


def run_command(
    args: list[str],
    *,
    cwd: Path | None = None,
    capture_output: bool = False,
) -> subprocess.CompletedProcess[str]:
    result = subprocess.run(
        args,
        cwd=str(cwd) if cwd is not None else None,
        check=False,
        capture_output=capture_output,
        text=True,
    )
    if result.returncode != 0:
        stdout = result.stdout.strip() if result.stdout else ""
        stderr = result.stderr.strip() if result.stderr else ""
        details = "\n".join(segment for segment in (stdout, stderr) if segment)
        raise RuntimeError(
            f"Command failed with exit code {result.returncode}: {' '.join(args)}"
            + (f"\n{details}" if details else "")
        )
    return result


def command_output(args: list[str], *, cwd: Path | None = None) -> str:
    return run_command(args, cwd=cwd, capture_output=True).stdout.strip()


def ensure_build_prerequisites() -> None:
    for command in ("cmake", "xcodebuild", "xcrun", "swift", "plutil", "otool", "install_name_tool"):
        ensure_command_exists(command)
    for group in PLATFORM_GROUPS:
        command_output(["xcrun", "--sdk", group.sdk, "--show-sdk-path"])
    command_output(["xcrun", "--find", "vtool"])


def ensure_source_tree_is_buildable(source_dir: Path) -> None:
    if not (source_dir / "CMakeLists.txt").exists():
        raise RuntimeError(f"Missing CMakeLists.txt in source tree: {source_dir}")


def copy_source_tree(source_dir: Path, destination_dir: Path) -> Path:
    ignored_names = shutil.ignore_patterns(
        ".git",
        ".github",
        "__pycache__",
        ".DS_Store",
        "build",
        "dist",
        "xcframeworkbuild",
    )
    working_source = destination_dir / "source"
    if working_source.exists():
        shutil.rmtree(working_source)
    shutil.copytree(source_dir, working_source, ignore=ignored_names)
    return working_source


def write_ccache_compiler_wrapper(path: Path, compiler_name: str) -> Path:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(
        "#!/bin/sh\n"
        f'exec ccache "$(xcrun --find {compiler_name})" "$@"\n',
        encoding="utf-8",
    )
    path.chmod(0o755)
    return path


def create_xcode_ccache_wrappers(directory: Path) -> CompilerWrapperPaths:
    return CompilerWrapperPaths(
        cc=write_ccache_compiler_wrapper(directory / "ccache-clang", "clang"),
        cxx=write_ccache_compiler_wrapper(directory / "ccache-clang++", "clang++"),
    )


def should_use_ccache() -> bool:
    return os.environ.get("SPM_RELEASE_ENABLE_CCACHE", "").lower() in {
        "1",
        "true",
        "yes",
        "on",
    }


def cmake_configuration_args_for_platform_group(
    platform_group: PlatformGroup,
    *,
    compiler_wrappers: CompilerWrapperPaths | None = None,
) -> tuple[str, ...]:
    # The Xcode generator needs the target architectures at configure time.
    # Passing only ARCHS during archive can produce object library references
    # that point at the wrong architecture directory in universal builds.
    arguments = [
        *CMAKE_CONFIGURATION_ARGS,
        f"-DCMAKE_OSX_ARCHITECTURES={platform_group.cmake_architectures}",
        f"-DCMAKE_OSX_SYSROOT={platform_group.sdk}",
        f"-DCMAKE_OSX_DEPLOYMENT_TARGET={platform_group.minimum_version}",
        "-DCMAKE_XCODE_ATTRIBUTE_SUPPORTS_MACCATALYST="
        + ("YES" if platform_group.catalyst else "NO"),
    ]
    if platform_group.cmake_system_name is not None:
        arguments.append(f"-DCMAKE_SYSTEM_NAME={platform_group.cmake_system_name}")
    if compiler_wrappers is not None:
        arguments.extend(
            [
                f"-DCMAKE_XCODE_ATTRIBUTE_CC={compiler_wrappers.cc}",
                f"-DCMAKE_XCODE_ATTRIBUTE_CXX={compiler_wrappers.cxx}",
            ]
        )
    return tuple(arguments)


def configure_cmake_project(
    source_dir: Path,
    build_dir: Path,
    *,
    platform_group: PlatformGroup,
) -> Path:
    build_dir.mkdir(parents=True, exist_ok=True)
    compiler_wrappers = None
    if should_use_ccache():
        if shutil.which("ccache") is None:
            raise RuntimeError(
                "SPM_RELEASE_ENABLE_CCACHE is set but ccache is not available in PATH."
            )
        compiler_wrappers = create_xcode_ccache_wrappers(build_dir / "compiler-wrappers")
    run_command(
        [
            "cmake",
            "-S",
            str(source_dir),
            "-B",
            str(build_dir),
            "-G",
            "Xcode",
            *cmake_configuration_args_for_platform_group(
                platform_group,
                compiler_wrappers=compiler_wrappers,
            ),
        ]
    )

    project_paths = sorted(build_dir.glob("*.xcodeproj"))
    if len(project_paths) != 1:
        raise RuntimeError(
            f"Expected exactly one generated Xcode project in {build_dir}, found {len(project_paths)}"
        )
    return project_paths[0]


def header_include_path(target_name: str, relative_path: str) -> Path:
    source_path = Path(relative_path)
    if source_path.parts and source_path.parts[0] == "src":
        source_path = Path(*source_path.parts[1:])
    return source_path


def rewrite_public_header_text(target_name: str, relative_path: str, contents: str) -> str:
    if target_name == "SharpYuv" and relative_path == "sharpyuv/sharpyuv_csp.h":
        return contents.replace('#include "sharpyuv/sharpyuv.h"', '#include "./sharpyuv.h"')
    return contents


def prepare_header_directories(source_dir: Path, output_root: Path) -> dict[str, Path]:
    header_paths: dict[str, Path] = {}
    for definition in ARTIFACT_DEFINITIONS:
        header_dir = output_root / definition.target_name
        header_dir.mkdir(parents=True, exist_ok=True)
        for relative_path in definition.public_headers:
            source_header = source_dir / relative_path
            if not source_header.exists():
                raise RuntimeError(
                    f"Missing public header for {definition.target_name}: {source_header}"
                )
            include_path = header_include_path(definition.target_name, relative_path)
            destination = header_dir / include_path
            destination.parent.mkdir(parents=True, exist_ok=True)
            destination.write_text(
                rewrite_public_header_text(
                    definition.target_name,
                    relative_path,
                    source_header.read_text(encoding="utf-8"),
                ),
                encoding="utf-8",
            )
        header_paths[definition.target_name] = header_dir
    return header_paths


def find_single_path(root: Path, pattern: str) -> Path:
    matches = sorted(root.rglob(pattern))
    if len(matches) != 1:
        raise RuntimeError(
            f"Expected exactly one match for {pattern} under {root}, found {len(matches)}"
        )
    return matches[0]


def find_built_dynamic_library(root: Path, library_name: str) -> Path:
    library_stem = library_name.removesuffix(".dylib")
    matches = sorted(path for path in root.rglob(f"{library_stem}*.dylib") if path.is_file())
    if not matches:
        raise RuntimeError(f"Unable to locate built dynamic library {library_name} under {root}")

    concrete_files = [path for path in matches if not path.is_symlink()]
    candidates = concrete_files or matches
    candidates.sort(key=lambda path: (len(path.name), path.name), reverse=True)
    return candidates[0]


def destination_probe_tokens(platform_group: PlatformGroup) -> tuple[str, ...]:
    if platform_group.catalyst:
        return ("platform:macOS", "variant:Mac Catalyst")
    return (f"platform:{platform_group.name}",)


def xcode_download_platform_name(platform_group: PlatformGroup) -> str | None:
    if platform_group.catalyst or platform_group.identifier == "macos":
        return None
    if platform_group.identifier.startswith("visionos"):
        return "visionOS"
    return platform_group.name.removesuffix(" Simulator")


def assert_destination_available(
    *,
    project_path: Path,
    scheme: str,
    platform_group: PlatformGroup,
) -> None:
    if platform_group.destination is None:
        return

    output = command_output(
        [
            "xcodebuild",
            "-project",
            str(project_path),
            "-scheme",
            scheme,
            "-showdestinations",
        ]
    )
    for raw_line in output.splitlines():
        line = raw_line.strip()
        if not line.startswith("{"):
            continue
        if not all(token in line for token in destination_probe_tokens(platform_group)):
            continue
        if "error:" in line:
            download_platform = xcode_download_platform_name(platform_group)
            guidance = ""
            if download_platform is not None:
                guidance = (
                    " Install the missing platform with "
                    + f"`xcodebuild -downloadPlatform {download_platform}`"
                    + " or from Xcode > Settings > Components."
                )
            raise RuntimeError(
                "Requested destination "
                + f"{platform_group.destination} is unavailable for scheme {scheme}: {line}"
                + guidance
            )
        return

    raise RuntimeError(
        "Requested destination "
        + f"{platform_group.destination} was not reported by xcodebuild -showdestinations for scheme {scheme}"
    )


def build_archive_for_slice(
    *,
    project_path: Path,
    artifact_definition: ArtifactDefinition,
    platform_group: PlatformGroup,
    archives_root: Path,
) -> BuiltSlice:
    archive_path = archives_root / artifact_definition.target_name / f"{platform_group.identifier}.xcarchive"
    derived_data_path = (
        archives_root / "derived-data" / artifact_definition.target_name / platform_group.identifier
    )
    archive_path.parent.mkdir(parents=True, exist_ok=True)
    derived_data_path.parent.mkdir(parents=True, exist_ok=True)

    arguments = [
        "xcodebuild",
        "-project",
        str(project_path),
        "-scheme",
        artifact_definition.cmake_target,
        "-configuration",
        "Release",
        "-derivedDataPath",
        str(derived_data_path),
        "-archivePath",
        str(archive_path),
        "archive",
    ]
    if platform_group.destination is not None:
        arguments.extend(["-destination", platform_group.destination])
    arguments.extend(platform_group.build_settings())
    assert_destination_available(
        project_path=project_path,
        scheme=artifact_definition.cmake_target,
        platform_group=platform_group,
    )
    run_command(arguments)

    binary_path = find_built_dynamic_library(derived_data_path, artifact_definition.library_name)
    validate_binary_platform(binary_path, platform_group.expected_vtool_platform)
    return BuiltSlice(
        platform_group=platform_group,
        archive_path=archive_path,
        binary_path=binary_path,
    )


def build_archived_libraries(
    *,
    source_dir: Path,
    build_root: Path,
    archives_root: Path,
) -> dict[str, list[BuiltSlice]]:
    build_output: dict[str, list[BuiltSlice]] = {
        definition.target_name: [] for definition in ARTIFACT_DEFINITIONS
    }
    for group in PLATFORM_GROUPS:
        project_path = configure_cmake_project(
            source_dir,
            build_root / group.identifier,
            platform_group=group,
        )
        for definition in ARTIFACT_DEFINITIONS:
            build_output[definition.target_name].append(
                build_archive_for_slice(
                    project_path=project_path,
                    artifact_definition=definition,
                    platform_group=group,
                    archives_root=archives_root,
                )
            )
    return build_output


def framework_binary_name(target_name: str) -> str:
    return target_name


def is_versioned_macos_framework(platform_group: PlatformGroup) -> bool:
    return platform_group.supported_platform == "macos"


def framework_binary_relative_path(target_name: str, platform_group: PlatformGroup) -> Path:
    binary_name = framework_binary_name(target_name)
    if is_versioned_macos_framework(platform_group):
        return Path("Versions") / "A" / binary_name
    return Path(binary_name)


def framework_resources_relative_dir(platform_group: PlatformGroup) -> Path:
    if is_versioned_macos_framework(platform_group):
        return Path("Versions") / "A" / "Resources"
    return Path()


def framework_headers_relative_dir(platform_group: PlatformGroup) -> Path:
    if is_versioned_macos_framework(platform_group):
        return Path("Versions") / "A" / "Headers"
    return Path("Headers")


def framework_modules_relative_dir(platform_group: PlatformGroup) -> Path:
    if is_versioned_macos_framework(platform_group):
        return Path("Versions") / "A" / "Modules"
    return Path("Modules")


def framework_install_name(target_name: str, platform_group: PlatformGroup) -> str:
    return f"@rpath/{target_name}.framework/{framework_binary_relative_path(target_name, platform_group).as_posix()}"


def render_framework_module_map(definition: ArtifactDefinition) -> str:
    header_lines = [
        f'  header "{header_include_path(definition.target_name, relative_path).as_posix()}"'
        for relative_path in definition.public_headers
    ]
    return "\n".join(
        [
            f"framework module {definition.target_name} {{",
            *header_lines,
            "  export *",
            "}",
            "",
        ]
    )


def framework_info_plist_bytes(target_name: str) -> bytes:
    payload = {
        "CFBundleExecutable": framework_binary_name(target_name),
        "CFBundleIdentifier": f"dev.spmforge.libwebp.{target_name}",
        "CFBundleName": target_name,
        "CFBundlePackageType": "FMWK",
        "CFBundleShortVersionString": "1.0",
        "CFBundleVersion": "1",
    }
    return plistlib.dumps(payload, fmt=plistlib.FMT_XML)


def linked_install_name(binary_path: Path, library_name: str) -> str:
    output = command_output(["otool", "-L", str(binary_path)])
    library_stem = library_name.removesuffix(".dylib")
    for raw_line in output.splitlines()[1:]:
        line = raw_line.strip()
        if not line:
            continue
        install_name = line.split(" ", 1)[0]
        if library_stem in install_name:
            return install_name
    raise RuntimeError(f"Unable to locate linked install name for {library_name} in {binary_path}")


def assemble_framework_bundle(
    frameworks_root: Path,
    *,
    definition: ArtifactDefinition,
    built_slice: BuiltSlice,
    headers_root: Path,
) -> Path:
    framework_dir = (
        frameworks_root
        / definition.target_name
        / built_slice.platform_group.identifier
        / f"{definition.target_name}.framework"
    )
    if framework_dir.exists():
        shutil.rmtree(framework_dir)

    headers_dir = framework_dir / framework_headers_relative_dir(built_slice.platform_group)
    modules_dir = framework_dir / framework_modules_relative_dir(built_slice.platform_group)
    resources_dir = framework_dir / framework_resources_relative_dir(built_slice.platform_group)
    headers_dir.mkdir(parents=True, exist_ok=True)
    modules_dir.mkdir(parents=True, exist_ok=True)
    resources_dir.mkdir(parents=True, exist_ok=True)
    shutil.copytree(headers_root, headers_dir, dirs_exist_ok=True)

    binary_path = framework_dir / framework_binary_relative_path(
        definition.target_name,
        built_slice.platform_group,
    )
    binary_path.parent.mkdir(parents=True, exist_ok=True)
    shutil.copy2(built_slice.binary_path, binary_path)
    run_command(
        [
            "install_name_tool",
            "-id",
            framework_install_name(definition.target_name, built_slice.platform_group),
            str(binary_path),
        ]
    )

    for dependency_name in definition.linked_binary_dependencies:
        dependency = artifact_definition_by_name(dependency_name)
        current_install_name = linked_install_name(binary_path, dependency.library_name)
        run_command(
            [
                "install_name_tool",
                "-change",
                current_install_name,
                framework_install_name(dependency.target_name, built_slice.platform_group),
                str(binary_path),
            ]
        )

    (modules_dir / "module.modulemap").write_text(
        render_framework_module_map(definition),
        encoding="utf-8",
    )
    (resources_dir / "Info.plist").write_bytes(framework_info_plist_bytes(definition.target_name))

    if is_versioned_macos_framework(built_slice.platform_group):
        versions_dir = framework_dir / "Versions"
        current_link = versions_dir / "Current"
        current_link.symlink_to("A")
        for link_name, relative_target in (
            (framework_binary_name(definition.target_name), Path("Versions") / "Current" / framework_binary_name(definition.target_name)),
            ("Headers", Path("Versions") / "Current" / "Headers"),
            ("Modules", Path("Versions") / "Current" / "Modules"),
            ("Resources", Path("Versions") / "Current" / "Resources"),
        ):
            (framework_dir / link_name).symlink_to(relative_target)
    return framework_dir


def create_xcframeworks(
    artifacts_dir: Path,
    build_output: dict[str, list[BuiltSlice]],
    header_paths: dict[str, Path],
) -> dict[str, Path]:
    artifacts_dir.mkdir(parents=True, exist_ok=True)
    created_xcframeworks: dict[str, Path] = {}
    frameworks_root = artifacts_dir / "_frameworks"

    for definition in ARTIFACT_DEFINITIONS:
        xcframework_dir = artifacts_dir / definition.xcframework_name
        arguments = ["xcodebuild", "-create-xcframework"]
        for built_slice in build_output[definition.target_name]:
            framework_dir = assemble_framework_bundle(
                frameworks_root,
                definition=definition,
                built_slice=built_slice,
                headers_root=header_paths[definition.target_name],
            )
            arguments.extend(
                [
                    "-framework",
                    str(framework_dir),
                ]
            )
        arguments.extend(["-output", str(xcframework_dir)])
        run_command(arguments)
        created_xcframeworks[definition.target_name] = xcframework_dir

    return created_xcframeworks


def load_xcframework_info(xcframework_dir: Path) -> dict[str, object]:
    info_path = xcframework_dir / "Info.plist"
    if not info_path.exists():
        raise RuntimeError(f"Missing XCFramework Info.plist: {info_path}")
    return plistlib.loads(info_path.read_bytes())


def matching_library_entry(
    available_libraries: list[dict[str, object]],
    platform_group: PlatformGroup,
) -> dict[str, object]:
    matches = [
        entry
        for entry in available_libraries
        if entry.get("SupportedPlatform") == platform_group.supported_platform
        and entry.get("SupportedPlatformVariant") == platform_group.supported_platform_variant
    ]
    if len(matches) != 1:
        raise RuntimeError(
            f"Expected exactly one XCFramework entry for {platform_group.name}, found {len(matches)}"
        )
    return matches[0]


def validate_binary_platform(binary_path: Path, expected_platform: str) -> None:
    output = command_output(["xcrun", "vtool", "-show-build", str(binary_path)])
    platforms = set(re.findall(r"platform\s+([A-Z0-9_]+)", output))
    if platforms != {expected_platform}:
        raise RuntimeError(
            f"Unexpected build platform metadata for {binary_path}: expected {expected_platform}, got {sorted(platforms)}"
        )


def validate_framework_bundle_layout(framework_dir: Path, *, target_name: str, platform_group: PlatformGroup) -> None:
    if is_versioned_macos_framework(platform_group):
        expected_paths = (
            framework_dir / "Versions" / "Current",
            framework_dir / "Versions" / "A" / framework_binary_name(target_name),
            framework_dir / "Versions" / "A" / "Headers",
            framework_dir / "Versions" / "A" / "Modules" / "module.modulemap",
            framework_dir / "Versions" / "A" / "Resources" / "Info.plist",
            framework_dir / framework_binary_name(target_name),
            framework_dir / "Headers",
            framework_dir / "Modules",
            framework_dir / "Resources",
        )
        missing_paths = [path for path in expected_paths if not path.exists()]
        if missing_paths:
            raise RuntimeError(
                "macOS framework bundle is missing versioned layout paths for "
                + f"{target_name}: {', '.join(str(path) for path in missing_paths)}"
            )
        return

    info_path = framework_dir / "Info.plist"
    if not info_path.exists():
        raise RuntimeError(f"Framework bundle is missing Info.plist: {info_path}")


def validate_xcframeworks(xcframeworks: dict[str, Path]) -> None:
    for definition in ARTIFACT_DEFINITIONS:
        xcframework_dir = xcframeworks[definition.target_name]
        info = load_xcframework_info(xcframework_dir)
        available_libraries = info.get("AvailableLibraries")
        if not isinstance(available_libraries, list):
            raise RuntimeError(
                f"XCFramework metadata for {definition.target_name} is missing AvailableLibraries"
            )
        if len(available_libraries) != len(PLATFORM_GROUPS):
            raise RuntimeError(
                f"XCFramework for {definition.target_name} contains {len(available_libraries)} slices, expected {len(PLATFORM_GROUPS)}"
            )

        for group in PLATFORM_GROUPS:
            entry = matching_library_entry(available_libraries, group)
            if entry.get("MergeableMetadata") is not True:
                raise RuntimeError(
                    f"XCFramework slice for {definition.target_name} on {group.name} is missing MergeableMetadata"
                )
            architectures = entry.get("SupportedArchitectures")
            if sorted(architectures or []) != sorted(group.architectures):
                raise RuntimeError(
                    f"Unexpected architectures for {definition.target_name} on {group.name}: {architectures}"
                )

            library_identifier = entry.get("LibraryIdentifier")
            library_path = entry.get("BinaryPath") or entry.get("LibraryPath")
            if not isinstance(library_identifier, str) or not isinstance(library_path, str):
                raise RuntimeError(
                    f"Incomplete XCFramework metadata for {definition.target_name} on {group.name}"
                )
            binary_path = xcframework_dir / library_identifier / library_path
            if not binary_path.exists():
                raise RuntimeError(f"Missing XCFramework binary slice: {binary_path}")
            validate_framework_bundle_layout(
                xcframework_dir / library_identifier / f"{definition.target_name}.framework",
                target_name=definition.target_name,
                platform_group=group,
            )
            validate_binary_platform(binary_path, group.expected_vtool_platform)


def cmake_quote(value: str) -> str:
    return value.replace("\\", "/").replace('"', '\\"')


def write_cmake_consumer_fixture(consumer_root: Path, xcframeworks: dict[str, Path]) -> tuple[Path, Path]:
    source_dir = consumer_root / "src"
    source_dir.mkdir(parents=True, exist_ok=True)
    cmake_lines = [
        "cmake_minimum_required(VERSION 3.17)",
        "project(spm_libwebp_consumer C)",
        "",
    ]

    for definition in ARTIFACT_DEFINITIONS:
        source_path = source_dir / f"{definition.target_name}.c"
        source_path.write_text(definition.consumer_source, encoding="utf-8")

        library_root = (
            xcframeworks[definition.target_name]
            / "macos-arm64_x86_64"
            / f"{definition.target_name}.framework"
        )
        header_dir = library_root / "Headers"
        frameworks = []
        for dependency_name in swiftpm_product_targets(definition):
            dependency = artifact_definition_by_name(dependency_name)
            frameworks.append(
                cmake_quote(
                    str(
                        xcframeworks[dependency.target_name]
                        / "macos-arm64_x86_64"
                        / f"{dependency.target_name}.framework"
                        / framework_binary_name(dependency.target_name)
                    )
                )
            )

        target_name = f"Smoke{definition.target_name}"
        cmake_lines.extend(
            [
                f"add_executable({target_name} MACOSX_BUNDLE src/{definition.target_name}.c)",
                f'target_include_directories({target_name} PRIVATE "{cmake_quote(str(header_dir))}")',
                "target_link_libraries("
                + target_name
                + " PRIVATE "
                + " ".join(f'"{framework}"' for framework in frameworks)
                + ")",
                "set_target_properties("
                + target_name
                + " PROPERTIES "
                + "XCODE_ATTRIBUTE_CODE_SIGNING_ALLOWED NO "
                + "XCODE_ATTRIBUTE_CODE_SIGNING_REQUIRED NO)",
                "",
            ]
        )

    cmake_path = consumer_root / "CMakeLists.txt"
    cmake_path.write_text("\n".join(cmake_lines), encoding="utf-8")
    build_dir = consumer_root / "build"
    run_command(["cmake", "-S", str(consumer_root), "-B", str(build_dir), "-G", "Xcode"])
    project_paths = sorted(build_dir.glob("*.xcodeproj"))
    if len(project_paths) != 1:
        raise RuntimeError(
            f"Expected exactly one top-level Xcode project in {build_dir}, found {len(project_paths)}"
        )
    project_path = project_paths[0]
    return project_path, build_dir


def verify_cmake_consumer_fixture(xcframeworks: dict[str, Path], work_dir: Path) -> None:
    project_path, build_dir = write_cmake_consumer_fixture(work_dir / "consumer-fixture", xcframeworks)
    macos_group = next(group for group in PLATFORM_GROUPS if group.identifier == "macos")

    run_command(
        [
            "xcodebuild",
            "-project",
            str(project_path),
            "-scheme",
            "ALL_BUILD",
            "-configuration",
            "Debug",
            "build",
            "MACOSX_DEPLOYMENT_TARGET=10.15",
            "CODE_SIGNING_ALLOWED=NO",
            "CODE_SIGNING_REQUIRED=NO",
        ],
        capture_output=True,
    )

    release_result = run_command(
        [
            "xcodebuild",
            "-project",
            str(project_path),
            "-scheme",
            "ALL_BUILD",
            "-configuration",
            "Release",
            "build",
            "MACOSX_DEPLOYMENT_TARGET=10.15",
            "MERGED_BINARY_TYPE=automatic",
            "CODE_SIGNING_ALLOWED=NO",
            "CODE_SIGNING_REQUIRED=NO",
        ],
        capture_output=True,
    )
    release_output = "\n".join(
        fragment for fragment in (release_result.stdout, release_result.stderr) if fragment
    )
    if "MERGED_BINARY_TYPE = automatic" not in release_output:
        raise RuntimeError("Release consumer build did not honor MERGED_BINARY_TYPE=automatic")

    for definition in ARTIFACT_DEFINITIONS:
        target_name = f"Smoke{definition.target_name}"
        debug_binary = build_dir / "Debug" / f"{target_name}.app" / "Contents" / "MacOS" / target_name
        release_binary = build_dir / "Release" / f"{target_name}.app" / "Contents" / "MacOS" / target_name
        if not debug_binary.exists():
            raise RuntimeError(f"Missing Debug consumer binary: {debug_binary}")
        if not release_binary.exists():
            raise RuntimeError(f"Missing Release consumer binary: {release_binary}")

        debug_otool = command_output(["otool", "-L", str(debug_binary)])
        for dependency_name in swiftpm_product_targets(definition):
            expected_install_name = framework_install_name(dependency_name, macos_group)
            if expected_install_name not in debug_otool:
                raise RuntimeError(
                    "Debug consumer binary for "
                    + f"{definition.target_name} is not linked against {expected_install_name}"
                )


def write_spm_binary_package_fixture(binary_package_root: Path, xcframeworks: dict[str, Path]) -> Path:
    binary_package_root.mkdir(parents=True, exist_ok=True)
    artifacts_root = binary_package_root / "Artifacts"
    artifacts_root.mkdir(parents=True, exist_ok=True)
    fixture_paths: dict[str, Path] = {}
    for target_name, xcframework_path in xcframeworks.items():
        link_path = artifacts_root / xcframework_path.name
        if link_path.exists() or link_path.is_symlink():
            if link_path.is_dir() and not link_path.is_symlink():
                shutil.rmtree(link_path)
            else:
                link_path.unlink()
        link_path.symlink_to(xcframework_path.resolve(), target_is_directory=True)
        fixture_paths[target_name] = Path("Artifacts") / xcframework_path.name

    manifest_path = binary_package_root / "Package.swift"
    manifest_path.write_text(
        render_local_binary_package_swift(
            package_name="LocalLibWebPBinary",
            xcframework_paths=fixture_paths,
        ),
        encoding="utf-8",
    )
    return binary_package_root


def write_spm_consumer_fixture(consumer_root: Path, binary_package_root: Path) -> Path:
    sources_dir = consumer_root / "Sources" / "SpmSmokeConsumer"
    sources_dir.mkdir(parents=True, exist_ok=True)
    manifest_path = consumer_root / "Package.swift"
    manifest_path.write_text(
        render_spm_consumer_package_swift(
            binary_package_name="LocalLibWebPBinary",
            binary_package_path=os.path.relpath(binary_package_root, consumer_root),
        ),
        encoding="utf-8",
    )
    for file_name, source in render_spm_consumer_sources().items():
        (sources_dir / file_name).write_text(source, encoding="utf-8")
    return consumer_root


def verify_spm_consumer_fixture(xcframeworks: dict[str, Path], work_dir: Path) -> None:
    binary_package_root = write_spm_binary_package_fixture(
        work_dir / "spm-binary-package",
        xcframeworks,
    )
    consumer_root = write_spm_consumer_fixture(
        work_dir / "spm-consumer-fixture",
        binary_package_root,
    )
    derived_data_path = work_dir / "spm-consumer-derived-data"
    scheme_name = "libwebp-consumer"
    macos_group = next(group for group in PLATFORM_GROUPS if group.identifier == "macos")

    run_command(["swift", "package", "dump-package"], cwd=binary_package_root, capture_output=True)
    run_command(["swift", "package", "dump-package"], cwd=consumer_root, capture_output=True)

    run_command(
        [
            "xcodebuild",
            "-scheme",
            scheme_name,
            "-configuration",
            "Debug",
            "-derivedDataPath",
            str(derived_data_path),
            "-destination",
            "platform=macOS",
            "build",
        ],
        cwd=consumer_root,
        capture_output=True,
    )

    release_result = run_command(
        [
            "xcodebuild",
            "-scheme",
            scheme_name,
            "-configuration",
            "Release",
            "-derivedDataPath",
            str(derived_data_path),
            "-destination",
            "platform=macOS",
            "MERGED_BINARY_TYPE=automatic",
            "build",
        ],
        cwd=consumer_root,
        capture_output=True,
    )
    release_output = "\n".join(
        fragment for fragment in (release_result.stdout, release_result.stderr) if fragment
    )
    if "MERGED_BINARY_TYPE = automatic" not in release_output:
        raise RuntimeError("SwiftPM release consumer build did not honor MERGED_BINARY_TYPE=automatic")

    debug_binary = derived_data_path / "Build" / "Products" / "Debug" / "SpmSmokeConsumer"
    release_binary = derived_data_path / "Build" / "Products" / "Release" / "SpmSmokeConsumer"
    if not debug_binary.exists():
        raise RuntimeError(f"Missing SwiftPM Debug consumer binary: {debug_binary}")
    if not release_binary.exists():
        raise RuntimeError(f"Missing SwiftPM Release consumer binary: {release_binary}")

    debug_otool = command_output(["otool", "-L", str(debug_binary)])
    for definition in ARTIFACT_DEFINITIONS:
        expected_install_name = framework_install_name(definition.target_name, macos_group)
        if expected_install_name not in debug_otool:
            raise RuntimeError(
                "SwiftPM Debug consumer binary is not linked against "
                + expected_install_name
            )


def verify_consumer_fixture(xcframeworks: dict[str, Path], work_dir: Path) -> None:
    verify_cmake_consumer_fixture(xcframeworks, work_dir)
    verify_spm_consumer_fixture(xcframeworks, work_dir)


def zip_xcframeworks(tag: str, xcframeworks: dict[str, Path], output_dir: Path) -> list[Path]:
    output_dir.mkdir(parents=True, exist_ok=True)
    artifact_paths: list[Path] = []
    artifacts = {artifact.target_name: artifact for artifact in release_artifacts_for_tag(tag)}

    for target_name, xcframework_dir in xcframeworks.items():
        artifact = artifacts[target_name]
        archive_path = output_dir / artifact.archive_name
        if archive_path.exists():
            archive_path.unlink()
        with zipfile.ZipFile(archive_path, "w", compression=zipfile.ZIP_DEFLATED) as archive:
            for file_path in sorted(xcframework_dir.rglob("*")):
                archive.write(file_path, file_path.relative_to(xcframework_dir.parent))
        artifact_paths.append(archive_path)

    return artifact_paths


def retag_release_archives(archives_dir: Path, *, source_tag: str, destination_tag: str) -> list[Path]:
    require_package_distribution_tag(source_tag)
    require_package_distribution_tag(destination_tag)
    archives_dir = archives_dir.resolve()

    source_artifacts = {
        artifact.target_name: artifact for artifact in release_artifacts_for_tag(source_tag)
    }
    destination_artifacts = {
        artifact.target_name: artifact for artifact in release_artifacts_for_tag(destination_tag)
    }
    renamed_paths: list[Path] = []

    for definition in ARTIFACT_DEFINITIONS:
        source_path = archives_dir / source_artifacts[definition.target_name].archive_name
        destination_path = archives_dir / destination_artifacts[definition.target_name].archive_name
        if not source_path.exists():
            raise RuntimeError(f"Missing archive to retag: {source_path}")
        if destination_path.exists() and destination_path != source_path:
            destination_path.unlink()
        if destination_path != source_path:
            source_path.rename(destination_path)
        renamed_paths.append(destination_path)

    return renamed_paths


def build_xcframework_archives(
    *,
    source_dir: Path,
    output_dir: Path,
    tag: str,
    working_dir: Path | None = None,
    keep_xcframeworks: bool = False,
) -> list[Path]:
    require_package_distribution_tag(tag)
    source_dir = source_dir.resolve()
    output_dir = output_dir.resolve()

    if not source_dir.exists():
        raise RuntimeError(f"Source directory does not exist: {source_dir}")

    ensure_build_prerequisites()

    context_manager = (
        tempfile.TemporaryDirectory(prefix="libwebp-build-")
        if working_dir is None
        else None
    )
    root_dir = Path(context_manager.name) if context_manager is not None else working_dir.resolve()
    root_dir.mkdir(parents=True, exist_ok=True)

    try:
        working_source = copy_source_tree(source_dir, root_dir)
        ensure_source_tree_is_buildable(working_source)
        header_paths = prepare_header_directories(working_source, root_dir / "headers")
        build_output = build_archived_libraries(
            source_dir=working_source,
            build_root=root_dir / "cmake-build",
            archives_root=root_dir / "archives",
        )
        xcframework_root = root_dir / "xcframeworks"
        xcframeworks = create_xcframeworks(xcframework_root, build_output, header_paths)
        validate_xcframeworks(xcframeworks)
        verify_consumer_fixture(xcframeworks, root_dir)
        artifact_paths = zip_xcframeworks(tag, xcframeworks, output_dir)

        if keep_xcframeworks:
            kept_dir = output_dir / "xcframeworks"
            if kept_dir.exists():
                shutil.rmtree(kept_dir)
            shutil.copytree(xcframework_root, kept_dir)

        return artifact_paths
    finally:
        if context_manager is not None:
            context_manager.cleanup()


def compute_checksums_for_archives(archives_dir: Path) -> dict[str, str]:
    archives_dir = archives_dir.resolve()
    checksums: dict[str, str] = {}
    for definition in ARTIFACT_DEFINITIONS:
        matches = sorted(archives_dir.glob(f"{definition.target_name}-v*.xcframework.zip"))
        if len(matches) != 1:
            raise RuntimeError(
                f"Expected exactly one archive for {definition.target_name} in {archives_dir}, found {len(matches)}"
            )
        checksum = command_output(["swift", "package", "compute-checksum", str(matches[0])])
        checksums[definition.target_name] = checksum
    return checksums


def write_json(path: Path, payload: dict[str, object]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n", encoding="utf-8")


def command_latest_stable_tag(args: argparse.Namespace) -> int:
    print(select_latest_stable_tag(read_tags_from_cli_or_stdin(args.tags)))
    return 0


def command_assert_stable_tag(args: argparse.Namespace) -> int:
    require_stable_tag(args.tag)
    print(args.tag)
    return 0


def command_fetch_upstream_tags(args: argparse.Namespace) -> int:
    fetch_upstream_tags(args.remote)
    return 0


def command_latest_fetched_upstream_stable_tag(_: argparse.Namespace) -> int:
    print(latest_fetched_upstream_stable_tag())
    return 0


def command_export_upstream_source(args: argparse.Namespace) -> int:
    export_upstream_source_tree(args.tag, Path(args.output_dir))
    return 0


def command_package_release_tag(args: argparse.Namespace) -> int:
    print(
        package_release_tag_for_upstream_tag(
            args.upstream_tag,
            channel=args.channel,
            sequence=args.sequence,
        )
    )
    return 0


def command_latest_package_release_tag(args: argparse.Namespace) -> int:
    latest_tag = latest_package_release_tag_for_upstream_tag(
        args.upstream_tag,
        read_tags_from_cli_or_stdin(args.tags),
    )
    if latest_tag is None:
        return 1
    print(latest_tag)
    return 0


def command_next_package_release_tag(args: argparse.Namespace) -> int:
    print(
        next_package_release_tag_for_upstream_tag(
            args.upstream_tag,
            read_tags_from_cli_or_stdin(args.tags),
        )
    )
    return 0


def command_release_artifacts(args: argparse.Namespace) -> int:
    artifacts = [dataclasses.asdict(artifact) for artifact in release_artifacts_for_tag(args.tag)]
    print(json.dumps({"artifacts": artifacts}, indent=2))
    return 0


def command_release_publish_plan(args: argparse.Namespace) -> int:
    plan = plan_release_publication(
        tag=args.tag,
        remote_tag_exists=args.tag_exists,
        release_asset_names=args.assets,
    )
    print(json.dumps(dataclasses.asdict(plan), indent=2))
    return 0


def command_print_build_plan(_: argparse.Namespace) -> int:
    print(json.dumps(build_plan_payload(), indent=2))
    return 0


def command_render_package_swift(args: argparse.Namespace) -> int:
    checksums = validate_checksums_payload(
        json.loads(Path(args.checksums_json).read_text(encoding="utf-8"))
    )
    package_swift = render_package_swift(
        owner=args.owner,
        repository=args.repository,
        tag=args.tag,
        checksums=checksums,
    )
    output_path = Path(args.output)
    output_path.parent.mkdir(parents=True, exist_ok=True)
    output_path.write_text(package_swift, encoding="utf-8")
    return 0


def command_compute_checksums(args: argparse.Namespace) -> int:
    write_json(Path(args.output), compute_checksums_for_archives(Path(args.archives_dir)))
    return 0


def command_build_xcframeworks(args: argparse.Namespace) -> int:
    artifact_paths = build_xcframework_archives(
        source_dir=Path(args.source_dir),
        output_dir=Path(args.output_dir),
        tag=args.tag,
        working_dir=Path(args.working_dir) if args.working_dir else None,
        keep_xcframeworks=args.keep_xcframeworks,
    )
    print(json.dumps({"archives": [str(path) for path in artifact_paths]}, indent=2))
    return 0


def command_retag_archives(args: argparse.Namespace) -> int:
    retagged_paths = retag_release_archives(
        Path(args.archives_dir),
        source_tag=args.source_tag,
        destination_tag=args.destination_tag,
    )
    print(json.dumps({"archives": [str(path) for path in retagged_paths]}, indent=2))
    return 0


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description="SwiftPM release helpers for libwebp.")
    subparsers = parser.add_subparsers(dest="command", required=True)

    latest_parser = subparsers.add_parser(
        "latest-stable-tag",
        help="Select the newest stable upstream tag from CLI args or stdin.",
    )
    latest_parser.add_argument("tags", nargs="*")
    latest_parser.set_defaults(func=command_latest_stable_tag)

    assert_parser = subparsers.add_parser(
        "assert-stable-tag",
        help="Validate a tag string matches the stable libwebp release format.",
    )
    assert_parser.add_argument("--tag", required=True)
    assert_parser.set_defaults(func=command_assert_stable_tag)

    fetch_upstream_tags_parser = subparsers.add_parser(
        "fetch-upstream-tags",
        help="Fetch upstream tags into the configured dedicated namespace.",
    )
    fetch_upstream_tags_parser.add_argument("--remote", default="upstream")
    fetch_upstream_tags_parser.set_defaults(func=command_fetch_upstream_tags)

    latest_fetched_upstream_stable_tag_parser = subparsers.add_parser(
        "latest-fetched-upstream-stable-tag",
        help="Select the newest stable upstream tag from the configured fetched namespace.",
    )
    latest_fetched_upstream_stable_tag_parser.set_defaults(
        func=command_latest_fetched_upstream_stable_tag
    )

    export_upstream_source_parser = subparsers.add_parser(
        "export-upstream-source",
        help="Export a fetched upstream stable tag into a local source snapshot directory.",
    )
    export_upstream_source_parser.add_argument("--tag", required=True)
    export_upstream_source_parser.add_argument("--output-dir", required=True)
    export_upstream_source_parser.set_defaults(func=command_export_upstream_source)

    package_release_tag_parser = subparsers.add_parser(
        "package-release-tag",
        help="Derive a package tag for a stable upstream libwebp tag.",
    )
    package_release_tag_parser.add_argument("--upstream-tag", required=True)
    package_release_tag_parser.add_argument(
        "--channel",
        choices=("alpha", "stable"),
        default="alpha",
    )
    package_release_tag_parser.add_argument("--sequence", type=int, default=1)
    package_release_tag_parser.set_defaults(func=command_package_release_tag)

    latest_package_release_tag_parser = subparsers.add_parser(
        "latest-package-release-tag",
        help="Select the newest package prerelease tag for an upstream stable tag from CLI args or stdin.",
    )
    latest_package_release_tag_parser.add_argument("--upstream-tag", required=True)
    latest_package_release_tag_parser.add_argument("tags", nargs="*")
    latest_package_release_tag_parser.set_defaults(func=command_latest_package_release_tag)

    next_package_release_tag_parser = subparsers.add_parser(
        "next-package-release-tag",
        help="Compute the next package prerelease tag for an upstream stable tag from CLI args or stdin.",
    )
    next_package_release_tag_parser.add_argument("--upstream-tag", required=True)
    next_package_release_tag_parser.add_argument("tags", nargs="*")
    next_package_release_tag_parser.set_defaults(func=command_next_package_release_tag)

    release_artifacts_parser = subparsers.add_parser(
        "release-artifacts",
        help="Print JSON describing the release assets for a package release tag.",
    )
    release_artifacts_parser.add_argument("--tag", required=True)
    release_artifacts_parser.set_defaults(func=command_release_artifacts)

    release_publish_plan_parser = subparsers.add_parser(
        "release-publish-plan",
        help="Plan whether a tag should publish fresh assets, repair an incomplete release, or skip.",
    )
    release_publish_plan_parser.add_argument("--tag", required=True)
    release_publish_plan_parser.add_argument("--tag-exists", action="store_true")
    release_publish_plan_parser.add_argument("--asset", dest="assets", action="append", default=[])
    release_publish_plan_parser.set_defaults(func=command_release_publish_plan)

    build_plan_parser = subparsers.add_parser(
        "print-build-plan",
        help="Print the supported Apple platform matrix as JSON.",
    )
    build_plan_parser.set_defaults(func=command_print_build_plan)

    render_package_parser = subparsers.add_parser(
        "render-package-swift",
        help="Render a Package.swift that references package prerelease assets.",
    )
    render_package_parser.add_argument("--owner", required=True)
    render_package_parser.add_argument("--repository", required=True)
    render_package_parser.add_argument("--tag", required=True)
    render_package_parser.add_argument("--checksums-json", required=True)
    render_package_parser.add_argument("--output", required=True)
    render_package_parser.set_defaults(func=command_render_package_swift)

    checksum_parser = subparsers.add_parser(
        "compute-checksums",
        help="Compute SwiftPM SHA-256 checksums for the versioned XCFramework archives.",
    )
    checksum_parser.add_argument("--archives-dir", required=True)
    checksum_parser.add_argument("--output", required=True)
    checksum_parser.set_defaults(func=command_compute_checksums)

    build_xcframeworks_parser = subparsers.add_parser(
        "build-xcframeworks",
        help="Build and archive all release XCFrameworks for a package release tag.",
    )
    build_xcframeworks_parser.add_argument("--source-dir", required=True)
    build_xcframeworks_parser.add_argument("--output-dir", required=True)
    build_xcframeworks_parser.add_argument("--tag", required=True)
    build_xcframeworks_parser.add_argument("--working-dir")
    build_xcframeworks_parser.add_argument("--keep-xcframeworks", action="store_true")
    build_xcframeworks_parser.set_defaults(func=command_build_xcframeworks)

    retag_archives_parser = subparsers.add_parser(
        "retag-archives",
        help="Rename packaged XCFramework archives from one package release tag to another.",
    )
    retag_archives_parser.add_argument("--archives-dir", required=True)
    retag_archives_parser.add_argument("--source-tag", required=True)
    retag_archives_parser.add_argument("--destination-tag", required=True)
    retag_archives_parser.set_defaults(func=command_retag_archives)

    return parser


def main(argv: list[str] | None = None) -> int:
    parser = build_parser()
    args = parser.parse_args(argv)
    return args.func(args)


if __name__ == "__main__":
    raise SystemExit(main())
