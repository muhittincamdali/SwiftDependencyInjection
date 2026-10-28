import SwiftUI

@main
struct DependencyDemoApp: App {
    /// The app-wide container: created once, when the scene starts, and passed down.
    @State private var dependencies = AppDependencies()

    var body: some Scene {
        WindowGroup {
            ContentView(dependencies: dependencies, initialDemo: Demo.fromLaunchArguments())
                .tint(Color(red: 0.04, green: 0.52, blue: 1.0))
        }
    }
}

/// The screens of the app.
enum Demo: String, CaseIterable, Identifiable, Hashable {
    case overrides
    case scopes
    case graph

    var id: Self { self }

    var title: String {
        switch self {
        case .overrides: "Live and test dependencies"
        case .scopes: "Shared, transient and child scopes"
        case .graph: "Dependency graph"
        }
    }

    var summary: String {
        switch self {
        case .overrides: "One container, the real API or a stub through override(_:)"
        case .scopes: "Which reads build a new instance, and what a session sees"
        case .graph: "The graph @DependencyContainer wrote at compile time"
        }
    }

    var systemImage: String {
        switch self {
        case .overrides: "arrow.triangle.swap"
        case .scopes: "square.stack.3d.up"
        case .graph: "point.3.connected.trianglepath.dotted"
        }
    }

    /// `-demo scopes` opens a screen directly and plays its scenario; the screenshot script
    /// uses it.
    static func fromLaunchArguments(_ arguments: [String] = ProcessInfo.processInfo.arguments) -> Demo? {
        guard let index = arguments.firstIndex(of: "-demo"), index + 1 < arguments.count else { return nil }
        return Demo(rawValue: arguments[index + 1])
    }
}

struct ContentView: View {
    let dependencies: AppDependencies
    let initialDemo: Demo?
    @State private var path: [Demo] = []

    var body: some View {
        NavigationStack(path: $path) {
            List(Demo.allCases) { demo in
                NavigationLink(value: demo) {
                    Label {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(demo.title)
                            Text(demo.summary)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    } icon: {
                        Image(systemName: demo.systemImage)
                    }
                }
            }
            .navigationTitle("Dependency Demo")
            .navigationDestination(for: Demo.self) { demo in
                switch demo {
                case .overrides: OverridesDemoView(autoplay: initialDemo == .overrides)
                case .scopes: ScopesDemoView(dependencies: dependencies, autoplay: initialDemo == .scopes)
                case .graph: GraphDemoView()
                }
            }
        }
        .onAppear {
            if let initialDemo, path.isEmpty {
                path = [initialDemo]
            }
        }
    }
}
