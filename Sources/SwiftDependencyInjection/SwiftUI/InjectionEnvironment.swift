//
//  InjectionEnvironment.swift
//  SwiftDependencyInjection
//
//  Created by Muhittin Camdali on 2024.
//  Copyright © 2024 Muhittin Camdali. All rights reserved.
//

#if canImport(SwiftUI)
import SwiftUI
import Combine

// MARK: - Injection Environment Key

/// Environment key for the dependency injection container.
private struct InjectionContainerKey: EnvironmentKey {
    static let defaultValue: InjectionContainer = InjectionContainer.shared
}

/// Extension to add injection container to SwiftUI environment.
public extension EnvironmentValues {
    /// The dependency injection container.
    var injectionContainer: InjectionContainer {
        get { self[InjectionContainerKey.self] }
        set { self[InjectionContainerKey.self] = newValue }
    }
}

// MARK: - Injection Container

/// A dependency injection container designed for SwiftUI.
///
/// Features:
/// - Thread-safe dependency resolution
/// - SwiftUI environment integration
/// - Combine publishers for reactive updates
/// - View-scoped dependencies
/// - Automatic memory management
///
/// Example usage:
/// ```swift
/// // In your App
/// @main
/// struct MyApp: App {
///     let container = InjectionContainer.shared
///
///     init() {
///         container.register(UserService.self) { _ in
///             UserServiceImpl()
///         }
///     }
///
///     var body: some Scene {
///         WindowGroup {
///             ContentView()
///                 .environment(\.injectionContainer, container)
///         }
///     }
/// }
///
/// // In your View
/// struct ContentView: View {
///     @Injected var userService: UserService
///
///     var body: some View {
///         // Use userService...
///     }
/// }
/// ```
public final class InjectionContainer: ObservableObject {
    
    // MARK: - Shared Instance
    
    /// The shared container instance.
    public static let shared = InjectionContainer()
    
    // MARK: - Properties
    
    /// Published changes for SwiftUI observation.
    @Published public private(set) var changeCount: Int = 0
    
    /// Registered factories.
    private var factories: [ObjectIdentifier: AnyInjectionFactory] = [:]
    
    /// Singleton instances.
    private var singletons: [ObjectIdentifier: Any] = [:]
    
    /// Named factories.
    private var namedFactories: [String: [ObjectIdentifier: AnyInjectionFactory]] = [:]
    
    /// View-scoped instances.
    private var viewScoped: [String: [ObjectIdentifier: Any]] = [:]
    
    /// Lock for thread safety.
    private let lock = NSRecursiveLock()
    
    /// Cancellables for Combine subscriptions.
    private var cancellables = Set<AnyCancellable>()
    
    /// Change publisher for reactive updates.
    private let changeSubject = PassthroughSubject<InjectionChange, Never>()
    
    /// Publisher for container changes.
    public var changes: AnyPublisher<InjectionChange, Never> {
        changeSubject.eraseToAnyPublisher()
    }
    
    // MARK: - Initialization
    
    /// Creates a new injection container.
    public init() {}
    
    // MARK: - Registration
    
    /// Registers a factory for a type.
    /// - Parameters:
    ///   - type: The type to register.
    ///   - scope: The scope for instances.
    ///   - factory: The factory closure.
    public func register<T>(
        _ type: T.Type,
        scope: InjectionScope = .transient,
        factory: @escaping (InjectionContainer) throws -> T
    ) {
        lock.lock()
        defer { lock.unlock() }
        
        let key = ObjectIdentifier(type)
        factories[key] = TypedInjectionFactory(scope: scope, factory: factory)
        
        notifyChange(.registered(type: String(describing: type)))
    }
    
    /// Registers a factory with a name.
    /// - Parameters:
    ///   - type: The type to register.
    ///   - name: The registration name.
    ///   - scope: The scope for instances.
    ///   - factory: The factory closure.
    public func register<T>(
        _ type: T.Type,
        name: String,
        scope: InjectionScope = .transient,
        factory: @escaping (InjectionContainer) throws -> T
    ) {
        lock.lock()
        defer { lock.unlock() }
        
        let key = ObjectIdentifier(type)
        
        if namedFactories[name] == nil {
            namedFactories[name] = [:]
        }
        namedFactories[name]?[key] = TypedInjectionFactory(scope: scope, factory: factory)
        
        notifyChange(.registered(type: "\(type):\(name)"))
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
        
        notifyChange(.registered(type: String(describing: type)))
    }
    
    /// Registers an observable object.
    /// - Parameters:
    ///   - type: The type to register.
    ///   - object: The observable object.
    public func registerObservable<T: ObservableObject>(
        _ type: T.Type,
        object: T
    ) {
        registerSingleton(type, instance: object)
    }
    
    // MARK: - Resolution
    
