// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "CloseChannel",
    platforms: [
        .iOS(.v12),
    ],
    products: [
        .library(
            name: "CloseChannel",
            targets: ["CloseChannelBinaryTarget", "CloseChannelBinaryWrapperTarget"]),
    ],
    dependencies: [
        .package(url: "https://github.com/TakeScoop/SwiftyRSA", from: "1.8.0"),
    ],
    
    targets: [
        .binaryTarget(
            name: "CloseChannelBinaryTarget",
            url: "https://github.com/close-dev-team/mobile-close-channel-sdk-binary-ios/archive/refs/tags/1.7.2.zip",
            checksum: "2e6d5be9b52e5f856cf10c6a83be71b6d76fa5843f9259d18c91f0966a01a32f"
        ),
        .target(
            name: "CloseChannelBinaryWrapperTarget",
            dependencies: [
                .product(name: "SwiftyRSA", package: "SwiftyRSA"),
            ],
            path: "./Sources/CloseChannelBinaryWrapper/"
        )
    ]
)
