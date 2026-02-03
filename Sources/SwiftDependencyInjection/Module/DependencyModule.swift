import Foundation

/// A protocol for grouping related dependency registrations into reusable modules.
///
/// Implement this protocol to organize registrations by feature or layer:
///
/// ```swift
/// struct NetworkModule: DependencyModule {
///     func register(in container: Container) {
///         container.register(HTTPClient.self, scope: .singleton) { _ in
///             URLSessionHTTPClient()
///         }
///         container.register(APIService.self) { resolver in
///             DefaultAPIService(client: resolver.resolve(HTTPClient.self))
///         }
///     }
/// }
/// ```
public protocol DependencyModule {

    /// Registers all dependencies provided by this module.
    /// - Parameter container: The container to register dependencies in.
    func register(in container: Container)
}

/// A module that composes multiple sub-modules together.
///
/// Useful for creating an application-level module from feature modules:
///
/// ```swift
/// let appModule = CompositeModule(modules: [
///     NetworkModule(),
///     StorageModule(),
///     AuthModule()
/// ])
/// container.load(module: appModule)
/// ```
public struct CompositeModule: DependencyModule {

    // MARK: - Properties

    private let modules: [DependencyModule]

    // MARK: - Initialization

    /// Creates a composite module from an array of sub-modules.
    /// - Parameter modules: The modules to compose.
    public init(modules: [DependencyModule]) {
        self.modules = modules
    }

    // MARK: - Registration

    public func register(in container: Container) {
        modules.forEach { $0.register(in: container) }
    }
}

/// A convenience module created from a closure.
///
/// ```swift
/// let module = ClosureModule { container in
///     container.register(Logger.self) { _ in ConsoleLogger() }
/// }
/// ```
public struct ClosureModule: DependencyModule {
    private let closure: (Container) -> Void

    public init(_ closure: @escaping (Container) -> Void) {
        self.closure = closure
    }

    public func register(in container: Container) {
        closure(container)
    }
}
