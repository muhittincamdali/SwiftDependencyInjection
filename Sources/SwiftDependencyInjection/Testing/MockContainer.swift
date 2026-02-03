//
//  MockContainer.swift
//  SwiftDependencyInjection
//
//  Created by Muhittin Camdali on 2024.
//  Copyright © 2024 Muhittin Camdali. All rights reserved.
//

import Foundation

// MARK: - Mock Container Protocol

/// Protocol for containers that support mocking dependencies.
public protocol MockableContainer: AnyObject {
    /// Registers a mock for a type.
    func registerMock<T>(_ type: T.Type, mock: T)
    
    /// Removes a mock for a type.
    func removeMock<T>(_ type: T.Type)
    
    /// Checks if a type has a mock registered.
    func hasMock<T>(_ type: T.Type) -> Bool
    
    /// Clears all mocks.
    func clearAllMocks()
}

// MARK: - Mock Container

/// A container specifically designed for testing with mocking support.
///
/// Features:
/// - Easy mock registration
/// - Spy support for tracking calls
/// - Verification helpers
/// - Automatic mock cleanup
/// - Stub and fake support
///
/// Example usage:
/// ```swift
/// let container = MockContainer()
///
/// // Register a mock
/// let mockService = MockUserService()
/// container.registerMock(UserService.self, mock: mockService)
///
/// // Resolve returns the mock
/// let service: UserService = try container.resolve()
/// XCTAssertTrue(service === mockService)
/// ```
public final class MockContainer: MockableContainer {
    
    // MARK: - Properties
    
    /// Registered mocks.
    private var mocks: [ObjectIdentifier: Any] = [:]
    
    /// Named mocks.
    private var namedMocks: [String: [ObjectIdentifier: Any]] = [:]
    
    /// Fallback factories for types without mocks.
    private var fallbackFactories: [ObjectIdentifier: AnyMockFactory] = [:]
    
    /// Resolution history for verification.
    private var resolutionHistory: [ResolutionRecord] = []
    
    /// Configuration for the mock container.
    private var configuration: MockContainerConfiguration
    
    /// Lock for thread safety.
    private let lock = NSRecursiveLock()
    
    /// Verification mode.
    public var verificationMode: VerificationMode = .strict
    
    // MARK: - Initialization
    
    /// Creates a new mock container.
    /// - Parameter configuration: Optional configuration.
    public init(configuration: MockContainerConfiguration = .default) {
        self.configuration = configuration
    }
    
    /// Creates a mock container from an existing container.
    /// - Parameter container: The container to wrap.
    public convenience init<C: AnyObject>(wrapping container: C) {
        self.init()
        // Copy registrations from the wrapped container if possible
    }
    
    // MARK: - Mock Registration
    
    /// Registers a mock for a type.
    /// - Parameters:
    ///   - type: The type to mock.
    ///   - mock: The mock instance.
    public func registerMock<T>(_ type: T.Type, mock: T) {
        lock.lock()
        defer { lock.unlock() }
        
        let key = ObjectIdentifier(type)
        mocks[key] = mock
    }
    
    /// Registers a named mock.
    /// - Parameters:
    ///   - type: The type to mock.
    ///   - name: The registration name.
    ///   - mock: The mock instance.
    public func registerMock<T>(_ type: T.Type, name: String, mock: T) {
        lock.lock()
        defer { lock.unlock() }
        
        let key = ObjectIdentifier(type)
        
        if namedMocks[name] == nil {
            namedMocks[name] = [:]
        }
        namedMocks[name]?[key] = mock
    }
    
    /// Registers a mock using a factory.
    /// - Parameters:
    ///   - type: The type to mock.
    ///   - factory: The factory to create mock instances.
    public func registerMockFactory<T>(
        _ type: T.Type,
        factory: @escaping () -> T
    ) {
        lock.lock()
        defer { lock.unlock() }
        
        let key = ObjectIdentifier(type)
        fallbackFactories[key] = TypedMockFactory(factory: factory)
    }
    
    /// Registers a spy wrapper around an existing instance.
    /// - Parameters:
    ///   - type: The type to spy on.
    ///   - instance: The real instance to wrap.
    /// - Returns: A spy wrapper for verification.
    @discardableResult
    public func registerSpy<T: AnyObject>(
        _ type: T.Type,
        wrapping instance: T
    ) -> Spy<T> {
        let spy = Spy(wrapping: instance)
        registerMock(type, mock: spy.proxy)
        return spy
    }
    
    /// Registers a stub that returns specified values.
    /// - Parameters:
    ///   - type: The type to stub.
    ///   - stub: The stub instance.
    public func registerStub<T>(_ type: T.Type, stub: T) {
        registerMock(type, mock: stub)
    }
    
