<p align="center">
  <img src="Assets/logo.png" alt="SwiftDependencyInjection" width="200"/>
</p>

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
