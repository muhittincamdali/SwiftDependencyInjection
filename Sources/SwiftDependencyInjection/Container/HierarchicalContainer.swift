//
//  HierarchicalContainer.swift
//  SwiftDependencyInjection
//
//  Created by Muhittin Camdali on 2024.
//  Copyright © 2024 Muhittin Camdali. All rights reserved.
//

import Foundation

// MARK: - Hierarchical Container Protocol

/// Protocol defining the contract for hierarchical dependency containers.
/// Hierarchical containers support parent-child relationships with
/// inheritance and override capabilities.
public protocol HierarchicalContainerProtocol: AnyObject {
    /// The parent container in the hierarchy.
    var parent: HierarchicalContainerProtocol? { get }
    
    /// Child containers in the hierarchy.
    var children: [HierarchicalContainerProtocol] { get }
    
    /// The depth of this container in the hierarchy.
    var depth: Int { get }
    
    /// Creates a child container.
    func createChild(name: String) -> HierarchicalContainerProtocol
    
    /// Resolves a dependency, searching up the hierarchy if needed.
    func resolve<T>(_ type: T.Type) throws -> T
    
    /// Checks if a dependency is registered at this level.
    func isRegisteredLocally<T>(_ type: T.Type) -> Bool
}

// MARK: - Hierarchical Container

/// A dependency injection container that supports hierarchical organization
/// with parent-child relationships.
///
/// Features:
/// - Parent-child container relationships
/// - Inheritance of registrations from parent
/// - Local overrides at any level
/// - Scoped lifetimes tied to hierarchy
/// - Automatic cleanup when containers are removed
///
/// Example usage:
/// ```swift
/// let root = HierarchicalContainer(name: "Root")
/// root.register(Logger.self) { _ in ConsoleLogger() }
///
/// let child = root.createChild(name: "Child")
/// child.register(Logger.self) { _ in FileLogger() } // Overrides parent
///
/// let logger = try child.resolve(Logger.self) // Returns FileLogger
/// ```
public final class HierarchicalContainer: HierarchicalContainerProtocol {
    
    // MARK: - Properties
    
    /// The name of this container.
    public let name: String
    
    /// The unique identifier for this container.
    public let identifier: UUID
    
    /// The parent container in the hierarchy.
    public private(set) weak var parent: HierarchicalContainerProtocol?
    
    /// Child containers in the hierarchy.
    public private(set) var children: [HierarchicalContainerProtocol] = []
    
    /// The depth of this container in the hierarchy.
    public var depth: Int {
        var currentDepth = 0
        var currentParent = parent
        while currentParent != nil {
            currentDepth += 1
            currentParent = currentParent?.parent
        }
        return currentDepth
    }
    
    /// Factory registrations at this level.
    private var factories: [ObjectIdentifier: AnyFactory] = [:]
    
    /// Singleton instances at this level.
    private var singletons: [ObjectIdentifier: Any] = [:]
    
    /// Named registrations at this level.
    private var namedFactories: [String: [ObjectIdentifier: AnyFactory]] = [:]
    
    /// Tagged registrations at this level.
    private var taggedFactories: [String: [ObjectIdentifier: [AnyFactory]]] = [:]
    
    /// Scoped instances at this level.
    private var scopedInstances: [String: [ObjectIdentifier: Any]] = [:]
    
    /// Configuration for this container.
    private let configuration: HierarchicalContainerConfiguration
    
    /// Lock for thread safety.
    private let lock = NSRecursiveLock()
    
    /// Resolution context for tracking the resolution stack.
    private var resolutionContext: ResolutionContext?
    
    /// Event notifier for container events.
    private var eventNotifier: HierarchicalContainerEventNotifier?
    
    // MARK: - Initialization
    
    /// Creates a new root hierarchical container.
    /// - Parameters:
    ///   - name: The name of the container.
    ///   - configuration: Optional configuration.
    public init(
        name: String,
        configuration: HierarchicalContainerConfiguration = .default
    ) {
        self.name = name
        self.identifier = UUID()
        self.configuration = configuration
    }
    
    /// Creates a child container with the specified parent.
    /// - Parameters:
    ///   - name: The name of the child container.
    ///   - parent: The parent container.
    ///   - configuration: Optional configuration.
    private init(
        name: String,
        parent: HierarchicalContainerProtocol,
        configuration: HierarchicalContainerConfiguration
    ) {
        self.name = name
        self.identifier = UUID()
        self.parent = parent
        self.configuration = configuration
    }
    
