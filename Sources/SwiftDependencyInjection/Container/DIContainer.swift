import Foundation
import Combine

/// The central dependency injection container.
///
/// `DIContainer` manages service registrations and resolves dependencies
/// at runtime. It supports scoped lifetimes, named registrations, and
/// module-based organization.
///
/// ## Quick Start
/// ```swift
/// let container = DIContainer.shared
///
/// container.register(NetworkService.self, scope: .singleton) {
///     URLSessionNetworkService()
/// }
///
/// let network: NetworkService = container.resolve(NetworkService.self)
/// ```
///
/// ## Thread Safety
/// For concurrent access, use ``ThreadSafeContainer`` instead.
public final class DIContainer: ObservableObject {

    // MARK: - Shared Instance

    /// The default shared container instance.
    public static let shared = DIContainer()

    // MARK: - Properties

    /// All service registrations keyed by their service key.
    private var registrations: [ServiceKey: Registration] = [:]

    /// Factory registrations keyed by type identifier.
    private var factories: [String: Any] = [:]

    /// Dependency graph for circular dependency detection.
    private let graph = DependencyGraph()

    /// Lock for thread-safe access to registrations.
    private let lock = NSRecursiveLock()

    /// Parent container for hierarchical resolution.
    public private(set) weak var parent: DIContainer?

    // MARK: - Initialization

    /// Creates a new container.
    /// - Parameter parent: An optional parent container for fallback resolution.
    public init(parent: DIContainer? = nil) {
        self.parent = parent
    }

    // MARK: - Registration

    /// Registers a service type with a factory closure.
    ///
    /// - Parameters:
    ///   - type: The service protocol or class type.
    ///   - name: An optional qualifier name for multiple registrations.
    ///   - scope: The lifetime scope. Defaults to `.transient`.
    ///   - factory: A closure that creates the service instance.
    @discardableResult
    public func register<T>(
        _ type: T.Type,
        name: String? = nil,
        scope: Scope = .transient,
        factory: @escaping () -> T
    ) -> DIContainer {
        let key = ServiceKey(type: type, name: name)
        let registration = Registration(scope: scope) { _ in factory() }
        lock.lock()
        registrations[key] = registration
        lock.unlock()
        return self
    }

    /// Registers a service type with a factory that receives the container.
    ///
    /// Use this overload when the service depends on other registered services:
    /// ```swift
    /// container.register(AuthService.self) { resolver in
    ///     DefaultAuthService(network: resolver.resolve(NetworkService.self))
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - type: The service protocol or class type.
    ///   - name: An optional qualifier name.
    ///   - scope: The lifetime scope. Defaults to `.transient`.
    ///   - factory: A closure receiving the container for nested resolution.
    @discardableResult
    public func register<T>(
        _ type: T.Type,
        name: String? = nil,
        scope: Scope = .transient,
        factory: @escaping (DIContainer) -> T
    ) -> DIContainer {
        let key = ServiceKey(type: type, name: name)
        let registration = Registration(scope: scope) { container in factory(container) }
        lock.lock()
        registrations[key] = registration
        lock.unlock()
        return self
    }

    // MARK: - Resolution

    /// Resolves a registered service.
    ///
    /// - Parameters:
    ///   - type: The service type to resolve.
    ///   - name: An optional qualifier name.
    /// - Returns: The resolved service instance.
    public func resolve<T>(_ type: T.Type, name: String? = nil) -> T {
        let key = ServiceKey(type: type, name: name)

        lock.lock()
        let registration = registrations[key]
        lock.unlock()

        if let registration = registration {
            graph.pushResolution(for: key)
            if graph.hasCircularDependency(for: key) {
                assertionFailure(
                    "[SwiftDependencyInjection] Circular dependency detected for \(key.typeIdentifier)"
                )
            }
            let instance = registration.resolve(from: self)
            graph.popResolution(for: key)

            guard let typed = instance as? T else {
                fatalError(
                    "[SwiftDependencyInjection] Type mismatch resolving \(key.typeIdentifier)"
                )
            }
            return typed
        }

        if let parent = parent {
            return parent.resolve(type, name: name)
        }

        fatalError(
            "[SwiftDependencyInjection] No registration found for \(String(describing: type))"
            + (name.map { " with name '\($0)'" } ?? "")
        )
    }

    /// Optionally resolves a service, returning `nil` if not registered.
    ///
    /// - Parameters:
    ///   - type: The service type to resolve.
    ///   - name: An optional qualifier name.
    /// - Returns: The resolved instance or `nil`.
    public func resolveOptional<T>(_ type: T.Type, name: String? = nil) -> T? {
        let key = ServiceKey(type: type, name: name)
        lock.lock()
        let hasRegistration = registrations[key] != nil
        lock.unlock()

        guard hasRegistration else {
            return parent?.resolveOptional(type, name: name)
        }

        return resolve(type, name: name)
    }

    // MARK: - Module Registration

    /// Registers all services defined in a module.
    /// - Parameter module: The module to register.
    @discardableResult
    public func registerModule(_ module: DIModule) -> DIContainer {
        module.register(in: self)
        return self
    }

    // MARK: - Factory Registration

    /// Registers a factory for a given type.
    /// - Parameters:
    ///   - type: The type the factory produces.
    ///   - factory: The factory instance.
    public func registerFactory<T>(_ type: T.Type, factory: Factory<T>) {
        let identifier = String(describing: type)
        lock.lock()
        factories[identifier] = factory
        lock.unlock()
    }

    /// Resolves an instance using a registered factory.
    /// - Parameter type: The type to create.
    /// - Returns: A new instance from the factory.
    public func resolveFactory<T>(_ type: T.Type) -> T {
        let identifier = String(describing: type)
        lock.lock()
        let factory = factories[identifier]
        lock.unlock()

        guard let typedFactory = factory as? Factory<T> else {
            fatalError("[SwiftDependencyInjection] No factory registered for \(identifier)")
        }
        return typedFactory.create(from: self)
    }

    // MARK: - Container Management

    /// Removes all registrations and cached instances.
    public func reset() {
        lock.lock()
        registrations.removeAll()
        factories.removeAll()
        lock.unlock()
        graph.reset()
    }

    /// Removes a specific registration.
    /// - Parameters:
    ///   - type: The service type to remove.
    ///   - name: An optional qualifier name.
    public func unregister<T>(_ type: T.Type, name: String? = nil) {
        let key = ServiceKey(type: type, name: name)
        lock.lock()
        registrations.removeValue(forKey: key)
        lock.unlock()
    }

    /// Returns the number of active registrations.
    public var registrationCount: Int {
        lock.lock()
        let count = registrations.count
        lock.unlock()
        return count
    }

    /// Checks whether a service type is registered.
    /// - Parameters:
    ///   - type: The service type to check.
    ///   - name: An optional qualifier name.
    /// - Returns: `true` if a registration exists.
    public func isRegistered<T>(_ type: T.Type, name: String? = nil) -> Bool {
        let key = ServiceKey(type: type, name: name)
        lock.lock()
        let exists = registrations[key] != nil
        lock.unlock()
        return exists
    }

    /// Creates a child container that falls back to this container.
    /// - Returns: A new child ``DIContainer``.
    public func createChildContainer() -> DIContainer {
        DIContainer(parent: self)
    }
}
