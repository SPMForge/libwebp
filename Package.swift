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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.35/WebP-1.6.0-alpha.35.xcframework.zip",
            checksum: "92b884198e2b4bacb7783c2030d96f3bc9ac60def5dd56058fed47f63a621de2"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.35/WebPDecoder-1.6.0-alpha.35.xcframework.zip",
            checksum: "84e0c04c8f906be9bb1049aa1237e315c488260d9d81810b63d07ef453c54821"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.35/WebPDemux-1.6.0-alpha.35.xcframework.zip",
            checksum: "0eaa62954a023b1bbba3758da3dd3ca4728d3d432a1454ba683325bd7adcc78a"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.35/WebPMux-1.6.0-alpha.35.xcframework.zip",
            checksum: "2fb6f253e41428109c8782bc3d1e23fecc1a1846f86a94c08d92b99f7fde6f33"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.35/SharpYuv-1.6.0-alpha.35.xcframework.zip",
            checksum: "e3ce6ed4c79c2ea75fc302f284af7b6cbf89df299967dd265c6834583f40bf4b"
        )
    ]
)
