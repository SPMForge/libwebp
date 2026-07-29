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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.102/WebP-1.6.0-alpha.102.xcframework.zip",
            checksum: "0b36e754fb6ee424274297cbaf1790a8cfc3f71f1d8fe2867023cef1495079c1"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.102/WebPDecoder-1.6.0-alpha.102.xcframework.zip",
            checksum: "cca6bc01e50b961a2aa73729d243e1d311279e5ab151e89e61c620004adb5d6a"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.102/WebPDemux-1.6.0-alpha.102.xcframework.zip",
            checksum: "81c24d1d7ae984c01b8e0cd952de7fc80d87c4d12b92a5e38c86f712e649cb42"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.102/WebPMux-1.6.0-alpha.102.xcframework.zip",
            checksum: "5ed6a9c70ccff7ba8a6d49c83f16f5a4401c5d7489fbeb41a7c910fff2eb833d"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.102/SharpYuv-1.6.0-alpha.102.xcframework.zip",
            checksum: "9fac8826cbdfa1e83d1913842fd20548090cd23e45e470e7c32697ec3bff9764"
        )
    ]
)
