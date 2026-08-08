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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.112/WebP-1.6.0-alpha.112.xcframework.zip",
            checksum: "f51ac0173f2bef78b38a3c3e00669318b77457bf5691f07093c9153b987be44d"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.112/WebPDecoder-1.6.0-alpha.112.xcframework.zip",
            checksum: "692f7759e225781e1ee9b1c7b9776c4dd3a61c39c46ecf99a3ab97d15e21623e"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.112/WebPDemux-1.6.0-alpha.112.xcframework.zip",
            checksum: "3b74b466f687a6b6a606774af238484cf00e606e33d77d9a092714a0bbf8a754"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.112/WebPMux-1.6.0-alpha.112.xcframework.zip",
            checksum: "133caec71dfde23b4c80bedac7ba1de9d464f763c0a29bf9d427561d2b0b96f7"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.112/SharpYuv-1.6.0-alpha.112.xcframework.zip",
            checksum: "010fce87b95e2c020c9d9b9706a95a05c50717c8b8a604435d9da6034a36b656"
        )
    ]
)
