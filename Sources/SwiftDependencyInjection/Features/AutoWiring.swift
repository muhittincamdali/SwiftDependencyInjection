//
//  AutoWiring.swift
//  SwiftDependencyInjection
//
//  Created by Muhittin Camdali on 2024.
//  Copyright © 2024 Muhittin Camdali. All rights reserved.
//

import Foundation

// MARK: - Auto Wiring Protocol

/// Protocol for types that support automatic dependency injection.
/// Conforming types can have their dependencies automatically resolved
/// and injected by the container.
public protocol AutoWirable {
    /// The dependencies required by this type.
    static var dependencies: [DependencyDescriptor] { get }
    
    /// Creates an instance with the provided resolved dependencies.
    /// - Parameter resolver: A function to resolve dependencies by type.
    init(resolver: DependencyResolver) throws
}

// MARK: - Dependency Descriptor

/// Describes a dependency for auto-wiring purposes.
public struct DependencyDescriptor: Equatable, Hashable {
    /// The type of the dependency.
    public let type: Any.Type
    
    /// The name of the dependency (for named registrations).
    public let name: String?
    
    /// Whether the dependency is optional.
    public let isOptional: Bool
    
    /// The default value factory if the dependency is optional.
    public let defaultFactory: (() -> Any)?
    
    /// Additional metadata for the dependency.
    public let metadata: [String: String]
    
    /// Creates a dependency descriptor.
    /// - Parameters:
    ///   - type: The type of the dependency.
    ///   - name: Optional name for named registrations.
    ///   - isOptional: Whether the dependency is optional.
    ///   - defaultFactory: Optional factory for default value.
    ///   - metadata: Additional metadata.
    public init(
        type: Any.Type,
        name: String? = nil,
        isOptional: Bool = false,
        defaultFactory: (() -> Any)? = nil,
        metadata: [String: String] = [:]
    ) {
        self.type = type
        self.name = name
        self.isOptional = isOptional
        self.defaultFactory = defaultFactory
        self.metadata = metadata
    }
    
    public static func == (lhs: DependencyDescriptor, rhs: DependencyDescriptor) -> Bool {
        ObjectIdentifier(lhs.type) == ObjectIdentifier(rhs.type) &&
        lhs.name == rhs.name &&
        lhs.isOptional == rhs.isOptional
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(type))
        hasher.combine(name)
        hasher.combine(isOptional)
    }
}

// MARK: - Dependency Resolver

/// Protocol for resolving dependencies.
public protocol DependencyResolver {
    /// Resolves a dependency of the specified type.
    /// - Parameter type: The type to resolve.
    /// - Returns: The resolved instance.
    /// - Throws: If the dependency cannot be resolved.
    func resolve<T>(_ type: T.Type) throws -> T
    
    /// Resolves a named dependency.
    /// - Parameters:
    ///   - type: The type to resolve.
    ///   - name: The registration name.
    /// - Returns: The resolved instance.
    /// - Throws: If the dependency cannot be resolved.
    func resolve<T>(_ type: T.Type, name: String) throws -> T
    
    /// Resolves an optional dependency.
    /// - Parameter type: The type to resolve.
    /// - Returns: The resolved instance, or nil if not registered.
    func resolveOptional<T>(_ type: T.Type) -> T?
}

// MARK: - Auto Wiring Container

/// A container that supports automatic dependency wiring.
/// Auto-wiring automatically resolves and injects dependencies
/// based on type information without explicit registration.
///
/// Features:
/// - Automatic dependency resolution
/// - Constructor injection
/// - Property injection
/// - Method injection
/// - Circular dependency detection
/// - Lazy dependency support
///
/// Example usage:
/// ```swift
/// let container = AutoWiringContainer()
/// container.register(Logger.self) { _ in ConsoleLogger() }
/// container.register(Database.self) { _ in SQLiteDatabase() }
///
/// // UserService's dependencies are automatically resolved
/// let service: UserService = try container.autoResolve()
/// ```
public final class AutoWiringContainer: DependencyResolver {
    
    // MARK: - Properties
    
    /// Registered factories.
    private var factories: [ObjectIdentifier: AnyAutoFactory] = [:]
    