    deinit {
        eventNotifier?.notify(.containerDestroyed(name: name))
        cleanup()
    }
    
    // MARK: - Child Container Management
    
    /// Creates a new child container.
    /// - Parameter name: The name for the child container.
    /// - Returns: A new child container.
    @discardableResult
    public func createChild(name: String) -> HierarchicalContainerProtocol {
        lock.lock()
        defer { lock.unlock() }
        
        let child = HierarchicalContainer(
            name: name,
            parent: self,
            configuration: configuration
        )
        
        children.append(child)
        eventNotifier?.notify(.childCreated(parent: self.name, child: name))
        
        return child
    }
    
    /// Creates a typed child container with additional configuration.
    /// - Parameters:
    ///   - name: The name for the child container.
    ///   - configure: A closure to configure the child container.
    /// - Returns: The configured child container.
    @discardableResult
    public func createChild(
        name: String,
        configure: (HierarchicalContainer) -> Void
    ) -> HierarchicalContainer {
        let child = createChild(name: name) as! HierarchicalContainer
        configure(child)
        return child
    }
    
    /// Removes a child container by name.
    /// - Parameter name: The name of the child container to remove.
    public func removeChild(name: String) {
        lock.lock()
        defer { lock.unlock() }
        
        if let index = children.firstIndex(where: { ($0 as? HierarchicalContainer)?.name == name }) {
            let child = children.remove(at: index)
            (child as? HierarchicalContainer)?.cleanup()
            eventNotifier?.notify(.childRemoved(parent: self.name, child: name))
        }
    }
    
    /// Removes all child containers.
    public func removeAllChildren() {
        lock.lock()
        defer { lock.unlock() }
        
        for child in children {
            (child as? HierarchicalContainer)?.cleanup()
        }
        children.removeAll()
        eventNotifier?.notify(.allChildrenRemoved(parent: name))
    }
    
    /// Finds a child container by name.
    /// - Parameter name: The name to search for.
    /// - Returns: The child container, or nil if not found.
    public func findChild(name: String) -> HierarchicalContainer? {
        lock.lock()
        defer { lock.unlock() }
        
        return children.first { ($0 as? HierarchicalContainer)?.name == name } as? HierarchicalContainer
    }
    
    /// Finds a descendant container by path.
    /// - Parameter path: The path to the container (e.g., "child1/child2").
    /// - Returns: The descendant container, or nil if not found.
    public func findDescendant(path: String) -> HierarchicalContainer? {
        let components = path.split(separator: "/").map(String.init)
        var current: HierarchicalContainer? = self
        
        for component in components {
            current = current?.findChild(name: component)
            if current == nil { return nil }
        }
        
        return current
    }
    
    // MARK: - Registration
    
    /// Registers a factory for creating instances of a type.
    /// - Parameters:
    ///   - type: The type to register.
    ///   - scope: The scope for the registration.
    ///   - factory: The factory closure.
    public func register<T>(
        _ type: T.Type,
        scope: HierarchyScope = .local,
        factory: @escaping (HierarchicalContainer) throws -> T
    ) {
        lock.lock()
        defer { lock.unlock() }
        
        let key = ObjectIdentifier(type)
        let registration = TypedFactory(scope: scope, factory: factory)
        factories[key] = registration
        
        eventNotifier?.notify(.registered(type: String(describing: type), container: name))
    }
    
    /// Registers a factory with a name.
    /// - Parameters:
    ///   - type: The type to register.
    ///   - name: The registration name.
    ///   - scope: The scope for the registration.
    ///   - factory: The factory closure.
    public func register<T>(
        _ type: T.Type,
        name registrationName: String,
        scope: HierarchyScope = .local,
        factory: @escaping (HierarchicalContainer) throws -> T
    ) {
        lock.lock()
        defer { lock.unlock() }
        
        let key = ObjectIdentifier(type)
        let registration = TypedFactory(scope: scope, factory: factory)
        
        if namedFactories[registrationName] == nil {
            namedFactories[registrationName] = [:]
        }
        namedFactories[registrationName]?[key] = registration
    }
    
