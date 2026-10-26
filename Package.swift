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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.192/WebP-1.6.0-alpha.192.xcframework.zip",
            checksum: "7b308b9855cb9b153233bfc07ab1ff2202e12fbc65424c9edfb60157076943ad"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.192/WebPDecoder-1.6.0-alpha.192.xcframework.zip",
            checksum: "13aca4dc81470d6498d323ff4bf30fabaad68af021b728edaeb8a92ed684b889"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.192/WebPDemux-1.6.0-alpha.192.xcframework.zip",
            checksum: "8a048aabfe11c263bb775b5708db948b819920e70cccd3a65463bd2f71366c2b"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.192/WebPMux-1.6.0-alpha.192.xcframework.zip",
            checksum: "bc3f7b89f83ef3a65d45819c330a4d48296b28e1c975ca3c675a4e4e5812d34d"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.192/SharpYuv-1.6.0-alpha.192.xcframework.zip",
            checksum: "4b16c8a552be9e10ee6d27d554c0bba057c407d1f2495b30be06b0c8981a5dfa"
        )
    ]
)
