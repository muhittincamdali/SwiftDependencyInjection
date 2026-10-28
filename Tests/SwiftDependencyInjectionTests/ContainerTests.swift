import Foundation
import Testing
@testable import SwiftDependencyInjection

@Suite("Shared and transient dependencies")
struct ContainerTests {
    @Test("A shared dependency is built once per container")
    func sharedIsBuiltOnce() {
        let container = TestContainer()
        let first = container.service
        let second = container.service
        #expect(first === second)
        #expect(container.serviceBuilds.value == 1)
        #expect(container.builds.value == 1)
    }

    @Test("Each container instance is its own scope")
    func containersDoNotShareInstances() {
        let first = TestContainer()
        let second = TestContainer()
        #expect(first.service !== second.service)
        #expect(first.serviceBuilds.value == 1)
        #expect(second.serviceBuilds.value == 1)
    }

    @Test("A transient dependency is new on every read but reuses shared ones")
    func transientIsNewEachTime() {
        let container = TestContainer()
        let first = container.request
        let second = container.request
        #expect(first !== second)
        #expect(first.id != second.id)
        // Both requests read the shared greeter, which was built once.
        #expect(container.builds.value == 1)
    }

    @Test("A provider can read other dependencies and plain properties")
    func providersReadEachOther() {
        let container = TestContainer()
        #expect(container.report == "Hello, graph Hello, report")
    }

    @Test("Concurrent first reads build a shared dependency exactly once")
    func concurrentReadsBuildOnce() async {
        let container = TestContainer()
        let ids = await withTaskGroup(of: UUID.self) { group in
            for _ in 0..<200 {
                group.addTask { container.service.id }
            }
            return await group.reduce(into: Set<UUID>()) { $0.insert($1) }
        }
        #expect(ids.count == 1)
        #expect(container.serviceBuilds.value == 1)
        #expect(container.builds.value == 1)
    }

    @Test("Concurrent reads of dependencies that read each other do not deadlock")
    func concurrentNestedReads() async {
        let container = TestContainer()
        await withTaskGroup(of: Void.self) { group in
            for index in 0..<200 {
                group.addTask {
                    switch index % 3 {
                    case 0: _ = container.report
                    case 1: _ = container.request
                    default: _ = container.greeter
                    }
                }
            }
        }
        #expect(container.builds.value == 1)
        #expect(container.serviceBuilds.value == 1)
    }

    @Test("A shared instance is released with its container")
    func instancesLiveAsLongAsTheContainer() {
        weak var tracked: Tracked?
        do {
            let container = TrackingContainer()
            tracked = container.tracked
            #expect(tracked != nil)
        }
        #expect(tracked == nil)
    }

    @Test("A child container reads the shared instances of its parent")
    func childScopes() {
        let app = TestContainer()
        let alice = SessionContainer(parent: app, userName: "Alice")
        let bob = SessionContainer(parent: app, userName: "Bob")
        #expect(alice.welcome == "Hello, Alice")
        #expect(bob.welcome == "Hello, Bob")
        #expect(app.builds.value == 1)
    }

    @Test("Generic containers work")
    func genericContainer() {
        let container = GenericContainer(element: 7)
        #expect(container.elements == [7, 7])
    }

    @Test("A container conformed by hand caches without the macro")
    func manualConformance() {
        let container = ManualContainer()
        #expect(container.greeter.greet("manual") == "Hello, manual")
    }

    @Test("A public container exposes its public dependencies")
    func publicContainer() {
        let container = PublicContainer()
        #expect(container.name == "public")
        #expect(container.internalValue == 42)
    }

    @Test("The resolution path is empty once building has finished")
    func resolutionPathIsUnwound() {
        let container = TestContainer()
        _ = container.report
        #expect(container.dependencyStorage.resolutionPath.isEmpty)
    }
}

@DependencyContainer
final class TrackingContainer {
    var tracked: Tracked {
        shared { Tracked() }
    }
}
