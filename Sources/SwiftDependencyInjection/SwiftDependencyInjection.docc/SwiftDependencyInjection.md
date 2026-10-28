# ``SwiftDependencyInjection``

Dependency containers you own, checked by the compiler: one macro adds thread-safe caching, typed
test overrides and a compile-time cycle check to a plain Swift class.

## Overview

A container is a final class that lists its dependencies as computed properties. The getter of
each one is a single ``DependencyContainer/shared(_:name:_:)`` call, for one instance per
container, or ``DependencyContainer/transient(_:name:_:)``, for a new instance on every read:

```swift
import SwiftDependencyInjection

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
```

The app creates the container once and passes it, or the dependencies it needs, to the objects
that use them. A test creates its own container and replaces what it needs:

```swift
let dependencies = AppDependencies()
dependencies.override {
    $0.api = { StubProfileAPI(profiles: [Profile(id: 1, name: "Ada", role: "Analyst")]) }
}
```

What this gives you:

- **No lookup that can fail.** A dependency is a property, so a missing one or a wrong type does
  not compile. There is no registration step and no global container.
- **Cycles are compile errors.** ``DependencyContainer()`` follows the reads between providers and
  reports `api → session → api` at the property where the cycle starts. Cycles it cannot see, such
  as one through a method, stop the process with the same path instead of overflowing the stack.
- **Swift 6 concurrency.** A shared dependency is built exactly once when many threads read it.
  A container marked `@MainActor` gets `@MainActor` override closures; any other container gets
  `@Sendable` ones.
- **Tests that run in parallel.** Instances and overrides belong to one container instance, so
  two tests with their own containers never see each other's replacements.

## Topics

### Essentials

- <doc:GettingStarted>
- ``DependencyContainer()``
- ``DependencyContainer``

### Tests and previews

- <doc:TestingWithOverrides>

### Lifetimes and scopes

- <doc:ScopesAndLifetimes>
- ``DependencyGraph``

### Choosing a library

- <doc:ChoosingADependencyInjectionLibrary>

### Storage

- ``DependencyStorage``
