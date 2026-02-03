//
//  ScopedInjection.swift
//  SwiftDependencyInjection
//
//  Created by Muhittin Camdali on 2024.
//  Copyright © 2024 Muhittin Camdali. All rights reserved.
//

import Foundation

// MARK: - Scope Protocol

/// Protocol for defining custom scopes.
public protocol ScopeProtocol: AnyObject {
    /// The unique identifier for this scope.
    var identifier: String { get }
    
    /// Whether the scope is active.
    var isActive: Bool { get }
    
    /// Activates the scope.
    func activate()
    
    /// Deactivates the scope.
    func deactivate()
    
    /// Gets a cached instance for a type.
    func getInstance<T>(_ type: T.Type) -> T?
    
    /// Caches an instance for a type.
    func setInstance<T>(_ type: T.Type, instance: T)
    
    /// Clears all cached instances.
    func clear()
}

// MARK: - Scope Manager

/// Manages the lifecycle of scopes and scoped dependencies.
///
/// Features:
/// - Named scope management
/// - Scope nesting and hierarchy
/// - Automatic scope cleanup
/// - Thread-safe scope operations
///
/// Example usage:
/// ```swift
/// let manager = ScopeManager()
///
/// // Create and activate a request scope
/// let requestScope = manager.createScope("request")
/// manager.activate(requestScope)
///
/// // Resolve scoped dependencies
/// let context: RequestContext = try container.resolve()
///
/// // End the scope
/// manager.deactivate(requestScope)
/// ```
public final class ScopeManager {
    
    // MARK: - Properties
    
    /// All registered scopes.
    private var scopes: [String: ScopeProtocol] = [:]
    
    /// Stack of active scopes.
    private var activeScopes: [ScopeProtocol] = []
    
    /// Lock for thread safety.
    private let lock = NSRecursiveLock()
    
    /// Observers for scope events.
    private var observers: [ScopeObserver] = []
    
    /// Parent scope manager for hierarchical scoping.
    private weak var parent: ScopeManager?
    
    // MARK: - Initialization
    
    /// Creates a new scope manager.
    public init() {}
    
    /// Creates a child scope manager.
    /// - Parameter parent: The parent scope manager.
    public init(parent: ScopeManager) {
        self.parent = parent
    }
    
    // MARK: - Scope Creation
    
    /// Creates a new scope with the specified identifier.
    /// - Parameter identifier: The unique identifier for the scope.
    /// - Returns: The created scope.
    @discardableResult
    public func createScope(_ identifier: String) -> ScopeProtocol {
        lock.lock()
        defer { lock.unlock() }
        
        let scope = BasicScope(identifier: identifier)
        scopes[identifier] = scope
        
        notifyObservers(.created(identifier))
        
        return scope
    }
    
    /// Creates a scope with custom configuration.
    /// - Parameters:
    ///   - identifier: The unique identifier.
    ///   - configuration: The scope configuration.
    /// - Returns: The created scope.
    @discardableResult
    public func createScope(
        _ identifier: String,
        configuration: ScopeConfiguration
    ) -> ScopeProtocol {
        lock.lock()
        defer { lock.unlock() }
        
        let scope = ConfigurableScope(identifier: identifier, configuration: configuration)
        scopes[identifier] = scope
        
        notifyObservers(.created(identifier))
        
        return scope
    }
    
    /// Gets an existing scope by identifier.
    /// - Parameter identifier: The scope identifier.
    /// - Returns: The scope, or nil if not found.
    public func getScope(_ identifier: String) -> ScopeProtocol? {
        lock.lock()
        defer { lock.unlock() }
        return scopes[identifier]
    }
    
    /// Removes a scope by identifier.
    /// - Parameter identifier: The scope identifier.
    public func removeScope(_ identifier: String) {
        lock.lock()
        defer { lock.unlock() }
        
        if let scope = scopes[identifier] {
            scope.deactivate()
            scope.clear()
        }
        
        scopes.removeValue(forKey: identifier)
        activeScopes.removeAll { $0.identifier == identifier }
        
        notifyObservers(.removed(identifier))
    }
    
    // MARK: - Scope Activation
    
    /// Activates a scope.
    /// - Parameter scope: The scope to activate.
    public func activate(_ scope: ScopeProtocol) {
        lock.lock()
        defer { lock.unlock() }
        
        guard !scope.isActive else { return }
        
        scope.activate()
        activeScopes.append(scope)
        
        notifyObservers(.activated(scope.identifier))
    }
    
