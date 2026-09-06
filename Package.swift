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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.141/WebP-1.6.0-alpha.141.xcframework.zip",
            checksum: "5ba354891b0f2901ab502743ae388f45829ea11b784791a6a6976c7ccab9f780"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.141/WebPDecoder-1.6.0-alpha.141.xcframework.zip",
            checksum: "5a1d62c2e6aed37fe7659089d0c881b5b92bd68d1f8b8f6d3a5209f711a35a18"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.141/WebPDemux-1.6.0-alpha.141.xcframework.zip",
            checksum: "9eafee05b757c950b392ba70de7c8c87ae211b762837622d63a8fc72d85437ee"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.141/WebPMux-1.6.0-alpha.141.xcframework.zip",
            checksum: "d693eebb231f6b33f4aa424e4810c4cc1349441661cddee8b4ba936bcaceff71"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.141/SharpYuv-1.6.0-alpha.141.xcframework.zip",
            checksum: "a2c1328c1cfab21470733414143c086857d4d56dc59caf827e741d585bf65ffd"
        )
    ]
)
