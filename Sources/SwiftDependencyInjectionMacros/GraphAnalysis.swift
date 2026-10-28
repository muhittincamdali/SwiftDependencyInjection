/// Cycle detection and dependency edges over the members of a container.
struct GraphAnalysis {
    /// Member names in declaration order.
    let order: [String]
    /// The members each member reads, restricted to members of the container.
    let reads: [String: [String]]
    let dependencyNames: Set<String>

    init(members: [ContainerModel.Member]) {
        let names = members.map(\.name)
        let known = Set(names)
        order = names
        var reads: [String: [String]] = [:]
        for member in members {
            reads[member.name] = member.reads.filter(known.contains)
        }
        self.reads = reads
        dependencyNames = Set(members.filter(\.isDependency).map(\.name))
    }

    /// One cycle per strongly connected component that has one, as a path that starts and ends
    /// at the member of the cycle declared first, for example `["a", "b", "a"]`. Cycles are
    /// ordered by that first member.
    func cycles() -> [[String]] {
        var result: [[String]] = []
        var reported: Set<String> = []
        for start in order where !reported.contains(start) {
            guard let path = shortestPath(from: start, to: start) else { continue }
            // Report a cycle once, at the member declared first; members declared later that sit
            // on the same cycle are covered by it.
            let members = Set(path)
            let firstDeclared = order.first(where: members.contains)
            guard firstDeclared == start else { continue }
            reported.formUnion(members)
            result.append(path)
        }
        return result
    }

    /// The dependencies `dependency` reads while it is built: direct reads of dependencies, and
    /// dependencies read through plain computed properties, in declaration order.
    func dependencyEdges(from dependency: String) -> [String] {
        var found: Set<String> = []
        var visited: Set<String> = [dependency]
        var stack = reads[dependency] ?? []
        while let next = stack.popLast() {
            if dependencyNames.contains(next) {
                found.insert(next)
                continue
            }
            guard visited.insert(next).inserted else { continue }
            stack.append(contentsOf: reads[next] ?? [])
        }
        return order.filter(found.contains)
    }

    /// Breadth-first search, so the reported cycle is a shortest one. Each member is visited
    /// once, so the search ends on any graph.
    private func shortestPath(from start: String, to goal: String) -> [String]? {
        var previous: [String: String] = [:]
        var queue = [start]
        var index = 0
        var visited: Set<String> = []
        while index < queue.count {
            let current = queue[index]
            index += 1
            for next in reads[current] ?? [] {
                if next == goal {
                    var path = [goal]
                    var step: String? = current
                    while let node = step, node != start {
                        path.append(node)
                        step = previous[node]
                    }
                    path.append(start)
                    return path.reversed()
                }
                guard visited.insert(next).inserted else { continue }
                previous[next] = current
                queue.append(next)
            }
        }
        return nil
    }
}
