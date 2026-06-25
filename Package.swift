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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.68/WebP-1.6.0-alpha.68.xcframework.zip",
            checksum: "af39249cfa9fa56674f2960abcfa971aba2f1e1b3f6432c84f3b5c8e2a6fc316"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.68/WebPDecoder-1.6.0-alpha.68.xcframework.zip",
            checksum: "a1c006417a314e36391b0d53b4f4224b25eeb25b61a7bf6dbd6614330a541ef6"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.68/WebPDemux-1.6.0-alpha.68.xcframework.zip",
            checksum: "d22166b2ad82f419103da276df57bc4edf783390e815c4fcc56eacac58efdda8"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.68/WebPMux-1.6.0-alpha.68.xcframework.zip",
            checksum: "0d5dabf8b9173fa169f7258fca1a101ed5511e2a26de390c8c2de28c88dd23cc"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.68/SharpYuv-1.6.0-alpha.68.xcframework.zip",
            checksum: "f3caab43394c3ac6fc78fc73249fbc56026d5385588d26c860e3e8b3ef8069e5"
        )
    ]
)
