from __future__ import annotations

import json
from pathlib import Path
import re

from spm_release_support.platform_contract import (
    ARTIFACT_DEFINITIONS,
    consumer_package_platform_lines,
    manifest_platform_lines,
    swiftpm_product_targets,
)
from spm_release_support.release_planning import release_artifacts_for_tag, require_package_distribution_tag


CHECKSUM_PATTERN = re.compile(r"^[0-9a-f]{64}$")


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
            "Missing checksum values for required binary targets: " + ", ".join(missing_checksums)
        )

    invalid_checksums = sorted(
        target_name
        for target_name, checksum in checksums.items()
        if target_name in artifact_map and CHECKSUM_PATTERN.fullmatch(checksum) is None
    )
    if invalid_checksums:
        raise ValueError(
            "Invalid SHA-256 checksum values for binary targets: " + ", ".join(invalid_checksums)
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

    return "\n".join(
        [
            "// swift-tools-version: 5.9",
            "import PackageDescription",
            "",
            "let package = Package(",
            '    name: "libwebp",',
            "    platforms: [",
            *manifest_platform_lines(),
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
        raise ValueError("Missing XCFramework paths for binary targets: " + ", ".join(missing_targets))

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
                "            path: " + swift_string_literal(str(xcframework_paths[definition.target_name])),
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
            *manifest_platform_lines(),
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
            *consumer_package_platform_lines(),
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
