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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.51/WebP-1.6.0-alpha.51.xcframework.zip",
            checksum: "c84d5533c0bfe05857e605b101fa08324ce895e343f15fbc371007b6ca7ff9d3"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.51/WebPDecoder-1.6.0-alpha.51.xcframework.zip",
            checksum: "b9ab5b0db0751770c41988d26d008163c261fd9554948e26ff154a2594124d7c"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.51/WebPDemux-1.6.0-alpha.51.xcframework.zip",
            checksum: "53e849ef5869803fb656160a011d87ab83dd87e1750686267eeb4f153fab1d95"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.51/WebPMux-1.6.0-alpha.51.xcframework.zip",
            checksum: "afe859cd612ad2fb1c834b0152361128857be2df006a4a2f846b88ba3460150e"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.51/SharpYuv-1.6.0-alpha.51.xcframework.zip",
            checksum: "434c88522f4603f5564a08b197d79cd7b2cee7938a9caafabe1315e529fea5c8"
        )
    ]
)
