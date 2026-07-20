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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.93/WebP-1.6.0-alpha.93.xcframework.zip",
            checksum: "96ef14466da31f14e3b6bbef1162aa957c7f8bfce0c34ade73ccfb769db72cf5"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.93/WebPDecoder-1.6.0-alpha.93.xcframework.zip",
            checksum: "dd9574394c2977866c404a000a70369cd85d6d118a4604186e323ae1b4d83e17"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.93/WebPDemux-1.6.0-alpha.93.xcframework.zip",
            checksum: "ab384b1cb1b69192fbc5f3d44b979d66c2be398f3321f665dcf63b251a675b6b"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.93/WebPMux-1.6.0-alpha.93.xcframework.zip",
            checksum: "07aeb108c08a18e0b2c0f5033cd8474c4c1ccc8764ca5d0375c6176be27c3c41"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.93/SharpYuv-1.6.0-alpha.93.xcframework.zip",
            checksum: "9aac8230d9f9189c8f914d477d005a01cbdd1f2df7f13efeb89aa2fc846d9be3"
        )
    ]
)
