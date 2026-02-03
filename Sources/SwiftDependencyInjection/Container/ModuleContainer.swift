//
//  ModuleContainer.swift
//  SwiftDependencyInjection
//
//  Created by Muhittin Camdali on 2024.
//  Copyright © 2024 Muhittin Camdali. All rights reserved.
//

import Foundation

// MARK: - Module Container Protocol

/// Protocol defining the contract for module-based dependency containers.
/// Module containers organize dependencies into logical groups for better
/// code organization and maintainability.
public protocol ModuleContainerProtocol: AnyObject {
    /// The unique identifier for this module container.
    var moduleIdentifier: String { get }
    
    /// The parent container, if any.
    var parent: ModuleContainerProtocol? { get }
    
    /// Child containers nested within this module.
    var children: [ModuleContainerProtocol] { get }
    
    /// Registers a module with this container.
    func registerModule(_ module: ModuleDependency)
    
    /// Resolves a dependency from this module container.
    func resolve<T>(_ type: T.Type) throws -> T
    
    /// Checks if a dependency is registered in this module.
    func isRegistered<T>(_ type: T.Type) -> Bool
}

// MARK: - Module Container

/// A container that organizes dependencies into modules for better
/// code organization, encapsulation, and maintainability.
///
/// Module containers support:
/// - Hierarchical module organization
/// - Module-level scoping
/// - Lazy module loading
/// - Module isolation
/// - Cross-module dependency resolution
///
/// Example usage:
/// ```swift
/// let container = ModuleContainer(identifier: "App")
/// container.registerModule(NetworkModule())
/// container.registerModule(DatabaseModule())
///
/// let service: NetworkService = try container.resolve()
/// ```
public final class ModuleContainer: ModuleContainerProtocol {
    
    // MARK: - Properties
    
    /// The unique identifier for this module container.
    public let moduleIdentifier: String
    
    /// The parent container reference.
    public private(set) weak var parent: ModuleContainerProtocol?
    
    /// Child containers nested within this module.
    public private(set) var children: [ModuleContainerProtocol] = []
    
    /// Internal storage for registered factories.
    private var factories: [ObjectIdentifier: Any] = [:]
    
    /// Internal storage for singleton instances.
    private var singletons: [ObjectIdentifier: Any] = [:]
    
    /// Internal storage for weak singleton instances.
    private var weakSingletons: [ObjectIdentifier: WeakBox] = [:]
    
    /// Registered modules.
    private var modules: [String: ModuleDependency] = [:]
    
    /// Lock for thread-safe access.
    private let lock = NSRecursiveLock()
    
    /// Configuration options for this container.
    private var configuration: ModuleContainerConfiguration
    
    /// Resolution stack for detecting circular dependencies.
    private var resolutionStack: [ObjectIdentifier] = []
    
    /// Event handlers for container lifecycle events.
    private var eventHandlers: [ModuleContainerEventHandler] = []
    
    /// Logger for debugging and diagnostics.
    private let logger: ModuleContainerLogger?
    
    // MARK: - Initialization
    
    /// Creates a new module container with the specified identifier.
    /// - Parameters:
    ///   - identifier: The unique identifier for this container.
    ///   - configuration: Optional configuration options.
    ///   - logger: Optional logger for diagnostics.
    public init(
        identifier: String,
        configuration: ModuleContainerConfiguration = .default,
        logger: ModuleContainerLogger? = nil
    ) {
        self.moduleIdentifier = identifier
        self.configuration = configuration
        self.logger = logger
        
        logger?.log(.info, "ModuleContainer '\(identifier)' initialized")
    }
    
    /// Creates a child module container.
    /// - Parameters:
    ///   - identifier: The unique identifier for the child container.
    ///   - parent: The parent container.
    ///   - configuration: Optional configuration options.
    ///   - logger: Optional logger for diagnostics.
    public convenience init(
        identifier: String,
        parent: ModuleContainerProtocol,
        configuration: ModuleContainerConfiguration = .default,
        logger: ModuleContainerLogger? = nil
    ) {
        self.init(identifier: identifier, configuration: configuration, logger: logger)
        self.parent = parent
    }
    