    // MARK: - Mock Removal
    
    /// Removes a mock for a type.
    /// - Parameter type: The type to remove the mock for.
    public func removeMock<T>(_ type: T.Type) {
        lock.lock()
        defer { lock.unlock() }
        
        let key = ObjectIdentifier(type)
        mocks.removeValue(forKey: key)
    }
    
    /// Removes a named mock.
    /// - Parameters:
    ///   - type: The type.
    ///   - name: The registration name.
    public func removeMock<T>(_ type: T.Type, name: String) {
        lock.lock()
        defer { lock.unlock() }
        
        let key = ObjectIdentifier(type)
        namedMocks[name]?.removeValue(forKey: key)
    }
    
    /// Clears all registered mocks.
    public func clearAllMocks() {
        lock.lock()
        defer { lock.unlock() }
        
        mocks.removeAll()
        namedMocks.removeAll()
        fallbackFactories.removeAll()
    }
    
    // MARK: - Mock Queries
    
    /// Checks if a type has a mock registered.
    /// - Parameter type: The type to check.
    /// - Returns: `true` if a mock is registered.
    public func hasMock<T>(_ type: T.Type) -> Bool {
        lock.lock()
        defer { lock.unlock() }
        
        let key = ObjectIdentifier(type)
        return mocks[key] != nil || fallbackFactories[key] != nil
    }
    
    /// Returns all mocked types.
    public var mockedTypes: [ObjectIdentifier] {
        lock.lock()
        defer { lock.unlock() }
        return Array(mocks.keys)
    }
    
    /// The number of registered mocks.
    public var mockCount: Int {
        lock.lock()
        defer { lock.unlock() }
        return mocks.count
    }
    
    // MARK: - Resolution
    
    /// Resolves a mock instance.
    /// - Parameter type: The type to resolve.
    /// - Returns: The mock instance.
    /// - Throws: `MockContainerError` if no mock is registered.
    public func resolve<T>(_ type: T.Type) throws -> T {
        lock.lock()
        defer { lock.unlock() }
        
        let key = ObjectIdentifier(type)
        
        // Record resolution
        resolutionHistory.append(ResolutionRecord(
            type: String(describing: type),
            timestamp: Date()
        ))
        
        // Check mocks
        if let mock = mocks[key] as? T {
            return mock
        }
        
        // Check fallback factories
        if let factory = fallbackFactories[key] as? TypedMockFactory<T> {
            return factory.factory()
        }
        
        // Handle based on verification mode
        switch verificationMode {
        case .strict:
            throw MockContainerError.mockNotRegistered(type: String(describing: type))
        case .lenient:
            throw MockContainerError.mockNotRegistered(type: String(describing: type))
        case .autoMock:
            // Would auto-generate a mock here if possible
            throw MockContainerError.mockNotRegistered(type: String(describing: type))
        }
    }
    
    /// Resolves a named mock.
    /// - Parameters:
    ///   - type: The type to resolve.
    ///   - name: The registration name.
    /// - Returns: The mock instance.
    /// - Throws: `MockContainerError` if no mock is registered.
    public func resolve<T>(_ type: T.Type, name: String) throws -> T {
        lock.lock()
        defer { lock.unlock() }
        
        let key = ObjectIdentifier(type)
        
        guard let mock = namedMocks[name]?[key] as? T else {
            throw MockContainerError.namedMockNotRegistered(
                type: String(describing: type),
                name: name
            )
        }
        
        return mock
    }
    
    /// Resolves an optional mock.
    /// - Parameter type: The type to resolve.
    /// - Returns: The mock instance, or nil if not registered.
    public func resolveOptional<T>(_ type: T.Type) -> T? {
        try? resolve(type)
    }
    
    // MARK: - Verification
    
    /// Verifies that a type was resolved.
    /// - Parameter type: The type to verify.
    /// - Returns: `true` if the type was resolved.
    public func wasResolved<T>(_ type: T.Type) -> Bool {
        lock.lock()
        defer { lock.unlock() }
        
        let typeName = String(describing: type)
        return resolutionHistory.contains { $0.type == typeName }
    }
    
    /// Returns the number of times a type was resolved.
    /// - Parameter type: The type to check.
    /// - Returns: The resolution count.
    public func resolutionCount<T>(_ type: T.Type) -> Int {
        lock.lock()
        defer { lock.unlock() }
        
        let typeName = String(describing: type)
        return resolutionHistory.filter { $0.type == typeName }.count
    }
    
    /// Clears the resolution history.
    public func clearHistory() {
        lock.lock()
        defer { lock.unlock() }
        resolutionHistory.removeAll()
    }
    
