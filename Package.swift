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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.103/WebP-1.6.0-alpha.103.xcframework.zip",
            checksum: "2124929d206c075d43cd3511fc62689b7befcd66ae3232e8292c49c560233ba5"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.103/WebPDecoder-1.6.0-alpha.103.xcframework.zip",
            checksum: "d4f29bb2132d2be1a45a0f8332dbcfa1e5c5a6517f937bbfe4a3ab3f3d8130f9"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.103/WebPDemux-1.6.0-alpha.103.xcframework.zip",
            checksum: "d40e47d155ed4327b5e69eb865bbd43f49361896634f630023be329da05c6a85"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.103/WebPMux-1.6.0-alpha.103.xcframework.zip",
            checksum: "691fcfae1631acefebfca1c900b75f61011aed97b90a7a57b4586a1d06bfc6ab"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.103/SharpYuv-1.6.0-alpha.103.xcframework.zip",
            checksum: "b1c531cce6b89fc7bc0d4e29f871adf8a1a91466d791475ce96ba7aaea3bb142"
        )
    ]
)
