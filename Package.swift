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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.15/WebP-1.6.0-alpha.15.xcframework.zip",
            checksum: "eb12b04e648a96bbb68935f0563458f624ffb7d397d1f77387ecec4e2565d862"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.15/WebPDecoder-1.6.0-alpha.15.xcframework.zip",
            checksum: "7e2bf35a2cae8c15c46cfec1b11de2ef827b785eb9cce22e39c077e6273f3c14"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.15/WebPDemux-1.6.0-alpha.15.xcframework.zip",
            checksum: "66eb099f926f713e1cff81a7db5811a3df9b7a3489d11389bb69aff2defe8ead"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.15/WebPMux-1.6.0-alpha.15.xcframework.zip",
            checksum: "7d2342122d421ee5a818d0404fb2f2bb40d2894dfb588b81aa317c51df94ccd4"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.15/SharpYuv-1.6.0-alpha.15.xcframework.zip",
            checksum: "e835669544b480d126bc0812a380b64af6b160855a88f7e0b74c4df1cf9db8c8"
        )
    ]
)
