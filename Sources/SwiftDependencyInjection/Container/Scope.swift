import Foundation

/// Defines the lifetime of a registered service.
///
/// Scopes control how often a new instance is created when resolving
/// a dependency from the container.
///
/// ## Scope Types
///
/// | Scope | Behavior |
/// |-------|----------|
/// | ``singleton`` | Single shared instance for the container's lifetime |
/// | ``transient`` | New instance on every resolution |
/// | ``weak`` | Cached via weak reference; recreated if deallocated |
///
/// ## Example
/// ```swift
/// container.register(MyService.self, scope: .singleton) {
///     MyServiceImpl()
/// }
/// ```
public enum Scope: String, Sendable, CaseIterable {

    /// A single instance is created and reused for all resolutions.
    /// The container holds a strong reference.
    case singleton

    /// A new instance is created every time the service is resolved.
    /// No caching is performed.
    case transient

    /// The instance is cached with a weak reference. If all external
    /// strong references are released, the next resolution creates
    /// a fresh instance.
    case weak
}
