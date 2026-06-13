import Foundation

/// A thread-safe Dependency Injection container.
public actor DIContainer {
    public static let shared = DIContainer()
    
    private var factories: [String: @Sendable () -> Any] = [:]
    
    private init() {}
    
    /// Registers a factory for a type.
    public func register<T: Sendable>(_ type: T.Type, factory: @escaping @Sendable () -> T) {
        let key = String(describing: type)
        factories[key] = factory
    }
    
    /// Resolves a type.
    public func resolve<T>(_ type: T.Type) -> T? {
        let key = String(describing: type)
        return factories[key]?() as? T
    }
}

/// A property wrapper for easy injection.
@propertyWrapper
public struct Inject<T> {
    private let type: T.Type
    
    public init(_ type: T.Type) {
        self.type = type
    }
    
    public var wrappedValue: T {
        // Warning: This is a synchronous access to an actor-based container.
        // In a real implementation, we would use a sync-safe storage or @MainActor.
        fatalError("Injection must be resolved via the container or an async property wrapper.")
    }
}
