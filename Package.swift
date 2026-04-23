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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.1/WebP-1.6.0-alpha.1.xcframework.zip",
            checksum: "6925fee8bbb4b9c9a2856705909b74e3b34c9a8aa7bf04d70b7d35bebdbee36d"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.1/WebPDecoder-1.6.0-alpha.1.xcframework.zip",
            checksum: "e346fe285e1e6c30f08e31e7a4786f573c82018eeb4b97ddd8b03f00224f319a"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.1/WebPDemux-1.6.0-alpha.1.xcframework.zip",
            checksum: "a4e7266592f175d83e4e36be76519727630752138d30c7fd65d3b6f946797970"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.1/WebPMux-1.6.0-alpha.1.xcframework.zip",
            checksum: "f7778857d4ebcd1d3fe5f4d5c5a4114af7285b8a106479e83b26436518d023f3"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.1/SharpYuv-1.6.0-alpha.1.xcframework.zip",
            checksum: "b1d38328539b95e228aeea0b709e457f5962cabda5668d11f3e161872949ed31"
        )
    ]
)
