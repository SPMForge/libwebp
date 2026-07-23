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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.96/WebP-1.6.0-alpha.96.xcframework.zip",
            checksum: "580fb2ccea1a04218a566c93f7c70e9fc2f9f6759c7933f38947c2619cb6b8a9"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.96/WebPDecoder-1.6.0-alpha.96.xcframework.zip",
            checksum: "c26d607f47c1fc7d8bcbd69ffbeeef18903a4afad55c96adb0302b0a85c620c5"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.96/WebPDemux-1.6.0-alpha.96.xcframework.zip",
            checksum: "3842f3b2caf419bc62386a4984ea60e5dc2e330e0546ead9b5657b5594adca93"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.96/WebPMux-1.6.0-alpha.96.xcframework.zip",
            checksum: "3a3877df0bbf38444dbe8f964949f49490a4f64b243502e055b4aa6d1cda6760"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.96/SharpYuv-1.6.0-alpha.96.xcframework.zip",
            checksum: "f3a85d9111422913c51dc89c5b2773bd19d66c15fc2630c644bab23c1d9de449"
        )
    ]
)