    /// Activates a scope by identifier.
    /// - Parameter identifier: The scope identifier.
    public func activate(_ identifier: String) {
        lock.lock()
        defer { lock.unlock() }
        
        guard let scope = scopes[identifier] else { return }
        
        guard !scope.isActive else { return }
        
        scope.activate()
        activeScopes.append(scope)
        
        notifyObservers(.activated(identifier))
    }
    
    /// Deactivates a scope.
    /// - Parameter scope: The scope to deactivate.
    public func deactivate(_ scope: ScopeProtocol) {
        lock.lock()
        defer { lock.unlock() }
        
        guard scope.isActive else { return }
        
        scope.deactivate()
        activeScopes.removeAll { $0.identifier == scope.identifier }
        
        notifyObservers(.deactivated(scope.identifier))
    }
    
    /// Deactivates a scope by identifier.
    /// - Parameter identifier: The scope identifier.
    public func deactivate(_ identifier: String) {
        lock.lock()
        defer { lock.unlock() }
        
        guard let scope = scopes[identifier] else { return }
        
        guard scope.isActive else { return }
        
        scope.deactivate()
        activeScopes.removeAll { $0.identifier == identifier }
        
        notifyObservers(.deactivated(identifier))
    }
    
    /// Deactivates all active scopes.
    public func deactivateAll() {
        lock.lock()
        defer { lock.unlock() }
        
        for scope in activeScopes {
            scope.deactivate()
            notifyObservers(.deactivated(scope.identifier))
        }
        
        activeScopes.removeAll()
    }
    
    // MARK: - Scope Queries
    
    /// Returns all active scopes.
    public var activeScopeIdentifiers: [String] {
        lock.lock()
        defer { lock.unlock() }
        return activeScopes.map { $0.identifier }
    }
    
    /// Checks if a scope is active.
    /// - Parameter identifier: The scope identifier.
    /// - Returns: `true` if the scope is active.
    public func isActive(_ identifier: String) -> Bool {
        lock.lock()
        defer { lock.unlock() }
        return activeScopes.contains { $0.identifier == identifier }
    }
    
    /// Gets the current innermost active scope.
    public var currentScope: ScopeProtocol? {
        lock.lock()
        defer { lock.unlock() }
        return activeScopes.last
    }
    
    /// Gets an instance from the current active scopes.
    /// - Parameter type: The type to get.
    /// - Returns: The cached instance, or nil.
    public func getInstance<T>(_ type: T.Type) -> T? {
        lock.lock()
        defer { lock.unlock() }
        
        // Search from innermost to outermost scope
        for scope in activeScopes.reversed() {
            if let instance = scope.getInstance(type) {
                return instance
            }
        }
        
        // Check parent manager
        return parent?.getInstance(type)
    }
    
    /// Caches an instance in the specified scope.
    /// - Parameters:
    ///   - type: The type to cache.
    ///   - instance: The instance to cache.
    ///   - scopeIdentifier: The scope to cache in.
    public func setInstance<T>(
        _ type: T.Type,
        instance: T,
        in scopeIdentifier: String
    ) {
        lock.lock()
        defer { lock.unlock() }
        
        guard let scope = scopes[scopeIdentifier] else { return }
        scope.setInstance(type, instance: instance)
    }
    
    /// Caches an instance in the current scope.
    /// - Parameters:
    ///   - type: The type to cache.
    ///   - instance: The instance to cache.
    public func setInstance<T>(_ type: T.Type, instance: T) {
        lock.lock()
        defer { lock.unlock() }
        
        guard let scope = activeScopes.last else { return }
        scope.setInstance(type, instance: instance)
    }
    
    // MARK: - Observers
    
    /// Adds an observer for scope events.
    /// - Parameter observer: The observer to add.
    public func addObserver(_ observer: ScopeObserver) {
        lock.lock()
        defer { lock.unlock() }
        observers.append(observer)
    }
    
    /// Removes all observers.
    public func removeAllObservers() {
        lock.lock()
        defer { lock.unlock() }
        observers.removeAll()
    }
    
    /// Notifies observers of an event.
    private func notifyObservers(_ event: ScopeEvent) {
        for observer in observers {
            observer.scopeEventOccurred(event)
        }
    }
    
    // MARK: - Cleanup
    
