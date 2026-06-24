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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.67/WebP-1.6.0-alpha.67.xcframework.zip",
            checksum: "be32a20e0f05833e15980a782ebb9439e5d4f87649aea3c9f6e745cc4bdaf6e5"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.67/WebPDecoder-1.6.0-alpha.67.xcframework.zip",
            checksum: "05599e040592b50ffa57459ca6c45209948578dcbd130a8712e28b1c7f6d7c93"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.67/WebPDemux-1.6.0-alpha.67.xcframework.zip",
            checksum: "bc198756824911fb6f95dc6421e28f1a3532ede42ad9e3adf17498ac34a38101"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.67/WebPMux-1.6.0-alpha.67.xcframework.zip",
            checksum: "e02812a1eded60ee8d20d93451cd0b1ffe21ce48362520b664c8ed1c0f80e513"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.67/SharpYuv-1.6.0-alpha.67.xcframework.zip",
            checksum: "80767015d6e8c1105d7a987c64a4c3e87fb3446d8ff2b7eda3a155baabefb331"
        )
    ]
)
