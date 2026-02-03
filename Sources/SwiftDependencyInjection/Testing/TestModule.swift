//
//  TestModule.swift
//  SwiftDependencyInjection
//
//  Created by Muhittin Camdali on 2024.
//  Copyright © 2024 Muhittin Camdali. All rights reserved.
//

import Foundation

// MARK: - Test Module Protocol

/// Protocol for modules specifically designed for testing.
public protocol TestModule: AnyObject {
    /// The name of the test module.
    var moduleName: String { get }
    
    /// Sets up the module before tests.
    func setUp()
    
    /// Tears down the module after tests.
    func tearDown()
    
    /// Configures mock registrations.
    func configureMocks(in container: MockContainer)
    
    /// Configures test fixtures.
    func configureFixtures(in container: MockContainer)
}

/// Default implementations for TestModule.
public extension TestModule {
    func setUp() {
        // Default empty implementation
    }
    
    func tearDown() {
        // Default empty implementation
    }
    
    func configureFixtures(in container: MockContainer) {
        // Default empty implementation
    }
}

// MARK: - Test Module Builder

/// Builder for creating test modules with fluent syntax.
public final class TestModuleBuilder {
    
    // MARK: - Properties
    
    private var moduleName: String
    private var setUpActions: [() -> Void] = []
    private var tearDownActions: [() -> Void] = []
    private var mockRegistrations: [(MockContainer) -> Void] = []
    private var fixtureRegistrations: [(MockContainer) -> Void] = []
    
    // MARK: - Initialization
    
    /// Creates a test module builder.
    /// - Parameter name: The module name.
    public init(name: String) {
        self.moduleName = name
    }
    
    // MARK: - Configuration
    
    /// Adds a set up action.
    /// - Parameter action: The action to perform on set up.
    @discardableResult
    public func onSetUp(_ action: @escaping () -> Void) -> Self {
        setUpActions.append(action)
        return self
    }
    
    /// Adds a tear down action.
    /// - Parameter action: The action to perform on tear down.
    @discardableResult
    public func onTearDown(_ action: @escaping () -> Void) -> Self {
        tearDownActions.append(action)
        return self
    }
    
    /// Registers a mock.
    /// - Parameters:
    ///   - type: The type to mock.
    ///   - mock: The mock instance.
    @discardableResult
    public func mock<T>(_ type: T.Type, with mock: T) -> Self {
        mockRegistrations.append { container in
            container.registerMock(type, mock: mock)
        }
        return self
    }
    
    /// Registers a mock factory.
    /// - Parameters:
    ///   - type: The type to mock.
    ///   - factory: The factory to create mocks.
    @discardableResult
    public func mock<T>(_ type: T.Type, factory: @escaping () -> T) -> Self {
        mockRegistrations.append { container in
            container.registerMockFactory(type, factory: factory)
        }
        return self
    }
    
    /// Registers a fixture.
    /// - Parameters:
    ///   - type: The type for the fixture.
    ///   - fixture: The fixture instance.
    @discardableResult
    public func fixture<T>(_ type: T.Type, value fixture: T) -> Self {
        fixtureRegistrations.append { container in
            container.registerMock(type, mock: fixture)
        }
        return self
    }
    
    /// Builds the test module.
    /// - Returns: A configured test module.
    public func build() -> BuiltTestModule {
        BuiltTestModule(
            name: moduleName,
            setUpActions: setUpActions,
            tearDownActions: tearDownActions,
            mockRegistrations: mockRegistrations,
            fixtureRegistrations: fixtureRegistrations
        )
    }
}

// MARK: - Built Test Module

/// A test module built from a builder.
public final class BuiltTestModule: TestModule {
    
    // MARK: - Properties
    
    public let moduleName: String
    private let setUpActions: [() -> Void]
    private let tearDownActions: [() -> Void]
    private let mockRegistrations: [(MockContainer) -> Void]
    private let fixtureRegistrations: [(MockContainer) -> Void]
    
    // MARK: - Initialization
    
    init(
        name: String,
        setUpActions: [() -> Void],
        tearDownActions: [() -> Void],
        mockRegistrations: [(MockContainer) -> Void],
        fixtureRegistrations: [(MockContainer) -> Void]
    ) {
        self.moduleName = name
        self.setUpActions = setUpActions
        self.tearDownActions = tearDownActions
        self.mockRegistrations = mockRegistrations
        self.fixtureRegistrations = fixtureRegistrations
    }
    
    // MARK: - TestModule
    
    public func setUp() {
        for action in setUpActions {
            action()
        }
    }
    
    public func tearDown() {
        for action in tearDownActions {
            action()
        }
    }
    
    public func configureMocks(in container: MockContainer) {
        for registration in mockRegistrations {
            registration(container)
        }
    }
    
    public func configureFixtures(in container: MockContainer) {
        for registration in fixtureRegistrations {
            registration(container)
        }
    }
}

// MARK: - Test Container

