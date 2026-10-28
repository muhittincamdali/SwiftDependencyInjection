# Choosing a dependency injection library

What this package does differently from Factory, swift-dependencies and SafeDI, and when one of
them fits better.

## Overview

[Factory](https://github.com/hmlongco/Factory) and
[swift-dependencies](https://github.com/pointfreeco/swift-dependencies) are the most widely used
dependency injection libraries for Swift, and both are mature, well documented and Swift 6 ready.
[SafeDI](https://github.com/dfed/SafeDI) validates a whole object graph at compile time. This
package takes a narrower position:

- **Containers are instances you own.** There is no shared container and no environment that a
  property wrapper reads from. You create a container, pass it or its dependencies on, and the
  container is the scope: its instances and overrides go away with it.
- **The macro checks the container.** Cycles between providers, providers in the wrong place and
  dependencies an override could not replace are compile errors with the fix in the message.
- **Overrides are generated and typed.** Each container gets an `Overrides` struct with one field
  per dependency, isolated like the container (`@MainActor` or `@Sendable`).
- **Small.** One protocol, one macro, one storage class; no build tool plugin, no generated
  files, no property wrappers.

## Compared feature by feature

|                                 | SwiftDependencyInjection                                | Factory                                        | swift-dependencies                       | SafeDI                                     |
| ------------------------------- | ------------------------------------------------------- | ---------------------------------------------- | ---------------------------------------- | ------------------------------------------ |
| Where dependencies live         | Container instances you create                          | `Container.shared` and custom containers       | Task-local `DependencyValues`            | Generated initializers of your types       |
| How a type gets one             | Initializer parameter or container property             | `@Injected` property wrapper or container call | `@Dependency` property wrapper           | `@Instantiated`, `@Received`, `@Forwarded` |
| Missing dependency              | Compile error                                           | Compile error (every factory has a default)    | Compile error for keys with a live value | Compile error (build plugin)               |
| Dependency cycles               | Compile error in one container, run-time stop otherwise | Run-time check in debug builds                 | Not applicable (no object graph)         | Compile error across the graph             |
| Test isolation                  | One container per test                                  | `.container` test trait                        | `.dependencies` test trait               | Generated `mock()` per root                |
| Contexts (preview, test, debug) | Write the override yourself                             | Built in                                       | Built in (`testValue`, `previewValue`)   | Mocks for previews                         |
| Built-in dependencies           | None                                                    | None                                           | Clock, date, UUID, random and more       | None                                       |
| Code generation                 | One attached macro                                      | None (macros in progress)                      | Macros for clients                       | Macros and a build tool plugin             |

The rows describe each library's main documented approach, as of October 2026.

## When to choose another library

Choose **Factory** when you want to inject from anywhere with a property wrapper, without passing
a container through initializers; when you need parameterized factories, more scopes (cached,
weak shared, graph, custom), decorators or contexts that switch implementations for previews,
tests and debug builds automatically; or when you want a widely used library with no
swift-syntax dependency.

Choose **swift-dependencies** when you use The Composable Architecture or Point-Free's other
libraries; when dependencies such as the clock, the date and UUID generation should flow into
any code through task locals, including escaping async work; or when you want `testValue` to make
an unexpected use of a dependency fail the test.

Choose **SafeDI** when you want the whole object graph across many types and modules validated at
compile time, with initializers and mocks generated for you, and accept a build tool plugin.

Choose **this package** when you want manual dependency injection with the repetitive parts
generated: dependencies in one class, passed explicitly, scoped by the container instance,
replaced through typed overrides, with cycles found by the compiler.

## Limits of this package

- The cycle check sees one container's source. Reads through methods, nested closures and other
  containers are checked at run time, when the cycle happens.
- There are no parameterized dependencies. Write a method that takes the parameter and builds
  the object from dependencies; it is not cached and not in `Overrides`.
- Providers are synchronous. Start asynchronous work from a method after building.
- The macro needs to know the container's isolation from its source; in a module with
  `MainActor` default isolation, write `@MainActor` on the container.
