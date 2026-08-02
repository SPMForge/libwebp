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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.106/WebP-1.6.0-alpha.106.xcframework.zip",
            checksum: "fedb8cd404a90ccb0dfb7d234cdef7a14c50e9d2052de4fac7526f7feb1a497a"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.106/WebPDecoder-1.6.0-alpha.106.xcframework.zip",
            checksum: "97f7278292a9c4f9247fcf0ecf835d6f084ac82e40b1be871f5489769926b18e"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.106/WebPDemux-1.6.0-alpha.106.xcframework.zip",
            checksum: "9d6e3250caed15fea46e8282ebd3ba3bedbf9ef7e1e109d8852c757e0a93752e"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.106/WebPMux-1.6.0-alpha.106.xcframework.zip",
            checksum: "147ae81133b12114dfed32757f0bdcdf13b492ed4c26d2007b4239aac4384533"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.106/SharpYuv-1.6.0-alpha.106.xcframework.zip",
            checksum: "20bdb69edefd38fc236469b80f90f33528dd8df6e9785c0732f49e5ae58fe67f"
        )
    ]
)
