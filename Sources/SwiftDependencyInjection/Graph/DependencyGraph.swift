import Foundation

/// Tracks the resolution stack to detect circular dependencies.
///
/// `DependencyGraph` maintains a per-thread stack of service keys
/// currently being resolved. If a key appears twice in the stack,
/// a circular dependency is detected.
///
/// ## How It Works
/// When ``DIContainer`` begins resolving a service, it pushes
/// the key onto the graph. If the same key is already in the stack,
/// `hasCircularDependency(for:)` returns `true`. After resolution
/// completes, the key is popped.
final class DependencyGraph {

    // MARK: - Properties

    /// Thread-local resolution stack storage.
    private let lock = NSRecursiveLock()

    /// Current resolution stack (array of keys being resolved).
    private var resolutionStack: [ServiceKey] = []

    /// Set for O(1) circular dependency checks.
    private var resolutionSet: Set<ServiceKey> = []

    // MARK: - Stack Operations

    /// Pushes a service key onto the resolution stack.
    /// - Parameter key: The key being resolved.
    func pushResolution(for key: ServiceKey) {
        lock.lock()
        resolutionStack.append(key)
        resolutionSet.insert(key)
        lock.unlock()
    }

    /// Pops a service key from the resolution stack.
    /// - Parameter key: The key that finished resolving.
    func popResolution(for key: ServiceKey) {
        lock.lock()
        if let index = resolutionStack.lastIndex(where: { $0 == key }) {
            resolutionStack.remove(at: index)
        }
        // Only remove from set if no other occurrence exists
        if !resolutionStack.contains(key) {
            resolutionSet.remove(key)
        }
        lock.unlock()
    }

    /// Checks whether resolving the given key would create a cycle.
    ///
    /// - Parameter key: The key to check.
    /// - Returns: `true` if the key already exists in the resolution stack
    ///   (indicating a circular dependency).
    func hasCircularDependency(for key: ServiceKey) -> Bool {
        lock.lock()
        // Count occurrences — if more than one, we have a cycle
        let count = resolutionStack.filter { $0 == key }.count
        lock.unlock()
        return count > 1
    }

    /// Returns the current resolution path for debugging.
    /// - Returns: An array of type identifiers in resolution order.
    func currentResolutionPath() -> [String] {
        lock.lock()
        let path = resolutionStack.map { $0.typeIdentifier }
        lock.unlock()
        return path
    }

    /// Resets the resolution stack. Useful in tests.
    func reset() {
        lock.lock()
        resolutionStack.removeAll()
        resolutionSet.removeAll()
        lock.unlock()
    }
}
