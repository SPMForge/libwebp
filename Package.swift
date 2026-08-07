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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.111/WebP-1.6.0-alpha.111.xcframework.zip",
            checksum: "ca9d36c262b7f667ba481ba9ce1b1b26ce38c2625b6f235ae2bc78b278d681d7"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.111/WebPDecoder-1.6.0-alpha.111.xcframework.zip",
            checksum: "3430701df8ecc50bb4e88f6f738972ba5e0440a3c960890ce84499ba6af3ab16"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.111/WebPDemux-1.6.0-alpha.111.xcframework.zip",
            checksum: "161566c626e0c774c2d930a3769abfab6b0022951d4b0cf8a8d875b75584edbd"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.111/WebPMux-1.6.0-alpha.111.xcframework.zip",
            checksum: "3f2b18ac5bdbcb51f4973eb2684e714a7143cf8c1f92fe9bb16b794cb2d8065e"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.111/SharpYuv-1.6.0-alpha.111.xcframework.zip",
            checksum: "6ba8da170889d6e3c7383873d2b0454929d15493a93b4ba4aa74c63268eaa216"
        )
    ]
)
