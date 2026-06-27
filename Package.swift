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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.70/WebP-1.6.0-alpha.70.xcframework.zip",
            checksum: "600295986350ce207b3cc0f5dbb3cb791956a964e33eac72b5b12733c0fcb162"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.70/WebPDecoder-1.6.0-alpha.70.xcframework.zip",
            checksum: "29bf17412d2ec62bec4bbfdf7d1a6cca1ea37c42f28d53997623635f745dbcab"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.70/WebPDemux-1.6.0-alpha.70.xcframework.zip",
            checksum: "bce957215716e2ae56d8f28e1b5d6e39e2e9781e8672bc948b74ef96fc452bd0"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.70/WebPMux-1.6.0-alpha.70.xcframework.zip",
            checksum: "b9fd56200a4cbce3c7c2ecb93be31f2fa8c06024e804bd89fd00b391d6d4b7eb"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.70/SharpYuv-1.6.0-alpha.70.xcframework.zip",
            checksum: "da00a5a751d7c51e803e9f7122282051bd8a8c7973563fdf8826b77383849b3c"
        )
    ]
)
