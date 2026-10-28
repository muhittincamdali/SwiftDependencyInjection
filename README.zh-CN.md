<!-- i18n-source: README.md@db0ca6cfacb99492bf497614f3316a072a7016fa status=reviewed -->
<!-- brand:start -->

<p align="center"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/banner-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/banner-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/banner-light.svg" alt="SwiftDependencyInjection: Dependency containers for Swift 6 that the compiler checks, with typed test overrides and no global state."></picture></p>

<!-- lang-selector:start -->
<p align="center"><a href="README.md">English</a> · <a href="README.tr.md">Türkçe</a> · <a href="README.zh-CN.md">简体中文</a> · <a href="README.ja.md">日本語</a> · <a href="README.ko.md">한국어</a> · <a href="README.es.md">Español</a> · <a href="README.de.md">Deutsch</a> · <a href="README.fr.md">Français</a> · <a href="README.pt-BR.md">Português (Brasil)</a> · <a href="README.ru.md">Русский</a></p>
<!-- lang-selector:end -->

<p align="center">
<a href="https://github.com/muhittincamdali/SwiftDependencyInjection/actions/workflows/ci.yml"><img src="https://github.com/muhittincamdali/SwiftDependencyInjection/actions/workflows/ci.yml/badge.svg" alt="CI 状态"></a>
<a href="https://github.com/muhittincamdali/SwiftDependencyInjection/releases"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/badge-version-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/badge-version-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/badge-version-light.svg" alt="最新版本: v1.0.0"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftDependencyInjection/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/badge-platforms-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/badge-platforms-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/badge-platforms-light.svg" alt="支持的平台: iOS 16+ · macOS 13+ · tvOS 16+ · watchOS 9+ · visionOS 1+"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftDependencyInjection/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/badge-language-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/badge-language-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/badge-language-light.svg" alt="语言版本: Swift 6.2+ · Swift 6 mode"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftDependencyInjection/blob/main/LICENSE"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/badge-license-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/badge-license-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/badge-license-light.svg" alt="许可证: MIT"></picture></a>
</p>

<p align="center">
<a href="#快速开始"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/button-start-zh-CN-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/button-start-zh-CN-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/button-start-zh-CN-light.svg" alt="开始使用"></picture></a>
<a href="https://muhittincamdali.github.io/SwiftDependencyInjection/documentation/swiftdependencyinjection/"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/button-docs-zh-CN-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/button-docs-zh-CN-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/button-docs-zh-CN-light.svg" alt="文档"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftDependencyInjection/tree/main/Examples"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/button-examples-zh-CN-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/button-examples-zh-CN-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/button-examples-zh-CN-light.svg" alt="示例"></picture></a>
</p>

> 本文是英文 README 的译文。如两者内容不一致，以英文版为准。

<!-- brand:end -->

SwiftDependencyInjection 是面向 Swift 6 的手动依赖注入库，重复的部分由它为你生成。你把依赖写成同一个 final class 的计算属性；`@DependencyContainer` 宏会把它变成容器：每个 `shared` 依赖只构建一次，并以线程安全的方式缓存；每个 `transient` 依赖在每次读取时都会重新构建；测试可以通过生成的、带类型的 `override` 替换其中任何一个；依赖循环会直接成为编译错误。这里没有全局容器，也没有可能在运行时失败的查找：依赖就是属性，缺少依赖的代码无法通过编译。

## 亮点

- **由编译器检查** — 依赖就是属性，因此缺少依赖或类型错误都会成为编译错误。宏会报告循环（`api → tokens → api`）、位置不对的 provider，以及 override 无法替换的依赖，每条消息都附带修复方法。
- **带类型的测试 override** — 每个容器都会得到一个 `Overrides` 结构体，每个依赖对应一个字段，类型与属性一致：`$0.api = { StubProfileAPI(…) }`。
- **没有全局状态** — 实例和 override 都属于某一个容器实例。各自创建容器的测试可以并行运行；子容器就是一个作用域，例如已登录的用户。
- **Swift 6 并发** — 即使有许多线程同时读取，shared 依赖也只会构建一次。`@MainActor` 容器得到 `@MainActor` 的 override，其他容器得到 `@Sendable` 的 override。
- **运行时同样能发现循环** — 宏看不到的循环（经由方法或闭包形成的）会让进程带着同样的路径信息停止，而不是栈溢出。
- **可以阅读的依赖图** — 每个容器都有一个在编译时生成的 `dependencyGraph`，并支持 Graphviz 输出。

