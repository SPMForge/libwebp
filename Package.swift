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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.11/WebP-1.6.0-alpha.11.xcframework.zip",
            checksum: "691910d9cba5694b19b29addc7ddd4f17cd88cbeed537ecc0097f366428dd67b"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.11/WebPDecoder-1.6.0-alpha.11.xcframework.zip",
            checksum: "e3a8ce04e5a4aa342ade3efcbf73e2925bc1e7a5888c142284e5b89dff164b25"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.11/WebPDemux-1.6.0-alpha.11.xcframework.zip",
            checksum: "90a30313cae438a80d66f4ce8cc58199c76710de5747b7f25617fda32de3ed35"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.11/WebPMux-1.6.0-alpha.11.xcframework.zip",
            checksum: "e267350d51fafa07e8a1d7f4f8cb683de8e38cc921feb96d498df5e7d3b55f9f"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.11/SharpYuv-1.6.0-alpha.11.xcframework.zip",
            checksum: "13d97f28bdb0ac70125f0ba31b176f88e64a4b9aaf6b041b342a2f9521f5cf1f"
        )
    ]
)
