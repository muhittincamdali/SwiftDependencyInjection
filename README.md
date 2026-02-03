# SwiftDependencyInjection

[![Swift](https://img.shields.io/badge/Swift-5.9+-orange.svg)](https://swift.org)
[![Platforms](https://img.shields.io/badge/Platforms-iOS%2015+%20|%20macOS%2013+-blue.svg)](https://developer.apple.com)
[![SPM](https://img.shields.io/badge/SPM-compatible-brightgreen.svg)](https://swift.org/package-manager)
[![License](https://img.shields.io/badge/License-MIT-lightgrey.svg)](LICENSE)

A lightweight, type-safe dependency injection container for Swift. Built with modern concurrency in mind — supports `@Inject` property wrappers, module-based registration, scoped lifetimes, and circular dependency detection out of the box.

---

## Features

| Feature | Description |
|---------|-------------|
| 🏗️ **Type-Safe Resolution** | Compile-time safety with runtime flexibility |
| 💉 **Property Wrappers** | `@Inject` and `@LazyInject` for clean syntax |
| 🔄 **Scoped Lifetimes** | Singleton, transient, and weak reference scopes |
| 📦 **Module System** | Group related registrations into reusable modules |
| 🧵 **Thread Safety** | Actor-based container for concurrent access |
| 🔍 **Circular Detection** | Catches dependency cycles before they crash |
| 🎨 **SwiftUI Support** | Environment integration for view injection |
| 🏭 **Factory Pattern** | Type-safe factories for parameterized creation |

---

## Installation

### Swift Package Manager

Add this to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/muhittincamdali/SwiftDependencyInjection.git", from: "1.0.0")
]
```

Then add the dependency to your target:

```swift
.target(
    name: "YourApp",
    dependencies: ["SwiftDependencyInjection"]
)
```

Or in Xcode: **File → Add Package Dependencies** and paste the repository URL.

---

## Quick Start

### 1. Define Your Protocols

```swift
protocol NetworkService {
    func fetch(url: URL) async throws -> Data
}

protocol AuthService {
    var isAuthenticated: Bool { get }
    func login(email: String, password: String) async throws
}
```

### 2. Create Implementations

```swift
class URLSessionNetworkService: NetworkService {
    func fetch(url: URL) async throws -> Data {
        let (data, _) = try await URLSession.shared.data(from: url)
        return data
    }
}

class DefaultAuthService: AuthService {
    private let network: NetworkService

    init(network: NetworkService) {
        self.network = network
    }

    var isAuthenticated: Bool { /* ... */ }

    func login(email: String, password: String) async throws {
        // Use network to authenticate
    }
}
```

### 3. Register Dependencies

```swift
import SwiftDependencyInjection

let container = DIContainer.shared

container.register(NetworkService.self, scope: .singleton) {
    URLSessionNetworkService()
}

container.register(AuthService.self, scope: .transient) { resolver in
    DefaultAuthService(network: resolver.resolve(NetworkService.self))
}
```

### 4. Resolve Dependencies

```swift
// Direct resolution
let auth: AuthService = container.resolve(AuthService.self)

// Or use property wrappers
class ProfileViewModel {
    @Inject var authService: AuthService
    @LazyInject var networkService: NetworkService
}
```

---

## Property Wrappers

### @Inject

Resolves the dependency immediately upon initialization:

```swift
class OrderService {
    @Inject var network: NetworkService
    @Inject(name: "v2") var legacyNetwork: NetworkService
}
```

### @LazyInject

Defers resolution until first access — useful for breaking circular dependencies or expensive services:

```swift
class AnalyticsManager {
    @LazyInject var logger: LoggerService

    func track(_ event: String) {
        logger.log(event) // Resolved here on first call
    }
}
```

---

## Scopes

| Scope | Behavior |
|-------|----------|
| `.singleton` | Created once, shared across all resolutions |
| `.transient` | New instance every time |
| `.weak` | Cached with weak reference; recreated if deallocated |

```swift
// Singleton — same instance everywhere
container.register(DatabaseService.self, scope: .singleton) {
    SQLiteDatabase()
}

// Transient — fresh instance each time
container.register(RequestBuilder.self, scope: .transient) {
    RequestBuilder()
}

// Weak — cached until no strong references remain
container.register(ImageCache.self, scope: .weak) {
    ImageCache(maxSize: 50_000_000)
}
```

---

## Modules

Group related registrations into modules for cleaner organization:

```swift
struct NetworkModule: DIModule {
    func register(in container: DIContainer) {
        container.register(NetworkService.self, scope: .singleton) {
            URLSessionNetworkService()
        }

        container.register(APIClient.self, scope: .singleton) { resolver in
            APIClient(network: resolver.resolve(NetworkService.self))
        }
    }
}

struct AuthModule: DIModule {
    func register(in container: DIContainer) {
        container.register(AuthService.self, scope: .transient) { resolver in
            DefaultAuthService(network: resolver.resolve(NetworkService.self))
        }
    }
}

// Register all modules at app launch
container.registerModule(NetworkModule())
container.registerModule(AuthModule())
```

---

## Factory Pattern

Create dependencies that require runtime parameters:

```swift
let userFactory = Factory<User> { container in
    let network = container.resolve(NetworkService.self)
    return User(network: network)
}

container.registerFactory(User.self, factory: userFactory)

// Later
let user = container.resolveFactory(User.self)
```

---

## Thread Safety

For concurrent environments, use the actor-based container:

```swift
let safeContainer = ThreadSafeContainer()

await safeContainer.register(NetworkService.self) {
    URLSessionNetworkService()
}

let network: NetworkService = await safeContainer.resolve(NetworkService.self)
```

---

## SwiftUI Integration

Inject the container into the SwiftUI environment:

```swift
@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .withDIContainer(DIContainer.shared)
        }
    }
}

struct ContentView: View {
    @EnvironmentObject private var container: DIContainer

    var body: some View {
        Text("Hello")
            .onAppear {
                let service: AuthService = container.resolve(AuthService.self)
            }
    }
}
```

---

## Circular Dependency Detection

The built-in dependency graph detects cycles at resolution time:

```swift
// This would be caught:
// A depends on B, B depends on A
container.register(ServiceA.self) { r in ServiceA(b: r.resolve(ServiceB.self)) }
container.register(ServiceB.self) { r in ServiceB(a: r.resolve(ServiceA.self)) }

let a: ServiceA = container.resolve(ServiceA.self)
// ⚠️ Triggers a circular dependency warning in debug builds
```

Use `@LazyInject` to break the cycle intentionally.

---

## Architecture

```
SwiftDependencyInjection/
├── Container/
│   ├── DIContainer.swift       # Core container with register/resolve
│   ├── Scope.swift             # Lifetime management
│   └── Module.swift            # Module-based registration
├── PropertyWrapper/
│   ├── Inject.swift            # @Inject wrapper
│   └── LazyInject.swift        # @LazyInject wrapper
├── Factory/
│   └── Factory.swift           # Factory pattern
├── Registration/
│   ├── ServiceKey.swift        # Type + name composite key
│   └── Registration.swift      # Registration descriptor
├── Thread/
│   └── ThreadSafeContainer.swift  # Actor-based safety
├── Extensions/
│   └── Container+SwiftUI.swift    # SwiftUI environment
└── Graph/
    └── DependencyGraph.swift      # Cycle detection
```

---

## Requirements

- Swift 5.9+
- iOS 15+ / macOS 13+

---

## License

MIT License. See [LICENSE](LICENSE) for details.
