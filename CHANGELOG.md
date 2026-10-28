# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [2.0.0] - 2026-10-28

### Added

- `@DependencyContainer`, a macro for final classes that list their dependencies as computed
  properties. It adds the `DependencyContainer` conformance and its storage, a nested
  `Overrides` struct with one typed field per dependency and an `override(_:)` method to apply
  it, and a static `dependencyGraph`.
- `DependencyContainer.shared(_:name:_:)`, which builds a dependency once per container (exactly
  once when many threads read it), and `transient(_:name:_:)`, which builds it on every read.
  Both take the key path of their property, which is the storage key and fixes the stored type
  to the property's type.
- Compile-time errors for dependency cycles (once per cycle, with the shortest path), providers
  outside a computed property getter, next to other statements or with another property's key
  path, dependencies with a setter, an `async` or `throws` getter or a `some` type, dependencies
  declared inside `#if`, and for `@DependencyContainer` on anything but a final class (with a
  fix-it that adds `final`).
- A run-time cycle check for cycles the macro cannot see (through methods or closures that run
  at once): the process stops with the path instead of overflowing the stack.
- Override closures that are `@MainActor` for a `@MainActor` container and `@Sendable`
  otherwise.
- `DependencyGraph` with the dependencies, their lifetimes and the reads between them, and
  Graphviz output.
- A DocC catalog with the articles "Getting started", "Testing with overrides", "Scopes and
  lifetimes" and "Choosing a dependency injection library", published to GitHub Pages.
- `Examples/DependencyDemo`, an iOS and macOS app with live and overridden containers, a log of
  shared, transient and session reads, and the generated graph. The README samples live in its
  `ReadmeSamples.swift`, which the test suite compiles and runs.
- CI through the shared workflows of `muhittincamdali/.github`: `swift test` on macOS, builds
  for iOS, macOS, tvOS, watchOS and visionOS, tests on an iOS simulator, the example app,
  DocC, link, hygiene and translation checks.

### Changed

- The package is rewritten for Swift 6.2 and the Swift 6 language mode, with swift-syntax 602 to
  604 for the macro. Nothing from the 1.x API is kept.

### Removed

- The June 2026 placeholder sources: the `DIContainer` actor, the `@Inject` property wrapper
  (which stopped the program on every read), the `AutoWirable` protocol, and the retry, circuit
  breaker, event bus and metrics helpers.
- CocoaPods support: the package ships a Swift macro, which CocoaPods cannot build.
- The release workflow; releases are created by hand.

## [1.0.0] - 2026-02-03

First release: a dependency container with scoped, lazy and hierarchical injection.

[Unreleased]: https://github.com/muhittincamdali/SwiftDependencyInjection/compare/v2.0.0...HEAD
[2.0.0]: https://github.com/muhittincamdali/SwiftDependencyInjection/compare/v1.0.0...v2.0.0
[1.0.0]: https://github.com/muhittincamdali/SwiftDependencyInjection/releases/tag/v1.0.0
