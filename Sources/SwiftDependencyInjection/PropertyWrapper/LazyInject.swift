import Foundation

/// A property wrapper that defers dependency resolution until first access.
///
/// `@LazyInject` is useful when you want to avoid resolving expensive
/// services at initialization time, or to break circular dependency cycles.
///
/// ```swift
/// class AnalyticsManager {
///     @LazyInject var logger: LoggerService
///
///     func track(_ event: String) {
///         logger.log(event) // Resolved on first access
///     }
/// }
/// ```
@propertyWrapper
public struct LazyInject<T> {

    // MARK: - Properties

    /// The lazily resolved service instance.
    private var service: T?

    /// Optional qualifier name.
    private let name: String?

    /// The container to resolve from.
    private let container: DIContainer

    // MARK: - Initialization

    /// Creates a `@LazyInject` wrapper.
    /// - Parameters:
    ///   - name: An optional qualifier name.
    ///   - container: The container to resolve from. Defaults to shared.
    public init(name: String? = nil, container: DIContainer = .shared) {
        self.name = name
        self.container = container
        self.service = nil
    }

    // MARK: - Wrapped Value

    /// The resolved service, created on first access.
    public var wrappedValue: T {
        mutating get {
            if let existing = service {
                return existing
            }
            let resolved = container.resolve(T.self, name: name)
            service = resolved
            return resolved
        }
    }

    /// Projects the wrapper itself for access to metadata.
    public var projectedValue: LazyInject<T> {
        self
    }
}
