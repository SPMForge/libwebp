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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.193/WebP-1.6.0-alpha.193.xcframework.zip",
            checksum: "4d30af783f2e51e1fe763e7328d8620bfb2ae84e632e82a6329cf9ab8d94802b"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.193/WebPDecoder-1.6.0-alpha.193.xcframework.zip",
            checksum: "defee9f3476097777af41e823e253aaaff25751972d6f25f6bc9767dcf1621e9"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.193/WebPDemux-1.6.0-alpha.193.xcframework.zip",
            checksum: "3fcc2668a0234b4e70eaa1089561065dcf1125c26c3866f2d7a4f70d56d7a76f"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.193/WebPMux-1.6.0-alpha.193.xcframework.zip",
            checksum: "42e32ab665a695dfb5a7f2d34a66cefcd80e336a204a89e63bf33d187b9eee22"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.193/SharpYuv-1.6.0-alpha.193.xcframework.zip",
            checksum: "1b093668b7845c4af0e28aaa007229044708143cd403595c3482b22e3d3e2203"
        )
    ]
)
