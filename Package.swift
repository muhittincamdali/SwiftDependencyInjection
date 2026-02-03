// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "SwiftDependencyInjection",
    platforms: [
        .iOS(.v15),
        .macOS(.v13)
    ],
    products: [
        .library(
            name: "SwiftDependencyInjection",
            targets: ["SwiftDependencyInjection"]
        )
    ],
    targets: [
        .target(
            name: "SwiftDependencyInjection",
            path: "Sources/SwiftDependencyInjection"
        ),
        .testTarget(
            name: "SwiftDependencyInjectionTests",
            dependencies: ["SwiftDependencyInjection"],
            path: "Tests/SwiftDependencyInjectionTests"
        )
    ]
)
