# Getting started

Add the package, declare a container, create it once and pass it on.

## Add the package

In Xcode, choose **File › Add Package Dependencies…**, enter
`https://github.com/muhittincamdali/SwiftDependencyInjection.git` and add the
**SwiftDependencyInjection** library to your app target. In a `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/muhittincamdali/SwiftDependencyInjection.git", from: "2.0.0")
],
targets: [
    .target(name: "YourApp", dependencies: [
        .product(name: "SwiftDependencyInjection", package: "SwiftDependencyInjection")
    ])
]
```

The package contains a Swift macro, so it builds with swift-syntax. Xcode asks once to trust the
macro (**Trust & Enable**). Recent versions of Swift Package Manager download a prebuilt
swift-syntax for macros when one exists for your toolchain, so the first build does not compile
all of it.

## Declare a container

A container is a final class with `@DependencyContainer`. Each dependency is a computed property
whose getter is one provider call with the key path of that property:

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

- ``DependencyContainer/shared(_:name:_:)`` builds the value on first read and keeps it for the
  life of the container.
- ``DependencyContainer/transient(_:name:_:)`` builds a new value on every read.
- A provider can read other dependencies and stored properties such as `configuration`.

The key path is the key of the instance and fixes its type: `shared(\.api) { DemoServerAPI(…) }`
stores an `any ProfileAPI`, so a test can replace it with another conforming type. The macro
reports an error if the key path names a different property.

Values that come from outside, such as a configuration or the signed-in user, are stored
properties set in `init`. Everything built from them is a dependency.

## Which isolation to choose

Mark the container `@MainActor` when its dependencies are main-actor types such as view models,
stores that drive SwiftUI, or anything created from a view. Its getters then run on the main
actor and its override closures are `@MainActor`.

Leave it nonisolated when its dependencies are `Sendable` services used from many tasks, such as
an HTTP client or a cache. Shared values must be `Sendable` in either case, because one instance
is handed to every reader.

In a module whose default isolation is `MainActor` (the default for new Xcode app projects), write
`@MainActor` on the container explicitly. The macro reads only the source of the class and cannot
see the module setting.

## Create it once, pass it on

Create the app's container where the app starts, and give each object what it needs:

```swift
@main
struct ProfilesApp: App {
    @State private var dependencies = AppDependencies()

    var body: some Scene {
        WindowGroup {
            ProfileList(store: dependencies.profileStore)
        }
    }
}
```

Passing dependencies through initializers keeps every object testable on its own: a test can
build a `ProfileStore` with a stub API without any container. Pass the container itself only to
objects that create other objects on demand, such as a coordinator that builds screens.

## What the compiler checks

`@DependencyContainer` reports these as errors, each with the fix in the message:

- a dependency cycle such as `api → tokens → api`, at the dependency declared first;
- a provider called outside a computed property getter, next to other statements, or with the
  key path of another property;
- a dependency with a setter, an `async` or `throws` getter, or a `some` type;
- `@DependencyContainer` on anything but a final class (with a fix-it that adds `final`).

Reads inside nested closures are not followed, because a callback such as
`Session(onExpiry: { self.session.refresh() })` runs after building has finished. If such a
closure runs during building, the run-time check stops the process with the cycle path.
