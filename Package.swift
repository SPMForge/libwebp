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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.23/WebP-1.6.0-alpha.23.xcframework.zip",
            checksum: "5f58379497b8a2bb2462884dcba8298b69b270f9a2a7ba3888d2c1be70fc7e27"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.23/WebPDecoder-1.6.0-alpha.23.xcframework.zip",
            checksum: "1bb156cb2cd5dfc8124f04a976b030c63025f8d84fbf7fae56f423f20f9b5a81"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.23/WebPDemux-1.6.0-alpha.23.xcframework.zip",
            checksum: "43c6f90bd24cce17ff456f03734392b71b615e8ce41751882d2b061ff1aa6ed6"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.23/WebPMux-1.6.0-alpha.23.xcframework.zip",
            checksum: "75540cdeacbae39bad03e427631bd264f8797b1aad8c78fc8f490531f0f6cad5"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.23/SharpYuv-1.6.0-alpha.23.xcframework.zip",
            checksum: "204fed00d4b3e0e1f1651d8bf0c01310449afdb9e1815240f2169c38be3f8a43"
        )
    ]
)
