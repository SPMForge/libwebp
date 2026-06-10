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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.53/WebP-1.6.0-alpha.53.xcframework.zip",
            checksum: "5e1a6048ac9e08d4279ba85e030a8cd38202fa1b3b26e7d44c229f71ff5d8178"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.53/WebPDecoder-1.6.0-alpha.53.xcframework.zip",
            checksum: "1fe5c125569ef13ec0b6138de38fcb244b8c6e2e18a73ed9391a4a8ec497b572"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.53/WebPDemux-1.6.0-alpha.53.xcframework.zip",
            checksum: "ddd793e06909fce15413b7447410290cc1f58b96e53989d1dd9338a2467d50ce"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.53/WebPMux-1.6.0-alpha.53.xcframework.zip",
            checksum: "e590e91466fc37c2d1e89b409a202a859dd3f91101a91004aa0a8766c7625b1d"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.53/SharpYuv-1.6.0-alpha.53.xcframework.zip",
            checksum: "ab684c367ff55ec50cdeae96538a8c63c4d6e171ed74d885cdc74b72f6babe80"
        )
    ]
)