    /// Clears all scopes.
    public func clearAll() {
        lock.lock()
        defer { lock.unlock() }
        
        for scope in scopes.values {
            scope.deactivate()
            scope.clear()
        }
        
        scopes.removeAll()
        activeScopes.removeAll()
    }
}

// MARK: - Basic Scope

/// A basic scope implementation.
public final class BasicScope: ScopeProtocol {
    
    // MARK: - Properties
    
    /// The unique identifier for this scope.
    public let identifier: String
    
    /// Whether the scope is active.
    public private(set) var isActive: Bool = false
    
    /// Cached instances.
    private var instances: [ObjectIdentifier: Any] = [:]
    
    /// Lock for thread safety.
    private let lock = NSLock()
    
    // MARK: - Initialization
    
    /// Creates a basic scope.
    /// - Parameter identifier: The scope identifier.
    public init(identifier: String) {
        self.identifier = identifier
    }
    
    // MARK: - Scope Operations
    
    /// Activates the scope.
    public func activate() {
        lock.lock()
        defer { lock.unlock() }
        isActive = true
    }
    
    /// Deactivates the scope.
    public func deactivate() {
        lock.lock()
        defer { lock.unlock() }
        isActive = false
    }
    
    /// Gets a cached instance.
    public func getInstance<T>(_ type: T.Type) -> T? {
        lock.lock()
        defer { lock.unlock() }
        
        let key = ObjectIdentifier(type)
        return instances[key] as? T
    }
    
    /// Caches an instance.
    public func setInstance<T>(_ type: T.Type, instance: T) {
        lock.lock()
        defer { lock.unlock() }
        
        let key = ObjectIdentifier(type)
        instances[key] = instance
    }
    
    /// Clears all cached instances.
    public func clear() {
        lock.lock()
        defer { lock.unlock() }
        instances.removeAll()
    }
}

// MARK: - Configurable Scope

/// A scope with additional configuration options.
public final class ConfigurableScope: ScopeProtocol {
    
    // MARK: - Properties
    
    /// The unique identifier for this scope.
    public let identifier: String
    
    /// The configuration for this scope.
    public let configuration: ScopeConfiguration
    
    /// Whether the scope is active.
    public private(set) var isActive: Bool = false
    
    /// Cached instances.
    private var instances: [ObjectIdentifier: CachedInstance] = [:]
    
    /// Lock for thread safety.
    private let lock = NSLock()
    
    /// Activation timestamp.
    private var activationTime: Date?
    
    // MARK: - Initialization
    
    /// Creates a configurable scope.
    /// - Parameters:
    ///   - identifier: The scope identifier.
    ///   - configuration: The scope configuration.
    public init(identifier: String, configuration: ScopeConfiguration) {
        self.identifier = identifier
        self.configuration = configuration
    }
    
    // MARK: - Scope Operations
    
    /// Activates the scope.
    public func activate() {
        lock.lock()
        defer { lock.unlock() }
        
        isActive = true
        activationTime = Date()
    }
    
    /// Deactivates the scope.
    public func deactivate() {
        lock.lock()
        defer { lock.unlock() }
        
        isActive = false
        
        if configuration.clearOnDeactivate {
            instances.removeAll()
        }
        
        activationTime = nil
    }
    
    /// Gets a cached instance.
    public func getInstance<T>(_ type: T.Type) -> T? {
        lock.lock()
        defer { lock.unlock() }
        
        let key = ObjectIdentifier(type)
        
        guard let cached = instances[key] else { return nil }
        
        // Check TTL
        if let ttl = configuration.defaultTTL {
            if Date().timeIntervalSince(cached.createdAt) > ttl {
                instances.removeValue(forKey: key)
                return nil
            }
        }
        
        return cached.value as? T
    }
    
    /// Caches an instance.
    public func setInstance<T>(_ type: T.Type, instance: T) {
        lock.lock()
        defer { lock.unlock() }
        
        // Check max instances
        if let max = configuration.maxInstances, instances.count >= max {
            // Remove oldest instance
            if let oldest = instances.min(by: { $0.value.createdAt < $1.value.createdAt }) {
                instances.removeValue(forKey: oldest.key)
            }
        }
        
        let key = ObjectIdentifier(type)
        instances[key] = CachedInstance(value: instance)
    }
    
    /// Clears all cached instances.
    public func clear() {
        lock.lock()
        defer { lock.unlock() }
        instances.removeAll()
    }
    
