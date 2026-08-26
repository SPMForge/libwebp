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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.130/WebP-1.6.0-alpha.130.xcframework.zip",
            checksum: "22aa86ee7de3099da9f7a0923c19e24a760b4fd07f91ee70558983cbf5c04d22"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.130/WebPDecoder-1.6.0-alpha.130.xcframework.zip",
            checksum: "18212331131b60d48695863807c13724147ca90fe207d1b45bd3a32f48390cae"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.130/WebPDemux-1.6.0-alpha.130.xcframework.zip",
            checksum: "112bd8674f6f93fc245e5c27a9350ad942f83112ab729f2c4817cae25696a7f9"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.130/WebPMux-1.6.0-alpha.130.xcframework.zip",
            checksum: "9daea30e2eec26a5983f25239305d7987daf49c3a24dfca3aede3dcfa3af52cc"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.130/SharpYuv-1.6.0-alpha.130.xcframework.zip",
            checksum: "b2ed4cf186ed6656723f92bea36042985485c259d9b969e64353cd99ee41f537"
        )
    ]
)
