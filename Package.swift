// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "SwiftDependencyInjection",
    platforms: [
        .iOS(.v16),
        .macOS(.v13),
        .tvOS(.v16),
        .watchOS(.v9),
        .visionOS(.v1),
    ],
    products: [
        .library(name: "SwiftDependencyInjection", targets: ["SwiftDependencyInjection"]),
    ],
    targets: [
        .target(name: "SwiftDependencyInjection"),
    ],
    swiftLanguageModes: [.v6]
)
