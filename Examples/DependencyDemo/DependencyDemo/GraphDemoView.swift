import SwiftDependencyInjection
import SwiftUI

/// Shows the graphs `@DependencyContainer` wrote for the two containers of the app.
struct GraphDemoView: View {
    private let graphs = [AppDependencies.dependencyGraph, SessionDependencies.dependencyGraph]

    var body: some View {
        List {
            ForEach(graphs, id: \.container) { graph in
                Section {
                    ForEach(graph.nodes, id: \.name) { node in
                        NodeRow(node: node, reads: graph.dependencies(of: node.name))
                    }
                } header: {
                    Text(graph.container)
                }
            }

            Section {
                CodeText(AppDependencies.dependencyGraph.dotDescription)
                    .textSelection(.enabled)
            } header: {
                Text("Graphviz")
            } footer: {
                Text("AppDependencies.dependencyGraph.dotDescription")
            }
        }
        .navigationTitle("Graph")
    }
}

private struct NodeRow: View {
    let node: DependencyGraph.Node
    let reads: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(node.name).font(.headline)
                Spacer()
                Text(node.lifetime.rawValue)
                    .font(.caption.weight(.semibold))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(
                        Capsule().fill(node.lifetime == .shared ? Color.accentColor.opacity(0.18) : Color.secondary.opacity(0.15))
                    )
            }
            Text(node.type)
                .font(.system(.subheadline, design: .monospaced))
                .foregroundStyle(.secondary)
            if !reads.isEmpty {
                Label("reads " + reads.joined(separator: ", "), systemImage: "arrow.right")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 2)
    }
}
