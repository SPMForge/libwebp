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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.86/WebP-1.6.0-alpha.86.xcframework.zip",
            checksum: "8123defee31c3734e23fc0dc8a6ffc181a63ad252a06a793717615ccb1fab1f3"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.86/WebPDecoder-1.6.0-alpha.86.xcframework.zip",
            checksum: "802f5b59473a8f3d08dc51ad312c606bb2564bcac10671ae231933735ad791d9"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.86/WebPDemux-1.6.0-alpha.86.xcframework.zip",
            checksum: "f4645270f66fb19c7072868d9b61d47db40d400f84dabcd5e142a2d96db17031"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.86/WebPMux-1.6.0-alpha.86.xcframework.zip",
            checksum: "6f2dc8f62dc63da4fe6ab82f0790c1a229629225a391713a6461e1ba1da74ed9"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.86/SharpYuv-1.6.0-alpha.86.xcframework.zip",
            checksum: "637706f728d3fc60f8ea249d5782865b269e4542f6800d4abe21b9b35d48ffba"
        )
    ]
)
