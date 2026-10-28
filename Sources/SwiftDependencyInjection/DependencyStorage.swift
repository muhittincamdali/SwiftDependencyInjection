import Foundation

/// The instances, test overrides and in-progress resolutions of one container.
///
/// `@DependencyContainer` adds one storage to each container, so each container instance is its
/// own scope: two containers never share a shared instance or an override. You do not call it
/// directly; ``DependencyContainer/shared(key:_:)`` and ``DependencyContainer/transient(key:_:)``
/// use it.
///
/// One recursive lock guards everything. It is held while a dependency is built, so a shared
/// dependency is built exactly once even when many threads ask for it at the same time, and a
/// provider may read other dependencies of the same container. Because only the thread that holds
/// the lock can be building, a name that is already in ``resolving`` means the provider asked for
/// itself: a dependency cycle.
public final class DependencyStorage: @unchecked Sendable {
    // Invariant behind @unchecked Sendable: every stored property below is read and written only
    // while `lock` is held. Override closures are stored by generated code that gives them the
    // container's isolation (@Sendable for a nonisolated container, @MainActor for a main-actor
    // container), so calling them from the getter that resolves them is safe.
    private let lock = NSRecursiveLock()
    private var instances: [String: any Sendable] = [:]
    private var overrides: [String: () -> Any] = [:]
    private var resolving: [String] = []

    /// Creates an empty storage.
    public init() {}

    /// Stores a test override for the dependency `name` and drops its cached shared instance, so
    /// the next read uses the override.
    ///
    /// Generated code calls this from the `override(_:)` method of a container, with a closure
    /// that has the container's isolation. Call that method instead.
    public func _setOverride(for name: String, _ make: @escaping () -> Any) {
        lock.lock()
        defer { lock.unlock() }
        overrides[name] = make
        instances[name] = nil
    }

    /// The names of the dependencies that are being built on the calling thread, outermost first.
    var resolutionPath: [String] {
        lock.lock()
        defer { lock.unlock() }
        return resolving
    }

    func shared<Value: Sendable>(
        _ name: String,
        in container: String,
        make: () -> Value
    ) -> Value {
        lock.lock()
        defer { lock.unlock() }
        if let instance = instances[name] {
            return cast(instance, name: name, container: container)
        }
        let value = build(name, in: container, make: make)
        instances[name] = value
        return value
    }

    func transient<Value>(
        _ name: String,
        in container: String,
        make: () -> Value
    ) -> Value {
        lock.lock()
        defer { lock.unlock() }
        return build(name, in: container, make: make)
    }

    /// Builds one value with the override if there is one, else with `make`. Called with the lock
    /// held.
    private func build<Value>(_ name: String, in container: String, make: () -> Value) -> Value {
        if resolving.contains(name) {
            DependencyFailure.report(.cycle(path: resolving, repeating: name, container: container))
        }
        resolving.append(name)
        defer { resolving.removeLast() }
        guard let override = overrides[name] else { return make() }
        return cast(override(), name: name, container: container)
    }

    private func cast<Value>(_ value: Any, name: String, container: String) -> Value {
        guard let typed = value as? Value else {
            DependencyFailure.report(.typeMismatch(
                name: name,
                container: container,
                stored: String(describing: type(of: value)),
                requested: String(describing: Value.self)
            ))
        }
        return typed
    }
}