    /// Registers a factory with a tag.
    /// - Parameters:
    ///   - type: The type to register.
    ///   - tag: The tag for grouping.
    ///   - scope: The scope for the registration.
    ///   - factory: The factory closure.
    public func register<T>(
        _ type: T.Type,
        tag: String,
        scope: HierarchyScope = .local,
        factory: @escaping (HierarchicalContainer) throws -> T
    ) {
        lock.lock()
        defer { lock.unlock() }
        
        let key = ObjectIdentifier(type)
        let registration = TypedFactory(scope: scope, factory: factory)
        
        if taggedFactories[tag] == nil {
            taggedFactories[tag] = [:]
        }
        if taggedFactories[tag]?[key] == nil {
            taggedFactories[tag]?[key] = []
        }
        taggedFactories[tag]?[key]?.append(registration)
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
    
    /// Registers a factory that creates instances inheriting parent registrations.
    /// - Parameters:
    ///   - type: The type to register.
    ///   - factory: The factory closure.
    public func registerInherited<T>(
        _ type: T.Type,
        factory: @escaping (HierarchicalContainer, T?) throws -> T
    ) {
        lock.lock()
        defer { lock.unlock() }
        
        let key = ObjectIdentifier(type)
        let parentInstance = try? (parent as? HierarchicalContainer)?.resolve(type)
        
        let registration = TypedFactory<T>(scope: .local) { container in
            try factory(container, parentInstance)
        }
        factories[key] = registration
    }
    
    // MARK: - Resolution
    
    /// Resolves an instance of the specified type.
    /// - Parameter type: The type to resolve.
    /// - Returns: An instance of the requested type.
    /// - Throws: `HierarchicalContainerError` if resolution fails.
    public func resolve<T>(_ type: T.Type) throws -> T {
        lock.lock()
        defer { lock.unlock() }
        
        return try resolveInternal(type, context: createResolutionContext())
    }
    
    /// Resolves a named instance of the specified type.
    /// - Parameters:
    ///   - type: The type to resolve.
    ///   - name: The registration name.
    /// - Returns: An instance of the requested type.
    /// - Throws: `HierarchicalContainerError` if resolution fails.
    public func resolve<T>(_ type: T.Type, name: String) throws -> T {
        lock.lock()
        defer { lock.unlock() }
        
        return try resolveNamedInternal(type, name: name, context: createResolutionContext())
    }
    
    /// Resolves all instances registered with a specific tag.
    /// - Parameters:
    ///   - type: The type to resolve.
    ///   - tag: The tag to search for.
    /// - Returns: An array of instances.
    public func resolveAll<T>(_ type: T.Type, tag: String) -> [T] {
        lock.lock()
        defer { lock.unlock() }
        
        var results: [T] = []
        let key = ObjectIdentifier(type)
        
        if let taggedList = taggedFactories[tag]?[key] {
            for factory in taggedList {
                if let typedFactory = factory as? TypedFactory<T>,
                   let instance = try? createInstance(from: typedFactory) {
                    results.append(instance)
                }
            }
        }
        
        // Also check parent
        if let parentContainer = parent as? HierarchicalContainer {
            results.append(contentsOf: parentContainer.resolveAll(type, tag: tag))
        }
        
        return results
    }
    
    /// Resolves an optional instance of the specified type.
    /// - Parameter type: The type to resolve.
    /// - Returns: An instance of the requested type, or nil if not registered.
    public func resolveOptional<T>(_ type: T.Type) -> T? {
        try? resolve(type)
    }
    
    /// Internal resolution method with context tracking.
    private func resolveInternal<T>(
        _ type: T.Type,
        context: ResolutionContext
    ) throws -> T {
        let key = ObjectIdentifier(type)
        
        // Check for circular dependencies
        if context.resolutionStack.contains(key) {
            let cycle = context.resolutionStack.map { String(describing: $0) }.joined(separator: " -> ")
            throw HierarchicalContainerError.circularDependency(cycle: cycle)
        }
        
        context.resolutionStack.append(key)
        defer { context.resolutionStack.removeLast() }
        
        // Check depth limit
        if context.resolutionStack.count > configuration.maxResolutionDepth {
            throw HierarchicalContainerError.maxDepthExceeded(depth: configuration.maxResolutionDepth)
        }
        
        // Check local singletons first
        if let singleton = singletons[key] as? T {
            return singleton
        }
        
        // Check local factories
        if let factory = factories[key] as? TypedFactory<T> {
            return try resolveWithScope(factory: factory, key: key, context: context)
        }
        
        // Check parent if allowed
        if configuration.inheritFromParent, let parentContainer = parent as? HierarchicalContainer {
            do {
                return try parentContainer.resolveInternal(type, context: context)
            } catch {
                // Continue to throw our own error
            }
        }
        
        throw HierarchicalContainerError.notRegistered(type: String(describing: type))
    }
    
    /// Resolves a named registration.
    private func resolveNamedInternal<T>(
        _ type: T.Type,
        name: String,
        context: ResolutionContext
    ) throws -> T {
        let key = ObjectIdentifier(type)
        
        // Check local named factories
        if let factory = namedFactories[name]?[key] as? TypedFactory<T> {
            return try createInstance(from: factory)
        }
        
        // Check parent
        if configuration.inheritFromParent, let parentContainer = parent as? HierarchicalContainer {
            do {
                return try parentContainer.resolveNamedInternal(type, name: name, context: context)
            } catch {
                // Continue to throw our own error
            }
        }
        
        throw HierarchicalContainerError.namedRegistrationNotFound(type: String(describing: type), name: name)
    }
    
    /// Resolves an instance considering its scope.
    private func resolveWithScope<T>(
        factory: TypedFactory<T>,
        key: ObjectIdentifier,
        context: ResolutionContext
    ) throws -> T {
        switch factory.scope {
        case .local:
            return try createInstance(from: factory)
            
        case .singleton:
            if let existing = singletons[key] as? T {
                return existing
            }
            let instance = try createInstance(from: factory)
            singletons[key] = instance
            return instance
            
        case .hierarchySingleton:
            // Share singleton across entire hierarchy
            if let root = findRoot() {
                if let existing = root.singletons[key] as? T {
                    return existing
                }
                let instance = try createInstance(from: factory)
                root.singletons[key] = instance
                return instance
            }
            return try createInstance(from: factory)
            
        case .parentScoped:
            // Instance is shared with immediate parent
            if let parentContainer = parent as? HierarchicalContainer {
                if let existing = parentContainer.singletons[key] as? T {
                    return existing
                }
                let instance = try createInstance(from: factory)
                parentContainer.singletons[key] = instance
                return instance
            }
            return try createInstance(from: factory)
            
        case .scoped(let scopeId):
            if scopedInstances[scopeId] == nil {
                scopedInstances[scopeId] = [:]
            }
            if let existing = scopedInstances[scopeId]?[key] as? T {
                return existing
            }
            let instance = try createInstance(from: factory)
            scopedInstances[scopeId]?[key] = instance
            return instance
        }
    }
    
    /// Creates an instance from a factory.
    private func createInstance<T>(from factory: TypedFactory<T>) throws -> T {
        do {
            return try factory.factory(self)
        } catch {
            throw HierarchicalContainerError.factoryError(underlying: error)
        }
    }
    
    /// Creates a new resolution context.
    private func createResolutionContext() -> ResolutionContext {
        ResolutionContext()
    }
    
    /// Finds the root container in the hierarchy.
    private func findRoot() -> HierarchicalContainer? {
        var current: HierarchicalContainer? = self
        while let parent = current?.parent as? HierarchicalContainer {
            current = parent
        }
        return current
    }
    
    // MARK: - Query Methods
    
    /// Checks if a type is registered locally (not in parent).
    /// - Parameter type: The type to check.
    /// - Returns: `true` if registered locally.
    public func isRegisteredLocally<T>(_ type: T.Type) -> Bool {
        lock.lock()
        defer { lock.unlock() }
        
        let key = ObjectIdentifier(type)
        return factories[key] != nil || singletons[key] != nil
    }
    
    /// Checks if a type is registered anywhere in the hierarchy.
    /// - Parameter type: The type to check.
    /// - Returns: `true` if registered.
    public func isRegistered<T>(_ type: T.Type) -> Bool {
        if isRegisteredLocally(type) { return true }
        
        if let parentContainer = parent as? HierarchicalContainer {
            return parentContainer.isRegistered(type)
        }
        
        return false
    }
    
    /// Returns the container where a type is registered.
    /// - Parameter type: The type to search for.
    /// - Returns: The container where the type is registered, or nil.
    public func containerFor<T>(_ type: T.Type) -> HierarchicalContainer? {
        if isRegisteredLocally(type) { return self }
        
        if let parentContainer = parent as? HierarchicalContainer {
            return parentContainer.containerFor(type)
        }
        
        return nil
    }
    
    /// Returns the full path of this container in the hierarchy.
    public var path: String {
        var components: [String] = [name]
        var current = parent as? HierarchicalContainer
        
        while let container = current {
            components.insert(container.name, at: 0)
            current = container.parent as? HierarchicalContainer
        }
        
        return components.joined(separator: "/")
    }
    
    /// Returns all descendants of this container.
    public var allDescendants: [HierarchicalContainer] {
        var descendants: [HierarchicalContainer] = []
        
        for child in children {
            if let hierarchicalChild = child as? HierarchicalContainer {
                descendants.append(hierarchicalChild)
                descendants.append(contentsOf: hierarchicalChild.allDescendants)
            }
        }
        
        return descendants
    }
    
    /// Returns the number of registrations at this level.
    public var localRegistrationCount: Int {
        lock.lock()
        defer { lock.unlock() }
        return factories.count + singletons.count
    }
    
    /// Returns the total number of registrations including parent.
    public var totalRegistrationCount: Int {
        var count = localRegistrationCount
        if let parentContainer = parent as? HierarchicalContainer {
            count += parentContainer.totalRegistrationCount
        }
        return count
    }
    
    // MARK: - Cleanup
    
    /// Clears all registrations at this level.
    public func clear() {
        lock.lock()
        defer { lock.unlock() }
        
        factories.removeAll()
        singletons.removeAll()
        namedFactories.removeAll()
        taggedFactories.removeAll()
        scopedInstances.removeAll()
        
        eventNotifier?.notify(.cleared(container: name))
    }
    
    /// Clears all cached singletons at this level.
    public func clearCache() {
        lock.lock()
        defer { lock.unlock() }
        
        singletons.removeAll()
        scopedInstances.removeAll()
        
        eventNotifier?.notify(.cacheCleared(container: name))
    }
    
    /// Clears a specific scope.
    /// - Parameter scopeId: The scope to clear.
    public func clearScope(_ scopeId: String) {
        lock.lock()
        defer { lock.unlock() }
        
        scopedInstances.removeValue(forKey: scopeId)
        eventNotifier?.notify(.scopeCleared(container: name, scope: scopeId))
    }
    
    /// Performs full cleanup of this container and all children.
    private func cleanup() {
        for child in children {
            (child as? HierarchicalContainer)?.cleanup()
        }
        
        clear()
        children.removeAll()
    }
    
    // MARK: - Event Handling
    
    /// Sets the event notifier for this container.
    /// - Parameter notifier: The notifier to use.
    public func setEventNotifier(_ notifier: HierarchicalContainerEventNotifier) {
        self.eventNotifier = notifier
    }
}

// MARK: - Supporting Types

/// Protocol for type-erased factories.
private protocol AnyFactory {}

/// Typed factory wrapper.
private struct TypedFactory<T>: AnyFactory {
    let scope: HierarchyScope
    let factory: (HierarchicalContainer) throws -> T
}

/// Resolution context for tracking state during resolution.
private class ResolutionContext {
    var resolutionStack: [ObjectIdentifier] = []
}

// MARK: - Hierarchy Scope

/// Defines the scope/lifecycle of a dependency in a hierarchical container.
public enum HierarchyScope {
    /// New instance created for each resolution.
    case local
    