    deinit {
        logger?.log(.info, "ModuleContainer '\(moduleIdentifier)' deallocated")
        notifyEventHandlers(.containerDeallocated(identifier: moduleIdentifier))
    }
    
    // MARK: - Module Registration
    
    /// Registers a module with this container.
    /// - Parameter module: The module to register.
    public func registerModule(_ module: ModuleDependency) {
        lock.lock()
        defer { lock.unlock() }
        
        let moduleName = String(describing: type(of: module))
        
        guard modules[moduleName] == nil else {
            logger?.log(.warning, "Module '\(moduleName)' already registered")
            return
        }
        
        modules[moduleName] = module
        module.configure(container: self)
        
        logger?.log(.info, "Module '\(moduleName)' registered")
        notifyEventHandlers(.moduleRegistered(name: moduleName))
    }
    
    /// Registers multiple modules with this container.
    /// - Parameter modules: The modules to register.
    public func registerModules(_ modules: [ModuleDependency]) {
        modules.forEach { registerModule($0) }
    }
    
    /// Unregisters a module from this container.
    /// - Parameter moduleType: The type of module to unregister.
    public func unregisterModule<T: ModuleDependency>(_ moduleType: T.Type) {
        lock.lock()
        defer { lock.unlock() }
        
        let moduleName = String(describing: moduleType)
        
        guard modules[moduleName] != nil else {
            logger?.log(.warning, "Module '\(moduleName)' not found")
            return
        }
        
        modules.removeValue(forKey: moduleName)
        logger?.log(.info, "Module '\(moduleName)' unregistered")
        notifyEventHandlers(.moduleUnregistered(name: moduleName))
    }
    
    /// Returns a registered module by type.
    /// - Parameter moduleType: The type of module to retrieve.
    /// - Returns: The registered module, or nil if not found.
    public func module<T: ModuleDependency>(_ moduleType: T.Type) -> T? {
        lock.lock()
        defer { lock.unlock() }
        
        let moduleName = String(describing: moduleType)
        return modules[moduleName] as? T
    }
    
    // MARK: - Dependency Registration
    
    /// Registers a factory for creating instances of a type.
    /// - Parameters:
    ///   - type: The type to register.
    ///   - scope: The scope for the registration.
    ///   - factory: The factory closure for creating instances.
    public func register<T>(
        _ type: T.Type,
        scope: DependencyScope = .transient,
        factory: @escaping (ModuleContainer) throws -> T
    ) {
        lock.lock()
        defer { lock.unlock() }
        
        let key = ObjectIdentifier(type)
        let registration = ModuleRegistration(
            type: type,
            scope: scope,
            factory: factory
        )
        
        factories[key] = registration
        
        logger?.log(.debug, "Registered \(type) with scope \(scope)")
        notifyEventHandlers(.dependencyRegistered(type: String(describing: type), scope: scope))
    }
    
    /// Registers a factory with a name for creating instances of a type.
    /// - Parameters:
    ///   - type: The type to register.
    ///   - name: The name for this registration.
    ///   - scope: The scope for the registration.
    ///   - factory: The factory closure for creating instances.
    public func register<T>(
        _ type: T.Type,
        name: String,
        scope: DependencyScope = .transient,
        factory: @escaping (ModuleContainer) throws -> T
    ) {
        lock.lock()
        defer { lock.unlock() }
        
        let key = NamedKey(type: type, name: name)
        let registration = ModuleRegistration(
            type: type,
            scope: scope,
            factory: factory
        )
        
        factories[ObjectIdentifier(key)] = registration
        
        logger?.log(.debug, "Registered \(type) with name '\(name)' and scope \(scope)")
    }
    
