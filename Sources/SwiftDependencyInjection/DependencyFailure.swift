/// A programming error found while resolving a dependency.
///
/// Both cases are mistakes in the container's code, not conditions an app can recover from, so
/// the process stops with a message that names the container and the dependencies involved.
/// `@DependencyContainer` reports most cycles at compile time already; the run-time check catches
/// the ones it cannot see, such as a cycle through a method or another file.
enum DependencyFailure: Equatable {
    /// `repeating` was requested again while it was being built. `path` is the chain of
    /// dependencies being built at that moment, outermost first.
    case cycle(path: [String], repeating: String, container: String)

    /// A cached instance or an override returned a value of another type than the property.
    case typeMismatch(name: String, container: String, stored: String, requested: String)

    var message: String {
        switch self {
        case let .cycle(path, repeating, container):
            let start = path.firstIndex(of: repeating) ?? path.startIndex
            let chain = (path[start...] + [repeating]).joined(separator: " → ")
            return "SwiftDependencyInjection: dependency cycle in \(container): \(chain). "
                + "A dependency cannot need itself while it is being built; pass one side a closure "
                + "that reads the other later, or move the shared part into its own dependency."
        case let .typeMismatch(name, container, stored, requested):
            return "SwiftDependencyInjection: \(container).\(name) holds a \(stored), "
                + "but a \(requested) was requested. shared { } and transient { } use the "
                + "property name as the key, so call each of them only once, from the getter of "
                + "the property it builds."
        }
    }

    static func report(_ failure: DependencyFailure) -> Never {
        fatalError(failure.message)
    }
}
