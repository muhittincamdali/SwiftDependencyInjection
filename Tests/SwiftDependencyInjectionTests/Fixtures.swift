import Foundation
import SwiftDependencyInjection

/// Counts calls from any thread.
final class Counter: @unchecked Sendable {
    private let lock = NSLock()
    private var count = 0

    var value: Int {
        lock.withLock { count }
    }

    func increment() {
        lock.withLock { count += 1 }
    }
}

protocol Greeter: Sendable {
    func greet(_ name: String) -> String
}

struct EnglishGreeter: Greeter {
    func greet(_ name: String) -> String { "Hello, \(name)" }
}

struct TestGreeter: Greeter {
    let prefix: String
    func greet(_ name: String) -> String { "\(prefix) \(name)" }
}

final class Service: Sendable {
    let id = UUID()
    let greeter: any Greeter

    init(greeter: any Greeter) {
        self.greeter = greeter
    }
}

/// A nonisolated container used from several threads by the tests.
@DependencyContainer
final class TestContainer {
    let builds = Counter()
    let serviceBuilds = Counter()

    var greeter: any Greeter {
        shared(\.greeter) {
            builds.increment()
            return EnglishGreeter()
        }
    }

    var service: Service {
        shared(\.service) {
            serviceBuilds.increment()
            return Service(greeter: greeter)
        }
    }

    var request: Service {
        transient(\.request) { Service(greeter: greeter) }
    }

    /// A plain computed property: not a dependency, but its reads still count as edges.
    var greeting: String {
        greeter.greet("graph")
    }

    var report: String {
        transient(\.report) { greeting + " " + service.greeter.greet("report") }
    }
}

@MainActor
final class Screen {
    let title: String

    init(title: String) {
        self.title = title
    }
}

@MainActor
@DependencyContainer
final class MainActorContainer {
    var screen: Screen {
        shared(\.screen) { Screen(title: "Live") }
    }

    var detail: Screen {
        transient(\.detail) { Screen(title: "Detail of \(screen.title)") }
    }
}

/// A scope below another container: one per signed-in user.
@DependencyContainer
final class SessionContainer {
    let parent: TestContainer
    let userName: String

    init(parent: TestContainer, userName: String) {
        self.parent = parent
        self.userName = userName
    }

    var welcome: String {
        shared(\.welcome) { parent.greeter.greet(userName) }
    }
}

@DependencyContainer
final class GenericContainer<Element: Sendable> {
    let element: Element

    init(element: Element) {
        self.element = element
    }

    var elements: [Element] {
        shared(\.elements) { [element, element] }
    }
}

@DependencyContainer
public final class PublicContainer {
    public init() {}

    public var name: String {
        shared(\.name) { "public" }
    }

    var internalValue: Int {
        shared(\.internalValue) { 42 }
    }
}

/// A container without the macro: conforming by hand gives caching and cycle checks, but no
/// generated overrides or graph.
final class ManualContainer: DependencyContainer {
    let dependencyStorage = DependencyStorage()

    var greeter: any Greeter {
        shared(\.greeter) { EnglishGreeter() }
    }
}

/// Holds a reference so a test can watch an instance being released.
final class Tracked: Sendable {}

/// Names that need backticks, an implicitly unwrapped optional and a private dependency.
@DependencyContainer
final class KeywordContainer {
    var `default`: String {
        shared(\.`default`) { "live" }
    }

    var settings: String! {
        shared(\.settings) { "settings" }
    }

    private var secret: Int {
        shared(\.secret) { 7 }
    }

    var revealed: Int {
        transient(\.revealed) { secret * 6 }
    }

    func overrideSecret(with value: Int) {
        override { $0.secret = { value } }
    }
}
