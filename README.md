<div align="center">

# 💉 SwiftDependencyInjection

**Compile-time safe dependency injection with Swift macros**

[![Swift](https://img.shields.io/badge/Swift-5.9+-F05138?style=for-the-badge&logo=swift&logoColor=white)](https://swift.org)
[![iOS](https://img.shields.io/badge/iOS-15.0+-000000?style=for-the-badge&logo=apple&logoColor=white)](https://developer.apple.com/ios/)
[![SPM](https://img.shields.io/badge/SPM-Compatible-FA7343?style=for-the-badge&logo=swift&logoColor=white)](https://swift.org/package-manager/)
[![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)](LICENSE)

</div>

---

## ✨ Features

- 🔒 **Compile-Time Safe** — Catch errors at build time
- 🏷️ **Swift Macros** — Modern macro-based API
- 🧪 **Testable** — Easy mock injection
- 📦 **Lightweight** — Minimal runtime overhead
- 🔄 **Scopes** — Singleton, transient, scoped

---

## 🚀 Quick Start

```swift
import SwiftDependencyInjection

// Register
@Module
struct AppModule {
    @Provides static func provideUserService() -> UserService {
        UserServiceImpl()
    }
}

// Inject
class ProfileViewModel {
    @Inject var userService: UserService
}

// Test with mock
Container.shared.register(MockUserService(), for: UserService.self)
```

---

## 📄 License

MIT • [@muhittincamdali](https://github.com/muhittincamdali)
