import Foundation

// MARK: - Dependency Module Protocol

/// Protocol for defining dependency modules that group related registrations.
///
/// Modules help organize dependency registrations into logical groups.
///
/// Example:
/// ```swift
/// struct NetworkModule: DependencyModule {
///     func register(in container: Container) {
///         container.register(URLSession.self) { _ in URLSession.shared }
///         container.register(APIClient.self) { r in
///             APIClient(session: r.resolve(URLSession.self))
///         }
///     }
/// }
/// ```
public protocol DependencyModule {
    /// Registers all dependencies provided by this module.
    /// - Parameter container: The container to register dependencies in.
    func register(in container: Container)
}

/// The main dependency injection container.
///
/// Manages service registrations and resolves dependencies with support
/// for different lifecycle scopes (singleton, transient).
public final class Container: Resolver {

    // MARK: - Types

    /// A factory closure that creates an instance using the resolver.
    public typealias Factory<T> = (Resolver) -> T

    // MARK: - Properties

    /// Shared global container instance
    public static let shared = Container()

    /// All registered service entries keyed by type identifier
    private var registrations: [String: Any] = [:]

    /// Cached singleton instances
    private var singletonCache: [String: Any] = [:]

    /// Parent container for hierarchical resolution
    private let parent: Container?

    // MARK: - Initialization

    /// Creates a new container.
    /// - Parameter parent: Optional parent container for hierarchical lookups.
    public init(parent: Container? = nil) {
        self.parent = parent
    }

    // MARK: - Registration

    /// Registers a service factory for the given type.
    /// - Parameters:
    ///   - type: The service protocol or class type.
    ///   - scope: The lifecycle scope (default: transient).
    ///   - factory: A closure that creates the service instance.
    @discardableResult
    public func register<T>(
        _ type: T.Type,
        scope: Scope = .transient,
        factory: @escaping Factory<T>
    ) -> Registration<T> {
        let key = typeKey(for: type)
        let registration = Registration(scope: scope, factory: factory)
        registrations[key] = registration
        return registration
    }

    /// Registers a service factory with a named qualifier.
    /// - Parameters:
    ///   - type: The service protocol or class type.
    ///   - name: A qualifier name to distinguish registrations.
    ///   - scope: The lifecycle scope.
    ///   - factory: A closure that creates the service instance.
    @discardableResult
    public func register<T>(
        _ type: T.Type,
        name: String,
        scope: Scope = .transient,
        factory: @escaping Factory<T>
    ) -> Registration<T> {
        let key = typeKey(for: type, name: name)
        let registration = Registration(scope: scope, factory: factory)
        registrations[key] = registration
        return registration
    }

    // MARK: - Resolution

    /// Resolves a service by its type.
    /// - Parameter type: The type to resolve.
    /// - Returns: An instance of the requested type.
    public func resolve<T>(_ type: T.Type) -> T {
        let key = typeKey(for: type)
        return resolveByKey(key, type: type)
    }

    /// Resolves a service by its type and name.
    /// - Parameters:
    ///   - type: The type to resolve.
    ///   - name: The qualifier name.
    /// - Returns: An instance of the requested type.
    public func resolve<T>(_ type: T.Type, name: String) -> T {
        let key = typeKey(for: type, name: name)
        return resolveByKey(key, type: type)
    }

    /// Attempts to resolve a service, returning nil if not registered.
    /// - Parameter type: The type to resolve.
    /// - Returns: An optional instance of the requested type.
    public func resolveOptional<T>(_ type: T.Type) -> T? {
        let key = typeKey(for: type)
        return resolveByKeyOptional(key, type: type)
    }

    // MARK: - Module Loading

    /// Loads a dependency module, registering all its services.
    /// - Parameter module: The module to load.
    public func load(module: DependencyModule) {
        module.register(in: self)
    }

    /// Loads multiple modules at once.
    /// - Parameter modules: The modules to load.
    public func load(modules: [DependencyModule]) {
        modules.forEach { $0.register(in: self) }
    }

    // MARK: - Management

    /// Removes all registrations and cached instances.
    public func removeAll() {
        registrations.removeAll()
        singletonCache.removeAll()
    }

    /// Checks if a type is registered in this container.
    /// - Parameter type: The type to check.
    /// - Returns: `true` if the type is registered.
    public func isRegistered<T>(_ type: T.Type) -> Bool {
        let key = typeKey(for: type)
        return registrations[key] != nil || parent?.isRegistered(type) == true
    }

    /// Returns the number of registered services.
    public var registrationCount: Int {
        registrations.count
    }

    // MARK: - Private

    private func resolveByKey<T>(_ key: String, type: T.Type) -> T {
        guard let instance = resolveByKeyOptional(key, type: type) else {
            fatalError("No registration found for type: \(type). Did you forget to register it?")
        }
        return instance
    }

    private func resolveByKeyOptional<T>(_ key: String, type: T.Type) -> T? {
        guard let registration = registrations[key] as? Registration<T> else {
            return parent?.resolveByKeyOptional(key, type: type)
        }

        switch registration.scope {
        case .singleton:
            if let cached = singletonCache[key] as? T {
                return cached
            }
            let instance = registration.factory(self)
            singletonCache[key] = instance
            return instance

        case .transient:
            return registration.factory(self)
        }
    }

    private func typeKey<T>(for type: T.Type, name: String? = nil) -> String {
        let baseKey = String(describing: type)
        if let name = name {
            return "\(baseKey)_\(name)"
        }
        return baseKey
    }
}
