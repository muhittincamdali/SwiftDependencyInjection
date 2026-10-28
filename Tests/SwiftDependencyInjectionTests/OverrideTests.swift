import Testing
@testable import SwiftDependencyInjection

@Suite("Overrides")
struct OverrideTests {
    @Test("An override replaces a shared dependency and what is built from it")
    func overrideShared() {
        let container = TestContainer()
        container.override { $0.greeter = { TestGreeter(prefix: "Hi") } }
        #expect(container.greeter.greet("test") == "Hi test")
        #expect(container.service.greeter.greet("test") == "Hi test")
        // The real provider never ran.
        #expect(container.builds.value == 0)
    }

    @Test("An overridden shared dependency is still built once")
    func overrideIsCached() {
        let container = TestContainer()
        let builds = Counter()
        container.override {
            $0.service = {
                builds.increment()
                return Service(greeter: TestGreeter(prefix: "Mock"))
            }
        }
        #expect(container.service === container.service)
        #expect(builds.value == 1)
    }

    @Test("An override replaces a shared instance that was already built")
    func overrideAfterFirstRead() {
        let container = TestContainer()
        let live = container.service
        container.override { $0.service = { Service(greeter: TestGreeter(prefix: "Late")) } }
        let replaced = container.service
        #expect(live !== replaced)
        #expect(replaced.greeter.greet("x") == "Late x")
        // The live instance is still valid for whoever holds it.
        #expect(live.greeter.greet("x") == "Hello, x")
    }

    @Test("An override of a transient dependency runs on every read")
    func overrideTransient() {
        let container = TestContainer()
        let builds = Counter()
        container.override {
            $0.request = {
                builds.increment()
                return Service(greeter: TestGreeter(prefix: "Request"))
            }
        }
        #expect(container.request !== container.request)
        #expect(builds.value == 2)
    }

    @Test("Fields left nil keep the real dependency")
    func untouchedFieldsStayLive() {
        let container = TestContainer()
        container.override { $0.request = { Service(greeter: TestGreeter(prefix: "R")) } }
        #expect(container.greeter.greet("x") == "Hello, x")
        #expect(container.builds.value == 1)
    }

    @Test("Overrides belong to one container, so parallel tests cannot see each other's")
    func overridesAreIsolatedPerContainer() async {
        await withTaskGroup(of: (String, String).self) { group in
            for index in 0..<50 {
                group.addTask {
                    let container = TestContainer()
                    let prefix = "Test\(index)"
                    container.override { $0.greeter = { TestGreeter(prefix: prefix) } }
                    return (prefix, container.service.greeter.greet("x"))
                }
            }
            for await (prefix, greeting) in group {
                #expect(greeting == "\(prefix) x")
            }
        }
    }

    @Test("A main-actor container takes main-actor overrides")
    @MainActor
    func mainActorOverrides() {
        let container = MainActorContainer()
        container.override { $0.screen = { Screen(title: "Preview") } }
        #expect(container.screen.title == "Preview")
        #expect(container.detail.title == "Detail of Preview")
        #expect(container.detail !== container.detail)
    }

    @Test("A later override replaces an earlier one")
    func lastOverrideWins() {
        let container = TestContainer()
        container.override { $0.greeter = { TestGreeter(prefix: "First") } }
        container.override { $0.greeter = { TestGreeter(prefix: "Second") } }
        #expect(container.greeter.greet("x") == "Second x")
    }

    @Test("Backticked, implicitly unwrapped and private dependencies can be overridden")
    func unusualDeclarations() {
        let container = KeywordContainer()
        #expect(container.default == "live")
        #expect(container.settings == "settings")
        #expect(container.revealed == 42)
        container.override {
            $0.default = { "test" }
            $0.settings = { nil }
        }
        container.overrideSecret(with: 2)
        #expect(container.default == "test")
        #expect(container.settings == nil)
        #expect(container.revealed == 12)
    }
}