    /// The duration the scope has been active.
    public var activeDuration: TimeInterval? {
        lock.lock()
        defer { lock.unlock() }
        
        guard let time = activationTime else { return nil }
        return Date().timeIntervalSince(time)
    }
    
    /// The number of cached instances.
    public var instanceCount: Int {
        lock.lock()
        defer { lock.unlock() }
        return instances.count
    }
}

/// Wrapper for cached instances with metadata.
private struct CachedInstance {
    let value: Any
    let createdAt: Date
    
    init(value: Any) {
        self.value = value
        self.createdAt = Date()
    }
}

// MARK: - Scope Configuration

/// Configuration options for scopes.
public struct ScopeConfiguration {
    /// Whether to clear instances when the scope is deactivated.
    public var clearOnDeactivate: Bool
    
    /// Default time-to-live for cached instances.
    public var defaultTTL: TimeInterval?
    
    /// Maximum number of instances to cache.
    public var maxInstances: Int?
    
    /// Whether to allow nested activation.
    public var allowNestedActivation: Bool
    
    /// Default configuration.
    public static let `default` = ScopeConfiguration(
        clearOnDeactivate: true,
        defaultTTL: nil,
        maxInstances: nil,
        allowNestedActivation: false
    )
    
    public init(
        clearOnDeactivate: Bool = true,
        defaultTTL: TimeInterval? = nil,
        maxInstances: Int? = nil,
        allowNestedActivation: Bool = false
    ) {
        self.clearOnDeactivate = clearOnDeactivate
        self.defaultTTL = defaultTTL
        self.maxInstances = maxInstances
        self.allowNestedActivation = allowNestedActivation
    }
}

// MARK: - Scope Events

/// Events that can occur during scope lifecycle.
public enum ScopeEvent {
    case created(String)
    case removed(String)
    case activated(String)
    case deactivated(String)
    case cleared(String)
}

/// Protocol for observing scope events.
public protocol ScopeObserver: AnyObject {
    func scopeEventOccurred(_ event: ScopeEvent)
}

// MARK: - Scoped Container

/// A container that supports scoped dependencies.
///
/// Example usage:
/// ```swift
/// let container = ScopedContainer()
///
/// // Register scoped dependency
/// container.register(RequestContext.self, scope: "request") { _ in
///     RequestContext()
/// }
///
/// // Use within a scope
/// container.withScope("request") { scoped in
///     let context: RequestContext = try scoped.resolve()
///     // Use context
/// }
/// ```
public final class ScopedContainer {
    
    // MARK: - Properties
    
    /// The scope manager.
    private let scopeManager: ScopeManager
    
    /// Registered factories.
    private var factories: [ObjectIdentifier: ScopedFactory] = [:]
    
    /// Global singletons (not scoped).
    private var singletons: [ObjectIdentifier: Any] = [:]
    
    /// Lock for thread safety.
    private let lock = NSRecursiveLock()
    
    // MARK: - Initialization
    
    /// Creates a new scoped container.
    /// - Parameter scopeManager: Optional scope manager (creates new if nil).
    public init(scopeManager: ScopeManager? = nil) {
        self.scopeManager = scopeManager ?? ScopeManager()
    }
    
    // MARK: - Registration
    
    /// Registers a factory with a scope.
    /// - Parameters:
    ///   - type: The type to register.
    ///   - scope: The scope identifier.
    ///   - factory: The factory closure.
    public func register<T>(
        _ type: T.Type,
        scope: String,
        factory: @escaping (ScopedContainer) throws -> T
    ) {
        lock.lock()
        defer { lock.unlock() }
        
        let key = ObjectIdentifier(type)
        factories[key] = ScopedFactory(
            scopeIdentifier: scope,
            factory: { container in try factory(container as! ScopedContainer) }
        )
    }
    
    /// Registers a global singleton (not scoped).
    /// - Parameters:
    ///   - type: The type to register.
    ///   - instance: The singleton instance.
    public func registerSingleton<T>(_ type: T.Type, instance: T) {
        lock.lock()
        defer { lock.unlock() }
        
        let key = ObjectIdentifier(type)
        singletons[key] = instance
    }
    
