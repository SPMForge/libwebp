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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.7/WebP-1.6.0-alpha.7.xcframework.zip",
            checksum: "661514365d5cfc7874fc9838d6a547fcc8ebe51c4c3ee30a89e2d7fe430ca5b6"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.7/WebPDecoder-1.6.0-alpha.7.xcframework.zip",
            checksum: "f91f5dca711fe595b171fd91ad607016b11822e0e52d9eb20750224774d5c166"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.7/WebPDemux-1.6.0-alpha.7.xcframework.zip",
            checksum: "8d3fc0e2f4785a82fce0ee6211381fc4d8792b15b365ab18abd377bd61a8017a"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.7/WebPMux-1.6.0-alpha.7.xcframework.zip",
            checksum: "5bad6264a85183de4df9e68a7f21eee1fa937223b626991cd1e17273d497ef7e"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.7/SharpYuv-1.6.0-alpha.7.xcframework.zip",
            checksum: "6586f0c4952aee8c981c585c027f8fca8785575261e21301a4fb71848aba3b4e"
        )
    ]
)
