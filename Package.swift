// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "SwiftDependencyInjection",
    platforms: [
        .iOS(.v15),
        .macOS(.v13),
        .tvOS(.v15),
        .watchOS(.v8),
        .visionOS(.v1)
    ],
    products: [
        .library(name: "SwiftDependencyInjection", targets: ["SwiftDependencyInjection"]),
    ],
    targets: [
        .target(
            name: "SwiftDependencyInjection",
            path: "Sources/SwiftDependencyInjection",
            swiftSettings: [
                .enableExperimentalFeature("StrictConcurrency")
            ]
        ),
        .testTarget(
            name: "SwiftDependencyInjectionTests",
            dependencies: ["SwiftDependencyInjection"]
        )
    ]
)
