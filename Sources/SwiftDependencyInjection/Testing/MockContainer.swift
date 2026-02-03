import Foundation

/// A mock container for unit testing that tracks resolution calls.
///
/// Use this in tests to verify that dependencies are resolved correctly
/// and to inject test doubles.
///
/// ```swift
/// let mock = MockContainer()
/// mock.register(UserService.self) { _ in MockUserService() }
///
/// let service = mock.resolve(UserService.self)
/// XCTAssertTrue(mock.wasResolved(UserService.self))
/// ```
public final class MockContainer: Resolver {

    // MARK: - Properties

    private let container = Container()
    private var resolutionLog: [String] = []
    private var resolutionCounts: [String: Int] = [:]

    // MARK: - Initialization

    public init() {}

    // MARK: - Registration

    /// Registers a mock service.
    @discardableResult
    public func register<T>(
        _ type: T.Type,
        scope: Scope = .transient,
        factory: @escaping (Resolver) -> T
    ) -> Registration<T> {
        container.register(type, scope: scope, factory: factory)
    }

    // MARK: - Resolution

    public func resolve<T>(_ type: T.Type) -> T {
        let key = String(describing: type)
        resolutionLog.append(key)
        resolutionCounts[key, default: 0] += 1
        return container.resolve(type)
    }

    public func resolve<T>(_ type: T.Type, name: String) -> T {
        let key = "\(String(describing: type))_\(name)"
        resolutionLog.append(key)
        resolutionCounts[key, default: 0] += 1
        return container.resolve(type, name: name)
    }

    public func resolveOptional<T>(_ type: T.Type) -> T? {
        let key = String(describing: type)
        resolutionLog.append(key)
        resolutionCounts[key, default: 0] += 1
        return container.resolveOptional(type)
    }

    // MARK: - Verification

    /// Checks if a type was ever resolved.
    public func wasResolved<T>(_ type: T.Type) -> Bool {
        let key = String(describing: type)
        return resolutionLog.contains(key)
    }

    /// Returns how many times a type was resolved.
    public func resolutionCount<T>(for type: T.Type) -> Int {
        let key = String(describing: type)
        return resolutionCounts[key] ?? 0
    }

    /// Returns the full resolution log in order.
    public var log: [String] { resolutionLog }

    /// Resets all tracking data.
    public func reset() {
        resolutionLog.removeAll()
        resolutionCounts.removeAll()
        container.removeAll()
    }
}
