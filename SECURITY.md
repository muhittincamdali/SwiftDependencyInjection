# Security policy

## Supported versions

Security fixes go into the latest release and the `main` branch.

## Reporting a vulnerability

Report it privately, not in a public issue: open the repository's
[Security tab](https://github.com/muhittincamdali/SwiftDependencyInjection/security) and choose
**Report a vulnerability**, or follow the other channels in the
[security policy of the muhittincamdali repositories](https://github.com/muhittincamdali/.github/blob/main/SECURITY.md).
Include a small program or test that shows the problem and the Swift, Xcode and OS versions you
ran it on.

## What SwiftDependencyInjection promises

SwiftDependencyInjection runs inside your app and handles only the closures you give it. These
are the properties a report can hold it to:

- It does not log, print, store or send anything. The only text it produces is the message of
  a dependency cycle, which names the container type and the dependencies involved and is
  passed to `fatalError`.
- Memory is bounded by your declarations: a container keeps at most one instance and one
  override per dependency property, and the chain of dependencies being built is no deeper than
  the number of dependencies, because a dependency that is requested again while it is being
  built stops the process instead of recursing.
- A shared dependency is built exactly once per container, also when many threads read it at
  the same time; everything a container stores is guarded by one lock.
- Overrides never cross containers: an override is stored in the container it was applied to.
- The macro runs at build time on the source of the class it is attached to. It reads no files,
  environment or network, and the code it generates calls only the public API of the library.

Providers run while their container's lock is held. A provider that blocks waiting for another
thread that reads the same container deadlocks, as with any lock; keep providers to building
objects.
