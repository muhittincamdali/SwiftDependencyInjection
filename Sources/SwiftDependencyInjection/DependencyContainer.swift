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
///         shared { URLSessionHTTPClient(baseURL: configuration.baseURL) }
///     }
///
///     var profileRepository: ProfileRepository {
///         transient { ProfileRepository(client: httpClient) }
///     }
/// }
/// ```
///
/// A dependency is a computed property whose getter is a single call to ``shared(key:_:)`` or
/// ``transient(key:_:)``. Reading the property is the only way to get it, so a dependency that
/// does not exist, or has another type, is a compile error rather than a failed lookup at run
/// time.
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
    ///   - key: The name the instance is stored under. Leave the default, the name of the
    ///     property whose getter calls this method.
    ///   - make: Builds the instance. It may read other dependencies of the container.
    public func shared<Value: Sendable>(key: String = #function, _ make: () -> Value) -> Value {
        dependencyStorage.shared(key, in: containerName, make: make)
    }

    /// Builds a new instance of a dependency on every read.
    ///
    /// Use it for objects with their own state, such as a view model per screen. Unlike a plain
    /// computed property, a transient dependency can be replaced in tests with `override(_:)` and
    /// takes part in the cycle check.
    ///
    /// - Parameters:
    ///   - key: The name used for overrides and cycle reports. Leave the default, the name of
    ///     the property whose getter calls this method.
    ///   - make: Builds the instance. It may read other dependencies of the container.
    public func transient<Value>(key: String = #function, _ make: () -> Value) -> Value {
        dependencyStorage.transient(key, in: containerName, make: make)
    }

    private var containerName: String {
        String(describing: Self.self)
    }
}
