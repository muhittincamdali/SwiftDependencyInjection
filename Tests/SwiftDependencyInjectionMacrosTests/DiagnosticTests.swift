import SwiftSyntaxMacrosGenericTestSupport
import Testing

@Suite("Compile-time checks")
struct DiagnosticTests {
    // MARK: - Cycles

    @Test("A provider that reads itself is a cycle")
    func selfCycle() throws {
        let expansion = try expandContainer("""
            @DependencyContainer
            final class App {
                var clock: Clock { shared(\\.clock) { Clock(parent: clock) } }
            }
            """)
        #expect(expansion.diagnostics.count == 1)
        #expect(expansion.diagnostics.first?.hasPrefix("3:9 Dependency cycle: clock → clock.") == true)
    }

    @Test("A cycle is reported once, at the dependency declared first, with the shortest path")
    func longerCycle() throws {
        let expansion = try expandContainer("""
            @DependencyContainer
            final class App {
                var session: Session { shared(\\.session) { Session(api: api) } }
                var api: API { shared(\\.api) { API(tokens: tokens) } }
                var tokens: Tokens { shared(\\.tokens) { Tokens(session: session, api: api) } }
            }
            """)
        // tokens → api is a second, shorter cycle in the same component; one report covers both.
        #expect(expansion.diagnostics.count == 1)
        #expect(expansion.diagnostics.first?.hasPrefix(
            "3:9 Dependency cycle: session → api → tokens → session."
        ) == true)
    }

    @Test("The README cycle sample gets the error the README shows")
    func readmeCycleSample() throws {
        // Copied from README.md, "Let the compiler find cycles"; keep both in step.
        let expansion = try expandContainer("""
            @DependencyContainer
            final class AppDependencies {
                var api: any ProfileAPI {
                    shared(\\.api) { TokenRefreshingAPI(tokens: tokens) }
                }

                var tokens: TokenStore {
                    shared(\\.tokens) { TokenStore(api: api) }
                }
            }
            """)
        #expect(expansion.diagnostics == [
            "3:9 Dependency cycle: api → tokens → api. 'api' needs itself while it is being built; pass one "
                + "side a closure that reads the other later, or move the shared part into its own dependency",
        ])
    }

    @Test("A cycle through a plain computed property is found")
    func cycleThroughPlainProperty() throws {
        let expansion = try expandContainer("""
            @DependencyContainer
            final class App {
                var headers: [String: String] { ["Authorization": client.token] }
                var client: Client { shared(\\.client) { Client(headers: self.headers) } }
            }
            """)
        #expect(expansion.messages.count == 1)
        #expect(expansion.messages.first?.hasPrefix("Dependency cycle: headers → client → headers.") == true)
    }

    @Test("Separate cycles are each reported")
    func separateCycles() throws {
        let expansion = try expandContainer("""
            @DependencyContainer
            final class App {
                var a: A { shared(\\.a) { A(b: b) } }
                var b: B { shared(\\.b) { B(a: a) } }
                var c: C { transient(\\.c) { C(c: c) } }
                var d: D { shared(\\.d) { D(a: a) } }
            }
            """)
        #expect(expansion.diagnostics.count == 2)
        #expect(expansion.diagnostics[0].hasPrefix("3:9 Dependency cycle: a → b → a."))
        #expect(expansion.diagnostics[1].hasPrefix("5:9 Dependency cycle: c → c."))
    }

    @Test("Reads that run later or read something else are not cycles")
    func noFalseCycles() throws {
        let expansion = try expandContainer("""
            @DependencyContainer
            final class App {
                let other: Other
                var session: Session {
                    shared(\\.session) {
                        // A callback runs after building has finished.
                        Session(onExpiry: { self.session.refresh() })
                    }
                }
                var api: API {
                    shared(\\.api) {
                        // A local constant shadows the property.
                        let api = API.live
                        return api.configured(other.api)
                    }
                }
                var logger: Logger {
                    shared(\\.logger) {
                        func make() -> Logger { logger }
                        return make()
                    }
                }
                var label: Label { shared(\\.label) { Label(text: "session", key: \\.session) } }
            }
            """)
        #expect(expansion.diagnostics.isEmpty)
    }

    // MARK: - Misuse

    @Test("Only a final class can be a container")
    func notAClass() throws {
        let structExpansion = try expandContainer("""
            @DependencyContainer
            struct App {}
            """)
        #expect(structExpansion.diagnostics == [
            "1:1 @DependencyContainer can only be attached to a final class",
        ])
        let actorExpansion = try expandContainer("""
            @DependencyContainer
            actor App {}
            """)
        #expect(actorExpansion.messages == ["@DependencyContainer can only be attached to a final class"])
    }

    @Test("A non-final class gets an error with a fix-it that adds final")
    func notFinal() {
        assertContainerExpansion(
            """
            @DependencyContainer
            public class App {}
            """,
            expandedSource: """
            public class App {}
            """,
            diagnostics: [
                DiagnosticSpec(
                    message: "A dependency container must be a final class, so that its dependencies cannot be "
                        + "replaced by a subclass the macro does not see",
                    line: 2,
                    column: 8,
                    fixIts: [FixItSpec(message: "Add 'final'")]
                ),
            ],
            fixedSource: """
            @DependencyContainer
            public final class App {}
            """
        )
    }

    @Test("Generated names cannot be declared by hand")
    func reservedNames() throws {
        let expansion = try expandContainer("""
            @DependencyContainer
            final class App {
                let dependencyStorage = DependencyStorage()
                struct Overrides {}
                static var dependencyGraph: Int { 0 }
            }
            """)
        #expect(expansion.messages == [
            "'dependencyStorage' is added by @DependencyContainer; rename this member",
            "'Overrides' is added by @DependencyContainer; rename this member",
            "'dependencyGraph' is added by @DependencyContainer; rename this member",
        ])
    }

    @Test("Providers outside a computed property getter are rejected")
    func providerOutsideGetter() throws {
        let expansion = try expandContainer("""
            @DependencyContainer
            final class App {
                func client(for id: Int) -> Client { shared(\\.client) { Client(id: id) } }
                init() { _ = transient(\\.count) { 1 } }
                subscript(index: Int) -> Int { shared(\\.count) { index } }
                lazy var cache: Cache = shared(\\.cache) { Cache() }
                struct Nested { var x: Int { shared(\\.x) { 1 } } }
            }
            """)
        #expect(expansion.messages == [
            "'shared' can only be called from the getter of a computed property, with the key path of that property",
            "'transient' can only be called from the getter of a computed property, with the key path of that property",
            "'shared' can only be called from the getter of a computed property, with the key path of that property",
            "'shared' can only be called from the getter of a computed property, with the key path of that property",
        ])
    }

    @Test("A getter must be the provider call alone")
    func providerNotSole() throws {
        let expansion = try expandContainer("""
            @DependencyContainer
            final class App {
                var client: Client {
                    print("building")
                    return shared(\\.client) { Client() }
                }
                var flag: Bool { true && transient(\\.flag) { false } }
            }
            """)
        #expect(expansion.messages == [
            #"Write the getter as a single 'shared(\.property) { … }' call and put the other statements inside the closure"#,
            #"Write the getter as a single 'transient(\.property) { … }' call and put the other statements inside the closure"#,
        ])
    }

    @Test("A dependency inside #if is rejected; an #if inside its closure is not")
    func conditionalDependency() throws {
        let expansion = try expandContainer("""
            @DependencyContainer
            final class App {
                #if DEBUG
                var logger: Logger {
                    shared(\\.logger) { Logger(tag: "debug") }
                }
                #else
                var logger: Logger {
                    transient(\\.logger) { Logger(tag: "release") }
                }
                #endif
                var clock: Clock {
                    shared(\\.clock) {
                        #if DEBUG
                        Clock(log: logger)
                        #else
                        Clock()
                        #endif
                    }
                }
            }
            """)
        #expect(expansion.diagnostics == [
            "5:9 A dependency cannot be declared inside '#if', because @DependencyContainer cannot tell which branch is built; declare it once and put the '#if' inside the closure passed to 'shared'",
            "9:9 A dependency cannot be declared inside '#if', because @DependencyContainer cannot tell which branch is built; declare it once and put the '#if' inside the closure passed to 'transient'",
        ])
        #expect(expansion.members.contains("var clock: (@Sendable () -> Clock)?"))
        #expect(!expansion.members.contains("var logger:"))
    }

    @Test("Dependencies take no key, setter, effects or opaque type")
    func dependencyShape() throws {
        let expansion = try expandContainer("""
            @DependencyContainer
            final class App {
                var a: A { shared(\\.b) { A() } }
                var b: B {
                    get { shared(\\.b) { B() } }
                    set {}
                }
                var c: C { get async { shared(\\.c) { C() } } }
                var d: some View { shared(\\.d) { Text("") } }
                static var e: E { shared(\\.e) { E() } }
            }
            """)
        #expect(expansion.messages == [
            #"Pass '\.a' to 'shared': the key path of the property whose getter calls it is the key of the instance and the key of its override"#,
            "Dependency 'b' cannot have a setter; replace it in tests with override(_:)",
            "Dependency 'c' must have a synchronous, non-throwing getter; dependencies are built when they are read",
            "Dependency 'd' cannot have an opaque 'some' type, because an override has to name the type; use 'any' or a concrete type",
            "Static property 'e' cannot be a dependency; dependencies belong to a container instance",
        ])
        // A dependency with an opaque type gets no override field, which would not compile.
        #expect(!expansion.members.contains("var d:"))
    }

    @Test("Functions and properties named like providers on other values are left alone")
    func unrelatedCalls() throws {
        let expansion = try expandContainer("""
            @DependencyContainer
            final class App {
                var session: URLSession { URLSession.shared }
                func reset() { cache.shared(1); other.transient() }
            }
            """)
        #expect(expansion.diagnostics.isEmpty)
        #expect(expansion.members.contains("nodes: [],"))
    }
}
