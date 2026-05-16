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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.28/WebP-1.6.0-alpha.28.xcframework.zip",
            checksum: "f3b6bf1f8c9fd708f2e7b949adee863db09813fa51e3be1ef60c147c74201647"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.28/WebPDecoder-1.6.0-alpha.28.xcframework.zip",
            checksum: "51d487b1795bfec1711d6089880d2fe0c1685c2edb5a9d9c56244bf70f48a915"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.28/WebPDemux-1.6.0-alpha.28.xcframework.zip",
            checksum: "53ca984dc18163d32c37e6e55f48b36f083f0e9029b30904d1851998e118c056"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.28/WebPMux-1.6.0-alpha.28.xcframework.zip",
            checksum: "af59640ab815472dceff81f5e43d472f9876ecd4b5e66c667576125f05180357"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.28/SharpYuv-1.6.0-alpha.28.xcframework.zip",
            checksum: "093a6aaf490e4df0175fcdd696614fbfb9dc81e7c83ccd066992185792591581"
        )
    ]
)
