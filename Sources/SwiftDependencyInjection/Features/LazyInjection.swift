//
//  LazyInjection.swift
//  SwiftDependencyInjection
//
//  Created by Muhittin Camdali on 2024.
//  Copyright © 2024 Muhittin Camdali. All rights reserved.
//

import Foundation

// MARK: - Lazy Protocol

/// Protocol for lazy dependency providers.
public protocol LazyProvider {
    associatedtype Value
    
    /// The lazily resolved value.
    var value: Value { get }
    
    /// Whether the value has been resolved.
    var isResolved: Bool { get }
    
    /// Resets the lazy provider to unresolved state.
    func reset()
}

// MARK: - Lazy

/// A lazy wrapper for dependencies that defers resolution until first access.
///
/// Features:
/// - Deferred resolution until first access
/// - Thread-safe value access
/// - Optional reset capability
/// - Resolution tracking
///
/// Example usage:
/// ```swift
/// class UserService {
///     let database: Lazy<Database>
///
///     init(database: Lazy<Database>) {
///         self.database = database
///     }
///
///     func getUser(id: Int) -> User {
///         // Database is resolved here on first access
///         return database.value.fetchUser(id: id)
///     }
/// }
/// ```
public final class Lazy<T>: LazyProvider {
    
    // MARK: - Properties
    
    /// The factory for creating the value.
    private let factory: () throws -> T
    
    /// The cached value.
    private var cachedValue: T?
    
    /// Whether the value has been resolved.
    public private(set) var isResolved: Bool = false
    
    /// Lock for thread safety.
    private let lock = NSLock()
    
    /// Error from resolution, if any.
    private var resolutionError: Error?
    
    // MARK: - Initialization
    
    /// Creates a lazy wrapper with a factory closure.
    /// - Parameter factory: The closure to create the value.
    public init(_ factory: @escaping () throws -> T) {
        self.factory = factory
    }
    
    /// Creates a lazy wrapper with an already resolved value.
    /// - Parameter value: The pre-resolved value.
    public init(value: T) {
        self.factory = { value }
        self.cachedValue = value
        self.isResolved = true
    }
    
    // MARK: - Value Access
    
    /// The lazily resolved value.
    /// - Note: Throws a fatal error if resolution fails.
    public var value: T {
        lock.lock()
        defer { lock.unlock() }
        
        if let cached = cachedValue {
            return cached
        }
        
        do {
            let resolved = try factory()
            cachedValue = resolved
            isResolved = true
            return resolved
        } catch {
            resolutionError = error
            fatalError("Lazy resolution failed: \(error)")
        }
    }
    
    /// Attempts to resolve the value, returning nil on failure.
    public var valueOrNil: T? {
        lock.lock()
        defer { lock.unlock() }
        
        if let cached = cachedValue {
            return cached
        }
        
        do {
            let resolved = try factory()
            cachedValue = resolved
            isResolved = true
            return resolved
        } catch {
            resolutionError = error
            return nil
        }
    }
    
    /// Attempts to resolve the value, throwing on failure.
    /// - Returns: The resolved value.
    /// - Throws: The error from resolution.
    public func resolve() throws -> T {
        lock.lock()
        defer { lock.unlock() }
        
        if let cached = cachedValue {
            return cached
        }
        
        let resolved = try factory()
        cachedValue = resolved
        isResolved = true
        return resolved
    }
    
    /// Resets the lazy provider to unresolved state.
    public func reset() {
        lock.lock()
        defer { lock.unlock() }
        
        cachedValue = nil
        isResolved = false
        resolutionError = nil
    }
    
    /// The error from the last resolution attempt, if any.
    public var error: Error? {
        lock.lock()
        defer { lock.unlock() }
        return resolutionError
    }
}

// MARK: - Lazy Box

/// A class-based lazy wrapper for use in property wrappers.
public final class LazyBox<T> {
    private var lazy: Lazy<T>?
    private var directValue: T?
    
    public init() {}
    
    public func configure(factory: @escaping () throws -> T) {
        lazy = Lazy(factory)
    }
    
    public func configure(value: T) {
        directValue = value
    }
    
    public var value: T {
        if let direct = directValue {
            return direct
        }
        guard let lazy = lazy else {
            fatalError("LazyBox not configured")
        }
        return lazy.value
    }
    
