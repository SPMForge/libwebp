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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.47/WebP-1.6.0-alpha.47.xcframework.zip",
            checksum: "29d877847947138940840b64c0bb83bb3982b726f8664ccaebf28bbce2333742"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.47/WebPDecoder-1.6.0-alpha.47.xcframework.zip",
            checksum: "9fdb7f3a9a063514b816eed6051c26523f338a66ae3319912546b859e5ecbfd4"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.47/WebPDemux-1.6.0-alpha.47.xcframework.zip",
            checksum: "fc93c1e57df4eeddf261ae0b7e20d14c101c6c197bdf1000e15f97cbe5fbaffa"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.47/WebPMux-1.6.0-alpha.47.xcframework.zip",
            checksum: "8137eb7b92952cb016d68f372af832b99811b15f5edfe1f3c5b4f18e1e12effb"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.47/SharpYuv-1.6.0-alpha.47.xcframework.zip",
            checksum: "cf3cdfae074e3668c2ea70f1270c9f55388a007671a7f320cba0479611924417"
        )
    ]
)
