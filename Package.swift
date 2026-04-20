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
            url: "https://github.com/SPMForge/libwebp/releases/download/v1.6.0-alpha.2/WebP-v1.6.0-alpha.2.xcframework.zip",
            checksum: "bb5639a509ff9290acda01231dbb85298c36575a034e2f761c10f109ea9b3886"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/v1.6.0-alpha.2/WebPDecoder-v1.6.0-alpha.2.xcframework.zip",
            checksum: "e8694bd4adcdc5d6a38025bd27eec17560e87ec67bdbf39af7596582897ed658"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/v1.6.0-alpha.2/WebPDemux-v1.6.0-alpha.2.xcframework.zip",
            checksum: "f150e6a0dd5c38f3526fc87c643a076dfe91bbe3683e95ec88cea3d3aa151860"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/v1.6.0-alpha.2/WebPMux-v1.6.0-alpha.2.xcframework.zip",
            checksum: "7c86e66056b1aeadd1f01efaf4a98ccda5032a5423f8be5fe21e54c41acadd1b"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/v1.6.0-alpha.2/SharpYuv-v1.6.0-alpha.2.xcframework.zip",
            checksum: "01c5fef502e27d17d950bd4ec763c522b851223cdb5e7ff0435ba891dce242d9"
        )
    ]
)