## 快速开始

**1. 添加软件包**

在 Xcode 中选择 **File › Add Package Dependencies…**，然后输入仓库地址：

```text
https://github.com/muhittincamdali/SwiftDependencyInjection.git
```

**2. 导入模块**

```swift
import SwiftDependencyInjection
```

**3. 声明容器**

每个依赖都是一个计算属性，它的 getter 就是一次 `shared` 或 `transient` 调用，并传入该属性自身的 key path
（[ReadmeSamples.swift](Examples/DependencyDemo/DependencyDemo/ReadmeSamples.swift)）：

```swift
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

只需创建一次容器，然后读取需要的依赖：`AppDependencies().profileStore` 会在首次使用时构建 API 和 store，之后返回同一个 store。key path 让每个实例具有其属性的类型，因此 `api` 以 `any ProfileAPI` 存储，测试可以用任何其他符合该协议的类型替换它。

## 安装

### Swift Package Manager

在 Xcode 中选择 **File › Add Package Dependencies…**，然后输入仓库地址：

```text
https://github.com/muhittincamdali/SwiftDependencyInjection.git
```

或者将其添加到 `Package.swift` 的 `dependencies` 中：

```swift
dependencies: [
    .package(url: "https://github.com/muhittincamdali/SwiftDependencyInjection.git", branch: "main")
],
targets: [
    .target(name: "YourApp", dependencies: [
        .product(name: "SwiftDependencyInjection", package: "SwiftDependencyInjection")
    ])
]
```

该软件包包含一个 Swift 宏，因此 Xcode 会请你确认一次信任（**Trust & Enable**），构建时使用 [swift-syntax](https://github.com/swiftlang/swift-syntax)（602 至 604）。

## 使用方法

下面的示例复制自示例应用所构建的
[`ReadmeSamples.swift`](Examples/DependencyDemo/DependencyDemo/ReadmeSamples.swift) 和
[`DependencyDemoApp.swift`](Examples/DependencyDemo/DependencyDemo/DependencyDemoApp.swift)，以及测试套件所运行的
[`ReadmeSamplesTests.swift`](Tests/SwiftDependencyInjectionTests/ReadmeSamplesTests.swift)。

### 只创建一次容器

应用拥有自己的容器，并把容器或所需的依赖向下传递：

```swift
@main
struct DependencyDemoApp: App {
    /// The app-wide container: created once, when the scene starts, and passed down.
    @State private var dependencies = AppDependencies()

    var body: some Scene {
        WindowGroup {
            ContentView(dependencies: dependencies, initialDemo: Demo.fromLaunchArguments())
                .tint(Color(red: 0.04, green: 0.52, blue: 1.0))
        }
    }
}
```

对象通过初始化方法获得依赖（`ProfileStore(api:)`），因此每个对象在测试中也可以脱离容器单独构建。

### 在测试中替换依赖

`override(_:)` 接收一个闭包，用来设置生成的 `Overrides` 的字段；保持为 `nil` 的字段沿用真实依赖。真实的 `profileStore` provider 会运行，并读取 stub：

```swift
let dependencies = AppDependencies()
dependencies.override {
    $0.api = { StubProfileAPI(profiles: [Profile(id: 1, name: "Ada", role: "Analyst")]) }
}

let store = dependencies.profileStore
try await store.refresh()

#expect(store.profiles.map(\.name) == ["Ada"])
```

每个测试都创建自己的容器，因此 override 不会在测试之间泄漏，Swift Testing 可以并行运行这些测试。预览使用同样的调用。

### 将依赖限定在一次会话内

一个容器实例就是一个作用域。子容器把父容器和该作用域的值保存为存储属性，因此其中的代码无需处理“用户不存在”的情况：

```swift
@MainActor
@DependencyContainer
final class SessionDependencies {
    let app: AppDependencies
    let user: Profile

    init(app: AppDependencies, user: Profile) {
        self.app = app
        self.user = user
    }

