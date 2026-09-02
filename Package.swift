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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.137/WebP-1.6.0-alpha.137.xcframework.zip",
            checksum: "9ed2f9b8b60ed8aff373470c5f836cc0501ef2a366f4b431808fa27d13be7abc"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.137/WebPDecoder-1.6.0-alpha.137.xcframework.zip",
            checksum: "e84b947e3536849a513f193f08882d42fad105ff41983083c1ad21df92cfd849"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.137/WebPDemux-1.6.0-alpha.137.xcframework.zip",
            checksum: "345908f924add302b5f346466e27a238f713d10837648fca60e4232ac7b4fa2c"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.137/WebPMux-1.6.0-alpha.137.xcframework.zip",
            checksum: "bc9fbcbbf6dc169cd7aa450e943c9f195f88494b08466c76620f5b60ec61bbb0"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.137/SharpYuv-1.6.0-alpha.137.xcframework.zip",
            checksum: "b138afc6ea04da4e0770d0d7346d978efa8a27b46178bc4931c9b3a6169052ef"
        )
    ]
)
