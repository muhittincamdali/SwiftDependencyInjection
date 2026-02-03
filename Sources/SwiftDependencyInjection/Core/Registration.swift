import Foundation

/// Represents a service registration in the dependency container.
///
/// Holds the factory closure and lifecycle scope for a registered service type.
public final class Registration<T> {

    // MARK: - Properties

    /// The lifecycle scope for this registration
    public let scope: Scope

    /// The factory closure that creates instances
    public let factory: (Resolver) -> T

    /// Optional post-creation configuration closure
    private var initCompletedHandler: ((Resolver, T) -> Void)?

    /// Human-readable name for debugging
    public private(set) var debugName: String?

    // MARK: - Initialization

    /// Creates a new registration.
    /// - Parameters:
    ///   - scope: The lifecycle scope.
    ///   - factory: The factory closure.
    public init(scope: Scope, factory: @escaping (Resolver) -> T) {
        self.scope = scope
        self.factory = factory
    }

    // MARK: - Configuration

    /// Adds a post-creation handler called after the instance is created.
    /// - Parameter handler: The handler receiving the resolver and new instance.
    /// - Returns: Self for chaining.
    @discardableResult
    public func initCompleted(_ handler: @escaping (Resolver, T) -> Void) -> Self {
        self.initCompletedHandler = handler
        return self
    }

    /// Sets a debug name for this registration.
    /// - Parameter name: The human-readable name.
    /// - Returns: Self for chaining.
    @discardableResult
    public func named(_ name: String) -> Self {
        self.debugName = name
        return self
    }

    // MARK: - Instance Creation

    /// Creates an instance using the factory and runs the init completed handler.
    /// - Parameter resolver: The resolver to use for nested dependencies.
    /// - Returns: A new instance of the registered type.
    internal func createInstance(resolver: Resolver) -> T {
        let instance = factory(resolver)
        initCompletedHandler?(resolver, instance)
        return instance
    }
}

// MARK: - CustomStringConvertible

extension Registration: CustomStringConvertible {
    public var description: String {
        let name = debugName ?? String(describing: T.self)
        return "Registration<\(name)>(scope: \(scope))"
    }
}