    /// Resolves an instance of the specified type.
    /// - Parameter type: The type to resolve.
    /// - Returns: The resolved instance.
    /// - Throws: `InjectionError` if resolution fails.
    public func resolve<T>(_ type: T.Type) throws -> T {
        lock.lock()
        defer { lock.unlock() }
        
        let key = ObjectIdentifier(type)
        
        // Check singletons
        if let singleton = singletons[key] as? T {
            return singleton
        }
        
        // Check factories
        guard let factory = factories[key] as? TypedInjectionFactory<T> else {
            throw InjectionError.notRegistered(type: String(describing: type))
        }
        
        return try resolveWithScope(factory: factory, key: key)
    }
    
    /// Resolves a named instance.
    /// - Parameters:
    ///   - type: The type to resolve.
    ///   - name: The registration name.
    /// - Returns: The resolved instance.
    /// - Throws: `InjectionError` if resolution fails.
    public func resolve<T>(_ type: T.Type, name: String) throws -> T {
        lock.lock()
        defer { lock.unlock() }
        
        let key = ObjectIdentifier(type)
        
        guard let factory = namedFactories[name]?[key] as? TypedInjectionFactory<T> else {
            throw InjectionError.namedNotRegistered(type: String(describing: type), name: name)
        }
        
        return try factory.factory(self)
    }
    
    /// Resolves an optional instance.
    /// - Parameter type: The type to resolve.
    /// - Returns: The resolved instance, or nil.
    public func resolveOptional<T>(_ type: T.Type) -> T? {
        try? resolve(type)
    }
    
    /// Resolves with scope handling.
    private func resolveWithScope<T>(
        factory: TypedInjectionFactory<T>,
        key: ObjectIdentifier
    ) throws -> T {
        switch factory.scope {
        case .transient:
            return try factory.factory(self)
            
        case .singleton:
            if let existing = singletons[key] as? T {
                return existing
            }
            let instance = try factory.factory(self)
            singletons[key] = instance
            return instance
            
        case .viewScoped(let viewId):
            if viewScoped[viewId] == nil {
                viewScoped[viewId] = [:]
            }
            if let existing = viewScoped[viewId]?[key] as? T {
                return existing
            }
            let instance = try factory.factory(self)
            viewScoped[viewId]?[key] = instance
            return instance
        }
    }
    
    // MARK: - View Scope Management
    
    /// Begins a view scope.
    /// - Parameter viewId: The view identifier.
    public func beginViewScope(_ viewId: String) {
        lock.lock()
        defer { lock.unlock() }
        
        if viewScoped[viewId] == nil {
            viewScoped[viewId] = [:]
        }
    }
    
    /// Ends a view scope and releases instances.
    /// - Parameter viewId: The view identifier.
    public func endViewScope(_ viewId: String) {
        lock.lock()
        defer { lock.unlock() }
        
        viewScoped.removeValue(forKey: viewId)
        notifyChange(.scopeEnded(viewId: viewId))
    }
    
    // MARK: - Observation
    
    /// Notifies subscribers of a change.
    private func notifyChange(_ change: InjectionChange) {
        changeCount += 1
        changeSubject.send(change)
    }
    
    // MARK: - Cleanup
    
    /// Clears all registrations.
    public func clear() {
        lock.lock()
        defer { lock.unlock() }
        
        factories.removeAll()
        singletons.removeAll()
        namedFactories.removeAll()
        viewScoped.removeAll()
        
        notifyChange(.cleared)
    }
    
    /// Clears cached singletons.
    public func clearSingletons() {
        lock.lock()
        defer { lock.unlock() }
        
        singletons.removeAll()
        notifyChange(.singletonsCleared)
    }
}

// MARK: - Supporting Types

/// Protocol for type-erased factories.
private protocol AnyInjectionFactory {}

/// Typed factory for injection.
private struct TypedInjectionFactory<T>: AnyInjectionFactory {
    let scope: InjectionScope
    let factory: (InjectionContainer) throws -> T
}

// MARK: - Injection Scope

/// Scopes for injected dependencies.
public enum InjectionScope {
    /// New instance for each resolution.
    case transient
    
    /// Single instance shared globally.
    case singleton
    
    /// Instance scoped to a specific view.
    case viewScoped(String)
}

// MARK: - Injection Change

/// Events for injection container changes.
public enum InjectionChange {
    case registered(type: String)
    case resolved(type: String)
    case scopeEnded(viewId: String)
    case cleared
    case singletonsCleared
}

// MARK: - Injection Error

/// Errors that can occur during injection.
public enum InjectionError: Error, LocalizedError {
    case notRegistered(type: String)
    case namedNotRegistered(type: String, name: String)
    case resolutionFailed(type: String, reason: String)
    
    public var errorDescription: String? {
        switch self {
        case .notRegistered(let type):
            return "Type '\(type)' is not registered"
        case .namedNotRegistered(let type, let name):
            return "Type '\(type)' with name '\(name)' is not registered"
        case .resolutionFailed(let type, let reason):
            return "Failed to resolve '\(type)': \(reason)"
        }
    }
}

// MARK: - Injected Property Wrapper

