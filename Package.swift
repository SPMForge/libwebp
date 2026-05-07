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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.19/WebP-1.6.0-alpha.19.xcframework.zip",
            checksum: "2b30e35e4bdc6b4e316e3ae95256fa8b9a1dce32097174bd194e40f83067cdfb"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.19/WebPDecoder-1.6.0-alpha.19.xcframework.zip",
            checksum: "8bcff8cc00f0b5081d008ae34e0e91aa3eb8cde8fce021720f9873558e77b448"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.19/WebPDemux-1.6.0-alpha.19.xcframework.zip",
            checksum: "07d2a6d1db074a38662c18e2d41f5a8069e9e205a1bd9299509815c16da6108a"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.19/WebPMux-1.6.0-alpha.19.xcframework.zip",
            checksum: "7d025cf8532129010fd1aebe25a328bd7e5bded6e6c46782b62d6323f9bd551d"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.19/SharpYuv-1.6.0-alpha.19.xcframework.zip",
            checksum: "75400177e91fd41bbdd1f9087332ab553bd79952135552be2a6ab9e64df690be"
        )
    ]
)
