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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.62/WebP-1.6.0-alpha.62.xcframework.zip",
            checksum: "4610a8167b15792d58e0a8de6cb6db8206dac56afb4246e9b24646f55416016d"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.62/WebPDecoder-1.6.0-alpha.62.xcframework.zip",
            checksum: "579a6d2fab174cfa43f371c1bd6855f8301f9637d65fe863f07e1a42539f9a19"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.62/WebPDemux-1.6.0-alpha.62.xcframework.zip",
            checksum: "8394fc805bed7c42a4855c9d4233b6107cb668cd298b73c7b7d9423fec4c872e"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.62/WebPMux-1.6.0-alpha.62.xcframework.zip",
            checksum: "24147058fb40323e85aff82837dafd1ee0811047c3a4a5391e1feee99cb9317c"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.62/SharpYuv-1.6.0-alpha.62.xcframework.zip",
            checksum: "6dcb84eafc93f9df0590b9ebfbac861140b9806bcdaba91030232180bde29fdf"
        )
    ]
)