    /// Registers a transient factory (new instance each time).
    /// - Parameters:
    ///   - type: The type to register.
    ///   - factory: The factory closure.
    public func registerTransient<T>(
        _ type: T.Type,
        factory: @escaping (ScopedContainer) throws -> T
    ) {
        lock.lock()
        defer { lock.unlock() }
        
        let key = ObjectIdentifier(type)
        factories[key] = ScopedFactory(
            scopeIdentifier: nil,
            factory: { container in try factory(container as! ScopedContainer) }
        )
    }
    
    // MARK: - Resolution
    
    /// Resolves an instance of the specified type.
    /// - Parameter type: The type to resolve.
    /// - Returns: An instance of the requested type.
    /// - Throws: `ScopedContainerError` if resolution fails.
    public func resolve<T>(_ type: T.Type) throws -> T {
        lock.lock()
        defer { lock.unlock() }
        
        let key = ObjectIdentifier(type)
        
        // Check singletons first
        if let singleton = singletons[key] as? T {
            return singleton
        }
        
        // Check if registered with a scope
        guard let factory = factories[key] else {
            throw ScopedContainerError.notRegistered(type: String(describing: type))
        }
        
        // If scoped, check scope manager
        if let scopeId = factory.scopeIdentifier {
            // Check if we have a cached instance in the scope
            if let cached: T = scopeManager.getInstance(type) {
                return cached
            }
            
            // Check if scope is active
            guard scopeManager.isActive(scopeId) else {
                throw ScopedContainerError.scopeNotActive(scope: scopeId)
            }
            
            // Create new instance and cache in scope
            let instance = try factory.factory(self) as! T
            scopeManager.setInstance(type, instance: instance, in: scopeId)
            return instance
        }
        
        // Transient: create new instance
        return try factory.factory(self) as! T
    }
    
    /// Resolves an optional instance.
    /// - Parameter type: The type to resolve.
    /// - Returns: An instance, or nil if not registered or scope inactive.
    public func resolveOptional<T>(_ type: T.Type) -> T? {
        try? resolve(type)
    }
    
    // MARK: - Scope Operations
    
    /// Executes a closure within a scope.
    /// - Parameters:
    ///   - scopeIdentifier: The scope to use.
    ///   - work: The closure to execute.
    /// - Returns: The result of the closure.
    /// - Throws: If the closure throws.
    public func withScope<R>(
        _ scopeIdentifier: String,
        work: (ScopedContainer) throws -> R
    ) throws -> R {
        let scope = scopeManager.getScope(scopeIdentifier) ?? scopeManager.createScope(scopeIdentifier)
        
        scopeManager.activate(scope)
        defer { scopeManager.deactivate(scope) }
        
        return try work(self)
    }
    
    /// Executes an async closure within a scope.
    /// - Parameters:
    ///   - scopeIdentifier: The scope to use.
    ///   - work: The async closure to execute.
    /// - Returns: The result of the closure.
    /// - Throws: If the closure throws.
    @available(iOS 13.0, macOS 10.15, *)
    public func withScope<R>(
        _ scopeIdentifier: String,
        work: (ScopedContainer) async throws -> R
    ) async throws -> R {
        let scope = scopeManager.getScope(scopeIdentifier) ?? scopeManager.createScope(scopeIdentifier)
        
        scopeManager.activate(scope)
        defer { scopeManager.deactivate(scope) }
        
        return try await work(self)
    }
    
    /// Creates a subscope container.
    /// - Parameter scopeIdentifier: The scope for the subscope container.
    /// - Returns: A new container that automatically activates the scope.
    public func subscope(_ scopeIdentifier: String) -> SubscopedContainer {
        SubscopedContainer(parent: self, scopeIdentifier: scopeIdentifier, scopeManager: scopeManager)
    }
    
    /// The scope manager for this container.
    public var scopes: ScopeManager {
        scopeManager
    }
}

/// Internal factory storage for scoped container.
private struct ScopedFactory {
    let scopeIdentifier: String?
    let factory: (Any) throws -> Any
}

// MARK: - Subscoped Container

/// A container that automatically manages a scope lifecycle.
public final class SubscopedContainer {
    
    // MARK: - Properties
    
    private let parent: ScopedContainer
    private let scopeIdentifier: String
    private let scopeManager: ScopeManager
    private var scope: ScopeProtocol?
    
    // MARK: - Initialization
    
    init(parent: ScopedContainer, scopeIdentifier: String, scopeManager: ScopeManager) {
        self.parent = parent
        self.scopeIdentifier = scopeIdentifier
        self.scopeManager = scopeManager
    }
    
