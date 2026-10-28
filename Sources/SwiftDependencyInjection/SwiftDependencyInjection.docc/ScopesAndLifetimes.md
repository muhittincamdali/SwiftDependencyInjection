# Scopes and lifetimes

How long a dependency lives, how child containers model a session, and what the graph shows.

## Shared and transient

A **shared** dependency is built on its first read and kept until the container is released.
The storage holds one recursive lock while a provider runs, so when many threads read the property
at the same time the provider runs once and every reader gets the same instance. Providers may read
other dependencies of the same container while the lock is held.

A **transient** dependency is built on every read. Use it for objects with their own state, such
as a model for one screen. It can still be overridden and takes part in the cycle check, which a
plain computed property does not.

A plain computed property without a provider is not a dependency: it is not cached, not in the
`Overrides`, and not a node in the graph. The macro still follows its reads when it looks for
cycles.

## The container is the scope

There is no global container. Each instance of a container class owns its instances and
overrides, and releases them when it is released. That makes scoping a matter of creating a
container where the scope starts:

```swift
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
```

Create a `SessionDependencies` when a user signs in and drop it when they sign out. Its shared
instances live as long as the session; the app-wide ones are read through `app` and stay shared
by every session. The user is a non-optional stored property, so nothing in the session has to
handle a missing user.

## Building inside a provider

A provider runs while its container's lock is held. Keep providers to construction: build the
object and return it. Work that waits, such as loading data, belongs in a method the app calls
afterwards (`try await store.refresh()`), not in the provider. A provider that blocks waiting
for another thread that reads the same container would deadlock, as with any lock.

## Cycles

A cycle is a provider that needs itself while it is being built: `api` reads `tokens`, which
reads `api`. The macro reports it at compile time:

```
error: Dependency cycle: api → tokens → api. 'api' needs itself while it is being built; pass one
side a closure that reads the other later, or move the shared part into its own dependency
```

The macro follows reads of the container's properties in providers and plain computed properties.
It does not follow reads in nested closures, local functions or methods. When such a read runs
during building, the storage sees the same dependency requested twice and stops the process with
`dependency cycle in AppDependencies: api → tokens → api` instead of recursing until the stack
overflows.

## The dependency graph

Each container gets a static `dependencyGraph` (``DependencyGraph``) written at compile time: the
dependencies in declaration order with their type and lifetime, and an edge for each dependency a
provider reads, directly or through plain computed properties.

```swift
let graph = AppDependencies.dependencyGraph
graph.dependencies(of: "profileStore")   // ["api"]
graph.dependents(of: "profileStore")     // ["profileEditor"]
print(graph.dotDescription)              // Graphviz DOT
```

Use it to document a container, or in a test that checks the wiring does not change by accident.
