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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.99/WebP-1.6.0-alpha.99.xcframework.zip",
            checksum: "6d3503b3a90a174e28e94be2e8889b11329fb8fc170a11c26b5840f0b9fe67fe"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.99/WebPDecoder-1.6.0-alpha.99.xcframework.zip",
            checksum: "b9aa8459b8d074e46c3b31b0b5a500b02509749b677f1317b6e43a1b2fbbe4ec"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.99/WebPDemux-1.6.0-alpha.99.xcframework.zip",
            checksum: "5b94ab9a180fbeef1c6f9a8e85139020e56450e9d1e9213b90abade6d3ccf317"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.99/WebPMux-1.6.0-alpha.99.xcframework.zip",
            checksum: "427ba107ba0f9a6231ec3fcf50e02152effb86637adb12aad5c57859006671fa"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.99/SharpYuv-1.6.0-alpha.99.xcframework.zip",
            checksum: "3905a374e1d2cd2719735092aa0344070d0881f16554d1e35e4c7a977dce3895"
        )
    ]
)
