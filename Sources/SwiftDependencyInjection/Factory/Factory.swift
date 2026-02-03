import Foundation

/// A type-safe factory for creating service instances with container access.
///
/// Factories allow you to register parameterized creation logic that
/// can resolve other dependencies during construction.
///
/// ## Example
/// ```swift
/// let factory = Factory<UserService> { container in
///     let network = container.resolve(NetworkService.self)
///     return UserService(network: network)
/// }
///
/// container.registerFactory(UserService.self, factory: factory)
/// let service = container.resolveFactory(UserService.self)
/// ```
public struct Factory<T> {

    // MARK: - Properties

    /// The creation closure that receives the container.
    private let closure: (DIContainer) -> T

    // MARK: - Initialization

    /// Creates a factory with a creation closure.
    /// - Parameter closure: A closure that receives the container and returns an instance.
    public init(_ closure: @escaping (DIContainer) -> T) {
        self.closure = closure
    }

    // MARK: - Creation

    /// Creates a new instance using the factory closure.
    /// - Parameter container: The container for resolving nested dependencies.
    /// - Returns: A new instance of `T`.
    public func create(from container: DIContainer) -> T {
        closure(container)
    }
}

// MARK: - Convenience Factory Builders

extension Factory {

    /// Creates a factory from a simple closure with no dependencies.
    /// - Parameter closure: A closure that returns a new instance.
    /// - Returns: A ``Factory`` wrapping the closure.
    public static func simple(_ closure: @escaping () -> T) -> Factory<T> {
        Factory { _ in closure() }
    }

    /// Creates a factory that resolves a single dependency.
    /// - Parameters:
    ///   - dependency: The dependency type to resolve.
    ///   - closure: A closure receiving the resolved dependency.
    /// - Returns: A ``Factory`` wrapping the closure.
    public static func with<D>(
        _ dependency: D.Type,
        _ closure: @escaping (D) -> T
    ) -> Factory<T> {
        Factory { container in
            let dep = container.resolve(D.self)
            return closure(dep)
        }
    }

    /// Creates a factory that resolves two dependencies.
    /// - Parameters:
    ///   - dep1: The first dependency type.
    ///   - dep2: The second dependency type.
    ///   - closure: A closure receiving both resolved dependencies.
    /// - Returns: A ``Factory`` wrapping the closure.
    public static func with<D1, D2>(
        _ dep1: D1.Type,
        _ dep2: D2.Type,
        _ closure: @escaping (D1, D2) -> T
    ) -> Factory<T> {
        Factory { container in
            let d1 = container.resolve(D1.self)
            let d2 = container.resolve(D2.self)
            return closure(d1, d2)
        }
    }
}
