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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.131/WebP-1.6.0-alpha.131.xcframework.zip",
            checksum: "5148a93615c56a7f637f9eb0d8b73183b6c0b1e40cda90fc8401548a24e8a1da"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.131/WebPDecoder-1.6.0-alpha.131.xcframework.zip",
            checksum: "0eecc195fa55ef83cec6ea9cc923b0b232c226dce44808f6c56d1140e46e39a8"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.131/WebPDemux-1.6.0-alpha.131.xcframework.zip",
            checksum: "83355edf00064747896babc6bb735d6878ffdcd0052644e26c82d9f187281fdd"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.131/WebPMux-1.6.0-alpha.131.xcframework.zip",
            checksum: "18bc193928c35cf5313b2d0b12ed5728faa83cf3285945d1385791baf48a0230"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.131/SharpYuv-1.6.0-alpha.131.xcframework.zip",
            checksum: "dd5457c46a0903834fa86d7c93cb53d7365f4d48fe72f59f85d2a74f0a2a1f6e"
        )
    ]
)