    public var isResolved: Bool {
        directValue != nil || (lazy?.isResolved ?? false)
    }
    
    public func reset() {
        lazy?.reset()
        directValue = nil
    }
}

// MARK: - Lazy Injection Property Wrapper

/// Property wrapper for lazy dependency injection.
///
/// Example usage:
/// ```swift
/// class MyService {
///     @LazyInjected var database: Database
///
///     func doWork() {
///         // Database resolved on first access
///         database.execute(query: "SELECT * FROM users")
///     }
/// }
/// ```
@propertyWrapper
public struct LazyInjected<T> {
    private let box: LazyBox<T>
    
    public var wrappedValue: T {
        box.value
    }
    
    public var projectedValue: LazyInjected<T> {
        self
    }
    
    public init() {
        self.box = LazyBox()
    }
    
    public init(factory: @escaping () throws -> T) {
        self.box = LazyBox()
        self.box.configure(factory: factory)
    }
    
    public mutating func configure(factory: @escaping () throws -> T) {
        box.configure(factory: factory)
    }
    
    public var isResolved: Bool {
        box.isResolved
    }
    
    public func reset() {
        box.reset()
    }
}

// MARK: - Provider

/// A provider that creates new instances on each access.
///
/// Unlike Lazy, Provider creates a new instance every time `get()` is called.
///
/// Example usage:
/// ```swift
/// class RequestHandler {
///     let contextProvider: Provider<RequestContext>
///
///     func handle(request: Request) {
///         let context = contextProvider.get() // New context each time
///         // Process request with context
///     }
/// }
/// ```
public final class Provider<T> {
    
    // MARK: - Properties
    
    /// The factory for creating instances.
    private let factory: () throws -> T
    
    /// Counter for tracking instance creation.
    private var instanceCount: Int = 0
    
    /// Lock for thread safety.
    private let lock = NSLock()
    
    // MARK: - Initialization
    
    /// Creates a provider with a factory closure.
    /// - Parameter factory: The closure to create instances.
    public init(_ factory: @escaping () throws -> T) {
        self.factory = factory
    }
    
    // MARK: - Instance Access
    
    /// Gets a new instance from the provider.
    /// - Returns: A new instance.
    /// - Throws: If the factory fails.
    public func get() throws -> T {
        lock.lock()
        instanceCount += 1
        lock.unlock()
        
        return try factory()
    }
    
    /// Gets a new instance, or nil if creation fails.
    public func getOrNil() -> T? {
        try? get()
    }
    
    /// The number of instances created by this provider.
    public var createdCount: Int {
        lock.lock()
        defer { lock.unlock() }
        return instanceCount
    }
    
    /// Resets the instance counter.
    public func resetCount() {
        lock.lock()
        defer { lock.unlock() }
        instanceCount = 0
    }
}

// MARK: - Provider Property Wrapper

/// Property wrapper for provider injection.
@propertyWrapper
public struct Provided<T> {
    private let provider: Provider<T>
    
    public var wrappedValue: T {
        try! provider.get()
    }
    
    public var projectedValue: Provider<T> {
        provider
    }
    
    public init(_ factory: @escaping () throws -> T) {
        self.provider = Provider(factory)
    }
}

// MARK: - Factory

/// A factory that can create instances with parameters.
///
/// Example usage:
/// ```swift
/// let userFactory: Factory<Int, User> = Factory { id in
///     User(id: id)
/// }
///
/// let user1 = try userFactory.create(1)
/// let user2 = try userFactory.create(2)
/// ```
public final class Factory<Param, T> {
    
    // MARK: - Properties
    
    /// The factory closure.
    private let factory: (Param) throws -> T
    
    /// Instance creation counter.
    private var instanceCount: Int = 0
    
    /// Lock for thread safety.
    private let lock = NSLock()
    
    // MARK: - Initialization
    
    /// Creates a factory with the given closure.
    /// - Parameter factory: The closure to create instances.
    public init(_ factory: @escaping (Param) throws -> T) {
        self.factory = factory
    }
    
    // MARK: - Instance Creation
    