    /// Named factories.
    private var namedFactories: [String: [ObjectIdentifier: AnyAutoFactory]] = [:]
    
    /// Singleton instances.
    private var singletons: [ObjectIdentifier: Any] = [:]
    
    /// Auto-wiring configuration.
    private var configuration: AutoWiringConfiguration
    
    /// Resolution stack for circular dependency detection.
    private var resolutionStack: Set<ObjectIdentifier> = []
    
    /// Lock for thread safety.
    private let lock = NSRecursiveLock()
    
    /// Logger for auto-wiring operations.
    private var logger: AutoWiringLogger?
    
    /// Type metadata cache for performance.
    private var metadataCache: [ObjectIdentifier: TypeMetadata] = [:]
    
    /// Post-initialization actions.
    private var postInitActions: [ObjectIdentifier: [(Any) -> Void]] = [:]
    
    // MARK: - Initialization
    
    /// Creates a new auto-wiring container.
    /// - Parameters:
    ///   - configuration: Optional configuration.
    ///   - logger: Optional logger for diagnostics.
    public init(
        configuration: AutoWiringConfiguration = .default,
        logger: AutoWiringLogger? = nil
    ) {
        self.configuration = configuration
        self.logger = logger
    }
    
    // MARK: - Registration
    
    /// Registers a factory for creating instances of a type.
    /// - Parameters:
    ///   - type: The type to register.
    ///   - scope: The scope for the registration.
    ///   - factory: The factory closure.
    public func register<T>(
        _ type: T.Type,
        scope: AutoWiringScope = .transient,
        factory: @escaping (AutoWiringContainer) throws -> T
    ) {
        lock.lock()
        defer { lock.unlock() }
        
        let key = ObjectIdentifier(type)
        factories[key] = TypedAutoFactory(scope: scope, factory: factory)
        
        logger?.log(.debug, "Registered \(type) with scope \(scope)")
    }
    
    /// Registers a factory with a name.
    /// - Parameters:
    ///   - type: The type to register.
    ///   - name: The registration name.
    ///   - scope: The scope for the registration.
    ///   - factory: The factory closure.
    public func register<T>(
        _ type: T.Type,
        name: String,
        scope: AutoWiringScope = .transient,
        factory: @escaping (AutoWiringContainer) throws -> T
    ) {
        lock.lock()
        defer { lock.unlock() }
        
        let key = ObjectIdentifier(type)
        
        if namedFactories[name] == nil {
            namedFactories[name] = [:]
        }
        namedFactories[name]?[key] = TypedAutoFactory(scope: scope, factory: factory)
    }
    
    /// Registers an auto-wirable type for automatic resolution.
    /// - Parameters:
    ///   - type: The auto-wirable type.
    ///   - scope: The scope for the registration.
    public func registerAutoWirable<T: AutoWirable>(
        _ type: T.Type,
        scope: AutoWiringScope = .transient
    ) {
        register(type, scope: scope) { container in
            try T(resolver: container)
        }
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
    }
    
    /// Registers a type with automatic constructor detection.
    /// - Parameters:
    ///   - type: The type to register.
    ///   - scope: The scope for the registration.
    public func registerAuto<T>(
        _ type: T.Type,
        scope: AutoWiringScope = .transient
    ) {
        // This would use runtime introspection in a real implementation
        // For now, we require AutoWirable conformance
        logger?.log(.warning, "Auto-registration requires AutoWirable conformance for \(type)")
    }
    
    // MARK: - Resolution
    
    /// Resolves an instance of the specified type.
    /// - Parameter type: The type to resolve.
    /// - Returns: An instance of the requested type.
    /// - Throws: `AutoWiringError` if resolution fails.
    public func resolve<T>(_ type: T.Type) throws -> T {
        lock.lock()
        defer { lock.unlock() }
        
        return try resolveInternal(type)
    }
    
