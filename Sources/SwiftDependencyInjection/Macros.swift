/// Turns a final class into a dependency container.
///
/// The class lists its dependencies as computed properties whose getter is a single
/// ``DependencyContainer/shared(_:name:_:)`` or ``DependencyContainer/transient(_:name:_:)`` call.
/// The macro adds:
///
/// - the ``DependencyContainer`` conformance and its `dependencyStorage`;
/// - a nested `Overrides` struct with one optional closure per dependency, typed like the
///   property, and an `override(_:)` method that applies it, for tests and previews;
/// - a static `dependencyGraph` (``DependencyGraph``) that lists the dependencies and the reads
///   between them.
///
/// It also checks the container at compile time and reports an error for a dependency cycle (a
/// provider that reads itself directly or through other dependencies), for a provider outside a
/// property getter or with the key path of another property, for a dependency with a setter, an
/// `async` or `throws` getter or a `some` type, for a dependency declared inside `#if` (put the
/// `#if` inside the provider closure instead), and for a declaration that is not a final class.
///
/// ```swift
/// @DependencyContainer
/// final class AppDependencies {
///     var httpClient: any HTTPClient { shared(\.httpClient) { URLSessionHTTPClient() } }
///     var profiles: ProfileRepository { shared(\.profiles) { ProfileRepository(client: httpClient) } }
/// }
///
/// let dependencies = AppDependencies()
/// dependencies.override { $0.httpClient = { StubHTTPClient(fixture: .profile) } }
/// ```
///
/// For a container marked `@MainActor` the override closures are `@MainActor`, so a test on the
/// main actor can create main-actor types in them. Otherwise they are `@Sendable`, because a
/// nonisolated container may build its dependencies on any thread. In a module whose default
/// isolation is `MainActor`, write `@MainActor` on the container too: the macro sees only the
/// source of the class, not the module setting.
///
/// The macro reads only the class body. Declare every dependency there: one declared in an
/// extension still works, but it has no override field, is not in the graph and is not part of
/// the cycle check, and the macro cannot warn about it.
@attached(member, names: named(dependencyStorage), named(Overrides), named(override), named(dependencyGraph))
@attached(extension, conformances: DependencyContainer)
public macro DependencyContainer() = #externalMacro(
    module: "SwiftDependencyInjectionMacros",
    type: "DependencyContainerMacro"
)