    /// Registers a singleton instance.
    /// - Parameters:
    ///   - type: The type to register.
    ///   - instance: The singleton instance.
    public func registerSingleton<T>(_ type: T.Type, instance: T) {
        lock.lock()
        defer { lock.unlock() }
        
        let key = ObjectIdentifier(type)
        singletons[key] = instance
        
        logger?.log(.debug, "Registered singleton instance for \(type)")
    }
    
    /// Registers a lazy singleton that will be created on first access.
    /// - Parameters:
    ///   - type: The type to register.
    ///   - factory: The factory closure for creating the singleton.
    public func registerLazySingleton<T>(
        _ type: T.Type,
        factory: @escaping (ModuleContainer) throws -> T
    ) {
        register(type, scope: .singleton, factory: factory)
    }
    
    /// Registers a weak singleton that can be deallocated when not in use.
    /// - Parameters:
    ///   - type: The type to register.
    ///   - factory: The factory closure for creating instances.
    public func registerWeakSingleton<T: AnyObject>(
        _ type: T.Type,
        factory: @escaping (ModuleContainer) throws -> T
    ) {
        register(type, scope: .weakSingleton, factory: factory)
    }
    
    // MARK: - Dependency Resolution
    
    /// Resolves an instance of the specified type.
    /// - Parameter type: The type to resolve.
    /// - Returns: An instance of the requested type.
    /// - Throws: `ModuleContainerError` if resolution fails.
    public func resolve<T>(_ type: T.Type) throws -> T {
        lock.lock()
        defer { lock.unlock() }
        
        return try resolveInternal(type)
    }
    
    /// Resolves an instance of the specified type with a name.
    /// - Parameters:
    ///   - type: The type to resolve.
    ///   - name: The name of the registration.
    /// - Returns: An instance of the requested type.
    /// - Throws: `ModuleContainerError` if resolution fails.
    public func resolve<T>(_ type: T.Type, name: String) throws -> T {
        lock.lock()
        defer { lock.unlock() }
        
        return try resolveInternal(type, name: name)
    }
    
    /// Resolves an optional instance of the specified type.
    /// - Parameter type: The type to resolve.
    /// - Returns: An instance of the requested type, or nil if not registered.
    public func resolveOptional<T>(_ type: T.Type) -> T? {
        try? resolve(type)
    }
    
    /// Resolves all registered instances of the specified type.
    /// - Parameter type: The type to resolve.
    /// - Returns: An array of all registered instances.
    public func resolveAll<T>(_ type: T.Type) -> [T] {
        lock.lock()
        defer { lock.unlock() }
        
        var instances: [T] = []
        
        for (_, value) in factories {
            if let registration = value as? ModuleRegistration<T> {
                if let instance = try? createInstance(from: registration) {
                    instances.append(instance)
                }
            }
        }
        
        return instances
    }
    
    /// Internal resolution method with circular dependency detection.
    private func resolveInternal<T>(_ type: T.Type, name: String? = nil) throws -> T {
        let key: ObjectIdentifier
        
        if let name = name {
            key = ObjectIdentifier(NamedKey(type: type, name: name))
        } else {
            key = ObjectIdentifier(type)
        }
        
        // Check for circular dependencies
        if configuration.detectCircularDependencies {
            if resolutionStack.contains(key) {
                let cycle = resolutionStack.map { String(describing: $0) }.joined(separator: " -> ")
                throw ModuleContainerError.circularDependency(cycle: cycle)
            }
        }
        
        resolutionStack.append(key)
        defer { resolutionStack.removeLast() }
        
        // Check singletons first
        if let singleton = singletons[key] as? T {
            logger?.log(.debug, "Resolved singleton for \(type)")
            return singleton
        }
        
        // Check weak singletons
        if let weakBox = weakSingletons[key], let instance = weakBox.value as? T {
            logger?.log(.debug, "Resolved weak singleton for \(type)")
            return instance
        }
        
        // Check factories
        if let registration = factories[key] as? ModuleRegistration<T> {
            return try createInstance(from: registration)
        }
        
        // Try parent container
        if let parent = parent {
            if let instance = try? parent.resolve(type) {
                logger?.log(.debug, "Resolved \(type) from parent container")
                return instance
            }
        }
        
        // Try child containers if configured
        if configuration.searchChildContainers {
            for child in children {
                if let instance = try? child.resolve(type) {
                    logger?.log(.debug, "Resolved \(type) from child container")
                    return instance
                }
            }
        }
        
        throw ModuleContainerError.notRegistered(type: String(describing: type))
    }
    
