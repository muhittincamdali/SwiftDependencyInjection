import Foundation

/// A property wrapper that resolves a dependency from the shared container
/// at initialization time.
///
/// Use `@Inject` to automatically resolve services without manually
/// calling `container.resolve(...)`:
///
/// ```swift
/// class ProfileViewModel {
///     @Inject var authService: AuthService
///     @Inject(name: "v2") var network: NetworkService
/// }
/// ```
///
/// > Important: The service must be registered in ``DIContainer/shared``
/// > before the owning type is initialized.
@propertyWrapper
public struct Inject<T> {

    // MARK: - Properties

    /// The resolved service instance.
    private let service: T

    // MARK: - Initialization

    /// Creates an `@Inject` wrapper, resolving from the shared container.
    /// - Parameter name: An optional qualifier name for named registrations.
    public init(name: String? = nil) {
        self.service = DIContainer.shared.resolve(T.self, name: name)
    }

    /// Creates an `@Inject` wrapper, resolving from a specific container.
    /// - Parameters:
    ///   - name: An optional qualifier name.
    ///   - container: The container to resolve from.
    public init(name: String? = nil, container: DIContainer) {
        self.service = container.resolve(T.self, name: name)
    }

    // MARK: - Wrapped Value

    /// The resolved service instance.
    public var wrappedValue: T {
        service
    }

    /// Projects the wrapper itself for access to metadata.
    public var projectedValue: Inject<T> {
        self
    }
}
