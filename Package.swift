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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.118/WebP-1.6.0-alpha.118.xcframework.zip",
            checksum: "86a3edb2b80ce24f251bd043ae82c73d3cf937a63e388210d9c6ab3eaaf65b85"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.118/WebPDecoder-1.6.0-alpha.118.xcframework.zip",
            checksum: "3e9e48c6fa4fc2a5a79cd304965f1e5c36561df0b774ec74e82dc5913577ddaa"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.118/WebPDemux-1.6.0-alpha.118.xcframework.zip",
            checksum: "044a068aca8f4ba41fbec58d6000e10cbe595fa94ea74328c0bee490b695b141"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.118/WebPMux-1.6.0-alpha.118.xcframework.zip",
            checksum: "b8ba3847dd6f7c08c0af658958fe73d0413ae38360642bcc05d1f9cf51fad94d"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.118/SharpYuv-1.6.0-alpha.118.xcframework.zip",
            checksum: "a436c97dd538ddee71c3baebd3c879b50c359906163fbf9017e9ee754ec7bd1d"
        )
    ]
)
