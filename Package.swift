// swift-tools-version: 6.2
import CompilerPluginSupport
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
    dependencies: [
        // The range covers the swift-syntax releases of Swift 6.2, 6.3 and 6.4, so the package
        // resolves next to other macro packages instead of forcing one swift-syntax version.
        .package(url: "https://github.com/swiftlang/swift-syntax.git", "602.0.0"..<"605.0.0"),
    ],
    targets: [
        .macro(
            name: "SwiftDependencyInjectionMacros",
            dependencies: [
                .product(name: "SwiftSyntax", package: "swift-syntax"),
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftDiagnostics", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
            ]
        ),
        .target(
            name: "SwiftDependencyInjection",
            dependencies: ["SwiftDependencyInjectionMacros"]
        ),
        .testTarget(
            name: "SwiftDependencyInjectionTests",
            dependencies: ["SwiftDependencyInjection"]
        ),
        .testTarget(
            name: "SwiftDependencyInjectionMacrosTests",
            dependencies: [
                "SwiftDependencyInjectionMacros",
                .product(name: "SwiftParser", package: "swift-syntax"),
                .product(name: "SwiftSyntaxMacroExpansion", package: "swift-syntax"),
                .product(name: "SwiftSyntaxMacrosGenericTestSupport", package: "swift-syntax"),
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)
