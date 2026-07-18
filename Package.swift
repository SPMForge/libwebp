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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.91/WebP-1.6.0-alpha.91.xcframework.zip",
            checksum: "f906087f9a009940d26272f6947d6da974e34d1657906ea26ecfaa311c83a9e5"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.91/WebPDecoder-1.6.0-alpha.91.xcframework.zip",
            checksum: "25bd9884b05b6309037c66423c0df268d1457e9fb86f96b970b55a81c7f05cde"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.91/WebPDemux-1.6.0-alpha.91.xcframework.zip",
            checksum: "8f047720ce8be78a0ae962d2787ba5484011eb3aef08be839e1905de04a60155"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.91/WebPMux-1.6.0-alpha.91.xcframework.zip",
            checksum: "3076e2e548b6374c437fab39054c1ea6245ece6b2e8699b2fff75388ddb7a6a6"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.91/SharpYuv-1.6.0-alpha.91.xcframework.zip",
            checksum: "f197940f7fe32a96fb731d8039785d64738e2a15c2ebd44fb472ced697719092"
        )
    ]
)
