// The README copies its samples from this file. The example app builds it, and the package's
// test target compiles and runs it through the symlink Tests/SwiftDependencyInjectionTests/ReadmeSamples.swift.
import Foundation
import SwiftDependencyInjection

struct Profile: Identifiable, Equatable, Sendable {
    let id: Int
    let name: String
    let role: String

    static let team = [
        Profile(id: 1, name: "Ada Lovelace", role: "Analyst"),
        Profile(id: 2, name: "Grace Hopper", role: "Compiler engineer"),
        Profile(id: 3, name: "Katherine Johnson", role: "Mathematician"),
        Profile(id: 4, name: "Margaret Hamilton", role: "Flight software lead"),
    ]
}

protocol ProfileAPI: Sendable {
    func fetchProfiles() async throws -> [Profile]
}

/// Stands in for a network client: answers after `latency` with the bundled team.
struct DemoServerAPI: ProfileAPI {
    let latency: Duration

    func fetchProfiles() async throws -> [Profile] {
        try await Task.sleep(for: latency)
        return Profile.team
    }
}

/// Answers at once with fixed profiles; tests and previews use it.
struct StubProfileAPI: ProfileAPI {
    let profiles: [Profile]

    func fetchProfiles() async throws -> [Profile] {
        profiles
    }
}

struct AppConfiguration: Sendable {
    var latency: Duration

    static let production = AppConfiguration(latency: .milliseconds(600))
}

@MainActor
final class ProfileStore {
    private let api: any ProfileAPI
    private(set) var profiles: [Profile] = []

    init(api: any ProfileAPI) {
        self.api = api
    }

    func refresh() async throws {
        profiles = try await api.fetchProfiles()
    }
}

/// A screen-sized object with its own state: every screen gets a new one.
@MainActor
final class ProfileEditor {
    let id = UUID()
    private let store: ProfileStore

    init(store: ProfileStore) {
        self.store = store
    }

    var profileCount: Int {
        store.profiles.count
    }
}

// MARK: - The container

@MainActor
@DependencyContainer
final class AppDependencies {
    let configuration: AppConfiguration

    init(configuration: AppConfiguration = .production) {
        self.configuration = configuration
    }

    var api: any ProfileAPI {
        shared(\.api) { DemoServerAPI(latency: configuration.latency) }
    }

    var profileStore: ProfileStore {
        shared(\.profileStore) { ProfileStore(api: api) }
    }

    var profileEditor: ProfileEditor {
        transient(\.profileEditor) { ProfileEditor(store: profileStore) }
    }
}

// MARK: - A child scope

/// Lives while one user is signed in; reads the app-wide dependencies through `app`.
@MainActor
@DependencyContainer
final class SessionDependencies {
    let app: AppDependencies
    let user: Profile

    init(app: AppDependencies, user: Profile) {
        self.app = app
        self.user = user
    }

    var greeting: String {
        shared(\.greeting) { "Signed in as \(user.name), \(app.profileStore.profiles.count) colleagues loaded" }
    }
}