    // MARK: - Lifecycle
    
    /// Begins the subscope.
    public func begin() {
        scope = scopeManager.getScope(scopeIdentifier) ?? scopeManager.createScope(scopeIdentifier)
        if let scope = scope {
            scopeManager.activate(scope)
        }
    }
    
    /// Ends the subscope.
    public func end() {
        if let scope = scope {
            scopeManager.deactivate(scope)
        }
        scope = nil
    }
    
    /// Resolves from the parent with the scope active.
    public func resolve<T>(_ type: T.Type) throws -> T {
        try parent.resolve(type)
    }
}

// MARK: - Scoped Container Error

/// Errors that can occur in scoped containers.
public enum ScopedContainerError: Error, LocalizedError {
    case notRegistered(type: String)
    case scopeNotActive(scope: String)
    case scopeNotFound(scope: String)
    
    public var errorDescription: String? {
        switch self {
        case .notRegistered(let type):
            return "Type '\(type)' is not registered"
        case .scopeNotActive(let scope):
            return "Scope '\(scope)' is not active"
        case .scopeNotFound(let scope):
            return "Scope '\(scope)' not found"
        }
    }
}

// MARK: - Predefined Scopes

/// Common scope identifiers.
public enum CommonScopes {
    /// Request-level scope (one instance per request).
    public static let request = "request"
    
    /// Session-level scope (one instance per session).
    public static let session = "session"
    
    /// Transaction-level scope.
    public static let transaction = "transaction"
    
    /// Test-level scope.
    public static let test = "test"
    
    /// View-level scope (for UI).
    public static let view = "view"
}

// MARK: - Scoped Property Wrapper

/// Property wrapper for scoped dependencies.
@propertyWrapper
public struct Scoped<T> {
    private let scopeIdentifier: String
    private var container: ScopedContainer?
    private var cachedValue: T?
    
    public var wrappedValue: T {
        mutating get {
            if let cached = cachedValue {
                return cached
            }
            
            guard let container = container else {
                fatalError("Scoped property not configured with container")
            }
            
            guard let value = try? container.resolve(T.self) else {
                fatalError("Failed to resolve scoped dependency")
            }
            
            cachedValue = value
            return value
        }
    }
    
    public var projectedValue: Scoped<T> {
        get { self }
        set { self = newValue }
    }
    
    public init(_ scope: String) {
        self.scopeIdentifier = scope
    }
    
    public mutating func configure(container: ScopedContainer) {
        self.container = container
        self.cachedValue = nil
    }
    
    public mutating func reset() {
        cachedValue = nil
    }
}

// MARK: - Scope Builder

/// Builder for creating scopes with fluent syntax.
public final class ScopeBuilder {
    private var identifier: String
    private var configuration: ScopeConfiguration = .default
    private var manager: ScopeManager?
    
    public init(identifier: String) {
        self.identifier = identifier
    }
    
    @discardableResult
    public func withConfiguration(_ configuration: ScopeConfiguration) -> Self {
        self.configuration = configuration
        return self
    }
    
    @discardableResult
    public func clearOnDeactivate(_ clear: Bool) -> Self {
        configuration.clearOnDeactivate = clear
        return self
    }
    
    @discardableResult
    public func withTTL(_ ttl: TimeInterval) -> Self {
        configuration.defaultTTL = ttl
        return self
    }
    
    @discardableResult
    public func maxInstances(_ max: Int) -> Self {
        configuration.maxInstances = max
        return self
    }
    
    @discardableResult
    public func inManager(_ manager: ScopeManager) -> Self {
        self.manager = manager
        return self
    }
    
    public func build() -> ScopeProtocol {
        let scope = ConfigurableScope(identifier: identifier, configuration: configuration)
        manager?.createScope(identifier, configuration: configuration)
        return scope
    }
}

// MARK: - Extensions

extension ScopeManager {
    /// Creates a scope using builder syntax.
    @discardableResult
    public func buildScope(_ identifier: String, configure: (ScopeBuilder) -> Void) -> ScopeProtocol {
        let builder = ScopeBuilder(identifier: identifier)
        builder.inManager(self)
        configure(builder)
        return builder.build()
    }
}

extension ScopedContainer {
    /// Subscript for type-based resolution.
    public subscript<T>(_ type: T.Type) -> T? {
        try? resolve(type)
    }
}