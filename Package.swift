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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.135/WebP-1.6.0-alpha.135.xcframework.zip",
            checksum: "e4a37dc11243776f20dcf717b7b8d953ded0fc4f7aa40db2fdf91a9d4cedbef8"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.135/WebPDecoder-1.6.0-alpha.135.xcframework.zip",
            checksum: "8bf37c0911bd842c9553cbe5875d92a89b76be6d9a8029f86cdfa31d4b4214d8"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.135/WebPDemux-1.6.0-alpha.135.xcframework.zip",
            checksum: "e340a771aca1b03387b376dcb25bf2daf2652d8a258bdf30ecaa4fb8bef4acb7"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.135/WebPMux-1.6.0-alpha.135.xcframework.zip",
            checksum: "d46e099d0e778927c32be237c191d8d4551172088d0523429d464dd56f6a5720"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.135/SharpYuv-1.6.0-alpha.135.xcframework.zip",
            checksum: "54a3421638484bd04a9baf54a2c7ed4a5be1c7fe63984d2accfa001009e03cc4"
        )
    ]
)
