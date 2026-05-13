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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.25/WebP-1.6.0-alpha.25.xcframework.zip",
            checksum: "006d2183dc9adc006494b23577bd7ef089a450f0b7d0366f42e81317dc8f88f8"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.25/WebPDecoder-1.6.0-alpha.25.xcframework.zip",
            checksum: "0750173e9129dac33f0fd73feedbdcf9eeb36b2412e623e9cc58a72df24850bf"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.25/WebPDemux-1.6.0-alpha.25.xcframework.zip",
            checksum: "cf68c4fe3b43b288b13545fa8a807050af24fb16717487208b9a3e77429287d2"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.25/WebPMux-1.6.0-alpha.25.xcframework.zip",
            checksum: "b9d4efe06343afaf036b2778ab2d8824d2a8f28a7bcbbb3de1ab2aae89153826"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.25/SharpYuv-1.6.0-alpha.25.xcframework.zip",
            checksum: "ed99bc1093f615624333f40907e388c5e5332b79bdc7ff099e54a344ea9ff28e"
        )
    ]
)
