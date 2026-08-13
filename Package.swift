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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.117/WebP-1.6.0-alpha.117.xcframework.zip",
            checksum: "dc316f4d89a0b85f495ee49b4c104c6eb4cae9e8f7e84bd3ff2df7246b39508d"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.117/WebPDecoder-1.6.0-alpha.117.xcframework.zip",
            checksum: "f3a88e01505bf8e5df1382cd60c4dce6a5448cea81061cc2fd14bd62ea944356"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.117/WebPDemux-1.6.0-alpha.117.xcframework.zip",
            checksum: "ed7a859f76d5ff8139d15711e7ad2fdddf0ea3503ce8318a6eb724e5ca70d38a"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.117/WebPMux-1.6.0-alpha.117.xcframework.zip",
            checksum: "989e4ff7339760829a9aac60ead0ec5689decadcf303a2d271ebb33e42430a46"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.117/SharpYuv-1.6.0-alpha.117.xcframework.zip",
            checksum: "1ae4ceaebbea7c6f1ae66ee5f8a444712f1aaec7e823db982343a9745c12b35b"
        )
    ]
)
