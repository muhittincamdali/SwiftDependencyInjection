#if canImport(SwiftDependencyInjectionMacros)
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
                var clock: Clock { shared { Clock(parent: clock) } }
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
                var session: Session { shared { Session(api: api) } }
                var api: API { shared { API(tokens: tokens) } }
                var tokens: Tokens { shared { Tokens(session: session, api: api) } }
            }
            """)
        // tokens → api is a second, shorter cycle in the same component; one report covers both.
        #expect(expansion.diagnostics.count == 1)
        #expect(expansion.diagnostics.first?.hasPrefix(
            "3:9 Dependency cycle: session → api → tokens → session."
        ) == true)
    }

    @Test("A cycle through a plain computed property is found")
    func cycleThroughPlainProperty() throws {
        let expansion = try expandContainer("""
            @DependencyContainer
            final class App {
                var headers: [String: String] { ["Authorization": client.token] }
                var client: Client { shared { Client(headers: self.headers) } }
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
                var a: A { shared { A(b: b) } }
                var b: B { shared { B(a: a) } }
                var c: C { transient { C(c: c) } }
                var d: D { shared { D(a: a) } }
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
                    shared {
                        // A callback runs after building has finished.
                        Session(onExpiry: { self.session.refresh() })
                    }
                }
                var api: API {
                    shared {
                        // A local constant shadows the property.
                        let api = API.live
                        return api.configured(other.api)
                    }
                }
                var logger: Logger {
                    shared {
                        func make() -> Logger { logger }
                        return make()
                    }
                }
                var label: Label { shared { Label(text: "session", key: \\.session) } }
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
            "'dependencyStorage' is generated by @DependencyContainer; rename this member",
            "'Overrides' is generated by @DependencyContainer; rename this member",
            "'dependencyGraph' is generated by @DependencyContainer; rename this member",
        ])
    }

    @Test("Providers outside a computed property getter are rejected")
    func providerOutsideGetter() throws {
        let expansion = try expandContainer("""
            @DependencyContainer
            final class App {
                func client(for id: Int) -> Client { shared { Client(id: id) } }
                init() { _ = transient { 1 } }
                subscript(index: Int) -> Int { shared { index } }
                lazy var cache: Cache = shared { Cache() }
                struct Nested { var x: Int { shared { 1 } } }
            }
            """)
        #expect(expansion.messages == [
            "'shared { }' can only be called from the getter of a computed property; the property name is the key of the instance",
            "'transient { }' can only be called from the getter of a computed property; the property name is the key of the instance",
            "'shared { }' can only be called from the getter of a computed property; the property name is the key of the instance",
            "'shared { }' can only be called from the getter of a computed property; the property name is the key of the instance",
        ])
    }

    @Test("A getter must be the provider call alone")
    func providerNotSole() throws {
        let expansion = try expandContainer("""
            @DependencyContainer
            final class App {
                var client: Client {
                    print("building")
                    return shared { Client() }
                }
                var flag: Bool { true && transient { false } }
            }
            """)
        #expect(expansion.messages == [
            "Write the getter as a single 'shared { … }' call and put the other statements inside the closure",
            "Write the getter as a single 'transient { … }' call and put the other statements inside the closure",
        ])
    }

    @Test("Dependencies take no key, setter, effects or opaque type")
    func dependencyShape() throws {
        let expansion = try expandContainer("""
            @DependencyContainer
            final class App {
                var a: A { shared(key: "a") { A() } }
                var b: B {
                    get { shared { B() } }
                    set {}
                }
                var c: C { get async { shared { C() } } }
                var d: some View { shared { Text("") } }
                static var e: E { shared { E() } }
            }
            """)
        #expect(expansion.messages == [
            "Remove the 'key:' argument; inside a dependency container 'shared' uses the property name as the key, which the generated overrides rely on",
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
#endif