    /// Single instance shared within this container.
    case singleton
    
    /// Single instance shared across the entire hierarchy.
    case hierarchySingleton
    
    /// Instance shared with the immediate parent.
    case parentScoped
    
    /// Instance shared within a named scope.
    case scoped(String)
}

// MARK: - Configuration

/// Configuration options for hierarchical containers.
public struct HierarchicalContainerConfiguration {
    /// Whether to inherit registrations from parent containers.
    public var inheritFromParent: Bool
    
    /// Maximum depth for resolution to prevent infinite loops.
    public var maxResolutionDepth: Int
    
    /// Whether to automatically propagate registrations to children.
    public var propagateToChildren: Bool
    
    /// Default configuration.
    public static let `default` = HierarchicalContainerConfiguration(
        inheritFromParent: true,
        maxResolutionDepth: 100,
        propagateToChildren: false
    )
    
    public init(
        inheritFromParent: Bool = true,
        maxResolutionDepth: Int = 100,
        propagateToChildren: Bool = false
    ) {
        self.inheritFromParent = inheritFromParent
        self.maxResolutionDepth = maxResolutionDepth
        self.propagateToChildren = propagateToChildren
    }
}

// MARK: - Errors

/// Errors that can occur during hierarchical container operations.
public enum HierarchicalContainerError: Error, LocalizedError {
    case notRegistered(type: String)
    case namedRegistrationNotFound(type: String, name: String)
    case circularDependency(cycle: String)
    case maxDepthExceeded(depth: Int)
    case factoryError(underlying: Error)
    case containerNotFound(path: String)
    
