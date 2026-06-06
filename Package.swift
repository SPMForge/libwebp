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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.49/WebP-1.6.0-alpha.49.xcframework.zip",
            checksum: "38a8b4f3f9d0846e69ee33a954a4180553e5b45e1360bdc48423bd841430a6ac"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.49/WebPDecoder-1.6.0-alpha.49.xcframework.zip",
            checksum: "5e33116aae12f8797123354bb59268cf5e46dfc83ca721e464628d58c7e982fc"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.49/WebPDemux-1.6.0-alpha.49.xcframework.zip",
            checksum: "759b997218da579c77e13628ca7d3053d7187d4627174ec6903cdebb7be6bbb8"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.49/WebPMux-1.6.0-alpha.49.xcframework.zip",
            checksum: "351461e2fe6bedbe879d5bc7aa848fe196f55f3a148c4b4c3782c7e11d21df34"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.49/SharpYuv-1.6.0-alpha.49.xcframework.zip",
            checksum: "36db8b1649e1451f9e29d32782ff82f29a0b5ff6071b6ed79ab32b64764747fb"
        )
    ]
)
