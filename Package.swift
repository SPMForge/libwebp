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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.120/WebP-1.6.0-alpha.120.xcframework.zip",
            checksum: "f5b2b49c7f11fae8323a9119fd7be40d3a8e435a40a2c8fcef90babd4f07a68e"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.120/WebPDecoder-1.6.0-alpha.120.xcframework.zip",
            checksum: "d377548ae966f0739692b1715c796fa4208746ba83d2f3b1b5cc71a3e9786d5c"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.120/WebPDemux-1.6.0-alpha.120.xcframework.zip",
            checksum: "f6abbbbc6d53284b7f5c096856f0c82dd76b93b79a50182abb7c7052d2c36b32"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.120/WebPMux-1.6.0-alpha.120.xcframework.zip",
            checksum: "a427862b844f05d3023ee4a073f04a6515c360aa5f999e8a8fb2b380af034be3"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.120/SharpYuv-1.6.0-alpha.120.xcframework.zip",
            checksum: "11f8106dc4b4e1d6a8374fc4eb4d7205021f4ffeb9b2b4d4b95f045e24e0ac97"
        )
    ]
)