    public var errorDescription: String? {
        switch self {
        case .notRegistered(let type):
            return "Type '\(type)' is not registered in the container hierarchy"
        case .namedRegistrationNotFound(let type, let name):
            return "Named registration '\(name)' for type '\(type)' not found"
        case .circularDependency(let cycle):
            return "Circular dependency detected: \(cycle)"
        case .maxDepthExceeded(let depth):
            return "Maximum resolution depth (\(depth)) exceeded"
        case .factoryError(let underlying):
            return "Factory error: \(underlying.localizedDescription)"
        case .containerNotFound(let path):
            return "Container not found at path: \(path)"
        }
    }
}

// MARK: - Events

/// Events that can occur in a hierarchical container.
public enum HierarchicalContainerEvent {
    case registered(type: String, container: String)
    case resolved(type: String, container: String)
    case childCreated(parent: String, child: String)
    case childRemoved(parent: String, child: String)
    case allChildrenRemoved(parent: String)
    case cleared(container: String)
    case cacheCleared(container: String)
    case scopeCleared(container: String, scope: String)
    case containerDestroyed(name: String)
}

/// Protocol for receiving hierarchical container events.
public protocol HierarchicalContainerEventNotifier: AnyObject {
    func notify(_ event: HierarchicalContainerEvent)
}

// MARK: - Builder

/// Builder for creating hierarchical containers with fluent syntax.
public final class HierarchicalContainerBuilder {
    private var name: String
    private var configuration: HierarchicalContainerConfiguration = .default
    private var registrations: [(HierarchicalContainer) -> Void] = []
    private var childBuilders: [(String, (HierarchicalContainer) -> Void)] = []
    
