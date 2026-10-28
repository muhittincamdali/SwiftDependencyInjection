/// A programming error found while resolving a dependency.
///
/// A cycle is a mistake in the container's code, not a condition an app can recover from, so the
/// process stops with a message that names the container and the dependencies involved.
/// `@DependencyContainer` reports most cycles at compile time already; the run-time check catches
/// the ones it cannot see, such as a cycle through a method or a closure that runs at once.
enum DependencyFailure: Equatable {
    /// `repeating` was requested again while it was being built. `path` is the chain of
    /// dependencies being built at that moment, outermost first.
    case cycle(path: [String], repeating: String, container: String)

    var message: String {
        switch self {
        case let .cycle(path, repeating, container):
            let start = path.firstIndex(of: repeating) ?? path.startIndex
            let chain = (path[start...] + [repeating]).joined(separator: " → ")
            return "SwiftDependencyInjection: dependency cycle in \(container): \(chain). "
                + "A dependency cannot need itself while it is being built; pass one side a closure "
                + "that reads the other later, or move the shared part into its own dependency."
        }
    }

    static func report(_ failure: DependencyFailure) -> Never {
        fatalError(failure.message)
    }
}