    /// Creates an instance from a registration.
    private func createInstance<T>(from registration: ModuleRegistration<T>) throws -> T {
        let key = ObjectIdentifier(T.self)
        
        switch registration.scope {
        case .transient:
            return try registration.factory(self)
            
        case .singleton:
            if let existing = singletons[key] as? T {
                return existing
            }
            let instance = try registration.factory(self)
            singletons[key] = instance
            return instance
            
        case .weakSingleton:
            if let weakBox = weakSingletons[key], let existing = weakBox.value as? T {
                return existing
            }
            let instance = try registration.factory(self)
            if let object = instance as? AnyObject {
                weakSingletons[key] = WeakBox(object)
            }
            return instance
            
        case .scoped(let scopeId):
            return try resolveScopedInstance(registration: registration, scopeId: scopeId)
            
        case .cached(let duration):
            return try resolveCachedInstance(registration: registration, duration: duration)
        }
    }
    
    /// Resolves a scoped instance.
    private func resolveScopedInstance<T>(
        registration: ModuleRegistration<T>,
        scopeId: String
    ) throws -> T {
        // Implementation for scoped instances
        // This would typically use a scope manager
        return try registration.factory(self)
    }
    
    /// Resolves a cached instance with expiration.
    private func resolveCachedInstance<T>(
        registration: ModuleRegistration<T>,
        duration: TimeInterval
    ) throws -> T {
        // Implementation for cached instances with TTL
        return try registration.factory(self)
    }
    
    // MARK: - Query Methods
    
    /// Checks if a type is registered in this container.
    /// - Parameter type: The type to check.
    /// - Returns: `true` if the type is registered.
    public func isRegistered<T>(_ type: T.Type) -> Bool {
        lock.lock()
        defer { lock.unlock() }
        
        let key = ObjectIdentifier(type)
        
        if singletons[key] != nil { return true }
        if factories[key] != nil { return true }
        if parent?.isRegistered(type) == true { return true }
        
        return false
    }
    
    /// Checks if a named registration exists.
    /// - Parameters:
    ///   - type: The type to check.
    ///   - name: The registration name.
    /// - Returns: `true` if the named registration exists.
    public func isRegistered<T>(_ type: T.Type, name: String) -> Bool {
        lock.lock()
        defer { lock.unlock() }
        
        let key = ObjectIdentifier(NamedKey(type: type, name: name))
        return factories[key] != nil
    }
    
    /// Returns the number of registered dependencies.
    public var registrationCount: Int {
        lock.lock()
        defer { lock.unlock() }
        return factories.count + singletons.count
    }
    
    /// Returns all registered type names.
    public var registeredTypes: [String] {
        lock.lock()
        defer { lock.unlock() }
        
        var types: [String] = []
        
        for (key, _) in factories {
            types.append(String(describing: key))
        }
        
        for (key, _) in singletons {
            types.append(String(describing: key))
        }
        
        return types
    }
    
    // MARK: - Child Container Management
    
    /// Creates a child container with the specified identifier.
    /// - Parameter identifier: The identifier for the child container.
    /// - Returns: A new child container.
    @discardableResult
    public func createChildContainer(identifier: String) -> ModuleContainer {
        lock.lock()
        defer { lock.unlock() }
        
        let child = ModuleContainer(
            identifier: identifier,
            parent: self,
            configuration: configuration,
            logger: logger
        )
        
        children.append(child)
        
        logger?.log(.info, "Created child container '\(identifier)'")
        notifyEventHandlers(.childContainerCreated(identifier: identifier))
        
        return child
    }
    
