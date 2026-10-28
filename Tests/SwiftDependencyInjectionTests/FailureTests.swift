import Testing
@testable import SwiftDependencyInjection

/// A cycle the macro cannot see, because it goes through a method.
@DependencyContainer
final class HiddenCycleContainer {
    var first: Int {
        shared(\.first) { makeFirst() }
    }

    var second: Int {
        shared(\.second) { first + 1 }
    }

    func makeFirst() -> Int {
        second + 1
    }
}

/// A cycle inside a closure that runs at once; the macro does not follow nested closures.
@DependencyContainer
final class ClosureCycleContainer {
    var numbers: [Int] {
        shared(\.numbers) { [1, 2].map { $0 + total } }
    }

    var total: Int {
        shared(\.total) { numbers.count }
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

    @Test("A cycle through a closure that runs at once stops the process")
    func closureCycleStopsTheProcess() async throws {
        let result = try await #require(
            processExitsWith: .failure,
            observing: [\.standardErrorContent]
        ) {
            _ = ClosureCycleContainer().total
        }
        let output = String(decoding: result.standardErrorContent, as: UTF8.self)
        #expect(output.contains("dependency cycle in ClosureCycleContainer: total → numbers → total"))
    }
    #endif
}
