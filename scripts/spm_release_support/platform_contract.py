from __future__ import annotations

from dataclasses import dataclass
import json
from pathlib import Path
import textwrap


REPO_ROOT = Path(__file__).resolve().parents[2]
DEFAULT_PLATFORM_CONTRACT_PATH = REPO_ROOT / "config" / "platforms.json"
RELEASE_METADATA_ASSETS: tuple[str, ...] = ("checksums.json",)


@dataclass(frozen=True)
class CompilerWrapperPaths:
    cc: Path
    cxx: Path


@dataclass(frozen=True)
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


@dataclass(frozen=True)
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
        return [
            f"SDKROOT={self.sdk}",
            f"{self.deployment_setting}={self.minimum_version}",
            f"ARCHS={' '.join(self.architectures)}",
            "ONLY_ACTIVE_ARCH=NO",
            "MERGEABLE_LIBRARY=YES",
            "CODE_SIGNING_ALLOWED=NO",
            "CODE_SIGNING_REQUIRED=NO",
            "SKIP_INSTALL=NO",
        ]

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


@dataclass(frozen=True)
class BuiltSlice:
    platform_group: PlatformGroup
    archive_path: Path
    binary_path: Path


ARTIFACT_DEFINITIONS: tuple[ArtifactDefinition, ...] = (
    ArtifactDefinition(
        target_name="WebP",
        cmake_target="webp",
        library_name="libwebp.dylib",
        public_headers=("src/webp/decode.h", "src/webp/encode.h", "src/webp/types.h"),
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
        public_headers=("src/webp/decode.h", "src/webp/types.h"),
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
        public_headers=("src/webp/decode.h", "src/webp/types.h", "src/webp/mux_types.h", "src/webp/demux.h"),
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
        public_headers=("src/webp/types.h", "src/webp/mux.h", "src/webp/mux_types.h"),
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
        public_headers=("sharpyuv/sharpyuv.h", "sharpyuv/sharpyuv_csp.h"),
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


def _swiftpm_version_literal(version: str) -> str:
    components = version.split(".")
    if not all(component.isdigit() for component in components):
        raise ValueError(f"unsupported SwiftPM deployment target version: {version}")
    while len(components) > 1 and components[-1] == "0":
        components.pop()
    return "_".join(components)


def load_platform_contract(path: Path = DEFAULT_PLATFORM_CONTRACT_PATH) -> dict[str, object]:
    payload = json.loads(path.read_text(encoding="utf-8"))
    if not isinstance(payload, dict):
        raise ValueError("platform contract must be a JSON object")
    deployment_targets = payload.get("deployment_targets")
    build_matrix = payload.get("build_matrix")
    if not isinstance(deployment_targets, dict):
        raise ValueError("deployment_targets must be an object")
    if not isinstance(build_matrix, list):
        raise ValueError("build_matrix must be a list")
    return payload


def deployment_target_model(path: Path = DEFAULT_PLATFORM_CONTRACT_PATH) -> dict[str, dict[str, object]]:
    payload = load_platform_contract(path)
    deployment_targets = payload["deployment_targets"]
    normalized: dict[str, dict[str, object]] = {}
    for family, entry in deployment_targets.items():
        if not isinstance(family, str) or not isinstance(entry, dict):
            raise ValueError("deployment target entries must be keyed by family and use object values")
        version = entry.get("version")
        swiftpm_platform = entry.get("swiftpm_platform")
        emit_to_package_manifest = entry.get("emit_to_package_manifest")
        if not isinstance(version, str) or not version:
            raise ValueError(f"deployment target version missing for {family}")
        if not isinstance(swiftpm_platform, str) or not swiftpm_platform:
            raise ValueError(f"swiftpm_platform missing for {family}")
        if not isinstance(emit_to_package_manifest, bool):
            raise ValueError(f"emit_to_package_manifest must be boolean for {family}")
        normalized[family] = {
            "version": version,
            "swiftpm_platform": swiftpm_platform,
            "emit_to_package_manifest": emit_to_package_manifest,
        }
    return normalized


def deployment_target_version(family: str, path: Path = DEFAULT_PLATFORM_CONTRACT_PATH) -> str:
    deployment_targets = deployment_target_model(path)
    if family not in deployment_targets:
        raise ValueError(f"Unknown deployment target family: {family}")
    return str(deployment_targets[family]["version"])


def _platform_group_from_entry(
    entry: dict[str, object],
    deployment_targets: dict[str, dict[str, object]],
) -> PlatformGroup:
    family = entry.get("family")
    if not isinstance(family, str) or family not in deployment_targets:
        raise ValueError(f"build matrix entry references unknown deployment target family: {family}")

    required_string_keys = ("name", "identifier", "supported_platform", "sdk", "deployment_setting", "expected_vtool_platform")
    normalized: dict[str, object] = {"family": family}
    for key in required_string_keys:
        value = entry.get(key)
        if not isinstance(value, str) or not value:
            raise ValueError(f"build matrix entry missing non-empty {key}")
        normalized[key] = value

    cmake_system_name = entry.get("cmake_system_name")
    if cmake_system_name is not None and not isinstance(cmake_system_name, str):
        raise ValueError("cmake_system_name must be a string or null")
    supported_platform_variant = entry.get("supported_platform_variant")
    if supported_platform_variant is not None and not isinstance(supported_platform_variant, str):
        raise ValueError("supported_platform_variant must be a string or null")
    destination = entry.get("destination")
    if destination is not None and not isinstance(destination, str):
        raise ValueError("destination must be a string or null")

    architectures = entry.get("architectures")
    if not isinstance(architectures, list) or not architectures or not all(isinstance(item, str) and item for item in architectures):
        raise ValueError("architectures must be a non-empty string list")

    simulator = entry.get("simulator", False)
    catalyst = entry.get("catalyst", False)
    if not isinstance(simulator, bool) or not isinstance(catalyst, bool):
        raise ValueError("simulator and catalyst flags must be boolean")

    return PlatformGroup(
        name=normalized["name"],
        identifier=normalized["identifier"],
        supported_platform=normalized["supported_platform"],
        sdk=normalized["sdk"],
        cmake_system_name=cmake_system_name,
        deployment_setting=normalized["deployment_setting"],
        minimum_version=str(deployment_targets[family]["version"]),
        architectures=tuple(architectures),
        expected_vtool_platform=normalized["expected_vtool_platform"],
        simulator=simulator,
        catalyst=catalyst,
        supported_platform_variant=supported_platform_variant,
        destination=destination,
    )


def load_platform_groups(path: Path = DEFAULT_PLATFORM_CONTRACT_PATH) -> tuple[PlatformGroup, ...]:
    payload = load_platform_contract(path)
    deployment_targets = deployment_target_model(path)
    return tuple(
        _platform_group_from_entry(entry, deployment_targets)
        for entry in payload["build_matrix"]
        if isinstance(entry, dict)
    )


PLATFORM_GROUPS: tuple[PlatformGroup, ...] = load_platform_groups()


def manifest_platform_entries(path: Path = DEFAULT_PLATFORM_CONTRACT_PATH) -> list[tuple[str, str]]:
    entries: list[tuple[str, str]] = []
    for family, entry in deployment_target_model(path).items():
        if not bool(entry["emit_to_package_manifest"]):
            continue
        entries.append((str(entry["swiftpm_platform"]), _swiftpm_version_literal(str(entry["version"]))))
    return entries


def manifest_platform_lines(path: Path = DEFAULT_PLATFORM_CONTRACT_PATH) -> list[str]:
    return [f"        .{platform}(.v{version})," for platform, version in manifest_platform_entries(path)]


def consumer_package_platform_lines(path: Path = DEFAULT_PLATFORM_CONTRACT_PATH) -> list[str]:
    deployment_targets = deployment_target_model(path)
    macos = deployment_targets["macos"]
    return [f"        .{macos['swiftpm_platform']}(.v{_swiftpm_version_literal(str(macos['version']))})"]


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


def build_plan_payload(path: Path = DEFAULT_PLATFORM_CONTRACT_PATH) -> dict[str, object]:
    return {
        "platform_groups": [group.to_dict() for group in load_platform_groups(path)],
        "deployment_targets": deployment_target_model(path),
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
