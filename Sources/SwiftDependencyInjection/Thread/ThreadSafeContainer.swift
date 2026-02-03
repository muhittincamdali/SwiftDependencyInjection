import Foundation

/// An actor-based thread-safe dependency injection container.
///
/// `ThreadSafeContainer` wraps ``DIContainer`` in a Swift actor,
/// ensuring all registration and resolution operations are
/// serialized across concurrent contexts.
///
/// ## Example
/// ```swift
/// let container = ThreadSafeContainer()
///
/// await container.register(NetworkService.self, scope: .singleton) {
///     URLSessionNetworkService()
/// }
///
/// let service: NetworkService = await container.resolve(NetworkService.self)
/// ```
public actor ThreadSafeContainer {

    // MARK: - Properties

    /// The underlying container.
    private let container: DIContainer

    // MARK: - Initialization

    /// Creates a new thread-safe container.
    /// - Parameter container: An existing container to wrap. Defaults to a new instance.
    public init(container: DIContainer = DIContainer()) {
        self.container = container
    }

    // MARK: - Registration

    /// Registers a service type with a factory closure.
    /// - Parameters:
    ///   - type: The service protocol or class type.
    ///   - name: An optional qualifier name.
    ///   - scope: The lifetime scope. Defaults to `.transient`.
    ///   - factory: A closure that creates the service instance.
    public func register<T>(
        _ type: T.Type,
        name: String? = nil,
        scope: Scope = .transient,
        factory: @escaping @Sendable () -> T
    ) {
        container.register(type, name: name, scope: scope, factory: factory)
    }

    // MARK: - Resolution

    /// Resolves a registered service.
    /// - Parameters:
    ///   - type: The service type to resolve.
    ///   - name: An optional qualifier name.
    /// - Returns: The resolved service instance.
    public func resolve<T>(_ type: T.Type, name: String? = nil) -> T {
        container.resolve(type, name: name)
    }

    /// Optionally resolves a service.
    /// - Parameters:
    ///   - type: The service type to resolve.
    ///   - name: An optional qualifier name.
    /// - Returns: The resolved instance or `nil`.
    public func resolveOptional<T>(_ type: T.Type, name: String? = nil) -> T? {
        container.resolveOptional(type, name: name)
    }

    // MARK: - Management

    /// Removes all registrations.
    public func reset() {
        container.reset()
    }

    /// Returns the number of active registrations.
    public var registrationCount: Int {
        container.registrationCount
    }

    /// Checks whether a type is registered.
    public func isRegistered<T>(_ type: T.Type, name: String? = nil) -> Bool {
        container.isRegistered(type, name: name)
    }
}
