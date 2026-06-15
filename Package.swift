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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.58/WebP-1.6.0-alpha.58.xcframework.zip",
            checksum: "317ec97da7b602b70fb6f18a6048e003e08cbfe341f6543c6d7e0177af513d31"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.58/WebPDecoder-1.6.0-alpha.58.xcframework.zip",
            checksum: "2ebf5c76d1a43d89b8f33750578a0be61fbc830c473c5046952ba28fa5481c34"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.58/WebPDemux-1.6.0-alpha.58.xcframework.zip",
            checksum: "6e1f4b5630056749ffc2c580caaab90b30ed3b4ae296559a6ded841edd8e1a18"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.58/WebPMux-1.6.0-alpha.58.xcframework.zip",
            checksum: "5cec8ea9c92fa8ed0cdc430e6fde1152f443668db485f38a7f4425ce83aaf039"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.58/SharpYuv-1.6.0-alpha.58.xcframework.zip",
            checksum: "2cda1b88cab5a6c95962d5770f1e804eab434b618570e817ae348a8a90fa4b1f"
        )
    ]
)
