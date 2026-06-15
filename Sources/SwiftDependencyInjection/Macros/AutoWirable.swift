import Foundation

/// SwiftDependencyInjection: AutoWiring Macro Placeholder
/// 
/// In a complete SwiftSyntax implementation, annotating a protocol or struct
/// with @AutoWirable automatically generates the container registration code.
/// This drastically reduces DI boilerplate in massive codebases.
public protocol AutoWirable: Sendable {}

public struct AutoWirableConfig: Sendable {
    public enum Scope: Sendable {
        case transient
        case singleton
    }
    
    public static func register() {
        print("🪄 [SwiftDI] AutoWiring Scan Initiated. Generating DI Graph at compile time.")
    }
}