    /// Removes a child container.
    /// - Parameter identifier: The identifier of the child container to remove.
    public func removeChildContainer(identifier: String) {
        lock.lock()
        defer { lock.unlock() }
        
        children.removeAll { $0.moduleIdentifier == identifier }
        
        logger?.log(.info, "Removed child container '\(identifier)'")
        notifyEventHandlers(.childContainerRemoved(identifier: identifier))
    }
    
    /// Finds a child container by identifier.
    /// - Parameter identifier: The identifier to search for.
    /// - Returns: The child container, or nil if not found.
    public func findChildContainer(identifier: String) -> ModuleContainer? {
        lock.lock()
        defer { lock.unlock() }
        
        return children.first { $0.moduleIdentifier == identifier } as? ModuleContainer
    }
    
    // MARK: - Event Handling
    
    /// Adds an event handler for container lifecycle events.
    /// - Parameter handler: The event handler to add.
    public func addEventHandler(_ handler: ModuleContainerEventHandler) {
        lock.lock()
        defer { lock.unlock() }
        eventHandlers.append(handler)
    }
    
    /// Removes all event handlers.
    public func removeAllEventHandlers() {
        lock.lock()
        defer { lock.unlock() }
        eventHandlers.removeAll()
    }
    
    /// Notifies all event handlers of an event.
    private func notifyEventHandlers(_ event: ModuleContainerEvent) {
        for handler in eventHandlers {
            handler.handle(event)
        }
    }
    
    // MARK: - Cleanup
    
    /// Clears all registrations and cached instances.
    public func clear() {
        lock.lock()
        defer { lock.unlock() }
        
        factories.removeAll()
        singletons.removeAll()
        weakSingletons.removeAll()
        modules.removeAll()
        
        logger?.log(.info, "Container cleared")
        notifyEventHandlers(.containerCleared)
    }
    
    /// Clears only cached instances, keeping registrations.
    public func clearCache() {
        lock.lock()
        defer { lock.unlock() }
        
        singletons.removeAll()
        weakSingletons.removeAll()
        
        logger?.log(.info, "Cache cleared")
        notifyEventHandlers(.cacheCleared)
    }
    
    /// Removes a specific registration.
    /// - Parameter type: The type to unregister.
    public func unregister<T>(_ type: T.Type) {
        lock.lock()
        defer { lock.unlock() }
        
        let key = ObjectIdentifier(type)
        factories.removeValue(forKey: key)
        singletons.removeValue(forKey: key)
        weakSingletons.removeValue(forKey: key)
        
        logger?.log(.debug, "Unregistered \(type)")
    }
}

// MARK: - Module Registration

/// Internal struct for storing registration information.
private struct ModuleRegistration<T> {
    let type: T.Type
    let scope: DependencyScope
    let factory: (ModuleContainer) throws -> T
}

// MARK: - Named Key

/// Key for named registrations.
private class NamedKey<T>: Hashable {
    let type: T.Type
    let name: String
    
    init(type: T.Type, name: String) {
        self.type = type
        self.name = name
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(type))
        hasher.combine(name)
    }
    
    static func == (lhs: NamedKey, rhs: NamedKey) -> Bool {
        lhs.type == rhs.type && lhs.name == rhs.name
    }
}

// MARK: - Weak Box

/// Box for holding weak references.
private class WeakBox {
    weak var value: AnyObject?
    
    init(_ value: AnyObject) {
        self.value = value
    }
}

// MARK: - Dependency Scope

/// Defines the scope/lifecycle of a dependency.
public enum DependencyScope: Equatable {
    /// New instance created for each resolution.
    case transient
    
