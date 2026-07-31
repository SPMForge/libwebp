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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.104/WebP-1.6.0-alpha.104.xcframework.zip",
            checksum: "b4d43fef19af881597f3061f2334ccbf1025993e99742567cfe150e3d74bd289"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.104/WebPDecoder-1.6.0-alpha.104.xcframework.zip",
            checksum: "7447bfa5926fb4d9b3717bad3ff732462233673c102dcb6c7673ec5bf8be967c"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.104/WebPDemux-1.6.0-alpha.104.xcframework.zip",
            checksum: "3e8cfa349bb1a8584e1754e4308cc41470e0a2dd024e2f0b10c581432f09d723"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.104/WebPMux-1.6.0-alpha.104.xcframework.zip",
            checksum: "9913778f1ba7db376dcb184917f0a655a15f874cd8e8fcec9bb9458ff5ecbc58"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.104/SharpYuv-1.6.0-alpha.104.xcframework.zip",
            checksum: "b79e8bf35473f907d605a97a2f50b3f17fd1a6ceac0825bd7e798b174235b7e5"
        )
    ]
)