    public init(name: String) {
        self.name = name
    }
    
    @discardableResult
    public func withConfiguration(_ configuration: HierarchicalContainerConfiguration) -> Self {
        self.configuration = configuration
        return self
    }
    
    @discardableResult
    public func register<T>(
        _ type: T.Type,
        scope: HierarchyScope = .local,
        factory: @escaping (HierarchicalContainer) throws -> T
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
    
    @discardableResult
    public func withChild(name: String, configure: @escaping (HierarchicalContainer) -> Void) -> Self {
        childBuilders.append((name, configure))
        return self
    }
    
    public func build() -> HierarchicalContainer {
        let container = HierarchicalContainer(name: name, configuration: configuration)
        
        for registration in registrations {
            registration(container)
        }
        
        for (childName, configure) in childBuilders {
            container.createChild(name: childName, configure: configure)
        }
        
        return container
    }
}

// MARK: - Convenience Extensions

extension HierarchicalContainer {
    /// Subscript for type-based resolution.
    public subscript<T>(_ type: T.Type) -> T? {
        try? resolve(type)
    }
    
    /// Resolves using type inference.
    public func resolve<T>() throws -> T {
        try resolve(T.self)
    }
    
    /// Creates a scoped child container.
    /// - Parameters:
    ///   - name: The name for the scoped container.
    ///   - scopeId: The scope identifier.
    /// - Returns: A new scoped child container.
    @discardableResult
    public func createScopedChild(name: String, scopeId: String) -> HierarchicalContainer {
        let child = createChild(name: name) as! HierarchicalContainer
        // Initialize scope
        child.scopedInstances[scopeId] = [:]
        return child
    }
}

// MARK: - Debug Description

extension HierarchicalContainer: CustomDebugStringConvertible {
    public var debugDescription: String {
        var lines: [String] = []
        buildDebugDescription(into: &lines, indent: 0)
        return lines.joined(separator: "\n")
    }
    
    private func buildDebugDescription(into lines: inout [String], indent: Int) {
        let prefix = String(repeating: "  ", count: indent)
        lines.append("\(prefix)📦 \(name) (depth: \(depth), registrations: \(localRegistrationCount))")
        
        for child in children {
            if let hierarchicalChild = child as? HierarchicalContainer {
                hierarchicalChild.buildDebugDescription(into: &lines, indent: indent + 1)
            }
        }
    }
}