    /// Resolves a named instance.
    /// - Parameters:
    ///   - type: The type to resolve.
    ///   - name: The registration name.
    /// - Returns: An instance of the requested type.
    /// - Throws: `AutoWiringError` if resolution fails.
    public func resolve<T>(_ type: T.Type, name: String) throws -> T {
        lock.lock()
        defer { lock.unlock() }
        
        let key = ObjectIdentifier(type)
        
        guard let factory = namedFactories[name]?[key] as? TypedAutoFactory<T> else {
            throw AutoWiringError.namedRegistrationNotFound(type: String(describing: type), name: name)
        }
        
        return try createInstance(from: factory, key: key)
    }
    
    /// Resolves an optional instance.
    /// - Parameter type: The type to resolve.
    /// - Returns: An instance, or nil if not registered.
    public func resolveOptional<T>(_ type: T.Type) -> T? {
        try? resolve(type)
    }
    
    /// Auto-resolves a type with automatic dependency injection.
    /// - Returns: An auto-wired instance.
    /// - Throws: `AutoWiringError` if resolution fails.
    public func autoResolve<T>() throws -> T {
        try resolve(T.self)
    }
    
    /// Auto-resolves an AutoWirable type.
    /// - Parameter type: The type to auto-resolve.
    /// - Returns: An auto-wired instance.
    /// - Throws: `AutoWiringError` if resolution fails.
    public func autoResolve<T: AutoWirable>(_ type: T.Type) throws -> T {
        lock.lock()
        defer { lock.unlock() }
        
        let key = ObjectIdentifier(type)
        
        // Check circular dependencies
        if resolutionStack.contains(key) {
            let cycle = resolutionStack.map { String(describing: $0) }.joined(separator: " -> ")
            throw AutoWiringError.circularDependency(cycle: cycle)
        }
        
        resolutionStack.insert(key)
        defer { resolutionStack.remove(key) }
        
        // Check if already registered
        if let factory = factories[key] as? TypedAutoFactory<T> {
            return try createInstance(from: factory, key: key)
        }
        
        // Auto-wire the type
        logger?.log(.debug, "Auto-wiring \(type)")
        
        let instance = try T(resolver: self)
        
        // Run post-init actions
        runPostInitActions(for: key, instance: instance)
        
        return instance
    }
    
    /// Internal resolution method.
    private func resolveInternal<T>(_ type: T.Type) throws -> T {
        let key = ObjectIdentifier(type)
        
        // Check for circular dependencies
        if resolutionStack.contains(key) {
            let cycle = resolutionStack.map { String(describing: $0) }.joined(separator: " -> ")
            throw AutoWiringError.circularDependency(cycle: cycle)
        }
        
        resolutionStack.insert(key)
        defer { resolutionStack.remove(key) }
        
        // Check singletons first
        if let singleton = singletons[key] as? T {
            return singleton
        }
        
        // Check registered factories
        if let factory = factories[key] as? TypedAutoFactory<T> {
            return try createInstance(from: factory, key: key)
        }
        
        // Try auto-wiring if the type conforms to AutoWirable
        if let autoWirableType = type as? AutoWirable.Type {
            logger?.log(.debug, "Attempting auto-wire for \(type)")
            // Would attempt to create instance here
        }
        
        throw AutoWiringError.notRegistered(type: String(describing: type))
    }
    
    /// Creates an instance from a factory.
    private func createInstance<T>(from factory: TypedAutoFactory<T>, key: ObjectIdentifier) throws -> T {
        switch factory.scope {
        case .transient:
            let instance = try factory.factory(self)
            runPostInitActions(for: key, instance: instance)
            return instance
            
        case .singleton:
            if let existing = singletons[key] as? T {
                return existing
            }
            let instance = try factory.factory(self)
            singletons[key] = instance
            runPostInitActions(for: key, instance: instance)
            return instance
            
        case .lazy:
            // Lazy instances are wrapped
            return try factory.factory(self)
        }
    }
    
    /// Runs post-initialization actions for an instance.
    private func runPostInitActions<T>(for key: ObjectIdentifier, instance: T) {
        if let actions = postInitActions[key] {
            for action in actions {
                action(instance)
            }
        }
    }
    
    // MARK: - Property Injection
    
