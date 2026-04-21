// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "libwebp",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
        .tvOS(.v13),
        .watchOS(.v8),
        .visionOS(.v1)
    ],
    products: [
        .library(name: "WebP", targets: ["WebP"]),
        .library(name: "WebPDecoder", targets: ["WebPDecoder"]),
        .library(name: "WebPDemux", targets: ["WebPDemux", "WebP"]),
        .library(name: "WebPMux", targets: ["WebPMux", "WebP"]),
        .library(name: "SharpYuv", targets: ["SharpYuv"])
    ],
    targets: [
        .binaryTarget(
            name: "WebP",
            url: "https://github.com/SPMForge/libwebp/releases/download/v1.6.0-alpha.6/WebP-v1.6.0-alpha.6.xcframework.zip",
            checksum: "6fbf5c49186605bbf9d6a30007ff0a368724c0ba927437aab06aa7aa5f90d9e4"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/v1.6.0-alpha.6/WebPDecoder-v1.6.0-alpha.6.xcframework.zip",
            checksum: "94b9d9a58cd60f9dbe39d59314c6b1eec810e37351381ff971681191ae73a44e"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/v1.6.0-alpha.6/WebPDemux-v1.6.0-alpha.6.xcframework.zip",
            checksum: "0df9ffa29b486a340e7d3725fbe8faa95776dc20be4b2132a0dd68dbe0ddddd8"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/v1.6.0-alpha.6/WebPMux-v1.6.0-alpha.6.xcframework.zip",
            checksum: "bbb3b56a4708832e28efe0199518454349409ff4dd8d578c805b519b30a03d44"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/v1.6.0-alpha.6/SharpYuv-v1.6.0-alpha.6.xcframework.zip",
            checksum: "6263e95e7b3173695d6e341bae20cd361b4fc031b4e228f54cbd393f02ad2664"
        )
    ]
)
