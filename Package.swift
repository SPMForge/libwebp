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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.140/WebP-1.6.0-alpha.140.xcframework.zip",
            checksum: "d527f9a66c9fbada16e394d9ca393503fe1fe3a4d4156afd2cd73de161063cc2"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.140/WebPDecoder-1.6.0-alpha.140.xcframework.zip",
            checksum: "208ba7c54c60862335ddc4f04220f4dfda9320351a9242b525794422e23396c3"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.140/WebPDemux-1.6.0-alpha.140.xcframework.zip",
            checksum: "a3516d1ac195f51479a8b74a35f082c2a6abd4fd5f6403f981029b0d290b8596"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.140/WebPMux-1.6.0-alpha.140.xcframework.zip",
            checksum: "80c305270f73e1901981713e2920f1695c14f1e6ad9c71c5109a33f17cbe1a64"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.140/SharpYuv-1.6.0-alpha.140.xcframework.zip",
            checksum: "3979af0e5a55e6e6139d6ef1cc07c38d783960d2917490acff0c9c4105fc18d6"
        )
    ]
)
