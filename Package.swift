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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.3/WebP-1.6.0-alpha.3.xcframework.zip",
            checksum: "01e61f3a5dd122896382d79fa4034aeb2fc8e7c7e261f13671d6908ff00b6281"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.3/WebPDecoder-1.6.0-alpha.3.xcframework.zip",
            checksum: "939cdeec925964ef512d268a65480ca4b3dde72ecb06b1635a81516e1b5f3b3f"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.3/WebPDemux-1.6.0-alpha.3.xcframework.zip",
            checksum: "192a01a2f9b75a76d581c528d7beca43177ca00fef510576f85a72a2098e32b7"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.3/WebPMux-1.6.0-alpha.3.xcframework.zip",
            checksum: "23211898823bf9d7b1cdeb4f97c4cdd4f2140bafabab1b388573b576809624d2"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.3/SharpYuv-1.6.0-alpha.3.xcframework.zip",
            checksum: "b00334372c34ebcc46fb391acede5a6be34fe14730ad2e07a9745b8d744651b0"
        )
    ]
)
