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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.133/WebP-1.6.0-alpha.133.xcframework.zip",
            checksum: "bfed6baa3eb30ba5a89820600b04bd3d4c635775a3a4b57f0a49f14da91262e8"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.133/WebPDecoder-1.6.0-alpha.133.xcframework.zip",
            checksum: "22082c25ab0776062e86a1f6ac653a5524e65c4cac8043346c0769557007c5cf"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.133/WebPDemux-1.6.0-alpha.133.xcframework.zip",
            checksum: "eacd107f10426b4fad84d5f6c1862a8a748970692b2baf92b6721e4eb9fc51a8"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.133/WebPMux-1.6.0-alpha.133.xcframework.zip",
            checksum: "c95994bdd5e3dfff13c37dbe39153b58f87436541c30ec7ffaaf1b8befa39d50"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.133/SharpYuv-1.6.0-alpha.133.xcframework.zip",
            checksum: "a0947a337c0c800fcd0e666cfc48ebec4b46a5a127a39d825a69469a4dfd1ff8"
        )
    ]
)
