import SwiftDependencyInjection
import Testing

/// Runs the README samples (ReadmeSamples.swift, shared with the example app).
@Suite("README samples")
@MainActor
struct ReadmeSamplesTests {
    @Test("The store shows what an overridden API returns")
    func storeShowsWhatTheAPIReturns() async throws {
        let dependencies = AppDependencies()
        dependencies.override {
            $0.api = { StubProfileAPI(profiles: [Profile(id: 1, name: "Ada", role: "Analyst")]) }
        }

        let store = dependencies.profileStore
        try await store.refresh()

        #expect(store.profiles.map(\.name) == ["Ada"])
    }

    @Test("The live container uses the demo server with the configured latency")
    func liveContainer() async throws {
        let dependencies = AppDependencies(configuration: AppConfiguration(latency: .zero))
        #expect(dependencies.api is DemoServerAPI)
        try await dependencies.profileStore.refresh()
        #expect(dependencies.profileStore.profiles == Profile.team)
    }

    @Test("The store is shared and every editor is new")
    func lifetimes() async throws {
        let dependencies = AppDependencies()
        dependencies.override { $0.api = { StubProfileAPI(profiles: Profile.team) } }
        try await dependencies.profileStore.refresh()

        let first = dependencies.profileEditor
        let second = dependencies.profileEditor
        #expect(first.id != second.id)
        #expect(first.profileCount == 4)
        #expect(dependencies.profileStore === dependencies.profileStore)
    }

    @Test("Sessions have their own instances and read the app's store")
    func sessions() async throws {
        let app = AppDependencies()
        app.override { $0.api = { StubProfileAPI(profiles: Profile.team) } }
        try await app.profileStore.refresh()

        let ada = SessionDependencies(app: app, user: Profile.team[0])
        let grace = SessionDependencies(app: app, user: Profile.team[1])

        #expect(ada.greeting == "Signed in as Ada Lovelace, 4 colleagues loaded")
        #expect(grace.greeting == "Signed in as Grace Hopper, 4 colleagues loaded")
        #expect(ada.app.profileStore === grace.app.profileStore)
    }

    @Test("The graph of the README container")
    func graph() {
        let graph = AppDependencies.dependencyGraph
        #expect(graph.nodes.map(\.name) == ["api", "profileStore", "profileEditor"])
        #expect(graph.dependencies(of: "profileStore") == ["api"])
        #expect(graph.dependencies(of: "profileEditor") == ["profileStore"])
        #expect(graph.node(named: "profileEditor")?.lifetime == .transient)
    }
}