    var greeting: String {
        shared(\.greeting) { "Signed in as \(user.name), \(app.profileStore.profiles.count) colleagues loaded" }
    }
}
```

用户登录时创建一个，退出登录时释放它；它的 shared 实例随之释放，而 `app.profileStore` 仍由所有会话共享。

### 让编译器发现循环

需要自身的 provider（无论是直接还是通过其他依赖）无法通过编译：

```swift
var api: any ProfileAPI {
    shared(\.api) { TokenRefreshingAPI(tokens: tokens) }
}

var tokens: TokenStore {
    shared(\.tokens) { TokenStore(api: api) }
}
```

```text
error: Dependency cycle: api → tokens → api. 'api' needs itself while it is being built; pass one
side a closure that reads the other later, or move the shared part into its own dependency
```

[`DiagnosticTests.swift`](Tests/SwiftDependencyInjectionMacrosTests/DiagnosticTests.swift) 用宏展开这个示例，并逐字检查错误文本。

嵌套闭包内的读取不会被跟踪，因为回调通常在构建完成之后才运行。如果这样的闭包在构建过程中运行，容器会以 `dependency cycle in AppDependencies: api → tokens → api` 停止进程，而不是栈溢出。

## 演示

[DependencyDemo](Examples/DependencyDemo) 应用用真实的库演示每一个想法。截图取自 iOS 27 模拟器中的这个应用，由 [`scripts/capture-example-screens.sh`](scripts/capture-example-screens.sh) 截取：

| 真实 API 与 override 后的 API | Shared、transient 与会话 | 生成的依赖图 |
| --- | --- | --- |
| <picture><source media="(prefers-color-scheme: dark)" srcset="docs/images/demo-overrides-dark.png"><img src="docs/images/demo-overrides-light.png" width="260" alt="两个容器加载资料：真实的容器注入了 DemoServerAPI，耗时约 600 毫秒；被 override 的容器注入了 StubProfileAPI"></picture> | <picture><source media="(prefers-color-scheme: dark)" srcset="docs/images/demo-scopes-dark.png"><img src="docs/images/demo-scopes-light.png" width="260" alt="读取日志：profileStore 两次返回同一个实例，profileEditor 每次返回新实例，两个会话共享应用的 store"></picture> | <picture><source media="(prefers-color-scheme: dark)" srcset="docs/images/demo-graph-dark.png"><img src="docs/images/demo-graph-light.png" width="260" alt="AppDependencies 和 SessionDependencies 的依赖，以及它们的生命周期和彼此之间的读取"></picture> |

要运行它，请用 Xcode 26 或更高版本打开 [Examples/DependencyDemo](Examples/DependencyDemo) 中的 `DependencyDemo.xcodeproj`，选择 iPhone 模拟器或 **My Mac**，然后点击 **Run**。[Examples/README.md](Examples/README.md) 介绍了每个界面。

## 何时应选择 Factory 或 swift-dependencies

[Factory](https://github.com/hmlongco/Factory) 和
[swift-dependencies](https://github.com/pointfreeco/swift-dependencies) 是使用最广泛的 Swift 依赖注入库，它们能做到这个软件包做不到的事：

- **选择 Factory**：想通过 `@Injected` 在任何地方注入而无需传递容器，需要带参数的 factory、更多作用域（cached、weak shared、graph、custom）、decorator，以及能为预览、测试和调试构建自动切换实现的 context。
- **选择 swift-dependencies**：配合 The Composable Architecture 使用，希望时钟、日期和 UUID 等依赖通过 task local 到达任何代码，或者希望测试中对某个依赖的意外使用直接导致测试失败。
- **选择 [SafeDI](https://github.com/dfed/SafeDI)**：想借助生成的初始化方法和 mock，在编译时跨模块验证整个对象图。
- **选择本软件包**：想要显式的构造函数注入，每个作用域一个容器类，带类型的 override，以及由编译器报告的循环。

文章
[Choosing a dependency injection library](https://muhittincamdali.github.io/SwiftDependencyInjection/documentation/swiftdependencyinjection/choosingadependencyinjectionlibrary)
逐项比较了它们，并列出了本软件包的局限。

## 文档

API 参考文档与文章：

- [SwiftDependencyInjection 参考](https://muhittincamdali.github.io/SwiftDependencyInjection/documentation/swiftdependencyinjection/)
- [入门](https://muhittincamdali.github.io/SwiftDependencyInjection/documentation/swiftdependencyinjection/gettingstarted)
- [使用 override 进行测试](https://muhittincamdali.github.io/SwiftDependencyInjection/documentation/swiftdependencyinjection/testingwithoverrides)
- [作用域与生命周期](https://muhittincamdali.github.io/SwiftDependencyInjection/documentation/swiftdependencyinjection/scopesandlifetimes)
- [选择依赖注入库](https://muhittincamdali.github.io/SwiftDependencyInjection/documentation/swiftdependencyinjection/choosingadependencyinjectionlibrary)

## 指南

- [入门](Sources/SwiftDependencyInjection/SwiftDependencyInjection.docc/GettingStarted.md)
  — 声明容器、选择隔离方式、向下传递依赖，以及编译器会检查什么。
- [使用 override 进行测试](Sources/SwiftDependencyInjection/SwiftDependencyInjection.docc/TestingWithOverrides.md)
  — override 如何带类型、限定作用域、缓存和隔离，以及如何在预览中使用。
- [作用域与生命周期](Sources/SwiftDependencyInjection/SwiftDependencyInjection.docc/ScopesAndLifetimes.md)
  — shared 与 transient、子容器、循环和依赖图。
- [选择依赖注入库](Sources/SwiftDependencyInjection/SwiftDependencyInjection.docc/ChoosingADependencyInjectionLibrary.md)
  — Factory、swift-dependencies、SafeDI 与本软件包并排对比。

## 系统要求

| 平台 | 最低版本 |
| --- | --- |
| iOS | 16 |
| macOS | 13 |
| tvOS | 16 |
| watchOS | 9 |
| visionOS | 1 |
| 工具链 | Swift 6.2 · Xcode 26+ |

## 架构

软件包包含一个库和一个宏 target：

| Target | 内容 |
| --- | --- |
| `SwiftDependencyInjection` | `DependencyContainer`（带有 `shared` 和 `transient` 的协议）、`DependencyStorage`、`DependencyGraph`，以及 `@DependencyContainer` 的声明 |
| `SwiftDependencyInjectionMacros` | 宏：读取类的主体，生成成员，发现循环并报告误用 |

设计决策：

- **用属性，而不是注册。** 依赖是计算属性，因此编译器会检查每一处使用。启动时不注册任何东西，所以运行时也就不会缺少任何东西。
- **key path 就是键。** `shared(\.api)` 以其属性的 key path 为键存储实例，同时把实例类型固定为属性的类型，因此符合该协议的其他类型的 override 也能适用，两个属性也绝不会共用同一个条目。
- **每个容器一把递归锁。** provider 运行期间持有该锁：shared 依赖只会构建一次，provider 之间可以互相读取，而正在构建的调用链同时也是运行时的循环检查。
- **override 是生成的，而不是按名称存储的。** 宏为每个依赖写出一个带类型的字段，并让闭包沿用容器的隔离方式。
- **容器就是作用域。** 没有全局状态，意味着测试之间无需重置，也没有隐藏的生命周期：容器的实例与该容器的存活时间完全一致。

## 路线图

- 可以像属性一样被 override 的带参数依赖（`func editor(for: Profile)`）。
- 可选的弱引用生命周期：有对象持有时只有一个实例，之后重新构建。
- 记录一次解析过程中构建了哪些依赖的跟踪功能，便于调试大型容器。

## 参与贡献

欢迎参与贡献。提交 pull request 之前，请先阅读[贡献指南](https://github.com/muhittincamdali/SwiftDependencyInjection/blob/main/CONTRIBUTING.md)和[行为准则](https://github.com/muhittincamdali/SwiftDependencyInjection/blob/main/CODE_OF_CONDUCT.md)。如发现安全问题，请按照[安全策略](https://github.com/muhittincamdali/SwiftDependencyInjection/blob/main/SECURITY.md)私下报告。

## 许可证

基于 MIT 许可证发布。详见 [LICENSE](LICENSE)。
