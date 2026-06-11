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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.54/WebP-1.6.0-alpha.54.xcframework.zip",
            checksum: "a73d7ccf5c09424c88896385cd2792b918abc8e8476cb088c99abeef3a37b0a9"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.54/WebPDecoder-1.6.0-alpha.54.xcframework.zip",
            checksum: "8aa2dd04d493626ab7afd607aa585d476c719a3ee1e67d34820a2902d3540de4"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.54/WebPDemux-1.6.0-alpha.54.xcframework.zip",
            checksum: "1effe98ebc05c071a53da114f3652af08d8d70dafbb244084cdc56b4f8f12847"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.54/WebPMux-1.6.0-alpha.54.xcframework.zip",
            checksum: "f7b447e0b31dbdd8945745ba3566330786d35279e9274f82637852d22edbc5c8"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.54/SharpYuv-1.6.0-alpha.54.xcframework.zip",
            checksum: "a862abf10eecefb97865cdba6e187bbbd7d9d2543e5395411f699c00dba5e814"
        )
    ]
)
