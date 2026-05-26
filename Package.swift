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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.38/WebP-1.6.0-alpha.38.xcframework.zip",
            checksum: "b94e72dccda81f5c3fb5c0b9378b9d191a81502dc0a6425fd5ce8212f7f122ab"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.38/WebPDecoder-1.6.0-alpha.38.xcframework.zip",
            checksum: "4935138e6931ac06dfffbc5b9e2e693296f54d865f85df57887a4ab62cf0a39d"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.38/WebPDemux-1.6.0-alpha.38.xcframework.zip",
            checksum: "ffa7f51c59f2f1e4b94e1829b5f213156c61f4ac140d144e95e1fcae7df3757b"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.38/WebPMux-1.6.0-alpha.38.xcframework.zip",
            checksum: "d9f7b55ccb1a446abbba792eed6f7c6d2d85a3b753a6db719ea03c52bbaf7273"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.38/SharpYuv-1.6.0-alpha.38.xcframework.zip",
            checksum: "5d37724401a3ac1333fc2f5f77440089fc8d668103a8725e350a65f2183c44ed"
        )
    ]
)
