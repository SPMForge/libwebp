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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.65/WebP-1.6.0-alpha.65.xcframework.zip",
            checksum: "4edb4db5dd910f5ba67f36d0085e83c823625b1bb54a9f2d59fe34c8b97576af"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.65/WebPDecoder-1.6.0-alpha.65.xcframework.zip",
            checksum: "3782ee08b58c0e64fb8180475d5c7ff57b070aef107846ded0dbd368fb1030cd"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.65/WebPDemux-1.6.0-alpha.65.xcframework.zip",
            checksum: "4617c83c9fe217a7b142979bfdbdaee8119d2181f25f8238325bbabea02c80ea"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.65/WebPMux-1.6.0-alpha.65.xcframework.zip",
            checksum: "a3858d9579355093f4a8634894b8b17cda14579bc90fcd5d943142a12131d66a"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.65/SharpYuv-1.6.0-alpha.65.xcframework.zip",
            checksum: "eb887649ec322333162b251d4cf5756c18fd978e8f5c991dfaa4183ed8993303"
        )
    ]
)