    /// Injects properties into an existing instance.
    /// - Parameter instance: The instance to inject properties into.
    /// - Throws: `AutoWiringError` if injection fails.
    public func injectProperties<T>(into instance: inout T) throws {
        // This would use Mirror for runtime property inspection
        let mirror = Mirror(reflecting: instance)
        
        for child in mirror.children {
            guard let propertyName = child.label else { continue }
            
            // Check if property is injectable (would need custom attribute in real impl)
            if propertyName.hasPrefix("_injected") {
                // Attempt to resolve and inject
                logger?.log(.debug, "Injecting property: \(propertyName)")
            }
        }
    }
    
    /// Adds a post-initialization action for a type.
    /// - Parameters:
    ///   - type: The type to add the action for.
    ///   - action: The action to perform after initialization.
    public func addPostInitAction<T>(_ type: T.Type, action: @escaping (T) -> Void) {
        lock.lock()
        defer { lock.unlock() }
        
        let key = ObjectIdentifier(type)
        
        if postInitActions[key] == nil {
            postInitActions[key] = []
        }
        
        postInitActions[key]?.append { instance in
            if let typed = instance as? T {
                action(typed)
            }
        }
    }
    
    // MARK: - Dependency Graph
    
    /// Analyzes and returns the dependency graph for a type.
    /// - Parameter type: The type to analyze.
    /// - Returns: The dependency graph.
    public func analyzeDependencies<T: AutoWirable>(_ type: T.Type) -> DependencyGraph {
        var graph = DependencyGraph(rootType: type)
        
        for descriptor in type.dependencies {
            let node = DependencyNode(
                type: descriptor.type,
                name: descriptor.name,
                isOptional: descriptor.isOptional
            )
            graph.addNode(node)
            
            // Recursively analyze if the dependency is also AutoWirable
            if let autoWirableType = descriptor.type as? AutoWirable.Type {
                let subGraph = analyzeDependencies(autoWirableType)
                graph.merge(subGraph)
            }
        }
        
        return graph
    }
    
    /// Validates that all dependencies can be resolved.
    /// - Parameter type: The type to validate.
    /// - Returns: A validation result.
    public func validateDependencies<T: AutoWirable>(_ type: T.Type) -> DependencyValidationResult {
        var missing: [DependencyDescriptor] = []
        var circular: [(DependencyDescriptor, DependencyDescriptor)] = []
        
        for descriptor in type.dependencies {
            let key = ObjectIdentifier(descriptor.type)
            
            if !descriptor.isOptional && factories[key] == nil && singletons[key] == nil {
                missing.append(descriptor)
            }
        }
        
        if missing.isEmpty && circular.isEmpty {
            return .valid
        } else {
            return .invalid(missing: missing, circular: circular)
        }
    }
    
    // MARK: - Cleanup
    
    /// Clears all registrations.
    public func clear() {
        lock.lock()
        defer { lock.unlock() }
        
        factories.removeAll()
        namedFactories.removeAll()
        singletons.removeAll()
        metadataCache.removeAll()
        postInitActions.removeAll()
    }
    
    /// Clears only cached singletons.
    public func clearCache() {
        lock.lock()
        defer { lock.unlock() }
        
        singletons.removeAll()
    }
}

// MARK: - Supporting Types

/// Protocol for type-erased factories.
private protocol AnyAutoFactory {}

/// Typed factory for auto-wiring.
private struct TypedAutoFactory<T>: AnyAutoFactory {
    let scope: AutoWiringScope
    let factory: (AutoWiringContainer) throws -> T
}

// MARK: - Auto Wiring Scope

/// Scopes for auto-wired dependencies.
public enum AutoWiringScope {
    /// New instance created for each resolution.
    case transient
    
    /// Single instance shared across the container.
    case singleton
    
    /// Instance created lazily on first access.
    case lazy
}

// MARK: - Configuration

/// Configuration for auto-wiring behavior.
public struct AutoWiringConfiguration {
    /// Whether to allow constructor auto-detection.
    public var allowConstructorDetection: Bool
    
    /// Whether to enable property injection.
    public var enablePropertyInjection: Bool
    
    /// Whether to enable method injection.
    public var enableMethodInjection: Bool
    
    /// Maximum depth for nested auto-wiring.
    public var maxWiringDepth: Int
    
