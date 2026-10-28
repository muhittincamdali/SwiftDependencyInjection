import Testing

@Suite("Macro expansion")
struct ExpansionTests {
    @Test("A nonisolated container gets storage, @Sendable overrides, a graph and the conformance")
    func nonisolatedContainer() {
        assertContainerExpansion(
            """
            @DependencyContainer
            final class App {
                var clock: any Clock<Duration> {
                    shared(\\.clock) { ContinuousClock() }
                }
                var model: Model {
                    transient(\\.model) { Model(clock: clock) }
                }
            }
            """,
            expandedSource: """
            final class App {
                var clock: any Clock<Duration> {
                    shared(\\.clock) { ContinuousClock() }
                }
                var model: Model {
                    transient(\\.model) { Model(clock: clock) }
                }

                nonisolated let dependencyStorage = SwiftDependencyInjection.DependencyStorage()

                /// Replacements for the dependencies of this container, for tests and previews. Each
                /// field is a closure that builds the replacement; leave a field `nil` to keep the
                /// real dependency.
                struct Overrides {
                    /// Replaces `clock`.
                    var clock: (@Sendable () -> any Clock<Duration>)?

                    /// Replaces `model`.
                    var model: (@Sendable () -> Model)?

                    init() {
                    }
                }

                /// Replaces dependencies of this container, for example with test doubles.
                ///
                /// Call it before the dependencies are read. A shared instance that was already
                /// built is dropped, so the next read builds the replacement; objects that already
                /// hold the old instance keep it.
                func override(_ configure: (inout Overrides) -> Void) {
                    var overrides = Overrides()
                    configure(&overrides)
                    if let make = overrides.clock {
                        _setOverride(\\.clock) {
                            make()
                        }
                    }
                    if let make = overrides.model {
                        _setOverride(\\.model) {
                            make()
                        }
                    }
                }

                /// The dependencies of this container and the reads between them, written at compile
                /// time by `@DependencyContainer`.
                nonisolated static var dependencyGraph: SwiftDependencyInjection.DependencyGraph {
                    SwiftDependencyInjection.DependencyGraph(
                        container: "App",
                        nodes: [
                            SwiftDependencyInjection.DependencyGraph.Node(name: "clock", type: "any Clock<Duration>", lifetime: .shared),
                            SwiftDependencyInjection.DependencyGraph.Node(name: "model", type: "Model", lifetime: .transient),
                        ],
                        edges: [
                            SwiftDependencyInjection.DependencyGraph.Edge(from: "model", to: "clock"),
                        ]
                    )
                }
            }

            extension App: SwiftDependencyInjection.DependencyContainer {
            }
            """
        )
    }

    @Test(
        "A main-actor container gets @MainActor override closures",
        arguments: ["MainActor", "_Concurrency.MainActor"]
    )
    func mainActorContainer(attribute: String) throws {
        let expansion = try expandContainer("""
            @\(attribute) @DependencyContainer
            final class App {
                var router: Router { shared(\\.router) { Router() } }
            }
            """)
        #expect(expansion.diagnostics.isEmpty)
        #expect(expansion.members.contains("var router: (@MainActor () -> Router)?"))
        #expect(!expansion.members.contains("@Sendable"))
    }

    @Test("A public container gets public members; fields keep each property's access")
    func accessLevels() throws {
        let expansion = try expandContainer("""
            @DependencyContainer
            public final class App {
                public var client: Client { shared(\\.client) { Client() } }
                package var cache: Cache { shared(\\.cache) { Cache() } }
                var model: Model { transient(\\.model) { Model() } }
                private var secret: Secret { shared(\\.secret) { Secret() } }
            }
            """)
        #expect(expansion.diagnostics.isEmpty)
        #expect(expansion.members.contains("public nonisolated let dependencyStorage"))
        #expect(expansion.members.contains("public struct Overrides"))
        #expect(expansion.members.contains("public init()"))
        #expect(expansion.members.contains("public func override(_ configure: (inout Overrides) -> Void)"))
        #expect(expansion.members.contains("public nonisolated static var dependencyGraph"))
        #expect(expansion.members.contains("public var client: (@Sendable () -> Client)?"))
        #expect(expansion.members.contains("package var cache: (@Sendable () -> Cache)?"))
        #expect(expansion.members.contains("    var model: (@Sendable () -> Model)?"))
        // A private field could not be set from the configure closure.
        #expect(expansion.members.contains("fileprivate var secret: (@Sendable () -> Secret)?"))
    }

    @Test("Backticked names use the plain name as the key; T! overrides return T?")
    func namesAndTypes() throws {
        let expansion = try expandContainer("""
            @DependencyContainer
            final class App {
                var `default`: Settings! { shared(\\.`default`) { Settings() } }
                var reader: Reader { return self.transient(\\.reader) { Reader(settings: self.default) } }
            }
            """)
        #expect(expansion.diagnostics.isEmpty)
        #expect(expansion.members.contains("var `default`: (@Sendable () -> Settings?)?"))
        #expect(expansion.members.contains(#"_setOverride(\.`default`)"#))
        #expect(expansion.members.contains(#"Node(name: "reader", type: "Reader", lifetime: .transient)"#))
        #expect(expansion.members.contains(#"Edge(from: "reader", to: "default")"#))
    }

    @Test("Edges follow reads through plain properties but not through other objects")
    func edges() throws {
        let expansion = try expandContainer("""
            @DependencyContainer
            final class App {
                let configuration: Configuration
                var baseURL: URL { configuration.baseURL }
                var client: Client { shared(\\.client) { Client(url: baseURL) } }
                var cache: Cache { shared(\\.cache) { Cache(client: other.client) } }
                var loader: Loader { shared(\\.loader) { Loader(client: client, cache: cache) } }
            }
            """)
        #expect(expansion.diagnostics.isEmpty)
        #expect(!expansion.members.contains(#"Edge(from: "client""#))
        #expect(!expansion.members.contains(#"Edge(from: "cache""#))
        #expect(expansion.members.contains(#"Edge(from: "loader", to: "client")"#))
        #expect(expansion.members.contains(#"Edge(from: "loader", to: "cache")"#))
    }

    @Test("A container without dependencies still gets every member")
    func emptyContainer() throws {
        let expansion = try expandContainer("""
            @DependencyContainer
            final class App {}
            """)
        #expect(expansion.diagnostics.isEmpty)
        #expect(expansion.members.contains("struct Overrides"))
        #expect(expansion.members.contains("nodes: [],"))
        #expect(expansion.members.contains("edges: []"))
    }

    @Test("The conformance is added only when the class does not declare it")
    func conformanceExtension() throws {
        let source = """
            @DependencyContainer
            final class App {}
            """
        #expect(try containerExtensions(source, missingConformances: ["DependencyContainer"]) == [
            "extension App: SwiftDependencyInjection.DependencyContainer {}",
        ])
        #expect(try containerExtensions(source, missingConformances: []).isEmpty)
    }
}
