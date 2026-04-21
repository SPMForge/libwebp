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
        .library(name: "WebP", targets: ["WebP", "SharpYuv"]),
        .library(name: "WebPDecoder", targets: ["WebPDecoder"]),
        .library(name: "WebPDemux", targets: ["WebPDemux", "WebP", "SharpYuv"]),
        .library(name: "WebPMux", targets: ["WebPMux", "WebP", "SharpYuv"]),
        .library(name: "SharpYuv", targets: ["SharpYuv"])
    ],
    targets: [
        .binaryTarget(
            name: "WebP",
            url: "https://github.com/SPMForge/libwebp/releases/download/v1.6.0-alpha.8/WebP-v1.6.0-alpha.8.xcframework.zip",
            checksum: "7c11aefd63ca2efab1eb66400e23dc320a6e2de3bc4e120ed32b7bb0152a7ee8"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/v1.6.0-alpha.8/WebPDecoder-v1.6.0-alpha.8.xcframework.zip",
            checksum: "8e97a154ecb3a08fbf3f88d406cbb6057fd0b3d6317da8acac1a04135a02a945"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/v1.6.0-alpha.8/WebPDemux-v1.6.0-alpha.8.xcframework.zip",
            checksum: "637f855271316012348464762bad844353edd8cbc04441d628616b22caac5277"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/v1.6.0-alpha.8/WebPMux-v1.6.0-alpha.8.xcframework.zip",
            checksum: "360230eb2acd0a4ce16a44304e163340432169ec31efc43844729f27fa06b922"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/v1.6.0-alpha.8/SharpYuv-v1.6.0-alpha.8.xcframework.zip",
            checksum: "71cee6ee979c75e32bd2bd5180a8858aa2ad9e3d4765c3828ab307a8cfef92c2"
        )
    ]
)