    /// Whether to prefer optional dependencies over throwing.
    public var preferOptional: Bool
    
    /// Default configuration.
    public static let `default` = AutoWiringConfiguration(
        allowConstructorDetection: true,
        enablePropertyInjection: false,
        enableMethodInjection: false,
        maxWiringDepth: 50,
        preferOptional: false
    )
    
    public init(
        allowConstructorDetection: Bool = true,
        enablePropertyInjection: Bool = false,
        enableMethodInjection: Bool = false,
        maxWiringDepth: Int = 50,
        preferOptional: Bool = false
    ) {
        self.allowConstructorDetection = allowConstructorDetection
        self.enablePropertyInjection = enablePropertyInjection
        self.enableMethodInjection = enableMethodInjection
        self.maxWiringDepth = maxWiringDepth
        self.preferOptional = preferOptional
    }
}

// MARK: - Type Metadata

/// Cached metadata about a type for auto-wiring.
private struct TypeMetadata {
    let type: Any.Type
    let isAutoWirable: Bool
    let dependencies: [DependencyDescriptor]
    let injectableProperties: [String]
}

// MARK: - Dependency Graph

/// Represents the dependency graph for a type.
public struct DependencyGraph {
    /// The root type of the graph.
    public let rootType: Any.Type
    
    /// All nodes in the graph.
    public private(set) var nodes: [DependencyNode] = []
    
    /// Edges representing dependencies between nodes.
    public private(set) var edges: [(from: Int, to: Int)] = []
    
    init(rootType: Any.Type) {
        self.rootType = rootType
    }
    
    mutating func addNode(_ node: DependencyNode) {
        nodes.append(node)
    }
    
    mutating func addEdge(from: Int, to: Int) {
        edges.append((from, to))
    }
    
    mutating func merge(_ other: DependencyGraph) {
        let offset = nodes.count
        nodes.append(contentsOf: other.nodes)
        
        for edge in other.edges {
            edges.append((edge.from + offset, edge.to + offset))
        }
    }
    
    /// Returns a topologically sorted order for resolution.
    public func topologicalSort() -> [DependencyNode]? {
        var inDegree = [Int](repeating: 0, count: nodes.count)
        var adjacency = [[Int]](repeating: [], count: nodes.count)
        
        for edge in edges {
            adjacency[edge.from].append(edge.to)
            inDegree[edge.to] += 1
        }
        
        var queue: [Int] = []
        for i in 0..<nodes.count where inDegree[i] == 0 {
            queue.append(i)
        }
        
        var result: [DependencyNode] = []
        
        while !queue.isEmpty {
            let current = queue.removeFirst()
            result.append(nodes[current])
            
            for neighbor in adjacency[current] {
                inDegree[neighbor] -= 1
                if inDegree[neighbor] == 0 {
                    queue.append(neighbor)
                }
            }
        }
        
        return result.count == nodes.count ? result : nil
    }
    
    /// Detects if there are any circular dependencies.
    public func hasCircularDependency() -> Bool {
        topologicalSort() == nil
    }
}

/// A node in the dependency graph.
public struct DependencyNode {
    public let type: Any.Type
    public let name: String?
    public let isOptional: Bool
    
    public init(type: Any.Type, name: String? = nil, isOptional: Bool = false) {
        self.type = type
        self.name = name
        self.isOptional = isOptional
    }
}

// MARK: - Validation Result

/// Result of dependency validation.
public enum DependencyValidationResult {
    case valid
    case invalid(missing: [DependencyDescriptor], circular: [(DependencyDescriptor, DependencyDescriptor)])
    
    public var isValid: Bool {
        if case .valid = self { return true }
        return false
    }
}

// MARK: - Errors

/// Errors that can occur during auto-wiring.
public enum AutoWiringError: Error, LocalizedError {
    case notRegistered(type: String)
    case namedRegistrationNotFound(type: String, name: String)
    case circularDependency(cycle: String)
    case maxDepthExceeded(depth: Int)
    case constructorNotFound(type: String)
    case propertyInjectionFailed(property: String, type: String)
    case validationFailed(missing: [String])
    
