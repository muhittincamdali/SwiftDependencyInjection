# Testing with overrides

Replace dependencies of one container with test doubles, without shared state between tests.

## Overview

`@DependencyContainer` generates a nested `Overrides` struct with one optional closure per
dependency, typed like the property, and an `override(_:)` method that applies it. Each test
creates its own container, so Swift Testing can run the tests in parallel:

```swift
@Test @MainActor
func storeShowsWhatTheAPIReturns() async throws {
    let dependencies = AppDependencies()
    dependencies.override {
        $0.api = { StubProfileAPI(profiles: [Profile(id: 1, name: "Ada", role: "Analyst")]) }
    }

    let store = dependencies.profileStore
    try await store.refresh()

    #expect(store.profiles.map(\.name) == ["Ada"])
}
```

`profileStore` is built by its real provider, which reads `api` and gets the stub. Fields you
leave `nil` keep the real dependency.

## How overrides behave

- **Typed.** `$0.api` accepts a closure that returns `any ProfileAPI`; any other type is a compile
  error, and a misspelled name does not exist.
- **Scoped to one container.** An override changes only the container it was applied to. There is
  no global state to reset after a test.
- **Built like the real one.** An override of a shared dependency runs once and its value is
  cached; an override of a transient dependency runs on every read.
- **Applied before use.** Call `override(_:)` before the dependency is read. If a shared instance
  was already built, it is dropped and the next read builds the replacement; objects that already
  hold the old instance keep it.
- **Isolated like the container.** In a `@MainActor` container the closures are `@MainActor`, so a
  test on the main actor can create main-actor doubles in them. In a nonisolated container they
  are `@Sendable`, because the container may build its dependencies on any thread.

A later `override(_:)` call replaces the closures it sets and leaves the others in place.

## Previews

Previews use the same mechanism:

```swift
#Preview {
    let dependencies = AppDependencies()
    dependencies.override { $0.api = { StubProfileAPI(profiles: Profile.team) } }
    return ProfileList(store: dependencies.profileStore)
}
```

## Overrides that need other dependencies

An override closure receives no arguments. Build what it needs before calling `override(_:)` and
capture it:

```swift
let configuration = AppConfiguration(latency: .zero)
let dependencies = AppDependencies(configuration: configuration)
dependencies.override {
    $0.api = { DemoServerAPI(latency: configuration.latency) }
}
```

Capturing the container itself in an override would create a reference cycle (the container keeps
the closure), so capture the values the closure needs instead.

## Testing without the container

Constructor injection means most objects do not need a container in tests at all:

```swift
let store = ProfileStore(api: StubProfileAPI(profiles: []))
```

Use container overrides when the code under test builds its own dependencies through the
container, or to test the wiring itself.
