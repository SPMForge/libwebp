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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.66/WebP-1.6.0-alpha.66.xcframework.zip",
            checksum: "449da4bbd2f96cb0432b539405bd45d64e4b55bfc55087042347aea41ba996ca"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.66/WebPDecoder-1.6.0-alpha.66.xcframework.zip",
            checksum: "c6a854d7fa5c9c54063540fce1cbdf286188ad17d6fa3a284b56ca55c1f0fede"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.66/WebPDemux-1.6.0-alpha.66.xcframework.zip",
            checksum: "8ea036bb7380dc92ea00e2f1d06682b5388ec06a95e3d3f2fe7eaf18916d472f"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.66/WebPMux-1.6.0-alpha.66.xcframework.zip",
            checksum: "31da614b57bdb61f5f29220a225c245b1da836a588adfcd3c4cdefabb1a79931"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.66/SharpYuv-1.6.0-alpha.66.xcframework.zip",
            checksum: "1f5ce9edec1675193fe149c03d6bac6baf1247569fde06ea60e31f5f02fd1b58"
        )
    ]
)