/// A container specifically designed for testing.
///
/// Features:
/// - Built-in mock support
/// - Test module management
/// - Automatic cleanup
/// - Test fixture support
/// - Verification helpers
///
/// Example usage:
/// ```swift
/// class UserServiceTests: XCTestCase {
///     var container: TestContainer!
///
///     override func setUp() {
///         container = TestContainer()
///         container.registerModule(UserTestModule())
///     }
///
///     override func tearDown() {
///         container.reset()
///     }
///
///     func testGetUser() {
///         let service: UserService = try! container.resolve()
///         // Test...
///     }
/// }
/// ```
public final class TestContainer {
    
    // MARK: - Properties
    
    /// The underlying mock container.
    public let mockContainer: MockContainer
    
    /// Registered test modules.
    private var modules: [String: TestModule] = [:]
    
    /// Test fixtures.
    private var fixtures: [ObjectIdentifier: Any] = [:]
    
    /// Lock for thread safety.
    private let lock = NSRecursiveLock()
    
    /// Test context for current test.
    private var testContext: TestContext?
    
    // MARK: - Initialization
    
    /// Creates a new test container.
    public init() {
        self.mockContainer = MockContainer()
    }
    
    /// Creates a test container with a configuration.
    /// - Parameter configuration: The mock container configuration.
    public init(configuration: MockContainerConfiguration) {
        self.mockContainer = MockContainer(configuration: configuration)
    }
    
    // MARK: - Module Management
    
    /// Registers a test module.
    /// - Parameter module: The module to register.
    public func registerModule(_ module: TestModule) {
        lock.lock()
        defer { lock.unlock() }
        
        modules[module.moduleName] = module
        module.configureMocks(in: mockContainer)
        module.configureFixtures(in: mockContainer)
    }
    
    /// Registers multiple test modules.
    /// - Parameter modules: The modules to register.
    public func registerModules(_ modules: [TestModule]) {
        for module in modules {
            registerModule(module)
        }
    }
    
    /// Removes a test module.
    /// - Parameter name: The module name.
    public func removeModule(_ name: String) {
        lock.lock()
        defer { lock.unlock() }
        
        if let module = modules.removeValue(forKey: name) {
            module.tearDown()
        }
    }
    
    /// Gets a registered module.
    /// - Parameter name: The module name.
    /// - Returns: The module, or nil if not found.
    public func module(_ name: String) -> TestModule? {
        lock.lock()
        defer { lock.unlock() }
        return modules[name]
    }
    
    // MARK: - Mock Registration
    
    /// Registers a mock.
    /// - Parameters:
    ///   - type: The type to mock.
    ///   - mock: The mock instance.
    public func registerMock<T>(_ type: T.Type, mock: T) {
        mockContainer.registerMock(type, mock: mock)
    }
    
    /// Registers a mock factory.
    /// - Parameters:
    ///   - type: The type to mock.
    ///   - factory: The factory for creating mocks.
    public func registerMockFactory<T>(_ type: T.Type, factory: @escaping () -> T) {
        mockContainer.registerMockFactory(type, factory: factory)
    }
    
    // MARK: - Fixture Management
    
    /// Registers a test fixture.
    /// - Parameters:
    ///   - type: The type for the fixture.
    ///   - fixture: The fixture instance.
    public func registerFixture<T>(_ type: T.Type, fixture: T) {
        lock.lock()
        defer { lock.unlock() }
        
        let key = ObjectIdentifier(type)
        fixtures[key] = fixture
        mockContainer.registerMock(type, mock: fixture)
    }
    
    /// Gets a test fixture.
    /// - Parameter type: The type to get.
    /// - Returns: The fixture, or nil if not found.
    public func fixture<T>(_ type: T.Type) -> T? {
        lock.lock()
        defer { lock.unlock() }
        
        let key = ObjectIdentifier(type)
        return fixtures[key] as? T
    }
    
    // MARK: - Resolution
    
    /// Resolves a dependency.
    /// - Parameter type: The type to resolve.
    /// - Returns: The resolved instance.
    /// - Throws: If resolution fails.
    public func resolve<T>(_ type: T.Type) throws -> T {
        try mockContainer.resolve(type)
    }
    
    /// Resolves an optional dependency.
    /// - Parameter type: The type to resolve.
    /// - Returns: The resolved instance, or nil.
    public func resolveOptional<T>(_ type: T.Type) -> T? {
        mockContainer.resolveOptional(type)
    }
    
    // MARK: - Test Lifecycle
    
    /// Sets up all registered modules.
    public func setUpModules() {
        lock.lock()
        defer { lock.unlock() }
        
        for module in modules.values {
            module.setUp()
        }
    }
    
    /// Tears down all registered modules.
    public func tearDownModules() {
        lock.lock()
        defer { lock.unlock() }
        
        for module in modules.values {
            module.tearDown()
        }
    }
    
    /// Resets the container to initial state.
    public func reset() {
        lock.lock()
        defer { lock.unlock() }
        
        tearDownModules()
        mockContainer.clearAllMocks()
        mockContainer.clearHistory()
        fixtures.removeAll()
        testContext = nil
    }
    