    /// Single instance shared across the container.
    case singleton
    
    /// Single instance that can be deallocated when not in use.
    case weakSingleton
    
    /// Instance shared within a specific scope.
    case scoped(String)
    
    /// Instance cached for a specific duration.
    case cached(TimeInterval)
    
    public static func == (lhs: DependencyScope, rhs: DependencyScope) -> Bool {
        switch (lhs, rhs) {
        case (.transient, .transient):
            return true
        case (.singleton, .singleton):
            return true
        case (.weakSingleton, .weakSingleton):
            return true
        case (.scoped(let a), .scoped(let b)):
            return a == b
        case (.cached(let a), .cached(let b)):
            return a == b
        default:
            return false
        }
    }
}

// MARK: - Dependency Module Protocol

/// Protocol for defining dependency modules.
public protocol ModuleDependency: AnyObject {
    /// Configures the module's dependencies in the container.
    func configure(container: ModuleContainer)
    
    /// Optional cleanup when the module is unloaded.
    func cleanup()
}

public extension ModuleDependency {
    func cleanup() {
        // Default empty implementation
    }
}

// MARK: - Module Container Configuration

/// Configuration options for module containers.
public struct ModuleContainerConfiguration {
    /// Whether to detect circular dependencies.
    public var detectCircularDependencies: Bool
    
    /// Whether to search child containers for dependencies.
    public var searchChildContainers: Bool
    
    /// Whether to allow overwriting existing registrations.
    public var allowOverwrite: Bool
    
    /// Maximum depth for hierarchical resolution.
    public var maxResolutionDepth: Int
    
    /// Default configuration.
    public static let `default` = ModuleContainerConfiguration(
        detectCircularDependencies: true,
        searchChildContainers: false,
        allowOverwrite: true,
        maxResolutionDepth: 100
    )
    
    public init(
        detectCircularDependencies: Bool = true,
        searchChildContainers: Bool = false,
        allowOverwrite: Bool = true,
        maxResolutionDepth: Int = 100
    ) {
        self.detectCircularDependencies = detectCircularDependencies
        self.searchChildContainers = searchChildContainers
        self.allowOverwrite = allowOverwrite
        self.maxResolutionDepth = maxResolutionDepth
    }
}

// MARK: - Module Container Error

/// Errors that can occur during module container operations.
public enum ModuleContainerError: Error, LocalizedError {
    case notRegistered(type: String)
    case circularDependency(cycle: String)
    case scopeNotFound(scopeId: String)
    case maxDepthExceeded(depth: Int)
    case factoryError(underlying: Error)
    case moduleNotFound(name: String)
    case invalidConfiguration(reason: String)
    
    public var errorDescription: String? {
        switch self {
        case .notRegistered(let type):
            return "Type '\(type)' is not registered in the container"
        case .circularDependency(let cycle):
            return "Circular dependency detected: \(cycle)"
        case .scopeNotFound(let scopeId):
            return "Scope '\(scopeId)' not found"
        case .maxDepthExceeded(let depth):
            return "Maximum resolution depth (\(depth)) exceeded"
        case .factoryError(let underlying):
            return "Factory error: \(underlying.localizedDescription)"
        case .moduleNotFound(let name):
            return "Module '\(name)' not found"
        case .invalidConfiguration(let reason):
            return "Invalid configuration: \(reason)"
        }
    }
}

// MARK: - Module Container Event

/// Events that can occur during container lifecycle.
public enum ModuleContainerEvent {
    case moduleRegistered(name: String)
    case moduleUnregistered(name: String)
    case dependencyRegistered(type: String, scope: DependencyScope)
    case dependencyResolved(type: String)
    case childContainerCreated(identifier: String)
    case childContainerRemoved(identifier: String)
    case containerCleared
    case cacheCleared
    case containerDeallocated(identifier: String)
}

// MARK: - Module Container Event Handler

