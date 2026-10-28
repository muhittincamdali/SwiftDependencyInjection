import Foundation

/// The instances, test overrides and in-progress resolutions of one container.
///
/// `@DependencyContainer` adds one storage to each container, so each container instance is its
/// own scope: two containers never share a shared instance or an override. You do not call it
/// directly; ``DependencyContainer/shared(_:name:_:)`` and
/// ``DependencyContainer/transient(_:name:_:)`` use it.
///
/// Entries are keyed by the key path of the property, which fixes their type: the value stored
/// for `\.api` is always an `api` value.
///
/// One recursive lock guards everything. It is held while a dependency is built, so a shared
/// dependency is built exactly once even when many threads ask for it at the same time, and a
/// provider may read other dependencies of the same container. Because only the thread that holds
/// the lock can be building, a key that is already being built means the provider asked for
/// itself: a dependency cycle.
public final class DependencyStorage: @unchecked Sendable {
    // Invariant behind @unchecked Sendable: every stored property below is read and written only
    // while `lock` is held. Override closures are stored by generated code that gives them the
    // container's isolation (@Sendable for a nonisolated container, @MainActor for a main-actor
    // container), so calling them from the getter that resolves them is safe.
    private let lock = NSRecursiveLock()
    private var instances: [AnyKeyPath: Any] = [:]
    private var overrides: [AnyKeyPath: () -> Any] = [:]
    private var resolving: [(key: AnyKeyPath, name: String)] = []

    /// Creates an empty storage.
    public init() {}

    /// The names of the dependencies that are being built on the calling thread, outermost first.
    var resolutionPath: [String] {
        lock.lock()
        defer { lock.unlock() }
        return resolving.map(\.name)
    }

    func setOverride(_ make: @escaping () -> Any, for key: AnyKeyPath) {
        lock.lock()
        defer { lock.unlock() }
        overrides[key] = make
        instances[key] = nil
    }

    func shared<Value: Sendable>(
        _ key: AnyKeyPath,
        name: String,
        in container: String,
        make: () -> Value
    ) -> Value {
        lock.lock()
        defer { lock.unlock() }
        if let instance = instances[key] {
            return Self.cast(instance)
        }
        let value: Value = build(key, name: name, in: container, make: make)
        instances[key] = value
        return value
    }

    func transient<Value>(
        _ key: AnyKeyPath,
        name: String,
        in container: String,
        make: () -> Value
    ) -> Value {
        lock.lock()
        defer { lock.unlock() }
        return build(key, name: name, in: container, make: make)
    }

    /// Builds one value with the override if there is one, else with `make`. Called with the lock
    /// held.
    private func build<Value>(
        _ key: AnyKeyPath,
        name: String,
        in container: String,
        make: () -> Value
    ) -> Value {
        if resolving.contains(where: { $0.key == key }) {
            DependencyFailure.report(.cycle(path: resolving.map(\.name), repeating: name, container: container))
        }
        resolving.append((key, name))
        defer { resolving.removeLast() }
        guard let override = overrides[key] else { return make() }
        return Self.cast(override())
    }

    /// Entries are keyed by a `KeyPath<Container, Value>` and written only with a `Value` for
    /// that key path, so the cast cannot fail.
    private static func cast<Value>(_ value: Any) -> Value {
        // swiftlint:disable:next force_cast
        value as! Value
    }
}
