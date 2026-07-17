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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.90/WebP-1.6.0-alpha.90.xcframework.zip",
            checksum: "ecc815f31b772ddf2320130c234147a9165a508375ae2bbdb619fd5f8edd22cf"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.90/WebPDecoder-1.6.0-alpha.90.xcframework.zip",
            checksum: "9271ca8adc92d5c03419c058bce5b65600ab8dcdfb621ddc83ee59d3d146cfff"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.90/WebPDemux-1.6.0-alpha.90.xcframework.zip",
            checksum: "02c394f4945d2beaaefa2a07109f499907eb70d59ad864a2ed99507a41fc2475"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.90/WebPMux-1.6.0-alpha.90.xcframework.zip",
            checksum: "bef8f330f9bc04e2ca890bb3f077774c040e429f45481473be25a9e0613176c9"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.90/SharpYuv-1.6.0-alpha.90.xcframework.zip",
            checksum: "f7e7381638625d2a3291eb1915c8b275f7c2e1f34d89e0fc23bade9029b4856a"
        )
    ]
)
