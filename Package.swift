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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.105/WebP-1.6.0-alpha.105.xcframework.zip",
            checksum: "bb782f1e423ca502812f04f9d85f702a33f7fc785ef78d47db3119acc8cdce84"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.105/WebPDecoder-1.6.0-alpha.105.xcframework.zip",
            checksum: "8e873f0c67182e0ed40ca32bc2ff458556e27542c016eca50650ca7770c1adfe"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.105/WebPDemux-1.6.0-alpha.105.xcframework.zip",
            checksum: "796f27b406260f71f460bd1175c146bb54d70b1c19585a1f8ae2b63593d28c26"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.105/WebPMux-1.6.0-alpha.105.xcframework.zip",
            checksum: "f7f20bec3effc112a9d11d01aca90094d1e9bcc7248164507c7075b353ea1936"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.105/SharpYuv-1.6.0-alpha.105.xcframework.zip",
            checksum: "5cfd71d68e39b87e1dc76b109899a5eb7f68ac14f2d09d208c848917922c0512"
        )
    ]
)
