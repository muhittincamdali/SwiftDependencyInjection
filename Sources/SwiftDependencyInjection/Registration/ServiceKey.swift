import Foundation

/// A composite key used to uniquely identify a service registration.
///
/// `ServiceKey` combines the metatype of the registered service with an
/// optional name string, allowing multiple registrations of the same
/// protocol under different names.
///
/// ## Example
/// ```swift
/// let key = ServiceKey(type: NetworkService.self, name: "v2")
/// ```
public struct ServiceKey: Hashable, Sendable {

    // MARK: - Properties

    /// String representation of the registered type.
    public let typeIdentifier: String

    /// Optional name qualifier to distinguish multiple registrations
    /// of the same type.
    public let name: String?

    // MARK: - Initialization

    /// Creates a new service key.
    /// - Parameters:
    ///   - type: The service type to register.
    ///   - name: An optional qualifier name.
    public init(type: Any.Type, name: String? = nil) {
        self.typeIdentifier = String(describing: type)
        self.name = name
    }

    // MARK: - Hashable

    public func hash(into hasher: inout Hasher) {
        hasher.combine(typeIdentifier)
        hasher.combine(name)
    }

    public static func == (lhs: ServiceKey, rhs: ServiceKey) -> Bool {
        lhs.typeIdentifier == rhs.typeIdentifier && lhs.name == rhs.name
    }
}
