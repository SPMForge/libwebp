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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.43/WebP-1.6.0-alpha.43.xcframework.zip",
            checksum: "c08db1554e7ff3c3007281dc514c600c1d37390676b3a903cfc6ea9bd501b5ec"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.43/WebPDecoder-1.6.0-alpha.43.xcframework.zip",
            checksum: "4370abec257d36e6cc51cfb63147f81d89a432a6df9f020719098db42f51b6e8"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.43/WebPDemux-1.6.0-alpha.43.xcframework.zip",
            checksum: "966e286aed655e99959340c4b8a77aafdb25001fc036753babcdb7cff7dad7ce"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.43/WebPMux-1.6.0-alpha.43.xcframework.zip",
            checksum: "44a695d22fab810b769b9a5ac1a86df7e133873a9fc6b3f2cfa41fd168d9f72e"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.43/SharpYuv-1.6.0-alpha.43.xcframework.zip",
            checksum: "3ef74447d43f9d4a3d5b85efb7633647a1cd5c70d2f29f2109982f5c18d19035"
        )
    ]
)
