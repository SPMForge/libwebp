// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "libwebp",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
        .tvOS(.v13),
        .watchOS(.v8),
        .visionOS(.v1)
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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0/WebP-1.6.0.xcframework.zip",
            checksum: "6b400182b1ff79a488fbe28027e9078bd7a41426f22c05720b6af1f0a0343ab1"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0/WebPDecoder-1.6.0.xcframework.zip",
            checksum: "a2113dbeea4a6d842c18dd343df58936cff2b309b72b9c6d9b41bef8e9f5d727"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0/WebPDemux-1.6.0.xcframework.zip",
            checksum: "0f8e9505416fda907e3e802078a2275b69507dfd0e4103533470342bfe0c6f0c"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0/WebPMux-1.6.0.xcframework.zip",
            checksum: "498fc5ca0e62d7dc04d52254bbf972529777799100a1a473675be4da8ca63c19"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0/SharpYuv-1.6.0.xcframework.zip",
            checksum: "8990771df6ff20e0cc63b45a94ef98b9cecb041209376cc14b684c7736dcc984"
        )
    ]
)
