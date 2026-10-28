/// A type that owns a set of dependencies and the instances it has built.
///
/// Attach ``DependencyContainer()`` to a final class instead of conforming by hand: the macro adds
/// the conformance, the ``dependencyStorage``, typed test overrides and a compile-time cycle check.
///
/// ```swift
/// @DependencyContainer
/// final class AppDependencies {
///     let configuration: AppConfiguration
///
///     init(configuration: AppConfiguration) {
///         self.configuration = configuration
///     }
///
///     var httpClient: any HTTPClient {
///         shared(\.httpClient) { URLSessionHTTPClient(baseURL: configuration.baseURL) }
///     }
///
///     var profileRepository: ProfileRepository {
///         transient(\.profileRepository) { ProfileRepository(client: httpClient) }
///     }
/// }
/// ```
///
/// A dependency is a computed property whose getter is a single call to
/// ``shared(_:name:_:)`` or ``transient(_:name:_:)`` with the key path of that property. Reading
/// the property is the only way to get it, so a dependency that does not exist, or has another
/// type, is a compile error rather than a failed lookup at run time.
public protocol DependencyContainer: AnyObject, Sendable {
    /// The instances and test overrides of this container.
    var dependencyStorage: DependencyStorage { get }
}

extension DependencyContainer {
    /// Returns the container's single instance of a dependency, building it on first use.
    ///
    /// The instance lives as long as the container. When several threads read the property at
    /// the same time, `make` runs once and every reader gets the same instance. An override set
    /// with the container's `override(_:)` method replaces `make`.
    ///
    /// - Parameters:
    ///   - keyPath: The key path of the property whose getter calls this method, such as
    ///     `\.httpClient`. It is the key of the instance, and it gives the instance the type of
    ///     the property, so `shared(\.api) { LiveAPI() }` stores an `any API`, which an override
    ///     can replace with another conforming type.
    ///   - name: The name used in a cycle report. Leave the default, the name of the property.
    ///   - make: Builds the instance. It may read other dependencies of the container.
    public func shared<Value: Sendable>(
        _ keyPath: KeyPath<Self, Value>,
        name: String = #function,
        _ make: () -> Value
    ) -> Value {
        dependencyStorage.shared(keyPath, name: name, in: containerName, make: make)
    }

    /// Builds a new instance of a dependency on every read.
    ///
    /// Use it for objects with their own state, such as a view model per screen. Unlike a plain
    /// computed property, a transient dependency can be replaced in tests with `override(_:)` and
    /// takes part in the cycle check.
    ///
    /// - Parameters:
    ///   - keyPath: The key path of the property whose getter calls this method, such as
    ///     `\.profileRepository`.
    ///   - name: The name used in a cycle report. Leave the default, the name of the property.
    ///   - make: Builds the instance. It may read other dependencies of the container.
    public func transient<Value>(
        _ keyPath: KeyPath<Self, Value>,
        name: String = #function,
        _ make: () -> Value
    ) -> Value {
        dependencyStorage.transient(keyPath, name: name, in: containerName, make: make)
    }

    /// Stores a test override for the dependency at `keyPath` and drops its cached shared
    /// instance, so the next read uses the override.
    ///
    /// The `override(_:)` method that `@DependencyContainer` generates calls this with a closure
    /// that has the container's isolation. Call that method instead: the generated `Overrides`
    /// make a `@Sendable` closure a requirement for a container that is not on the main actor.
    public func _setOverride<Value>(_ keyPath: KeyPath<Self, Value>, _ make: @escaping () -> Value) {
        dependencyStorage.setOverride({ make() }, for: keyPath)
    }

    private var containerName: String {
        String(describing: Self.self)
    }
}