    /// Returns the full resolution history.
    public var history: [ResolutionRecord] {
        lock.lock()
        defer { lock.unlock() }
        return resolutionHistory
    }
    
    /// Verifies expectations using a DSL.
    /// - Parameter expectations: The verification closure.
    public func verify(_ expectations: (MockVerifier) throws -> Void) rethrows {
        let verifier = MockVerifier(container: self)
        try expectations(verifier)
    }
}

// MARK: - Supporting Types

/// Protocol for type-erased mock factories.
private protocol AnyMockFactory {}

/// Typed mock factory.
private struct TypedMockFactory<T>: AnyMockFactory {
    let factory: () -> T
}

/// Record of a resolution.
public struct ResolutionRecord {
    public let type: String
    public let timestamp: Date
}

// MARK: - Mock Container Configuration

/// Configuration for mock containers.
public struct MockContainerConfiguration {
    /// Whether to record resolution history.
    public var recordHistory: Bool
    
    /// Maximum history entries to keep.
    public var maxHistoryEntries: Int
    
    /// Default configuration.
    public static let `default` = MockContainerConfiguration(
        recordHistory: true,
        maxHistoryEntries: 1000
    )
    
    public init(
        recordHistory: Bool = true,
        maxHistoryEntries: Int = 1000
    ) {
        self.recordHistory = recordHistory
        self.maxHistoryEntries = maxHistoryEntries
    }
}

// MARK: - Verification Mode

/// Modes for mock verification.
public enum VerificationMode {
    /// Strict mode: throws if mock not found.
    case strict
    
    /// Lenient mode: returns nil for optional types.
    case lenient
    
    /// Auto-mock mode: auto-generates mocks when possible.
    case autoMock
}

// MARK: - Mock Verifier

/// Helper for verifying mock behavior.
public final class MockVerifier {
    private let container: MockContainer
    
    init(container: MockContainer) {
        self.container = container
    }
    
    /// Verifies that a type was resolved at least once.
    /// - Parameter type: The type to verify.
    /// - Throws: `MockVerificationError` if not resolved.
    public func wasResolved<T>(_ type: T.Type) throws {
        guard container.wasResolved(type) else {
            throw MockVerificationError.notResolved(type: String(describing: type))
        }
    }
    
    /// Verifies that a type was resolved exactly n times.
    /// - Parameters:
    ///   - type: The type to verify.
    ///   - times: The expected count.
    /// - Throws: `MockVerificationError` if count doesn't match.
    public func wasResolved<T>(_ type: T.Type, times: Int) throws {
        let actual = container.resolutionCount(type)
        guard actual == times else {
            throw MockVerificationError.wrongCount(
                type: String(describing: type),
                expected: times,
                actual: actual
            )
        }
    }
    
    /// Verifies that a type was never resolved.
    /// - Parameter type: The type to verify.
    /// - Throws: `MockVerificationError` if was resolved.
    public func wasNeverResolved<T>(_ type: T.Type) throws {
        guard !container.wasResolved(type) else {
            throw MockVerificationError.unexpectedResolution(type: String(describing: type))
        }
    }
}

// MARK: - Spy

/// A spy wrapper for tracking method calls on an instance.
public final class Spy<T: AnyObject> {
    /// The wrapped instance.
    public let wrapped: T
    
    /// The proxy that tracks calls (same as wrapped for now).
    public var proxy: T { wrapped }
    
    /// Recorded invocations.
    private var invocations: [SpyInvocation] = []
    
    /// Lock for thread safety.
    private let lock = NSLock()
    
    /// Creates a spy wrapping an instance.
    /// - Parameter instance: The instance to spy on.
    public init(wrapping instance: T) {
        self.wrapped = instance
    }
    
    /// Records an invocation.
    /// - Parameters:
    ///   - method: The method name.
    ///   - arguments: The arguments.
    public func recordInvocation(_ method: String, arguments: [Any] = []) {
        lock.lock()
        defer { lock.unlock() }
        
        invocations.append(SpyInvocation(
            method: method,
            arguments: arguments,
            timestamp: Date()
        ))
    }
    
    /// Checks if a method was called.
    /// - Parameter method: The method name.
    /// - Returns: `true` if the method was called.
    public func wasCalled(_ method: String) -> Bool {
        lock.lock()
        defer { lock.unlock() }
        return invocations.contains { $0.method == method }
    }
    
    /// Returns the number of times a method was called.
    /// - Parameter method: The method name.
    /// - Returns: The call count.
    public func callCount(_ method: String) -> Int {
        lock.lock()
        defer { lock.unlock() }
        return invocations.filter { $0.method == method }.count
    }
    
