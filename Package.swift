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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.32/WebP-1.6.0-alpha.32.xcframework.zip",
            checksum: "6e243cddca7a1b6c9e5ac0d59ede9eec46f17609f2734b0fdbba8c1d6895e98f"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.32/WebPDecoder-1.6.0-alpha.32.xcframework.zip",
            checksum: "74cc7371e836f57cade4f56d0e9fc8be988936d582107b140c01f9891c0d3efb"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.32/WebPDemux-1.6.0-alpha.32.xcframework.zip",
            checksum: "0967ba1a6bfcecb7585ac2da4e8d62fe0b0faf34d1fe5ee61deadbc452d6ffee"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.32/WebPMux-1.6.0-alpha.32.xcframework.zip",
            checksum: "a9bca194cd9f1ca605777653fd231c1f2f80a108ef813f04db8279d0905830bb"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.32/SharpYuv-1.6.0-alpha.32.xcframework.zip",
            checksum: "e60b418c4f5a395f85f4fdf6ce24f37fe03bfde73c1bf3cc6ae330523667ee9c"
        )
    ]
)
