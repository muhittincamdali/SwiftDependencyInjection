<p align="center">
  <img src="https://img.shields.io/badge/Swift-6.0-FA7343?style=for-the-badge&logo=swift&logoColor=white" alt="Swift 6.0"/>
  <img src="https://img.shields.io/badge/Platform-iOS%20|%20macOS%20|%20visionOS-007AFF?style=for-the-badge&logo=apple&logoColor=white" alt="Platform"/>
  <img src="https://img.shields.io/badge/Standard-Unified%20Core-5856D6?style=for-the-badge" alt="Standard"/>
</p>

---

> **🛡️ PART OF THE 2026 UNIFIED CORE**
> This repository is a verified component of 'The Endless March' initiative. Purified for Swift 6, zero-dependency, and engineered for maximum hardware saturation.
> 
> *Flagship Engines:* [SwiftNetwork](https://github.com/muhittincamdali/SwiftNetwork) | [SwiftAI](https://github.com/muhittincamdali/SwiftAI) | [LiquidGlassKit](https://github.com/muhittincamdali/LiquidGlassKit)

---

<h1 align="center">SwiftDependencyInjection</h1>

<p align="center">
  <strong>💉 Compile-time safe dependency injection with Swift macros</strong>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Swift-6.0-orange.svg" alt="Swift"/>
  <img src="https://img.shields.io/badge/iOS-17.0+-blue.svg" alt="iOS"/>
</p>

---

## Features

| Feature | Description |
|---------|-------------|
| 🔒 **Type-Safe** | Compile-time verification |
| ⚡ **No Runtime** | Zero runtime overhead |
| 🏗️ **Scopes** | Singleton, transient, scoped |
| 🧪 **Testable** | Easy mock injection |
| 📦 **Macros** | Swift 5.9+ macros |

## Quick Start

```swift
import SwiftDI

// Define dependencies
@Module
struct AppModule {
    @Singleton
    func provideNetworkService() -> NetworkService {
        URLSessionNetworkService()
    }
    
    @Singleton
    func provideUserRepository(network: NetworkService) -> UserRepository {
        UserRepositoryImpl(network: network)
    }
    
    @Transient
    func provideUserViewModel(repo: UserRepository) -> UserViewModel {
        UserViewModel(repository: repo)
    }
}

// Inject
@Inject var viewModel: UserViewModel

// Or explicit
let viewModel = Container.resolve(UserViewModel.self)
```

## Scopes

```swift
@Singleton // One instance
@Transient // New instance each time
@Scoped("session") // Per scope lifetime
```

## Property Injection

```swift
class MyViewController: UIViewController {
    @Inject var viewModel: MyViewModel
    @Inject var analytics: AnalyticsService
}
```

## Testing

```swift
// Override for tests
Container.register(UserRepository.self) {
    MockUserRepository()
}
```

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md).

## License

MIT License

---

## 📈 Star History

<a href="https://star-history.com/#muhittincamdali/SwiftDependencyInjection&Date">
 <picture>
   <source media="(prefers-color-scheme: dark)" srcset="https://api.star-history.com/svg?repos=muhittincamdali/SwiftDependencyInjection&type=Date&theme=dark" />
   <source media="(prefers-color-scheme: light)" srcset="https://api.star-history.com/svg?repos=muhittincamdali/SwiftDependencyInjection&type=Date" />
   <img alt="Star History Chart" src="https://api.star-history.com/svg?repos=muhittincamdali/SwiftDependencyInjection&type=Date" />
 </picture>
</a>
