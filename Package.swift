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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.61/WebP-1.6.0-alpha.61.xcframework.zip",
            checksum: "c440061f1c440b70db8715514d76126e017e132c2ec0b87fb81b3dabfed82f61"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.61/WebPDecoder-1.6.0-alpha.61.xcframework.zip",
            checksum: "15bf1f16c7b46e2193b03928c496e13bde613c68d33176a0fda5db8c1650310a"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.61/WebPDemux-1.6.0-alpha.61.xcframework.zip",
            checksum: "b3ab5be481128ccb010f1d1d95742323901be2996eb64c0fa8891dd7459ea91e"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.61/WebPMux-1.6.0-alpha.61.xcframework.zip",
            checksum: "5b352cdfb44be5796a6f2b7ce4810234d3d35391182727b84e541d62ae05b89b"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.61/SharpYuv-1.6.0-alpha.61.xcframework.zip",
            checksum: "10fe483bc293b46058f75b4835b5492969434aa19ca4e537eeb8f612549e0285"
        )
    ]
)
