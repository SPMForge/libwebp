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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.60/WebP-1.6.0-alpha.60.xcframework.zip",
            checksum: "175fc0e6b58ee3dee91cd22ad54f14ecae1272ca776858ce405a1a0b6cf88780"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.60/WebPDecoder-1.6.0-alpha.60.xcframework.zip",
            checksum: "492b21a85540074aa16ce248821ceb433ef67bfca23dd8baeb8fa5a7b57291cc"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.60/WebPDemux-1.6.0-alpha.60.xcframework.zip",
            checksum: "f8c3d42c14e3db3680224cac7f7bf668252be37b30afe99f8d759f65a2851ce3"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.60/WebPMux-1.6.0-alpha.60.xcframework.zip",
            checksum: "fb266d61403fa2200b2f6662d31e500fc56fd1bb31d48d4fa6a040d3d0a099fc"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.60/SharpYuv-1.6.0-alpha.60.xcframework.zip",
            checksum: "5200b8ec610bb69fdd17fa4516dad5890d7daaba8920886e34e3718cf6e355f4"
        )
    ]
)
