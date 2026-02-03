import XCTest
@testable import SwiftDependencyInjection

// MARK: - Test Types

private protocol MessageService {
    var message: String { get }
}

private final class MockMessageService: MessageService {
    let message: String

    init(message: String = "hello") {
        self.message = message
    }
}

// MARK: - Property Wrapper Tests

final class PropertyWrapperTests: XCTestCase {

    override func setUp() {
        super.setUp()
        DIContainer.shared.reset()
    }

    override func tearDown() {
        DIContainer.shared.reset()
        super.tearDown()
    }

    // MARK: - @Inject

    func testInjectResolvesFromSharedContainer() {
        DIContainer.shared.register(MessageService.self) {
            MockMessageService(message: "injected")
        }

        let wrapper = Inject<MessageService>()
        XCTAssertEqual(wrapper.wrappedValue.message, "injected")
    }

    func testInjectWithName() {
        DIContainer.shared.register(MessageService.self, name: "greeting") {
            MockMessageService(message: "hi there")
        }

        let wrapper = Inject<MessageService>(name: "greeting")
        XCTAssertEqual(wrapper.wrappedValue.message, "hi there")
    }

    func testInjectFromSpecificContainer() {
        let container = DIContainer()
        container.register(MessageService.self) {
            MockMessageService(message: "specific")
        }

        let wrapper = Inject<MessageService>(container: container)
        XCTAssertEqual(wrapper.wrappedValue.message, "specific")
    }

    // MARK: - @LazyInject

    func testLazyInjectDefersResolution() {
        DIContainer.shared.register(MessageService.self) {
            MockMessageService(message: "lazy")
        }

        var wrapper = LazyInject<MessageService>()
        // Access triggers resolution
        XCTAssertEqual(wrapper.wrappedValue.message, "lazy")
    }

    func testLazyInjectCachesAfterFirstAccess() {
        var callCount = 0
        DIContainer.shared.register(MessageService.self) {
            callCount += 1
            return MockMessageService(message: "cached-\(callCount)")
        }

        var wrapper = LazyInject<MessageService>()
        let first = wrapper.wrappedValue.message
        let second = wrapper.wrappedValue.message

        XCTAssertEqual(first, second)
        XCTAssertEqual(callCount, 1)
    }

    func testLazyInjectWithName() {
        DIContainer.shared.register(MessageService.self, name: "special") {
            MockMessageService(message: "named-lazy")
        }

        var wrapper = LazyInject<MessageService>(name: "special")
        XCTAssertEqual(wrapper.wrappedValue.message, "named-lazy")
    }
}
