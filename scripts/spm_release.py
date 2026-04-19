#!/usr/bin/env python3

from __future__ import annotations

import argparse
import dataclasses
import json
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
CHECKSUM_PATTERN = re.compile(r"^[0-9a-f]{64}$")


@dataclasses.dataclass(frozen=True)
class ArtifactDefinition:
    target_name: str
    cmake_target: str
    library_name: str
    public_headers: tuple[str, ...]
    consumer_dependencies: tuple[str, ...]
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
class PlatformGroup:
    name: str
    identifier: str
    supported_platform: str
    sdk: str
    deployment_setting: str
    minimum_version: str
    architectures: tuple[str, ...]
    expected_vtool_platform: str
    simulator: bool = False
    catalyst: bool = False
    supported_platform_variant: str | None = None
    destination: str | None = None

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
            "deployment_setting": self.deployment_setting,
            "minimum_version": self.minimum_version,
            "architectures": list(self.architectures),
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
        consumer_dependencies=("WebP",),
        consumer_source=textwrap.dedent(
            """\
            #include "decode.h"
            #include "encode.h"

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
        consumer_dependencies=("WebPDecoder",),
        consumer_source=textwrap.dedent(
            """\
            #include "decode.h"

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
        consumer_dependencies=("WebPDemux", "WebP"),
        consumer_source=textwrap.dedent(
            """\
            #include <stdint.h>
            #include "demux.h"

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
        consumer_dependencies=("WebPMux", "WebP"),
        consumer_source=textwrap.dedent(
            """\
            #include "mux.h"

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
        consumer_dependencies=("SharpYuv",),
        consumer_source=textwrap.dedent(
            """\
            #include "sharpyuv.h"
            #include "sharpyuv_csp.h"

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
        deployment_setting="IPHONEOS_DEPLOYMENT_TARGET",
        minimum_version="13.0",
        architectures=("arm64",),
        expected_vtool_platform="IOS",
    ),
    PlatformGroup(
        name="iOS Simulator",
        identifier="ios-simulator",
        supported_platform="ios",
        supported_platform_variant="simulator",
        sdk="iphonesimulator",
        deployment_setting="IPHONEOS_DEPLOYMENT_TARGET",
        minimum_version="13.0",
        architectures=("arm64", "x86_64"),
        expected_vtool_platform="IOSSIMULATOR",
        simulator=True,
    ),
    PlatformGroup(
        name="macOS",
        identifier="macos",
        supported_platform="macos",
        sdk="macosx",
        deployment_setting="MACOSX_DEPLOYMENT_TARGET",
        minimum_version="10.15",
        architectures=("arm64", "x86_64"),
        expected_vtool_platform="MACOS",
    ),
    PlatformGroup(
        name="Mac Catalyst",
        identifier="mac-catalyst",
        supported_platform="ios",
        supported_platform_variant="maccatalyst",
        sdk="macosx",
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
        deployment_setting="TVOS_DEPLOYMENT_TARGET",
        minimum_version="13.0",
        architectures=("arm64",),
        expected_vtool_platform="TVOS",
    ),
    PlatformGroup(
        name="tvOS Simulator",
        identifier="tvos-simulator",
        supported_platform="tvos",
        supported_platform_variant="simulator",
        sdk="appletvsimulator",
        deployment_setting="TVOS_DEPLOYMENT_TARGET",
        minimum_version="13.0",
        architectures=("arm64", "x86_64"),
        expected_vtool_platform="TVOSSIMULATOR",
        simulator=True,
    ),
    PlatformGroup(
        name="watchOS",
        identifier="watchos",
        supported_platform="watchos",
        sdk="watchos",
        deployment_setting="WATCHOS_DEPLOYMENT_TARGET",
        minimum_version="8.0",
        architectures=("arm64", "arm64_32"),
        expected_vtool_platform="WATCHOS",
    ),
    PlatformGroup(
        name="watchOS Simulator",
        identifier="watchos-simulator",
        supported_platform="watchos",
        supported_platform_variant="simulator",
        sdk="watchsimulator",
        deployment_setting="WATCHOS_DEPLOYMENT_TARGET",
        minimum_version="8.0",
        architectures=("arm64", "x86_64"),
        expected_vtool_platform="WATCHOSSIMULATOR",
        simulator=True,
    ),
    PlatformGroup(
        name="visionOS",
        identifier="visionos",
        supported_platform="xros",
        sdk="xros",
        deployment_setting="XROS_DEPLOYMENT_TARGET",
        minimum_version="1.0",
        architectures=("arm64",),
        expected_vtool_platform="VISIONOS",
    ),
    PlatformGroup(
        name="visionOS Simulator",
        identifier="visionos-simulator",
        supported_platform="xros",
        supported_platform_variant="simulator",
        sdk="xrsimulator",
        deployment_setting="XROS_DEPLOYMENT_TARGET",
        minimum_version="1.0",
        architectures=("arm64", "x86_64"),
        expected_vtool_platform="VISIONOSSIMULATOR",
        simulator=True,
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
    "-DCMAKE_XCODE_ATTRIBUTE_SUPPORTS_MACCATALYST=YES",
)


def require_stable_tag(tag: str) -> tuple[int, int, int]:
    match = STABLE_TAG_PATTERN.fullmatch(tag)
    if match is None:
        raise ValueError(f"Expected a stable release tag like v1.6.0, got: {tag}")
    return tuple(int(component) for component in match.groups())


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
    require_stable_tag(tag)
    return [
        ReleaseArtifact(
            target_name=definition.target_name,
            library_name=definition.library_name,
            archive_name=definition.archive_name_for_tag(tag),
            xcframework_name=definition.xcframework_name,
        )
        for definition in ARTIFACT_DEFINITIONS
    ]


def render_package_swift(
    *,
    owner: str,
    repository: str,
    tag: str,
    checksums: dict[str, str],
) -> str:
    require_stable_tag(tag)
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
        f'        .library(name: "{artifact.target_name}", targets: ["{artifact.target_name}"])'
        for artifact in artifact_map.values()
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
            '    name: "spm-libwebp",',
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


def read_tags_from_cli_or_stdin(tags: list[str]) -> list[str]:
    if tags:
        return tags
    return [line.strip() for line in sys.stdin if line.strip()]


def artifact_definition_by_name(target_name: str) -> ArtifactDefinition:
    for definition in ARTIFACT_DEFINITIONS:
        if definition.target_name == target_name:
            return definition
    raise RuntimeError(f"Unknown artifact target: {target_name}")


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
    for command in ("cmake", "xcodebuild", "xcrun", "swift", "plutil", "otool"):
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


def configure_cmake_project(source_dir: Path, build_dir: Path) -> Path:
    build_dir.mkdir(parents=True, exist_ok=True)
    run_command(
        [
            "cmake",
            "-S",
            str(source_dir),
            "-B",
            str(build_dir),
            "-G",
            "Xcode",
            *CMAKE_CONFIGURATION_ARGS,
        ]
    )

    project_paths = sorted(build_dir.glob("*.xcodeproj"))
    if len(project_paths) != 1:
        raise RuntimeError(
            f"Expected exactly one generated Xcode project in {build_dir}, found {len(project_paths)}"
        )
    return project_paths[0]


def prepare_header_directories(source_dir: Path, output_root: Path) -> dict[str, Path]:
    header_paths: dict[str, Path] = {}
    for definition in ARTIFACT_DEFINITIONS:
        header_dir = output_root / definition.target_name
        header_dir.mkdir(parents=True, exist_ok=True)
        copied_headers: list[str] = []
        for relative_path in definition.public_headers:
            source_header = source_dir / relative_path
            if not source_header.exists():
                raise RuntimeError(
                    f"Missing public header for {definition.target_name}: {source_header}"
                )
            destination = header_dir / source_header.name
            shutil.copy2(source_header, destination)
            copied_headers.append(source_header.name)

        module_map_path = header_dir / "module.modulemap"
        module_map_path.write_text(
            "\n".join(
                [
                    f"module {definition.target_name} {{",
                    *[f'  header "{header_name}"' for header_name in copied_headers],
                    "  export *",
                    "}",
                    "",
                ]
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
    run_command(arguments)

    binary_path = find_built_dynamic_library(derived_data_path, artifact_definition.library_name)
    return BuiltSlice(
        platform_group=platform_group,
        archive_path=archive_path,
        binary_path=binary_path,
    )


def build_archived_libraries(
    project_path: Path,
    archives_root: Path,
) -> dict[str, list[BuiltSlice]]:
    build_output: dict[str, list[BuiltSlice]] = {
        definition.target_name: [] for definition in ARTIFACT_DEFINITIONS
    }
    for definition in ARTIFACT_DEFINITIONS:
        for group in PLATFORM_GROUPS:
            build_output[definition.target_name].append(
                build_archive_for_slice(
                    project_path=project_path,
                    artifact_definition=definition,
                    platform_group=group,
                    archives_root=archives_root,
                )
            )
    return build_output


def create_xcframeworks(
    artifacts_dir: Path,
    build_output: dict[str, list[BuiltSlice]],
    header_paths: dict[str, Path],
) -> dict[str, Path]:
    artifacts_dir.mkdir(parents=True, exist_ok=True)
    created_xcframeworks: dict[str, Path] = {}

    for definition in ARTIFACT_DEFINITIONS:
        xcframework_dir = artifacts_dir / definition.xcframework_name
        arguments = ["xcodebuild", "-create-xcframework"]
        for built_slice in build_output[definition.target_name]:
            arguments.extend(
                [
                    "-library",
                    str(built_slice.binary_path),
                    "-headers",
                    str(header_paths[definition.target_name]),
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
            validate_binary_platform(binary_path, group.expected_vtool_platform)


def cmake_quote(value: str) -> str:
    return value.replace("\\", "/").replace('"', '\\"')


def write_consumer_fixture(consumer_root: Path, xcframeworks: dict[str, Path]) -> tuple[Path, Path]:
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

        library_root = xcframeworks[definition.target_name] / "macos-arm64_x86_64"
        header_dir = library_root / "Headers"
        dylibs = []
        for dependency_name in definition.consumer_dependencies:
            dependency = artifact_definition_by_name(dependency_name)
            dylibs.append(
                cmake_quote(
                    str(
                        xcframeworks[dependency.target_name]
                        / "macos-arm64_x86_64"
                        / dependency.library_name
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
                + " ".join(f'"{dylib}"' for dylib in dylibs)
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
    project_path = find_single_path(build_dir, "*.xcodeproj")
    return project_path, build_dir


def verify_consumer_fixture(xcframeworks: dict[str, Path], work_dir: Path) -> None:
    project_path, build_dir = write_consumer_fixture(work_dir / "consumer-fixture", xcframeworks)

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
        if definition.library_name not in debug_otool:
            raise RuntimeError(
                f"Debug consumer binary for {definition.target_name} is not linked against {definition.library_name}"
            )


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


def build_xcframework_archives(
    *,
    source_dir: Path,
    output_dir: Path,
    tag: str,
    working_dir: Path | None = None,
    keep_xcframeworks: bool = False,
) -> list[Path]:
    require_stable_tag(tag)
    source_dir = source_dir.resolve()
    output_dir = output_dir.resolve()

    if not source_dir.exists():
        raise RuntimeError(f"Source directory does not exist: {source_dir}")

    ensure_build_prerequisites()

    context_manager = (
        tempfile.TemporaryDirectory(prefix="spm-libwebp-build-")
        if working_dir is None
        else None
    )
    root_dir = Path(context_manager.name) if context_manager is not None else working_dir.resolve()
    root_dir.mkdir(parents=True, exist_ok=True)

    try:
        working_source = copy_source_tree(source_dir, root_dir)
        ensure_source_tree_is_buildable(working_source)
        project_path = configure_cmake_project(working_source, root_dir / "cmake-build")
        header_paths = prepare_header_directories(working_source, root_dir / "headers")
        build_output = build_archived_libraries(project_path, root_dir / "archives")
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


def command_release_artifacts(args: argparse.Namespace) -> int:
    artifacts = [dataclasses.asdict(artifact) for artifact in release_artifacts_for_tag(args.tag)]
    print(json.dumps({"artifacts": artifacts}, indent=2))
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


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description="SwiftPM release helpers for spm-libwebp.")
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

    release_artifacts_parser = subparsers.add_parser(
        "release-artifacts",
        help="Print JSON describing the release assets for a stable tag.",
    )
    release_artifacts_parser.add_argument("--tag", required=True)
    release_artifacts_parser.set_defaults(func=command_release_artifacts)

    build_plan_parser = subparsers.add_parser(
        "print-build-plan",
        help="Print the supported Apple platform matrix as JSON.",
    )
    build_plan_parser.set_defaults(func=command_print_build_plan)

    render_package_parser = subparsers.add_parser(
        "render-package-swift",
        help="Render a Package.swift that references release assets.",
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
        help="Build and archive all release XCFrameworks for a stable tag.",
    )
    build_xcframeworks_parser.add_argument("--source-dir", required=True)
    build_xcframeworks_parser.add_argument("--output-dir", required=True)
    build_xcframeworks_parser.add_argument("--tag", required=True)
    build_xcframeworks_parser.add_argument("--working-dir")
    build_xcframeworks_parser.add_argument("--keep-xcframeworks", action="store_true")
    build_xcframeworks_parser.set_defaults(func=command_build_xcframeworks)

    return parser


def main(argv: list[str] | None = None) -> int:
    parser = build_parser()
    args = parser.parse_args(argv)
    return args.func(args)


if __name__ == "__main__":
    raise SystemExit(main())
