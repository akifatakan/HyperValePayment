// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "HyperVale",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "HyperVale",
            targets: ["HyperVale"]
        )
    ],
    dependencies: [
        // No external deps by default — keep it lightweight.
        // Add Alamofire or a networking lib if you prefer.
    ],
    targets: [
        .target(
            name: "HyperVale",
            path: "Sources/HyperVale",
            resources: [
                // If you later add bundled assets (e.g., localized strings)
            ]
        ),
        .testTarget(
            name: "HyperValeTests",
            dependencies: ["HyperVale"],
            path: "Tests/HyperValeTests"
        )
    ]
)