    /// Creates an instance with the given parameter.
    /// - Parameter param: The parameter for creation.
    /// - Returns: A new instance.
    /// - Throws: If creation fails.
    public func create(_ param: Param) throws -> T {
        lock.lock()
        instanceCount += 1
        lock.unlock()
        
        return try factory(param)
    }
    
    /// Creates an instance, or nil if creation fails.
    public func createOrNil(_ param: Param) -> T? {
        try? create(param)
    }
    
    /// The number of instances created.
    public var createdCount: Int {
        lock.lock()
        defer { lock.unlock() }
        return instanceCount
    }
}

// MARK: - Multi-Parameter Factory

/// A factory that accepts two parameters.
public final class Factory2<P1, P2, T> {
    private let factory: (P1, P2) throws -> T
    
    public init(_ factory: @escaping (P1, P2) throws -> T) {
        self.factory = factory
    }
    
    public func create(_ p1: P1, _ p2: P2) throws -> T {
        try factory(p1, p2)
    }
}

/// A factory that accepts three parameters.
public final class Factory3<P1, P2, P3, T> {
    private let factory: (P1, P2, P3) throws -> T
    
    public init(_ factory: @escaping (P1, P2, P3) throws -> T) {
        self.factory = factory
    }
    
    public func create(_ p1: P1, _ p2: P2, _ p3: P3) throws -> T {
        try factory(p1, p2, p3)
    }
}

// MARK: - Deferred

/// A deferred value that is resolved asynchronously.
///
/// Example usage:
/// ```swift
/// let config: Deferred<AppConfig> = Deferred {
///     try await loadConfigFromServer()
/// }
///
/// // Later...
/// let value = try await config.value
/// ```
@available(iOS 13.0, macOS 10.15, *)
public final class Deferred<T> {
    
    // MARK: - Properties
    
    /// The async factory.
    private let factory: () async throws -> T
    
    /// The cached value.
    private var cachedValue: T?
    
    /// Whether the value has been resolved.
    public private(set) var isResolved: Bool = false
    
    /// Actor for thread safety.
    private let isolation = DeferredIsolation<T>()
    
    // MARK: - Initialization
    
    /// Creates a deferred value with an async factory.
    /// - Parameter factory: The async closure to create the value.
    public init(_ factory: @escaping () async throws -> T) {
        self.factory = factory
    }
    
    // MARK: - Value Access
    
    /// The asynchronously resolved value.
    public var value: T {
        get async throws {
            if let cached = cachedValue {
                return cached
            }
            
            let resolved = try await factory()
            cachedValue = resolved
            isResolved = true
            return resolved
        }
    }
    
    /// Resets the deferred value to unresolved state.
    public func reset() {
        cachedValue = nil
        isResolved = false
    }
}

/// Internal actor for deferred value isolation.
@available(iOS 13.0, macOS 10.15, *)
private actor DeferredIsolation<T> {
    var value: T?
    var isResolving: Bool = false
    
    func getValue(factory: () async throws -> T) async throws -> T {
        if let value = value {
            return value
        }
        
        isResolving = true
        let resolved = try await factory()
        value = resolved
        isResolving = false
        
        return resolved
    }
}

// MARK: - Lazy Collection

/// A lazy collection that resolves elements on demand.
public final class LazyCollection<T> {
    
    // MARK: - Properties
    
    /// Factories for each element.
    private var factories: [() throws -> T] = []
    
    /// Resolved elements.
    private var resolved: [Int: T] = [:]
    
    /// Lock for thread safety.
    private let lock = NSLock()
    
    // MARK: - Initialization
    
    /// Creates an empty lazy collection.
    public init() {}
    
    /// Creates a lazy collection with factories.
    /// - Parameter factories: The factories for elements.
    public init(factories: [() throws -> T]) {
        self.factories = factories
    }
    
    // MARK: - Element Access
    
    /// Adds a factory for a new element.
    /// - Parameter factory: The factory for the element.
    public func add(_ factory: @escaping () throws -> T) {
        lock.lock()
        defer { lock.unlock() }
        factories.append(factory)
    }
    
