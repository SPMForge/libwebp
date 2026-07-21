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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.94/WebP-1.6.0-alpha.94.xcframework.zip",
            checksum: "64752b8de746b2823f27e6fd1afbff51424f383ff0280d48c2c3d7c547ff4689"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.94/WebPDecoder-1.6.0-alpha.94.xcframework.zip",
            checksum: "dea8f30f440796f34649c230b41d84660db4362a956cee13a2c05667c13836c2"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.94/WebPDemux-1.6.0-alpha.94.xcframework.zip",
            checksum: "8bac81fdc475a0442dfc37a5af672cf28790e22f5a2dd8f44749163541918e9c"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.94/WebPMux-1.6.0-alpha.94.xcframework.zip",
            checksum: "46872a7dabccf777e73b074c57db5876bcc9adb5355d8e3a6b3bf453532b3e0c"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.94/SharpYuv-1.6.0-alpha.94.xcframework.zip",
            checksum: "52b82285a33221dbc1c9c063ba76a0f4708dcf6c7523c13b87bd8294370cfd11"
        )
    ]
)
