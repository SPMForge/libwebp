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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.6/WebP-1.6.0-alpha.6.xcframework.zip",
            checksum: "459eb2d02ce9e211374e40bf98eb3434f53892aef2f53af41938206239c0e4a1"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.6/WebPDecoder-1.6.0-alpha.6.xcframework.zip",
            checksum: "4f31241d751ddadd775bce72a92ecf00a7fbb9a4eb269d2f899e9e81af610566"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.6/WebPDemux-1.6.0-alpha.6.xcframework.zip",
            checksum: "a8bd218e077fd36c2a91dbe546a16f9d92dd34851716be3a57a87da8eaa18658"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.6/WebPMux-1.6.0-alpha.6.xcframework.zip",
            checksum: "a1e7e859a4d158de4437ddd0510357f62595a5583b03b361ecbd8af9cc65b1e6"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.6/SharpYuv-1.6.0-alpha.6.xcframework.zip",
            checksum: "19d74ccac9da533697942d8a87c018a4ab1938addd8d6fb1a57833d8dfcab749"
        )
    ]
)