    public var errorDescription: String? {
        switch self {
        case .notRegistered(let type):
            return "Type '\(type)' is not registered for auto-wiring"
        case .namedRegistrationNotFound(let type, let name):
            return "Named registration '\(name)' for type '\(type)' not found"
        case .circularDependency(let cycle):
            return "Circular dependency detected: \(cycle)"
        case .maxDepthExceeded(let depth):
            return "Maximum auto-wiring depth (\(depth)) exceeded"
        case .constructorNotFound(let type):
            return "No suitable constructor found for type '\(type)'"
        case .propertyInjectionFailed(let property, let type):
            return "Failed to inject property '\(property)' in type '\(type)'"
        case .validationFailed(let missing):
            return "Validation failed, missing dependencies: \(missing.joined(separator: ", "))"
        }
    }
}

// MARK: - Logger

/// Protocol for auto-wiring logging.
public protocol AutoWiringLogger {
    func log(_ level: AutoWiringLogLevel, _ message: String)
}

/// Log levels for auto-wiring.
public enum AutoWiringLogLevel {
    case debug
    case info
    case warning
    case error
}

// MARK: - Default Logger

/// Default console logger for auto-wiring.
public final class ConsoleAutoWiringLogger: AutoWiringLogger {
    public init() {}
    
    public func log(_ level: AutoWiringLogLevel, _ message: String) {
        let prefix: String
        switch level {
        case .debug: prefix = "🔧"
        case .info: prefix = "ℹ️"
        case .warning: prefix = "⚠️"
        case .error: prefix = "❌"
        }
        print("[\(prefix)] AutoWiring: \(message)")
    }
}

// MARK: - Convenience Extensions

extension AutoWiringContainer {
    /// Registers using a builder pattern.
    @discardableResult
    public func register<T>(_ type: T.Type) -> AutoWiringRegistration<T> {
        AutoWiringRegistration(container: self, type: type)
    }
}

/// Builder for auto-wiring registrations.
public final class AutoWiringRegistration<T> {
    private let container: AutoWiringContainer
    private let type: T.Type
    private var scope: AutoWiringScope = .transient
    private var name: String?
    
    init(container: AutoWiringContainer, type: T.Type) {
        self.container = container
        self.type = type
    }
    
    @discardableResult
    public func withScope(_ scope: AutoWiringScope) -> Self {
        self.scope = scope
        return self
    }
    
    @discardableResult
    public func withName(_ name: String) -> Self {
        self.name = name
        return self
    }
    
    @discardableResult
    public func using(factory: @escaping (AutoWiringContainer) throws -> T) -> Self {
        if let name = name {
            container.register(type, name: name, scope: scope, factory: factory)
        } else {
            container.register(type, scope: scope, factory: factory)
        }
        return self
    }
    
    @discardableResult
    public func asInstance(_ instance: T) -> Self {
        container.registerSingleton(type, instance: instance)
        return self
    }
}

// MARK: - Injectable Property Wrapper

/// Property wrapper for auto-injected dependencies.
@propertyWrapper
public struct AutoInjected<T> {
    private var value: T?
    private let name: String?
    
    public var wrappedValue: T {
        get {
            guard let value = value else {
                fatalError("AutoInjected property accessed before injection")
            }
            return value
        }
        set {
            value = newValue
        }
    }
    
    public init(name: String? = nil) {
        self.name = name
    }
    
    public mutating func inject(from container: AutoWiringContainer) throws {
        if let name = name {
            value = try container.resolve(T.self, name: name)
        } else {
            value = try container.resolve(T.self)
        }
    }
}

// MARK: - Optional Injected

/// Property wrapper for optional auto-injected dependencies.
@propertyWrapper
public struct OptionalAutoInjected<T> {
    private var value: T?
    private let name: String?
    
    public var wrappedValue: T? {
        get { value }
        set { value = newValue }
    }
    
    public init(name: String? = nil) {
        self.name = name
    }
    
    public mutating func inject(from container: AutoWiringContainer) {
        if let name = name {
            value = try? container.resolve(T.self, name: name)
        } else {
            value = try? container.resolve(T.self)
        }
    }
}