    /// Begins a test context.
    /// - Parameter name: The test name.
    public func beginTest(_ name: String) {
        testContext = TestContext(name: name)
        setUpModules()
    }
    
    /// Ends the current test context.
    public func endTest() {
        tearDownModules()
        testContext = nil
    }
    
    // MARK: - Verification
    
    /// Verifies mock expectations.
    /// - Parameter expectations: The verification closure.
    public func verify(_ expectations: (MockVerifier) throws -> Void) rethrows {
        try mockContainer.verify(expectations)
    }
    
    /// Verifies that a type was resolved.
    /// - Parameter type: The type to verify.
    /// - Returns: `true` if the type was resolved.
    public func wasResolved<T>(_ type: T.Type) -> Bool {
        mockContainer.wasResolved(type)
    }
}

// MARK: - Test Context

/// Context for a test execution.
public struct TestContext {
    /// The test name.
    public let name: String
    
    /// The start time.
    public let startTime: Date
    
    /// Custom metadata.
    public var metadata: [String: Any] = [:]
    
    init(name: String) {
        self.name = name
        self.startTime = Date()
    }
}

// MARK: - Common Test Modules

/// A test module for network mocking.
public final class NetworkTestModule: TestModule {
    public let moduleName = "Network"
    
    /// Mock responses.
    public var mockResponses: [String: Any] = [:]
    
    public init() {}
    
    public func configureMocks(in container: MockContainer) {
        // Register network-related mocks
    }
    
    /// Configures a mock response for a URL.
    /// - Parameters:
    ///   - url: The URL pattern.
    ///   - response: The mock response.
    public func mockResponse(for url: String, response: Any) {
        mockResponses[url] = response
    }
}

/// A test module for database mocking.
public final class DatabaseTestModule: TestModule {
    public let moduleName = "Database"
    
    /// In-memory data store.
    public var dataStore: [String: [Any]] = [:]
    
    public init() {}
    
    public func setUp() {
        dataStore.removeAll()
    }
    
    public func tearDown() {
        dataStore.removeAll()
    }
    
    public func configureMocks(in container: MockContainer) {
        // Register database-related mocks
    }
    
    /// Seeds data into the mock database.
    /// - Parameters:
    ///   - table: The table name.
    ///   - data: The data to seed.
    public func seed(_ table: String, with data: [Any]) {
        dataStore[table] = data
    }
}

/// A test module for authentication mocking.
public final class AuthTestModule: TestModule {
    public let moduleName = "Auth"
    
    /// Mock authenticated user.
    public var authenticatedUser: Any?
    
    /// Whether the user is authenticated.
    public var isAuthenticated: Bool = false
    
    public init() {}
    
    public func setUp() {
        isAuthenticated = false
        authenticatedUser = nil
    }
    
    public func configureMocks(in container: MockContainer) {
        // Register auth-related mocks
    }
    
    /// Simulates a logged-in user.
    /// - Parameter user: The mock user.
    public func mockLoggedInUser(_ user: Any) {
        authenticatedUser = user
        isAuthenticated = true
    }
    
    /// Simulates a logged-out state.
    public func mockLoggedOut() {
        authenticatedUser = nil
        isAuthenticated = false
    }
}

// MARK: - Test Helpers

/// Helper for setting up test dependencies.
public final class TestDependencyHelper {
    
    /// Creates a pre-configured test container with common modules.
    /// - Returns: A configured test container.
    public static func createStandardContainer() -> TestContainer {
        let container = TestContainer()
        container.registerModules([
            NetworkTestModule(),
            DatabaseTestModule(),
            AuthTestModule()
        ])
        return container
    }
    
    /// Configures a container with a closure.
    /// - Parameters:
    ///   - container: The container to configure.
    ///   - configure: The configuration closure.
    public static func configure(
        _ container: TestContainer,
        with configure: (TestContainer) -> Void
    ) {
        configure(container)
    }
}

// MARK: - Extensions

extension TestContainer {
    /// Subscript for type-based resolution.
    public subscript<T>(_ type: T.Type) -> T? {
        try? resolve(type)
    }
    
    /// Creates a test container using builder pattern.
    public static func build(_ configure: (TestModuleBuilder) -> Void) -> TestContainer {
        let container = TestContainer()
        let builder = TestModuleBuilder(name: "Test")
        configure(builder)
        container.registerModule(builder.build())
        return container
    }
}

// MARK: - Async Test Support

@available(iOS 13.0, macOS 10.15, *)
extension TestContainer {
    /// Resolves a dependency asynchronously.
    /// - Parameter type: The type to resolve.
    /// - Returns: The resolved instance.
    public func resolveAsync<T>(_ type: T.Type) async throws -> T {
        try resolve(type)
    }
    
    /// Runs a test with async setup and teardown.
    /// - Parameters:
    ///   - name: The test name.
    ///   - test: The async test closure.
    public func runAsyncTest(
        _ name: String,
        test: (TestContainer) async throws -> Void
    ) async throws {
        beginTest(name)
        defer { endTest() }
        try await test(self)
    }
}
