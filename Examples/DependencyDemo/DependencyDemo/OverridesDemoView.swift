import SwiftUI

/// Loads profiles through two containers of the same type: one as the app builds it, one with
/// the API replaced through `override(_:)`, as a test or a preview would.
struct OverridesDemoView: View {
    let autoplay: Bool
    @State private var live = LoadState.idle
    @State private var stubbed = LoadState.idle

    var body: some View {
        List {
            Section {
                LoadStateView(state: live)
            } header: {
                Text("Live container")
            } footer: {
                CodeText("AppDependencies()")
            }

            Section {
                LoadStateView(state: stubbed)
            } header: {
                Text("Same container, API overridden")
            } footer: {
                CodeText("""
                    dependencies.override {
                        $0.api = { StubProfileAPI(profiles: .preview) }
                    }
                    """)
            }

            Section {
                Button("Load both", systemImage: "arrow.clockwise") {
                    Task { await loadBoth() }
                }
                .disabled(live == .loading || stubbed == .loading)
            } footer: {
                Text("Each load uses a new container, so the two never share an instance or an override.")
            }
        }
        .navigationTitle("Overrides")
        .task {
            if autoplay { await loadBoth() }
        }
    }

    private func loadBoth() async {
        live = .loading
        stubbed = .loading
        async let liveResult = Self.load(from: AppDependencies())
        let preview = AppDependencies()
        preview.override {
            $0.api = { StubProfileAPI(profiles: .preview) }
        }
        async let stubbedResult = Self.load(from: preview)
        (live, stubbed) = await (liveResult, stubbedResult)
    }

    private static func load(from dependencies: AppDependencies) async -> LoadState {
        let clock = ContinuousClock()
        let start = clock.now
        do {
            let store = dependencies.profileStore
            try await store.refresh()
            return .loaded(
                api: String(describing: type(of: dependencies.api)),
                names: store.profiles.map(\.name),
                elapsed: start.duration(to: clock.now)
            )
        } catch {
            return .failed(error.localizedDescription)
        }
    }
}

extension [Profile] {
    static let preview = [
        Profile(id: 101, name: "Preview Person", role: "Stub data"),
        Profile(id: 102, name: "Second Preview", role: "Stub data"),
    ]
}

enum LoadState: Equatable {
    case idle
    case loading
    case loaded(api: String, names: [String], elapsed: Duration)
    case failed(String)
}

private struct LoadStateView: View {
    let state: LoadState

    var body: some View {
        switch state {
        case .idle:
            Text("Not loaded").foregroundStyle(.secondary)
        case .loading:
            HStack(spacing: 8) {
                ProgressView()
                Text("Loading…").foregroundStyle(.secondary)
            }
        case let .loaded(api, names, elapsed):
            LabeledContent("Injected API", value: api)
            LabeledContent(
                "Load time",
                value: elapsed.formatted(.units(allowed: [.milliseconds], width: .abbreviated))
            )
            ForEach(names, id: \.self) { name in
                Label(name, systemImage: "person.crop.circle")
            }
        case let .failed(message):
            Label(message, systemImage: "exclamationmark.triangle")
        }
    }
}

/// Monospaced code in a section footer.
struct CodeText: View {
    let code: String

    init(_ code: String) {
        self.code = code
    }

    var body: some View {
        Text(code)
            .font(.system(.caption, design: .monospaced))
            .foregroundStyle(.secondary)
    }
}
