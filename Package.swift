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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.132/WebP-1.6.0-alpha.132.xcframework.zip",
            checksum: "8d598730b8635c561464433705b7744ac5a2c9310d13d1ee3cfbc19bed2a2a4e"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.132/WebPDecoder-1.6.0-alpha.132.xcframework.zip",
            checksum: "6dc4f260e249a03dd731bd6d1f21e4ee36d8957be1d310067e1db85b137a4901"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.132/WebPDemux-1.6.0-alpha.132.xcframework.zip",
            checksum: "d80aa573cdf5b4b6042507d2159a992f36c7db1382541dc77ac1c7f453b4c06d"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.132/WebPMux-1.6.0-alpha.132.xcframework.zip",
            checksum: "92d9a157f36799c8746f2fd09609d5a38f6a6ca3e266bfa21cd372759862c42f"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.132/SharpYuv-1.6.0-alpha.132.xcframework.zip",
            checksum: "dfdda963f0ec8f54beb596ce380dcf91dad6c361e65e7bb04b26f41bde02c690"
        )
    ]
)
