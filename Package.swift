// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "HyperValePayment",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "HyperValePayment",
            targets: ["HyperValePayment"]
        )
    ],
    dependencies: [
        // No external deps by default — keep it lightweight.
        // Add Alamofire or a networking lib if you prefer.
    ],
    targets: [
        .target(
            name: "HyperValePayment",
            path: "Sources/HyperValePayment",
            resources: [
                // If you later add bundled assets (e.g., localized strings)
            ]
        ),
        .testTarget(
            name: "HyperValePaymentTests",
            dependencies: ["HyperValePayment"],
            path: "Tests/HyperValePaymentTests"
        )
    ]
)
