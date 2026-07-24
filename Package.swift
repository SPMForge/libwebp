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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.97/WebP-1.6.0-alpha.97.xcframework.zip",
            checksum: "7b25c6e324db2a4e394bf05a4a87b67da11df7161a3ee5dd5fdc1a0d49e4428e"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.97/WebPDecoder-1.6.0-alpha.97.xcframework.zip",
            checksum: "7bc9b3afb5885357700f9c71090f63176d629c0fc09de985b5978498bffdf232"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.97/WebPDemux-1.6.0-alpha.97.xcframework.zip",
            checksum: "284425abeddae9aaa10223dd8fb34c48981e481502a81fa6788a9df857c6a66a"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.97/WebPMux-1.6.0-alpha.97.xcframework.zip",
            checksum: "e515cdb4e692b84dee5ee85f5269a4dc4ec0863c811d2203a3101183f9469ccd"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.97/SharpYuv-1.6.0-alpha.97.xcframework.zip",
            checksum: "17a313a0372d906ab98749f3178b8bcd52c7a6396ae6c00ff39ce92b0cbff1d3"
        )
    ]
)
