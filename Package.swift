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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.30/WebP-1.6.0-alpha.30.xcframework.zip",
            checksum: "1978e8cf5a5739d4459384361e5b3e9a967e8018b0ab040bc230ff76a2a3faf7"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.30/WebPDecoder-1.6.0-alpha.30.xcframework.zip",
            checksum: "955aa79fc2804b9ef1efcfcddd362ea7569f9d9387a70e56577e22248edfff03"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.30/WebPDemux-1.6.0-alpha.30.xcframework.zip",
            checksum: "33d90a64989190b29fb4cc42f598956f47e262868890bad61a8d2730a85f9f2b"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.30/WebPMux-1.6.0-alpha.30.xcframework.zip",
            checksum: "c4445d289f139a3ee06fd04af5afdb004354e3b99bae68d1f9063574531b5d4a"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.30/SharpYuv-1.6.0-alpha.30.xcframework.zip",
            checksum: "97d5db8d9f535cf43cf6f1fa1051001543a7c28e908a02df12fa0f4d8802b77f"
        )
    ]
)
