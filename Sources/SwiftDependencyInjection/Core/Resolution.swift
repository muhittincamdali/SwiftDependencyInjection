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
    private let _resolve: (Any.Type) -> Any
    private let _resolveNamed: (Any.Type, String) -> Any
    private let _resolveOptional: (Any.Type) -> Any?

    public init(_ resolver: Resolver) {
        _resolve = { type in
            resolver.resolve(type as! Any.Type)
        }
        _resolveNamed = { type, name in
            resolver.resolve(type as! Any.Type, name: name)
        }
        _resolveOptional = { type in
            resolver.resolveOptional(type as! Any.Type)
        }
    }

    public func resolve<T>(_ type: T.Type) -> T {
        _resolve(type) as! T
    }

    public func resolve<T>(_ type: T.Type, name: String) -> T {
        _resolveNamed(type, name) as! T
    }

    public func resolveOptional<T>(_ type: T.Type) -> T? {
        _resolveOptional(type) as? T
    }
}
