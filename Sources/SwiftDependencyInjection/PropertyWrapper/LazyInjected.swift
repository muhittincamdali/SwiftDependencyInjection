import Foundation

/// A property wrapper that lazily resolves a dependency on first access.
///
/// Unlike `@Injected`, the resolution is deferred until the property is first read.
///
/// ```swift
/// class MyViewModel {
///     @LazyInjected var heavyService: HeavyService
/// }
/// ```
@propertyWrapper
public struct LazyInjected<T> {

    // MARK: - Properties

    private var instance: T?
    private let name: String?
    private let container: Container

    // MARK: - Initialization

    /// Creates a `@LazyInjected` property using the shared container.
    public init() {
        self.name = nil
        self.container = Container.shared
    }

    /// Creates a `@LazyInjected` property with a named qualifier.
    /// - Parameter name: The qualifier name.
    public init(name: String) {
        self.name = name
        self.container = Container.shared
    }

    /// Creates a `@LazyInjected` property using a specific container.
    /// - Parameter container: The container to resolve from.
    public init(container: Container) {
        self.name = nil
        self.container = container
    }

    // MARK: - Wrapped Value

    /// The lazily resolved dependency.
    public var wrappedValue: T {
        mutating get {
            if let existing = instance {
                return existing
            }
            let resolved: T
            if let name = name {
                resolved = container.resolve(T.self, name: name)
            } else {
                resolved = container.resolve(T.self)
            }
            instance = resolved
            return resolved
        }
        set {
            instance = newValue
        }
    }
}
