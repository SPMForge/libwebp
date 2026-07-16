// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "libwebp",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
        .tvOS(.v13),
        .watchOS(.v8),
        .visionOS(.v1),
    ],
    products: [
        .library(name: "WebP", targets: ["WebP", "SharpYuv"]),
        .library(name: "WebPDecoder", targets: ["WebPDecoder"]),
        .library(name: "WebPDemux", targets: ["WebPDemux", "WebP", "SharpYuv"]),
        .library(name: "WebPMux", targets: ["WebPMux", "WebP", "SharpYuv"]),
        .library(name: "SharpYuv", targets: ["SharpYuv"])
    ],
    targets: [
        .binaryTarget(
            name: "WebP",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.89/WebP-1.6.0-alpha.89.xcframework.zip",
            checksum: "b52b6f44f10869cc68ec022d499f595592ff6e9c1b064ef7dc52632622968b58"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.89/WebPDecoder-1.6.0-alpha.89.xcframework.zip",
            checksum: "bd7acaeeed5bedeb6995aab2bc158a4cfad4e85e2b7f84666bb72faf27ca6ac6"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.89/WebPDemux-1.6.0-alpha.89.xcframework.zip",
            checksum: "7f6549af20f9876a357375319702a936d591255cc6c8f7d34a1e350021b134c7"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.89/WebPMux-1.6.0-alpha.89.xcframework.zip",
            checksum: "a823d942795b3be4a10f114c1f90e62606eeb729fbf770a82a2f22645a11ae77"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.89/SharpYuv-1.6.0-alpha.89.xcframework.zip",
            checksum: "7777269c8d6828ecabeeb07173b597d034effeccb7f44b978c6aa283ff8cf910"
        )
    ]
)
