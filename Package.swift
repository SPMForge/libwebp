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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.41/WebP-1.6.0-alpha.41.xcframework.zip",
            checksum: "ebdd655c2e8bf4aab3d04e4f41da20389a854301074fe1537aec36de7372e243"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.41/WebPDecoder-1.6.0-alpha.41.xcframework.zip",
            checksum: "854ca2a11700513143b3f2153a59644ae4e64e19176aaae8a0f13e0883ec7143"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.41/WebPDemux-1.6.0-alpha.41.xcframework.zip",
            checksum: "b17564ee4f5cc144da4d9dfa65021ecb0035e1bf0763f58f1e6384ab6f68b993"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.41/WebPMux-1.6.0-alpha.41.xcframework.zip",
            checksum: "766242098dfcba42e2361aa5548de3a5ab863ff5c11b5a414af677ac90caa9d8"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.41/SharpYuv-1.6.0-alpha.41.xcframework.zip",
            checksum: "9c03d5b0c33884f6927c0daafc00eb619b63afc77cc11623db66438c8cffb99e"
        )
    ]
)
