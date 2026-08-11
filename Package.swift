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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.115/WebP-1.6.0-alpha.115.xcframework.zip",
            checksum: "866b05884126bf6da71db75829687d11dffaedde482cb61b2d69e21db552807a"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.115/WebPDecoder-1.6.0-alpha.115.xcframework.zip",
            checksum: "8a41f141e5ae8c30074cd8ce9ba094749ae41fff759953302aad41072bb00f4e"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.115/WebPDemux-1.6.0-alpha.115.xcframework.zip",
            checksum: "059c1223ea0acd94fa32df733eff2e5798bd3db4f5672c20be7bb2ef1d11f515"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.115/WebPMux-1.6.0-alpha.115.xcframework.zip",
            checksum: "c944f24dc3553afb337fe5daedf9b6c1c44f37e8cf1ae1baa8b38f2fc479a9e4"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.115/SharpYuv-1.6.0-alpha.115.xcframework.zip",
            checksum: "52fb0e9516ea8a61b0ab7776218b00da94bfbe2623da1ad3e50d8c271f0318e7"
        )
    ]
)
