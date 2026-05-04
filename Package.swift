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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.16/WebP-1.6.0-alpha.16.xcframework.zip",
            checksum: "ed05ab5ee6f1b359d906ac921c519d9d02925b45496ed7a4f83ea0cd4d8dffb3"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.16/WebPDecoder-1.6.0-alpha.16.xcframework.zip",
            checksum: "48ea5d9b9f6f9acd70243d276008bf21235e116e30209347dd897e3650e723db"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.16/WebPDemux-1.6.0-alpha.16.xcframework.zip",
            checksum: "209771a8100d0b268c126e86df14f8018409cf1f74bc872a4bcdf47ebfd48813"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.16/WebPMux-1.6.0-alpha.16.xcframework.zip",
            checksum: "056cb375494c9d4ac4b2db47da4991eabd3b3717d0fc91df2ebd6026a1a1d0c4"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.16/SharpYuv-1.6.0-alpha.16.xcframework.zip",
            checksum: "c53774bc2eaaae230dc30570b1654c1aeb66c47d4513e68368811d304e6217ba"
        )
    ]
)
