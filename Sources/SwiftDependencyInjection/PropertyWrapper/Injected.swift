import Foundation

/// A property wrapper that resolves a dependency from the shared container.
///
/// The dependency is resolved immediately when the enclosing type is initialized.
///
/// ```swift
/// class MyViewModel {
///     @Injected var service: NetworkService
///     @Injected(name: "debug") var logger: Logger
/// }
/// ```
@propertyWrapper
public struct Injected<T> {

    // MARK: - Properties

    /// The resolved dependency instance
    private var instance: T

    // MARK: - Initialization

    /// Creates an `@Injected` property that resolves from the shared container.
    public init() {
        self.instance = Container.shared.resolve(T.self)
    }

    /// Creates an `@Injected` property with a named qualifier.
    /// - Parameter name: The qualifier name for the registration.
    public init(name: String) {
        self.instance = Container.shared.resolve(T.self, name: name)
    }

    /// Creates an `@Injected` property resolving from a specific container.
    /// - Parameter container: The container to resolve from.
    public init(container: Container) {
        self.instance = container.resolve(T.self)
    }

    /// Creates an `@Injected` property resolving from a specific container with a name.
    /// - Parameters:
    ///   - container: The container to resolve from.
    ///   - name: The qualifier name.
    public init(container: Container, name: String) {
        self.instance = container.resolve(T.self, name: name)
    }

    // MARK: - Wrapped Value

    /// The resolved dependency.
    public var wrappedValue: T {
        get { instance }
        set { instance = newValue }
    }

    /// Provides access to the property wrapper itself via `$` syntax.
    public var projectedValue: Self {
        self
    }
}
