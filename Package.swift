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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.124/WebP-1.6.0-alpha.124.xcframework.zip",
            checksum: "5639c8073aabe58052dd5a5ed4ebe19f700d20a4881e5616a943ce88b42b6dda"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.124/WebPDecoder-1.6.0-alpha.124.xcframework.zip",
            checksum: "5972000a08da45484c482a75fe1e948dc541b55dd3d51141540dddf276e51336"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.124/WebPDemux-1.6.0-alpha.124.xcframework.zip",
            checksum: "84e08ebb1287f7c05388c643548af8c909e8462f6795da2b0c9555ae9abb05d9"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.124/WebPMux-1.6.0-alpha.124.xcframework.zip",
            checksum: "b1e8af1fbdeb3c641597646bc05a750716c686cbb9bb27833cc1657e71761b0f"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.124/SharpYuv-1.6.0-alpha.124.xcframework.zip",
            checksum: "76fc91dbc5b47ff15de12471a293b13d0d6bb3ab98133c4d142baf2c6634a951"
        )
    ]
)