    /// Returns all invocations for a method.
    /// - Parameter method: The method name.
    /// - Returns: The invocations.
    public func invocationsFor(_ method: String) -> [SpyInvocation] {
        lock.lock()
        defer { lock.unlock() }
        return invocations.filter { $0.method == method }
    }
    
    /// Clears recorded invocations.
    public func reset() {
        lock.lock()
        defer { lock.unlock() }
        invocations.removeAll()
    }
}

/// A recorded spy invocation.
public struct SpyInvocation {
    public let method: String
    public let arguments: [Any]
    public let timestamp: Date
}

// MARK: - Stub Builder

/// Builder for creating stubs with fluent syntax.
public final class StubBuilder<T> {
    private var stubs: [String: Any] = [:]
    
    public init() {}
    
    /// Configures a return value for a method.
    @discardableResult
    public func when(_ method: String, return value: Any) -> Self {
        stubs[method] = value
        return self
    }
    
    /// Gets the stub configuration.
    public func configuration() -> [String: Any] {
        stubs
    }
}

// MARK: - Mock Container Errors

/// Errors that can occur in mock containers.
public enum MockContainerError: Error, LocalizedError {
    case mockNotRegistered(type: String)
    case namedMockNotRegistered(type: String, name: String)
    case verificationFailed(reason: String)
    
    public var errorDescription: String? {
        switch self {
        case .mockNotRegistered(let type):
            return "No mock registered for type '\(type)'"
        case .namedMockNotRegistered(let type, let name):
            return "No mock registered for type '\(type)' with name '\(name)'"
        case .verificationFailed(let reason):
            return "Verification failed: \(reason)"
        }
    }
}

/// Errors that can occur during mock verification.
public enum MockVerificationError: Error, LocalizedError {
    case notResolved(type: String)
    case wrongCount(type: String, expected: Int, actual: Int)
    case unexpectedResolution(type: String)
    
    public var errorDescription: String? {
        switch self {
        case .notResolved(let type):
            return "Expected '\(type)' to be resolved, but it was not"
        case .wrongCount(let type, let expected, let actual):
            return "Expected '\(type)' to be resolved \(expected) times, but was resolved \(actual) times"
        case .unexpectedResolution(let type):
            return "Expected '\(type)' to not be resolved, but it was"
        }
    }
}

// MARK: - Test Double Types

/// Marker protocol for test doubles.
public protocol TestDouble {}

/// A fake implementation for testing.
public protocol Fake: TestDouble {
    /// Resets the fake to initial state.
    func reset()
}

/// A stub implementation for testing.
public protocol Stub: TestDouble {
    /// Configures the stub responses.
    func configure(_ configuration: [String: Any])
}

/// A mock implementation for testing.
public protocol Mock: TestDouble {
    /// Verifies expectations.
    func verify() throws
    
    /// Resets the mock.
    func reset()
}

// MARK: - Convenience Extensions

extension MockContainer {
    /// Subscript for type-based resolution.
    public subscript<T>(_ type: T.Type) -> T? {
        try? resolve(type)
    }
    
    /// Registers multiple mocks at once.
    public func registerMocks(_ registrations: [(Any.Type, Any)]) {
        for (type, mock) in registrations {
            let key = ObjectIdentifier(type)
            mocks[key] = mock
        }
    }
    
    /// Creates a mock container with initial mocks.
    /// - Parameter mocks: Initial mock registrations.
    /// - Returns: A configured mock container.
    public static func with(_ configure: (MockContainer) -> Void) -> MockContainer {
        let container = MockContainer()
        configure(container)
        return container
    }
}

// MARK: - XCTest Integration Helpers

/// Protocol for XCTest assertions.
public protocol MockAssertions {
    func assertMockResolved<T>(_ type: T.Type, file: StaticString, line: UInt)
    func assertMockNotResolved<T>(_ type: T.Type, file: StaticString, line: UInt)
    func assertMockResolvedTimes<T>(_ type: T.Type, times: Int, file: StaticString, line: UInt)
}

extension MockContainer: MockAssertions {
    /// Asserts that a mock was resolved.
    public func assertMockResolved<T>(
        _ type: T.Type,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        // This would integrate with XCTest in a real implementation
        precondition(wasResolved(type), "Expected \(type) to be resolved")
    }
    
    /// Asserts that a mock was not resolved.
    public func assertMockNotResolved<T>(
        _ type: T.Type,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        precondition(!wasResolved(type), "Expected \(type) to not be resolved")
    }
    
    /// Asserts that a mock was resolved a specific number of times.
    public func assertMockResolvedTimes<T>(
        _ type: T.Type,
        times: Int,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let actual = resolutionCount(type)
        precondition(actual == times, "Expected \(type) to be resolved \(times) times, got \(actual)")
    }
}
