import Testing
@testable import SwiftDependencyInjection

/// A cycle the macro cannot see, because it goes through a method.
@DependencyContainer
final class HiddenCycleContainer {
    var first: Int {
        shared { makeFirst() }
    }

    var second: Int {
        shared { first + 1 }
    }

    func makeFirst() -> Int {
        second + 1
    }
}

/// Two properties that pass the same key by hand, which the macro would reject.
final class CollidingKeysContainer: DependencyContainer {
    let dependencyStorage = DependencyStorage()

    var number: Int {
        shared(key: "value") { 1 }
    }

    var text: String {
        shared(key: "value") { "one" }
    }
}

@Suite("Failure messages")
struct FailureTests {
    @Test("A cycle message shows only the part of the path that repeats")
    func cycleMessage() {
        let failure = DependencyFailure.cycle(
            path: ["root", "first", "second"],
            repeating: "first",
            container: "AppDependencies"
        )
        #expect(failure.message.contains("dependency cycle in AppDependencies: first → second → first."))
        #expect(!failure.message.contains("root"))
    }

    @Test("A self-cycle names the dependency twice")
    func selfCycleMessage() {
        let failure = DependencyFailure.cycle(path: ["clock"], repeating: "clock", container: "C")
        #expect(failure.message.contains("C: clock → clock."))
    }

    @Test("A type mismatch names the property and both types")
    func typeMismatchMessage() {
        let failure = DependencyFailure.typeMismatch(
            name: "text",
            container: "CollidingKeysContainer",
            stored: "Int",
            requested: "String"
        )
        #expect(failure.message.contains("CollidingKeysContainer.text holds a Int, but a String was requested"))
    }

    #if os(macOS)
    @Test("A cycle through a method stops the process with the cycle path")
    func runtimeCycleStopsTheProcess() async throws {
        let result = try await #require(
            processExitsWith: .failure,
            observing: [\.standardErrorContent]
        ) {
            _ = HiddenCycleContainer().first
        }
        let output = String(decoding: result.standardErrorContent, as: UTF8.self)
        #expect(output.contains("dependency cycle in HiddenCycleContainer: first → second → first"))
    }

    @Test("Two dependencies under one key stop the process with both types")
    func keyCollisionStopsTheProcess() async throws {
        let result = try await #require(
            processExitsWith: .failure,
            observing: [\.standardErrorContent]
        ) {
            let container = CollidingKeysContainer()
            _ = container.number
            _ = container.text
        }
        let output = String(decoding: result.standardErrorContent, as: UTF8.self)
        #expect(output.contains("CollidingKeysContainer.value holds a Int, but a String was requested"))
    }
    #endif
}
