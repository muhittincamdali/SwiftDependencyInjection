import Testing
import SwiftDependencyInjection

@Suite("Dependency graph")
struct GraphTests {
    @Test("The macro lists dependencies in declaration order with their lifetimes")
    func nodes() {
        let graph = TestContainer.dependencyGraph
        #expect(graph.container == "TestContainer")
        #expect(graph.nodes == [
            .init(name: "greeter", type: "any Greeter", lifetime: .shared),
            .init(name: "service", type: "Service", lifetime: .shared),
            .init(name: "request", type: "Service", lifetime: .transient),
            .init(name: "report", type: "String", lifetime: .transient),
        ])
        // `greeting` is a plain computed property, not a dependency.
        #expect(graph.node(named: "greeting") == nil)
    }

    @Test("Reads through a plain computed property become edges")
    func edgesThroughPlainProperties() {
        let graph = TestContainer.dependencyGraph
        #expect(graph.dependencies(of: "service") == ["greeter"])
        #expect(graph.dependencies(of: "request") == ["greeter"])
        // `report` reads `greeting`, which reads `greeter`, and `service` directly.
        #expect(graph.dependencies(of: "report") == ["greeter", "service"])
        #expect(graph.dependents(of: "greeter") == ["service", "request", "report"])
        #expect(graph.dependencies(of: "greeter").isEmpty)
    }

    @Test("Reads of another container are not edges of this one")
    func edgesStayInTheContainer() {
        let graph = SessionContainer.dependencyGraph
        #expect(graph.nodes.map(\.name) == ["welcome"])
        #expect(graph.edges.isEmpty)
    }

    @Test("A main-actor container has a graph that can be read from any isolation")
    func mainActorGraph() async {
        let graph = await Task.detached { MainActorContainer.dependencyGraph }.value
        #expect(graph.dependencies(of: "detail") == ["screen"])
    }

    @Test("The DOT description draws shared boxes and transient ellipses")
    func dotDescription() {
        let graph = DependencyGraph(
            container: "App",
            nodes: [
                .init(name: "client", type: "any HTTPClient", lifetime: .shared),
                .init(name: "model", type: "Model", lifetime: .transient),
            ],
            edges: [.init(from: "model", to: "client")]
        )
        #expect(graph.dotDescription == """
            digraph "App" {
              rankdir=LR;
              "client" [shape=box, label="client\\nany HTTPClient"];
              "model" [shape=ellipse, label="model\\nModel"];
              "model" -> "client";
            }
            """)
    }

    @Test("DOT strings escape quotes and backslashes")
    func dotEscaping() {
        let graph = DependencyGraph(
            container: "A\"B",
            nodes: [.init(name: "x", type: #"Tagged<"id", \Path>"#, lifetime: .shared)],
            edges: []
        )
        #expect(graph.dotDescription.contains(#"digraph "A\"B" {"#))
        #expect(graph.dotDescription.contains(#"label="x\nTagged<\"id\", \\Path>""#))
    }
}
