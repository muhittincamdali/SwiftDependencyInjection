import Foundation

/// Protocol for types that can resolve dependencies.
///
/// Implemented by `Container` and `ThreadSafeContainer`.
public protocol Resolver: AnyObject {

    /// Resolves a service by its type.
    /// - Parameter type: The type to resolve.
    /// - Returns: An instance of the requested type.
    func resolve<T>(_ type: T.Type) -> T

    /// Resolves a service by its type and qualifier name.
    /// - Parameters:
    ///   - type: The type to resolve.
    ///   - name: The qualifier name.
    /// - Returns: An instance of the requested type.
    func resolve<T>(_ type: T.Type, name: String) -> T

    /// Attempts to resolve a service, returning nil if not registered.
    /// - Parameter type: The type to resolve.
    /// - Returns: An optional instance of the requested type.
    func resolveOptional<T>(_ type: T.Type) -> T?
}

/// Provides default implementations for resolution convenience methods.
public extension Resolver {

    /// Resolves a service using type inference.
    /// - Returns: An instance of the inferred type.
    func resolve<T>() -> T {
        resolve(T.self)
    }

    /// Resolves an optional service using type inference.
    /// - Returns: An optional instance of the inferred type.
    func resolveOptional<T>() -> T? {
        resolveOptional(T.self)
    }

    /// Resolves a named service using type inference.
    /// - Parameter name: The qualifier name.
    /// - Returns: An instance of the inferred type.
    func resolve<T>(name: String) -> T {
        resolve(T.self, name: name)
    }
}

/// A type-erased resolver wrapper for passing resolution capability without
/// exposing the full container interface.
public final class AnyResolver: Resolver {
    private let wrapped: Resolver

    public init(_ resolver: Resolver) {
        self.wrapped = resolver
    }

    public func resolve<T>(_ type: T.Type) -> T {
        wrapped.resolve(type)
    }

    public func resolve<T>(_ type: T.Type, name: String) -> T {
        wrapped.resolve(type, name: name)
    }

    public func resolveOptional<T>(_ type: T.Type) -> T? {
        wrapped.resolveOptional(type)
    }
}
