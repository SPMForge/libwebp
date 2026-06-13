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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.56/WebP-1.6.0-alpha.56.xcframework.zip",
            checksum: "d3a6038315bdb56267c8169a26da991b5ae00fb170f111d81db26a1c7e175904"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.56/WebPDecoder-1.6.0-alpha.56.xcframework.zip",
            checksum: "17bb2df610b7fc78a152e4e2cbf23df7bbe32ecfe97ee47eec79fa3b0f5cb356"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.56/WebPDemux-1.6.0-alpha.56.xcframework.zip",
            checksum: "146bd9f86d804169b77e76ec6cf2689419c1c6ebdab5a38cc1fc1d0cfc5506e2"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.56/WebPMux-1.6.0-alpha.56.xcframework.zip",
            checksum: "5e0e7a79b7ff203ac6f1dda598189d5b1251cfc0037394c7df68604774021865"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.56/SharpYuv-1.6.0-alpha.56.xcframework.zip",
            checksum: "5e287a4512946ff473260b5587e790e7ebbdd72976a9e1293579815950307a5d"
        )
    ]
)
