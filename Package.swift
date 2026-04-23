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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.2/WebP-1.6.0-alpha.2.xcframework.zip",
            checksum: "bd195b53a86d94842d84b655cbdff1f46b650b265ca0a2b802bcd6d4813d58de"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.2/WebPDecoder-1.6.0-alpha.2.xcframework.zip",
            checksum: "e6d76992b902c00f065e5f95ad1d37aef23bf9f026f82069b10745e4bbd39ee8"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.2/WebPDemux-1.6.0-alpha.2.xcframework.zip",
            checksum: "9533dceab02d5790bb861cee9b46fe8d9b3fb5d3e0000ea874f19348071b8293"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.2/WebPMux-1.6.0-alpha.2.xcframework.zip",
            checksum: "2633425d2558dbba35176cf33d4cd5727d5de0afe72728cdee0921f0856b7471"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.2/SharpYuv-1.6.0-alpha.2.xcframework.zip",
            checksum: "e7291939ecdf62f5bbcbbf4f919ba9d5f1750dddfd8e00a550cfcec55a920ca5"
        )
    ]
)
