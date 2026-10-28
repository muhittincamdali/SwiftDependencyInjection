import SwiftUI

/// Reads dependencies of the app container and of child containers and logs which instance
/// each read returned.
struct ScopesDemoView: View {
    let dependencies: AppDependencies
    let autoplay: Bool
    @State private var reads: [Read] = []

    struct Read: Identifiable {
        let id = UUID()
        let what: String
        let instance: String
        let isNew: Bool
    }

    var body: some View {
        List {
            Section {
                Button("Read profileStore (shared)", systemImage: "shippingbox") { readStore() }
                Button("Read profileEditor (transient)", systemImage: "square.and.pencil") { readEditor() }
                Button("Start a session for each of two users", systemImage: "person.2") { startSessions() }
                Button("Clear log", systemImage: "trash", role: .destructive) { reads.removeAll() }
            }

            Section {
                if reads.isEmpty {
                    Text("Tap a button above.").foregroundStyle(.secondary)
                }
                ForEach(reads) { read in
                    HStack(alignment: .firstTextBaseline) {
                        Image(systemName: read.isNew ? "sparkles" : "arrow.uturn.backward")
                            .foregroundStyle(read.isNew ? Color.accentColor : Color.secondary)
                            .frame(width: 22)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(read.what)
                            Text(read.instance)
                                .font(.system(.caption, design: .monospaced))
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            } header: {
                Text("Reads")
            } footer: {
                Text("A sparkle marks a new instance; an arrow marks one the container already had.")
            }
        }
        .navigationTitle("Scopes")
        .task {
            guard autoplay, reads.isEmpty else { return }
            try? await dependencies.profileStore.refresh()
            readStore()
            readStore()
            readEditor()
            readEditor()
            startSessions()
        }
    }

    private func readStore() {
        let store = dependencies.profileStore
        log("profileStore", instance: store)
    }

    private func readEditor() {
        let editor = dependencies.profileEditor
        log("profileEditor", instance: editor)
    }

    private func startSessions() {
        for user in Profile.team.prefix(2) {
            let session = SessionDependencies(app: dependencies, user: user)
            log("session.greeting", text: session.greeting, isNew: true)
            log("session.app.profileStore", instance: session.app.profileStore)
        }
    }

    @State private var seen: Set<ObjectIdentifier> = []

    private func log(_ what: String, instance: AnyObject) {
        let identifier = ObjectIdentifier(instance)
        let isNew = seen.insert(identifier).inserted
        let address = String(UInt(bitPattern: identifier.hashValue), radix: 16)
        log(what, text: "\(type(of: instance)) …\(address.suffix(6))", isNew: isNew)
    }

    private func log(_ what: String, text: String, isNew: Bool) {
        reads.append(Read(what: what, instance: text, isNew: isNew))
    }
}
