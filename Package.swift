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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.83/WebP-1.6.0-alpha.83.xcframework.zip",
            checksum: "751cca4750bb1cad820f9fa2f78560deee94518c0e5c869afd0de788ab1a4d0a"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.83/WebPDecoder-1.6.0-alpha.83.xcframework.zip",
            checksum: "62e7c1d5a17cf34ed1102dff3dbd2aad1def5fe5e409ef81590f55809559dbc6"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.83/WebPDemux-1.6.0-alpha.83.xcframework.zip",
            checksum: "19e7bc3db2f635edfa2ea981af090beb9566ef054174547d838317b2c2470d20"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.83/WebPMux-1.6.0-alpha.83.xcframework.zip",
            checksum: "9deb8feac486ae313fb196eafbd8d28f1ee214284bd963fdcc5d7933f7f93282"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.83/SharpYuv-1.6.0-alpha.83.xcframework.zip",
            checksum: "c197b3b3357d331c32c478d0503a9d4ac8ad5b178c5f8922462b17f0ac0039e2"
        )
    ]
)
