import Foundation

/// A thread-safe wrapper around `Container` using a read-write lock.
///
/// All registration and resolution operations are protected by an `NSRecursiveLock`,
/// making it safe to use from multiple threads simultaneously.
public final class ThreadSafeContainer: Resolver {

    // MARK: - Properties

    private let container: Container
    private let lock = NSRecursiveLock()

    // MARK: - Initialization

    /// Creates a thread-safe container.
    /// - Parameter container: The underlying container (default: new container).
    public init(container: Container = Container()) {
        self.container = container
    }

    // MARK: - Registration

    /// Thread-safe service registration.
    /// - Parameters:
    ///   - type: The service type.
    ///   - scope: The lifecycle scope.
    ///   - factory: The factory closure.
    @discardableResult
    public func register<T>(
        _ type: T.Type,
        scope: Scope = .transient,
        factory: @escaping (Resolver) -> T
    ) -> Registration<T> {
        lock.lock()
        defer { lock.unlock() }
        return container.register(type, scope: scope, factory: factory)
    }

    /// Thread-safe named service registration.
    @discardableResult
    public func register<T>(
        _ type: T.Type,
        name: String,
        scope: Scope = .transient,
        factory: @escaping (Resolver) -> T
    ) -> Registration<T> {
        lock.lock()
        defer { lock.unlock() }
        return container.register(type, name: name, scope: scope, factory: factory)
    }

    // MARK: - Resolution

    /// Thread-safe service resolution.
    public func resolve<T>(_ type: T.Type) -> T {
        lock.lock()
        defer { lock.unlock() }
        return container.resolve(type)
    }

    /// Thread-safe named service resolution.
    public func resolve<T>(_ type: T.Type, name: String) -> T {
        lock.lock()
        defer { lock.unlock() }
        return container.resolve(type, name: name)
    }

    /// Thread-safe optional resolution.
    public func resolveOptional<T>(_ type: T.Type) -> T? {
        lock.lock()
        defer { lock.unlock() }
        return container.resolveOptional(type)
    }

    // MARK: - Module Loading

    /// Thread-safe module loading.
    public func load(module: DependencyModule) {
        lock.lock()
        defer { lock.unlock() }
        container.load(module: module)
    }

    // MARK: - Management

    /// Thread-safe removal of all registrations.
    public func removeAll() {
        lock.lock()
        defer { lock.unlock() }
        container.removeAll()
    }
}
