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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.77/WebP-1.6.0-alpha.77.xcframework.zip",
            checksum: "2271c8adece2a4dab82e9300a357fbe9cd8ff116a2f370e93a31b6cc9960dda7"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.77/WebPDecoder-1.6.0-alpha.77.xcframework.zip",
            checksum: "0539fc7e1d5bb683203e5898a9b90a86d4a8886a113ab80ef1645b319cd977be"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.77/WebPDemux-1.6.0-alpha.77.xcframework.zip",
            checksum: "51317c45d4423309ebf544daa744c9e9235a2f2946c1451e255a06e8f78f74a5"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.77/WebPMux-1.6.0-alpha.77.xcframework.zip",
            checksum: "45edab4be7cc51b39d20546570c9e1dc6ecd234438b5288fb2e3a3e4fae055fe"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.77/SharpYuv-1.6.0-alpha.77.xcframework.zip",
            checksum: "c96373ef5964111d005c2c0550f992c2f42b329a332a49b2736c1df8fb690dc9"
        )
    ]
)
