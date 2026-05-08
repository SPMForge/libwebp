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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.20/WebP-1.6.0-alpha.20.xcframework.zip",
            checksum: "b88ce7c447198f5cfe1951267b4651ada742dcde5b2099dbe9785b2a09be5087"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.20/WebPDecoder-1.6.0-alpha.20.xcframework.zip",
            checksum: "38174cea4683b315a7dce9395f2ebf0a9417a6be280fc46342e2dc8a3b14d4ff"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.20/WebPDemux-1.6.0-alpha.20.xcframework.zip",
            checksum: "fd58c38482b6aaf795f9420d7da12470a9ccc937df36c8785512faec9e787a52"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.20/WebPMux-1.6.0-alpha.20.xcframework.zip",
            checksum: "3b6b82680b4bb5e41745a4a0f293a38f0a57f3cc5cc3e0792c0245e005d03d50"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.20/SharpYuv-1.6.0-alpha.20.xcframework.zip",
            checksum: "3c7703e4d215e2f2c19961581d9eaf9e678221c0549bd1179a05574274de159b"
        )
    ]
)
