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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.10/WebP-1.6.0-alpha.10.xcframework.zip",
            checksum: "3c1927293dcb4f9a881aa38ffdea4f6f77f9733a5c102f63361e54ac35321421"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.10/WebPDecoder-1.6.0-alpha.10.xcframework.zip",
            checksum: "07eb3a11fdd8a29aa88c431da6ff92b107fd960b0c9058dd65389754e7348c57"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.10/WebPDemux-1.6.0-alpha.10.xcframework.zip",
            checksum: "90c09791cd072f9ac0f2a73ae277577f21069f50eba992147a6519e3489c8a30"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.10/WebPMux-1.6.0-alpha.10.xcframework.zip",
            checksum: "edb50ed729ec565a7ce7d52640e3411cb99387b5b698b68e3fb9b6cf31ed1696"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.10/SharpYuv-1.6.0-alpha.10.xcframework.zip",
            checksum: "92c31d62b58a1e373ffbf50b5710b7f083004a4c524ab50a41e8b3023dfec139"
        )
    ]
)
