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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.29/WebP-1.6.0-alpha.29.xcframework.zip",
            checksum: "3f004b8319511dbac86cd81aa207dbdbdd5ea88bed36ce21ef70538a93f72e21"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.29/WebPDecoder-1.6.0-alpha.29.xcframework.zip",
            checksum: "ccb0742259033956430e8701edfdbcc2eaa72128050511aa25e4967b06bd509c"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.29/WebPDemux-1.6.0-alpha.29.xcframework.zip",
            checksum: "61825539b589d815e1365bd23279d316aa842586df0702ade6489ed15d680bc7"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.29/WebPMux-1.6.0-alpha.29.xcframework.zip",
            checksum: "941e5d90258bd2233dd708e132da4e8ec411a1ea6fa82b66523a45d639734235"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.29/SharpYuv-1.6.0-alpha.29.xcframework.zip",
            checksum: "5e927b94d1da594b1a9833908a5fe6b67c24f09c7b84fcf8f194872417140eb1"
        )
    ]
)
