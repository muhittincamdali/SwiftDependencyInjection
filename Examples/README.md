# Examples

## DependencyDemo

A small iOS and macOS app built on two containers, `AppDependencies` and a per-user
`SessionDependencies`, with one screen per idea:

- **Live and test dependencies**: loads profiles through a container as the app builds it
  (a simulated server that answers after 600 ms) and through a second container whose `api` is
  replaced with `override(_:)`, and shows which API each one injected and how long it took.
- **Shared, transient and child scopes**: logs every read of `profileStore` (shared, the same
  instance each time), `profileEditor` (transient, a new instance each time) and of two session
  containers that read the app's store through their parent.
- **Dependency graph**: lists the nodes, lifetimes and edges of the `dependencyGraph` that
  `@DependencyContainer` wrote for both containers at compile time, and its Graphviz text.

The app target uses `MainActor` default isolation, as new Xcode app projects do, and its
containers are marked `@MainActor`. It uses the package from this checkout (a local package
reference to `../..`), so it always shows the current code.

Run it:

1. Open `Examples/DependencyDemo/DependencyDemo.xcodeproj` in Xcode 26 or later.
2. Choose the **DependencyDemo** scheme and an iPhone simulator or **My Mac** as the run
   destination.
3. Press **Run** (⌘R). Xcode asks once to trust the package's macro.

From the command line:

```sh
cd Examples/DependencyDemo
xcodebuild build -scheme DependencyDemo -destination 'generic/platform=iOS Simulator' -skipMacroValidation
xcodebuild build -scheme DependencyDemo -destination 'platform=macOS' -skipMacroValidation
```

The README samples live in
[`DependencyDemo/ReadmeSamples.swift`](DependencyDemo/DependencyDemo/ReadmeSamples.swift).
The README copies its code from that file, and the package's test target compiles and runs the
same file through the symlink `Tests/SwiftDependencyInjectionTests/ReadmeSamples.swift`.

The screenshots in the README come from this app:
[`scripts/capture-example-screens.sh`](../scripts/capture-example-screens.sh) opens each screen
with `-demo overrides`, `-demo scopes` or `-demo graph`, lets it play its scenario and takes a
simulator screenshot in light and dark appearance.

The project file is generated from [`project.yml`](DependencyDemo/project.yml) with
[XcodeGen](https://github.com/yonaskolb/XcodeGen); run `xcodegen` in `Examples/DependencyDemo`
after changing it.
