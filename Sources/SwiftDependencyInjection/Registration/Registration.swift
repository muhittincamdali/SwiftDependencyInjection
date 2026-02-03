import Foundation

/// Describes a single service registration within the container.
///
/// A `Registration` holds the factory closure, the desired scope,
/// and any cached instance for singleton or weak scopes.
///
/// ## Usage
/// Registrations are created internally by ``DIContainer`` when you
/// call `register(_:scope:factory:)`.
public final class Registration {

    // MARK: - Properties

    /// The scope that controls instance lifetime.
    public let scope: Scope

    /// The factory closure that produces new instances.
    public let factory: (DIContainer) -> Any

    /// Cached singleton instance, if applicable.
    internal var cachedInstance: Any?

    /// Weak reference storage for `.weak` scope.
    internal weak var weakInstance: AnyObject?

    // MARK: - Initialization

    /// Creates a new registration.
    /// - Parameters:
    ///   - scope: The desired lifetime scope.
    ///   - factory: A closure that creates the service instance.
    public init(scope: Scope, factory: @escaping (DIContainer) -> Any) {
        self.scope = scope
        self.factory = factory
        self.cachedInstance = nil
        self.weakInstance = nil
    }

    // MARK: - Resolution

    /// Resolves an instance according to the registration's scope.
    /// - Parameter container: The container used for nested resolutions.
    /// - Returns: The resolved service instance.
    public func resolve(from container: DIContainer) -> Any {
        switch scope {
        case .singleton:
            if let existing = cachedInstance {
                return existing
            }
            let instance = factory(container)
            cachedInstance = instance
            return instance

        case .transient:
            return factory(container)

        case .weak:
            if let existing = weakInstance {
                return existing
            }
            let instance = factory(container)
            if let object = instance as? AnyObject {
                weakInstance = object
            }
            return instance
        }
    }

    /// Clears any cached instances.
    public func reset() {
        cachedInstance = nil
        weakInstance = nil
    }
}
