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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.80/WebP-1.6.0-alpha.80.xcframework.zip",
            checksum: "88e20556cc9d1c93123c41d75a7675c50352a053a56214f4a2696f988d8ecc77"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.80/WebPDecoder-1.6.0-alpha.80.xcframework.zip",
            checksum: "e842889cacc2d94a9e02739378ffd06cfc963c0347f9d49bff703f633ef15ce5"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.80/WebPDemux-1.6.0-alpha.80.xcframework.zip",
            checksum: "d98bf3b070d87e280184c627383cf23f8c829165bf3b38e69cd83d4553de5fcb"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.80/WebPMux-1.6.0-alpha.80.xcframework.zip",
            checksum: "2cc120fd7a3c7dbe976dcf5f9618c2ab0fc2dcb7061f93501b30a94af3816533"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.80/SharpYuv-1.6.0-alpha.80.xcframework.zip",
            checksum: "c80191281a0c2ea697e7b97e62f08d1252647efe70c3d01812d6bc400e616437"
        )
    ]
)
