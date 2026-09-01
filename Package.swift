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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.136/WebP-1.6.0-alpha.136.xcframework.zip",
            checksum: "85d2d02783617e111bd337daa5721f19cc75c713e97093dcc045d2d002f91d6e"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.136/WebPDecoder-1.6.0-alpha.136.xcframework.zip",
            checksum: "8ca7ded9d9825d9270677a43f3167dc3405e5aebd8a6448deee8da08fc252e1f"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.136/WebPDemux-1.6.0-alpha.136.xcframework.zip",
            checksum: "f29d04be9d3615502f829a0db2f2c9a2094abc456ecc8975e0285d2390a0b66a"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.136/WebPMux-1.6.0-alpha.136.xcframework.zip",
            checksum: "1fbb40049f24ab1a5f4576a7231dc85a402bad3e9309d6e2d042c0ae4609b311"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.136/SharpYuv-1.6.0-alpha.136.xcframework.zip",
            checksum: "f0bda49b0baa189eddf974c363d5bcea1f2834635796ea31657a8466ff8e30e1"
        )
    ]
)