/// Protocol for handling container events.
public protocol ModuleContainerEventHandler {
    func handle(_ event: ModuleContainerEvent)
}

// MARK: - Module Container Logger

/// Protocol for logging container operations.
public protocol ModuleContainerLogger {
    func log(_ level: ModuleContainerLogLevel, _ message: String)
}

/// Log levels for container logging.
public enum ModuleContainerLogLevel {
    case debug
    case info
    case warning
    case error
}

// MARK: - Default Logger

/// Default console logger implementation.
public final class ConsoleModuleContainerLogger: ModuleContainerLogger {
    public let minLevel: ModuleContainerLogLevel
    
    public init(minLevel: ModuleContainerLogLevel = .info) {
        self.minLevel = minLevel
    }
    
    public func log(_ level: ModuleContainerLogLevel, _ message: String) {
        let prefix: String
        switch level {
        case .debug:
            prefix = "🔍 DEBUG"
        case .info:
            prefix = "ℹ️ INFO"
        case .warning:
            prefix = "⚠️ WARNING"
        case .error:
            prefix = "❌ ERROR"
        }
        
        print("[\(prefix)] ModuleContainer: \(message)")
    }
}

// MARK: - Module Container Builder

/// Builder pattern for creating module containers.
public final class ModuleContainerBuilder {
    private var identifier: String
    private var configuration: ModuleContainerConfiguration = .default
    private var modules: [ModuleDependency] = []
    private var logger: ModuleContainerLogger?
    private var registrations: [(ModuleContainer) -> Void] = []
    
    public init(identifier: String) {
        self.identifier = identifier
    }
    
    @discardableResult
    public func withConfiguration(_ configuration: ModuleContainerConfiguration) -> Self {
        self.configuration = configuration
        return self
    }
    
    @discardableResult
    public func withModule(_ module: ModuleDependency) -> Self {
        modules.append(module)
        return self
    }
    
    @discardableResult
    public func withModules(_ modules: [ModuleDependency]) -> Self {
        self.modules.append(contentsOf: modules)
        return self
    }
    
    @discardableResult
    public func withLogger(_ logger: ModuleContainerLogger) -> Self {
        self.logger = logger
        return self
    }
    
    @discardableResult
    public func register<T>(
        _ type: T.Type,
        scope: DependencyScope = .transient,
        factory: @escaping (ModuleContainer) throws -> T
    ) -> Self {
        registrations.append { container in
            container.register(type, scope: scope, factory: factory)
        }
        return self
    }
    
    @discardableResult
    public func registerSingleton<T>(_ type: T.Type, instance: T) -> Self {
        registrations.append { container in
            container.registerSingleton(type, instance: instance)
        }
        return self
    }
    
    public func build() -> ModuleContainer {
        let container = ModuleContainer(
            identifier: identifier,
            configuration: configuration,
            logger: logger
        )
        
        for module in modules {
            container.registerModule(module)
        }
        
        for registration in registrations {
            registration(container)
        }
        
        return container
    }
}

// MARK: - Convenience Extensions

public extension ModuleContainer {
    /// Resolves a type using subscript syntax.
    subscript<T>(type: T.Type) -> T? {
        try? resolve(type)
    }
    
    /// Registers a type using operator syntax.
    static func += <T>(container: ModuleContainer, registration: (type: T.Type, factory: (ModuleContainer) throws -> T)) {
        container.register(registration.type, factory: registration.factory)
    }
}

// MARK: - Assembly Protocol

/// Protocol for grouping related registrations.
public protocol ModuleAssembly {
    func assemble(container: ModuleContainer)
}

/// Combines multiple assemblies into one.
public final class CompositeAssembly: ModuleAssembly {
    private let assemblies: [ModuleAssembly]
    
    public init(_ assemblies: [ModuleAssembly]) {
        self.assemblies = assemblies
    }
    
    public func assemble(container: ModuleContainer) {
        for assembly in assemblies {
            assembly.assemble(container: container)
        }
    }
}
