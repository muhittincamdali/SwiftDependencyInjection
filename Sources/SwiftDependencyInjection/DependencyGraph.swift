/// The dependencies of a container and which of them each one reads while it is built.
///
/// `@DependencyContainer` writes the graph of a container at compile time from the getters in its
/// body, as the static `dependencyGraph` property:
///
/// ```swift
/// print(AppDependencies.dependencyGraph.dotDescription)
/// ```
///
/// An edge from `a` to `b` means that the provider of `a` reads `b`, directly or through a plain
/// computed property of the container. Reads inside nested closures, which may run later, are
/// not edges.
public struct DependencyGraph: Sendable, Equatable {
    /// How long a built instance lives.
    public enum Lifetime: String, Sendable, Equatable {
        /// One instance per container, built on first use (``DependencyContainer/shared(_:name:_:)``).
        case shared
        /// A new instance on every read (``DependencyContainer/transient(_:name:_:)``).
        case transient
    }

    /// One dependency of the container.
    public struct Node: Sendable, Equatable {
        /// The property name.
        public let name: String
        /// The property type as written in the source.
        public let type: String
        /// Whether the property is shared or transient.
        public let lifetime: Lifetime

        /// Creates a node.
        public init(name: String, type: String, lifetime: Lifetime) {
            self.name = name
            self.type = type
            self.lifetime = lifetime
        }
    }

    /// A dependency that another one reads while it is built.
    public struct Edge: Sendable, Equatable {
        /// The dependency being built.
        public let from: String
        /// The dependency it reads.
        public let to: String

        /// Creates an edge.
        public init(from: String, to: String) {
            self.from = from
            self.to = to
        }
    }

    /// The container type name.
    public let container: String
    /// The dependencies, in declaration order.
    public let nodes: [Node]
    /// The reads between dependencies, ordered by `from` in declaration order.
    public let edges: [Edge]

    /// Creates a graph.
    public init(container: String, nodes: [Node], edges: [Edge]) {
        self.container = container
        self.nodes = nodes
        self.edges = edges
    }

    /// The node named `name`, if the container has such a dependency.
    public func node(named name: String) -> Node? {
        nodes.first { $0.name == name }
    }

    /// The dependencies that `name` reads while it is built.
    public func dependencies(of name: String) -> [String] {
        edges.filter { $0.from == name }.map(\.to)
    }

    /// The dependencies that read `name` while they are built.
    public func dependents(of name: String) -> [String] {
        edges.filter { $0.to == name }.map(\.from)
    }

    /// The graph in Graphviz DOT format; shared dependencies are drawn as boxes, transient ones
    /// as ellipses.
    public var dotDescription: String {
        var lines = ["digraph \(Self.quoted(container)) {", "  rankdir=LR;"]
        for node in nodes {
            let shape = node.lifetime == .shared ? "box" : "ellipse"
            let label = Self.quoted("\(node.name)\n\(node.type)")
            lines.append("  \(Self.quoted(node.name)) [shape=\(shape), label=\(label)];")
        }
        for edge in edges {
            lines.append("  \(Self.quoted(edge.from)) -> \(Self.quoted(edge.to));")
        }
        lines.append("}")
        return lines.joined(separator: "\n")
    }

    /// Escapes `text` as a DOT string, so a type such as `Dictionary<String, Int>` or a name with
    /// a quote cannot end the string early.
    private static func quoted(_ text: String) -> String {
        var escaped = ""
        for character in text {
            switch character {
            case "\\": escaped += "\\\\"
            case "\"": escaped += "\\\""
            case "\n": escaped += "\\n"
            default: escaped.append(character)
            }
        }
        return "\"\(escaped)\""
    }
}
