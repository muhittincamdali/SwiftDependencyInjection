import Foundation

/// Defines the lifecycle scope for a registered dependency.
///
/// Controls how instances are created and cached by the container.
public enum Scope: Equatable, CustomStringConvertible {

    /// A new instance is created every time the service is resolved.
    ///
    /// Use for stateless services or when each consumer needs its own instance.
    /// ```swift
    /// container.register(Logger.self, scope: .transient) { _ in
    ///     ConsoleLogger()
    /// }
    /// ```
    case transient

    /// A single instance is created and reused for all subsequent resolutions.
    ///
    /// The instance is lazily created on first resolution and cached.
    /// ```swift
    /// container.register(Database.self, scope: .singleton) { _ in
    ///     SQLiteDatabase()
    /// }
    /// ```
    case singleton

    // MARK: - CustomStringConvertible

    public var description: String {
        switch self {
        case .transient:
            return "transient"
        case .singleton:
            return "singleton"
        }
    }

    // MARK: - Properties

    /// Whether this scope caches instances.
    public var isCached: Bool {
        switch self {
        case .singleton:
            return true
        case .transient:
            return false
        }
    }

    /// Whether a new instance is created on each resolution.
    public var createsNewInstance: Bool {
        switch self {
        case .transient:
            return true
        case .singleton:
            return false
        }
    }
}
