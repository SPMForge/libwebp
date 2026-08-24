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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.128/WebP-1.6.0-alpha.128.xcframework.zip",
            checksum: "58434383a60ef54dcb2bfb84dc857338d52bde3b5655e2dade9c8a4cdede524f"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.128/WebPDecoder-1.6.0-alpha.128.xcframework.zip",
            checksum: "d3b26e5e3d0e9b0fe9b3b497da1922ba8657e37aa05e49663849db4863203d0b"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.128/WebPDemux-1.6.0-alpha.128.xcframework.zip",
            checksum: "6c0e93133e4962e2511ed154d566f85ab2d9c828a916b27f7903eda922092d1f"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.128/WebPMux-1.6.0-alpha.128.xcframework.zip",
            checksum: "f23aec04ca28e47cacf962435e6696c29d04c90b305c557fd39acbbacbe9289b"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.128/SharpYuv-1.6.0-alpha.128.xcframework.zip",
            checksum: "bda281e412664b37663c1484fb42c10e22ce3cb397c78afd0b0924030b2d5260"
        )
    ]
)
