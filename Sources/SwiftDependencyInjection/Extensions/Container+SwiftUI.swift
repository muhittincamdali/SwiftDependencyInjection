import SwiftUI

// MARK: - Environment Key

/// An environment key for injecting the DI container into SwiftUI views.
private struct DIContainerEnvironmentKey: EnvironmentKey {
    static let defaultValue: DIContainer = .shared
}

extension EnvironmentValues {

    /// The dependency injection container available in the environment.
    ///
    /// Access it inside any SwiftUI view via `@Environment`:
    /// ```swift
    /// @Environment(\.diContainer) var container
    /// ```
    public var diContainer: DIContainer {
        get { self[DIContainerEnvironmentKey.self] }
        set { self[DIContainerEnvironmentKey.self] = newValue }
    }
}

// MARK: - View Extension

extension View {

    /// Injects a ``DIContainer`` into the SwiftUI environment.
    ///
    /// ```swift
    /// ContentView()
    ///     .withDIContainer(DIContainer.shared)
    /// ```
    ///
    /// - Parameter container: The container to inject.
    /// - Returns: A view with the container in the environment.
    public func withDIContainer(_ container: DIContainer) -> some View {
        self
            .environment(\.diContainer, container)
            .environmentObject(container)
    }
}

// MARK: - Convenience View Modifier

/// A view modifier that provides the container to its content.
public struct DIContainerModifier: ViewModifier {

    /// The container to inject.
    let container: DIContainer

    public func body(content: Content) -> some View {
        content
            .environment(\.diContainer, container)
            .environmentObject(container)
    }
}
