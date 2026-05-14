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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.26/WebP-1.6.0-alpha.26.xcframework.zip",
            checksum: "ed107557389d92e1453ff3dc4421eb61c2fffbc1b8eec8211e19096a43789aaf"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.26/WebPDecoder-1.6.0-alpha.26.xcframework.zip",
            checksum: "9e4c85dd9d5e1373d544ac5d05411d8376324b7d1602d4f83ed7b035beb51ade"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.26/WebPDemux-1.6.0-alpha.26.xcframework.zip",
            checksum: "c0b2696a15929e90ed1ca04644ab802b65414c58e4b7d7576bc1d954bee1dded"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.26/WebPMux-1.6.0-alpha.26.xcframework.zip",
            checksum: "9046059bf58ff4ad2aabec064518e94bdb7c9f21e03746340d9e03324397f3ce"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.26/SharpYuv-1.6.0-alpha.26.xcframework.zip",
            checksum: "90997b23637e714eb6335b65c3c7119169816193fa720b5a88b3027bd2ebf89d"
        )
    ]
)