/// Property wrapper for injecting dependencies in SwiftUI views.
///
/// Example:
/// ```swift
/// struct MyView: View {
///     @Injected var userService: UserService
///
///     var body: some View {
///         Text(userService.currentUser.name)
///     }
/// }
/// ```
@propertyWrapper
public struct Injected<T>: DynamicProperty {
    @Environment(\.injectionContainer) private var container
    
    private let name: String?
    
    public var wrappedValue: T {
        do {
            if let name = name {
                return try container.resolve(T.self, name: name)
            }
            return try container.resolve(T.self)
        } catch {
            fatalError("Failed to resolve \(T.self): \(error)")
        }
    }
    
    /// Creates an injected property.
    public init() {
        self.name = nil
    }
    
    /// Creates a named injected property.
    /// - Parameter name: The registration name.
    public init(name: String) {
        self.name = name
    }
}

// MARK: - Optional Injected

/// Property wrapper for optionally injecting dependencies.
@propertyWrapper
public struct OptionalInjected<T>: DynamicProperty {
    @Environment(\.injectionContainer) private var container
    
    private let name: String?
    
    public var wrappedValue: T? {
        if let name = name {
            return try? container.resolve(T.self, name: name)
        }
        return container.resolveOptional(T.self)
    }
    
    public init() {
        self.name = nil
    }
    
    public init(name: String) {
        self.name = name
    }
}

// MARK: - Injected Observable

/// Property wrapper for injecting observable objects.
@propertyWrapper
public struct InjectedObservable<T: ObservableObject>: DynamicProperty {
    @Environment(\.injectionContainer) private var container
    @StateObject private var observed = ObservableHolder<T>()
    
    public var wrappedValue: T {
        observed.object!
    }
    
    public var projectedValue: ObservedObject<T>.Wrapper {
        ObservedObject(wrappedValue: observed.object!).projectedValue
    }
    
    public init() { }
    
    public mutating func update() {
        if observed.object == nil, let value = container.resolveOptional(T.self) {
            observed.object = value
        }
    }
}

/// Holder for observable objects that defers initialization.
private class ObservableHolder<T: ObservableObject>: ObservableObject {
    @Published var object: T?
}

// MARK: - View Extensions

public extension View {
    /// Injects a container into the view hierarchy.
    /// - Parameter container: The container to inject.
    func inject(_ container: InjectionContainer) -> some View {
        environment(\.injectionContainer, container)
    }
    
    /// Creates a view scope for scoped dependencies.
    /// - Parameter id: The scope identifier.
    func viewScope(_ id: String) -> some View {
        modifier(ViewScopeModifier(scopeId: id))
    }
}

// MARK: - View Scope Modifier

/// Modifier for managing view scopes.
private struct ViewScopeModifier: ViewModifier {
    let scopeId: String
    @Environment(\.injectionContainer) private var container
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                container.beginViewScope(scopeId)
            }
            .onDisappear {
                container.endViewScope(scopeId)
            }
    }
}

// MARK: - Injection Container Builder

/// Builder for configuring injection containers.
public final class InjectionContainerBuilder {
    private let container: InjectionContainer
    
    public init(container: InjectionContainer = .shared) {
        self.container = container
    }
    
    @discardableResult
    public func register<T>(
        _ type: T.Type,
        scope: InjectionScope = .transient,
        factory: @escaping (InjectionContainer) throws -> T
    ) -> Self {
        container.register(type, scope: scope, factory: factory)
        return self
    }
    
    @discardableResult
    public func registerSingleton<T>(_ type: T.Type, instance: T) -> Self {
        container.registerSingleton(type, instance: instance)
        return self
    }
    
    public func build() -> InjectionContainer {
        container
    }
}

// MARK: - Dependency Provider View

/// A view that provides dependencies to its children.
public struct DependencyProvider<Content: View>: View {
    private let container: InjectionContainer
    private let content: Content
    
    public init(
        container: InjectionContainer,
        @ViewBuilder content: () -> Content
    ) {
        self.container = container
        self.content = content()
    }
    
    public var body: some View {
        content
            .environment(\.injectionContainer, container)
    }
}

// MARK: - Resolved View

/// A view that resolves a dependency and passes it to a content builder.
public struct ResolvedView<T, Content: View>: View {
    @Environment(\.injectionContainer) private var container
    private let type: T.Type
    private let content: (T) -> Content
    
    public init(
        _ type: T.Type,
        @ViewBuilder content: @escaping (T) -> Content
    ) {
        self.type = type
        self.content = content
    }
    
    public var body: some View {
        if let resolved = container.resolveOptional(type) {
            content(resolved)
        } else {
            EmptyView()
        }
    }
}

// MARK: - Convenience Extensions

public extension InjectionContainer {
    /// Subscript for type-based resolution.
    subscript<T>(_ type: T.Type) -> T? {
        resolveOptional(type)
    }
    
    /// Configures the container using a builder closure.
    func configure(_ builder: (InjectionContainerBuilder) -> Void) {
        let containerBuilder = InjectionContainerBuilder(container: self)
        builder(containerBuilder)
    }
}

#endif
