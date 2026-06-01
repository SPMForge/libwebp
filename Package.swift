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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.44/WebP-1.6.0-alpha.44.xcframework.zip",
            checksum: "67fd40db55ed527d09995501526a2c27800ec1c4b874a848e1cc36ae656f5ded"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.44/WebPDecoder-1.6.0-alpha.44.xcframework.zip",
            checksum: "023e70229b6681cffd931bffd87d343802524fa1d56522aa4be5eefbb8f70e41"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.44/WebPDemux-1.6.0-alpha.44.xcframework.zip",
            checksum: "bf5384334cdeb70146bdf6ab795d2b103f2035cce77cb2573de533ab47c76498"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.44/WebPMux-1.6.0-alpha.44.xcframework.zip",
            checksum: "395d7ca711ebbcef1ed9e5ae78c2702e0344c189d0706f551175d8d2be1aa08f"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.44/SharpYuv-1.6.0-alpha.44.xcframework.zip",
            checksum: "ea11a566f15fbaea2d474aa03c27fb7fbbd15e449108eb4f79f38c68f52a2df3"
        )
    ]
)
