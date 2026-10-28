# Contributing to SwiftDependencyInjection

Thank you for helping. This guide covers what you need to build, test and change the package.

## Ground rules

- Be kind; the [code of conduct](CODE_OF_CONDUCT.md) applies everywhere in the project.
- Report security problems privately, as described in [SECURITY.md](SECURITY.md).
- Open an issue before a large change, so we can agree on the API first.

## Set up

You need Xcode 26 or later (Swift 6.2).

```sh
git clone https://github.com/muhittincamdali/SwiftDependencyInjection.git
cd SwiftDependencyInjection
swift build
swift test
```

Open `Package.swift` in Xcode to work on the library and the macro, and
`Examples/DependencyDemo/DependencyDemo.xcodeproj` to run the example app.

## Checks to run before a pull request

```sh
swift test                                    # macOS: library, macro and exit tests
xcodebuild test -scheme SwiftDependencyInjection-Tests -skipMacroValidation \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro'
xcodebuild docbuild -scheme SwiftDependencyInjection -destination 'generic/platform=macOS'
xcodebuild build -project Examples/DependencyDemo/DependencyDemo.xcodeproj \
  -scheme DependencyDemo -destination 'generic/platform=iOS Simulator' -skipMacroValidation
```

The `SwiftDependencyInjection-Tests` scheme leaves out the macro tests: Xcode builds a target
that depends on a macro for the Mac, so it cannot run on a simulator. `swift test` runs them.
CI runs the same steps, builds for tvOS, watchOS and visionOS, and checks links.

## Writing code

- The library compiles in the Swift 6 language mode without warnings; shared values are
  `Sendable`.
- Every macro diagnostic says what is wrong and how to fix it, and has a test in
  `Tests/SwiftDependencyInjectionMacrosTests`.
- The macro must not report an error for valid code. When a check cannot be exact (reads in
  nested closures, shadowed names), it stays silent and leaves the case to the run-time check.
- Generated code calls only the public API of the library and uses fully qualified names
  (`SwiftDependencyInjection.DependencyStorage`).
- Document every public symbol; `xcodebuild docbuild` must report no warnings.

## Writing tests

- Use Swift Testing. Macro expansions are checked with `assertContainerExpansion` (a full
  snapshot) or `expandContainer` (diagnostics and single members) from
  `Tests/SwiftDependencyInjectionMacrosTests/Support.swift`.
- Runtime behaviour is tested through real containers declared with the macro in
  `Tests/SwiftDependencyInjectionTests/Fixtures.swift`. Process-stopping failures are tested
  with exit tests, which run on macOS.
- Test the edge cases: concurrent first reads, overrides after a value was built, main-actor
  containers, backticked names, and cycles through methods and closures.

## README samples

The README's code comes from `Examples/DependencyDemo/DependencyDemo/ReadmeSamples.swift`, which
the tests compile through a symlink, from `DependencyDemoApp.swift` and from
`Tests/SwiftDependencyInjectionTests/ReadmeSamplesTests.swift`. Change the sample there first,
then copy it into the README. Regenerate the screenshots with
`scripts/capture-example-screens.sh` when a demo screen changes.

## Commits and pull requests

- Use [Conventional Commits](https://www.conventionalcommits.org/) (`feat:`, `fix:`, `docs:`,
  `test:`, `ci:`), one change per commit, with a body that says why.
- Add a line to the `Unreleased` section of [CHANGELOG.md](CHANGELOG.md) for every change a
  user would notice.
