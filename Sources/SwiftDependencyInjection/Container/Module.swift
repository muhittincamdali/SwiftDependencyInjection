import Foundation

/// A protocol for grouping related dependency registrations.
///
/// Modules provide a clean way to organize registrations by feature
/// or layer. Implement this protocol and call ``DIContainer/registerModule(_:)``
/// to apply all registrations at once.
///
/// ## Example
/// ```swift
/// struct NetworkModule: DIModule {
///     func register(in container: DIContainer) {
///         container.register(NetworkService.self, scope: .singleton) {
///             URLSessionNetworkService()
///         }
///         container.register(APIClient.self, scope: .singleton) { resolver in
///             APIClient(network: resolver.resolve(NetworkService.self))
///         }
///     }
/// }
///
/// // At app launch
/// DIContainer.shared.registerModule(NetworkModule())
/// ```
public protocol DIModule {

    /// Registers all services provided by this module.
    /// - Parameter container: The container to register services in.
    func register(in container: DIContainer)
}

// MARK: - Module Composition

/// A composite module that combines multiple modules into one.
///
/// Use this to group several modules and register them in a single call:
/// ```swift
/// let appModule = CompositeModule(modules: [
///     NetworkModule(),
///     AuthModule(),
///     StorageModule()
/// ])
/// container.registerModule(appModule)
/// ```
public struct CompositeModule: DIModule {

    /// The child modules to register.
    private let modules: [DIModule]

    /// Creates a composite module.
    /// - Parameter modules: An array of modules to compose.
    public init(modules: [DIModule]) {
        self.modules = modules
    }

    /// Registers all child modules sequentially.
    /// - Parameter container: The container to register services in.
    public func register(in container: DIContainer) {
        for module in modules {
            module.register(in: container)
        }
    }
}
