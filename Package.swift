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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.123/WebP-1.6.0-alpha.123.xcframework.zip",
            checksum: "2bdc703cb6e257b34fc4a8d316e0aa8a17834a1b5d448120dce6e82e5b68e10a"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.123/WebPDecoder-1.6.0-alpha.123.xcframework.zip",
            checksum: "fc1d7638556de0980f7f2ce2469d178e4798a70794c77dc23744f3995f5a93bc"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.123/WebPDemux-1.6.0-alpha.123.xcframework.zip",
            checksum: "8bc141e139fb1b026ebb7c1da4160189bc136805309dbbc845704f9bbc0c841d"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.123/WebPMux-1.6.0-alpha.123.xcframework.zip",
            checksum: "c5f794676fe5674145182b65a3c61d6dd5a00a1653af5087d7dbe7703148cfdb"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.123/SharpYuv-1.6.0-alpha.123.xcframework.zip",
            checksum: "605fedb5875930d12448b055a607cb033ebd956cf4174013449cbf792a1a3848"
        )
    ]
)
