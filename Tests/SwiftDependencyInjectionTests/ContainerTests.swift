import XCTest
@testable import SwiftDependencyInjection

// MARK: - Test Protocols & Types

protocol TestService {
    var identifier: String { get }
}

final class MockTestService: TestService {
    let identifier: String

    init(identifier: String = "default") {
        self.identifier = identifier
    }
}

protocol DependentService {
    var dependency: TestService { get }
}

final class MockDependentService: DependentService {
    let dependency: TestService

    init(dependency: TestService) {
        self.dependency = dependency
    }
}

// MARK: - Container Tests

final class ContainerTests: XCTestCase {

    private var container: DIContainer!

    override func setUp() {
        super.setUp()
        container = DIContainer()
    }

    override func tearDown() {
        container.reset()
        container = nil
        super.tearDown()
    }

    // MARK: - Registration & Resolution

    func testRegisterAndResolve() {
        container.register(TestService.self) {
            MockTestService()
        }

        let service = container.resolve(TestService.self)
        XCTAssertEqual(service.identifier, "default")
    }

    func testNamedRegistration() {
        container.register(TestService.self, name: "primary") {
            MockTestService(identifier: "primary")
        }
        container.register(TestService.self, name: "secondary") {
            MockTestService(identifier: "secondary")
        }

        let primary = container.resolve(TestService.self, name: "primary")
        let secondary = container.resolve(TestService.self, name: "secondary")

        XCTAssertEqual(primary.identifier, "primary")
        XCTAssertEqual(secondary.identifier, "secondary")
    }

    func testResolveWithDependency() {
        container.register(TestService.self, scope: .singleton) {
            MockTestService(identifier: "injected")
        }
        container.register(DependentService.self) { resolver in
            MockDependentService(dependency: resolver.resolve(TestService.self))
        }

        let service = container.resolve(DependentService.self)
        XCTAssertEqual(service.dependency.identifier, "injected")
    }

    // MARK: - Scopes

    func testSingletonScope() {
        container.register(TestService.self, scope: .singleton) {
            MockTestService(identifier: UUID().uuidString)
        }

        let first = container.resolve(TestService.self)
        let second = container.resolve(TestService.self)

        XCTAssertEqual(first.identifier, second.identifier)
    }

    func testTransientScope() {
        container.register(TestService.self, scope: .transient) {
            MockTestService(identifier: UUID().uuidString)
        }

        let first = container.resolve(TestService.self)
        let second = container.resolve(TestService.self)

        XCTAssertNotEqual(first.identifier, second.identifier)
    }

    // MARK: - Optional Resolution

    func testOptionalResolveReturnsNil() {
        let result = container.resolveOptional(TestService.self)
        XCTAssertNil(result)
    }

    func testOptionalResolveReturnsInstance() {
        container.register(TestService.self) {
            MockTestService()
        }

        let result = container.resolveOptional(TestService.self)
        XCTAssertNotNil(result)
    }

    // MARK: - Container Management

    func testRegistrationCount() {
        XCTAssertEqual(container.registrationCount, 0)

        container.register(TestService.self) { MockTestService() }
        XCTAssertEqual(container.registrationCount, 1)

        container.register(DependentService.self) { _ in
            MockDependentService(dependency: MockTestService())
        }
        XCTAssertEqual(container.registrationCount, 2)
    }

    func testIsRegistered() {
        XCTAssertFalse(container.isRegistered(TestService.self))

        container.register(TestService.self) { MockTestService() }
        XCTAssertTrue(container.isRegistered(TestService.self))
    }

    func testUnregister() {
        container.register(TestService.self) { MockTestService() }
        XCTAssertTrue(container.isRegistered(TestService.self))

        container.unregister(TestService.self)
        XCTAssertFalse(container.isRegistered(TestService.self))
    }

    func testReset() {
        container.register(TestService.self) { MockTestService() }
        container.register(DependentService.self) { _ in
            MockDependentService(dependency: MockTestService())
        }

        container.reset()
        XCTAssertEqual(container.registrationCount, 0)
    }

    // MARK: - Child Container

    func testChildContainerFallsBackToParent() {
        container.register(TestService.self) {
            MockTestService(identifier: "parent")
        }

        let child = container.createChildContainer()
        let service = child.resolve(TestService.self)

        XCTAssertEqual(service.identifier, "parent")
    }

    func testChildContainerOverridesParent() {
        container.register(TestService.self) {
            MockTestService(identifier: "parent")
        }

        let child = container.createChildContainer()
        child.register(TestService.self) {
            MockTestService(identifier: "child")
        }

        let service = child.resolve(TestService.self)
        XCTAssertEqual(service.identifier, "child")
    }

    // MARK: - Module

    func testModuleRegistration() {
        struct TestModule: DIModule {
            func register(in container: DIContainer) {
                container.register(TestService.self, scope: .singleton) {
                    MockTestService(identifier: "module")
                }
            }
        }

        container.registerModule(TestModule())
        let service = container.resolve(TestService.self)
        XCTAssertEqual(service.identifier, "module")
    }

    // MARK: - Factory

    func testFactoryRegistration() {
        let factory = Factory<MockTestService> { _ in
            MockTestService(identifier: "factory-made")
        }

        container.registerFactory(MockTestService.self, factory: factory)
        let instance = container.resolveFactory(MockTestService.self)
        XCTAssertEqual(instance.identifier, "factory-made")
    }
}
