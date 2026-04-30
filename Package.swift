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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.12/WebP-1.6.0-alpha.12.xcframework.zip",
            checksum: "7e0608475de1d02ac61f63de811a3e93cd6433b3c639f5aac535b1c8523cca6c"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.12/WebPDecoder-1.6.0-alpha.12.xcframework.zip",
            checksum: "23a9ef54e573a7059542d795a2df0088bb606d35f7b079e1af4e2aa27c75d243"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.12/WebPDemux-1.6.0-alpha.12.xcframework.zip",
            checksum: "aa3e6e574f383673ff51e6f53a656622768b408b7685218e044eaea1d6efa344"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.12/WebPMux-1.6.0-alpha.12.xcframework.zip",
            checksum: "408b1cef576e2fe27f45680ad8657be118551c00fa9006845972a1b179be41ec"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.12/SharpYuv-1.6.0-alpha.12.xcframework.zip",
            checksum: "0a321ea006a3ac9915030c4574ed75cbaaaa7d2350e7a20f61a89e3a9c71041e"
        )
    ]
)