    /// Gets an element at the specified index.
    /// - Parameter index: The index of the element.
    /// - Returns: The resolved element.
    /// - Throws: If resolution fails or index is out of bounds.
    public func get(at index: Int) throws -> T {
        lock.lock()
        defer { lock.unlock() }
        
        guard index >= 0 && index < factories.count else {
            throw LazyCollectionError.indexOutOfBounds(index: index, count: factories.count)
        }
        
        if let existing = resolved[index] {
            return existing
        }
        
        let element = try factories[index]()
        resolved[index] = element
        return element
    }
    
    /// Gets all resolved elements.
    /// - Returns: An array of resolved elements.
    /// - Throws: If any resolution fails.
    public func getAll() throws -> [T] {
        var results: [T] = []
        for i in 0..<count {
            results.append(try get(at: i))
        }
        return results
    }
    
    /// The number of elements.
    public var count: Int {
        lock.lock()
        defer { lock.unlock() }
        return factories.count
    }
    
    /// The number of resolved elements.
    public var resolvedCount: Int {
        lock.lock()
        defer { lock.unlock() }
        return resolved.count
    }
    
    /// Resets all resolved elements.
    public func reset() {
        lock.lock()
        defer { lock.unlock() }
        resolved.removeAll()
    }
}

/// Errors for lazy collections.
public enum LazyCollectionError: Error, LocalizedError {
    case indexOutOfBounds(index: Int, count: Int)
    
    public var errorDescription: String? {
        switch self {
        case .indexOutOfBounds(let index, let count):
            return "Index \(index) out of bounds for collection with \(count) elements"
        }
    }
}

// MARK: - Lazy Map

/// A lazy map that resolves values on demand.
public final class LazyMap<Key: Hashable, Value> {
    
    // MARK: - Properties
    
    /// Factories for each key.
    private var factories: [Key: () throws -> Value] = [:]
    
    /// Resolved values.
    private var resolved: [Key: Value] = [:]
    
    /// Lock for thread safety.
    private let lock = NSLock()
    
    // MARK: - Initialization
    
    /// Creates an empty lazy map.
    public init() {}
    
    // MARK: - Value Access
    
    /// Sets a factory for a key.
    /// - Parameters:
    ///   - factory: The factory for the value.
    ///   - key: The key.
    public func set(_ factory: @escaping () throws -> Value, for key: Key) {
        lock.lock()
        defer { lock.unlock() }
        factories[key] = factory
        resolved.removeValue(forKey: key)
    }
    
    /// Gets the value for a key.
    /// - Parameter key: The key.
    /// - Returns: The resolved value.
    /// - Throws: If resolution fails or key not found.
    public func get(_ key: Key) throws -> Value {
        lock.lock()
        defer { lock.unlock() }
        
        if let existing = resolved[key] {
            return existing
        }
        
        guard let factory = factories[key] else {
            throw LazyMapError.keyNotFound(key: String(describing: key))
        }
        
        let value = try factory()
        resolved[key] = value
        return value
    }
    
    /// Gets the value for a key, or nil if not found.
    public func getOrNil(_ key: Key) -> Value? {
        try? get(key)
    }
    
    /// Subscript access.
    public subscript(key: Key) -> Value? {
        try? get(key)
    }
    
    /// The keys in the map.
    public var keys: [Key] {
        lock.lock()
        defer { lock.unlock() }
        return Array(factories.keys)
    }
    
    /// Resets all resolved values.
    public func reset() {
        lock.lock()
        defer { lock.unlock() }
        resolved.removeAll()
    }
    
    /// Resets a specific key.
    public func reset(key: Key) {
        lock.lock()
        defer { lock.unlock() }
        resolved.removeValue(forKey: key)
    }
}

/// Errors for lazy maps.
public enum LazyMapError: Error, LocalizedError {
    case keyNotFound(key: String)
    
    public var errorDescription: String? {
        switch self {
        case .keyNotFound(let key):
            return "Key '\(key)' not found in lazy map"
        }
    }
}

// MARK: - Extensions

extension Lazy: CustomStringConvertible {
    public var description: String {
        if isResolved {
            return "Lazy<\(T.self)>(resolved: \(cachedValue!))"
        } else {
            return "Lazy<\(T.self)>(unresolved)"
        }
    }
}

extension Provider: CustomStringConvertible {
    public var description: String {
        "Provider<\(T.self)>(created: \(createdCount))"
    }
}
