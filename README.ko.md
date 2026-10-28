<!-- i18n-source: README.md@db0ca6cfacb99492bf497614f3316a072a7016fa status=reviewed -->
<!-- brand:start -->

<p align="center"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/banner-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/banner-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/banner-light.svg" alt="SwiftDependencyInjection: Dependency containers for Swift 6 that the compiler checks, with typed test overrides and no global state."></picture></p>

<!-- lang-selector:start -->
<p align="center"><a href="README.md">English</a> · <a href="README.tr.md">Türkçe</a> · <a href="README.zh-CN.md">简体中文</a> · <a href="README.ja.md">日本語</a> · <a href="README.ko.md">한국어</a> · <a href="README.es.md">Español</a> · <a href="README.de.md">Deutsch</a> · <a href="README.fr.md">Français</a> · <a href="README.pt-BR.md">Português (Brasil)</a> · <a href="README.ru.md">Русский</a></p>
<!-- lang-selector:end -->

<p align="center">
<a href="https://github.com/muhittincamdali/SwiftDependencyInjection/actions/workflows/ci.yml"><img src="https://github.com/muhittincamdali/SwiftDependencyInjection/actions/workflows/ci.yml/badge.svg" alt="CI 상태"></a>
<a href="https://github.com/muhittincamdali/SwiftDependencyInjection/releases"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/badge-version-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/badge-version-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/badge-version-light.svg" alt="최신 버전: v1.0.0"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftDependencyInjection/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/badge-platforms-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/badge-platforms-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/badge-platforms-light.svg" alt="지원 플랫폼: iOS 16+ · macOS 13+ · tvOS 16+ · watchOS 9+ · visionOS 1+"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftDependencyInjection/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/badge-language-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/badge-language-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/badge-language-light.svg" alt="언어 버전: Swift 6.2+ · Swift 6 mode"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftDependencyInjection/blob/main/LICENSE"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/badge-license-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/badge-license-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/badge-license-light.svg" alt="라이선스: MIT"></picture></a>
</p>

<p align="center">
<a href="#빠른-시작"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/button-start-ko-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/button-start-ko-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/button-start-ko-light.svg" alt="시작하기"></picture></a>
<a href="https://muhittincamdali.github.io/SwiftDependencyInjection/documentation/swiftdependencyinjection/"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/button-docs-ko-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/button-docs-ko-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/button-docs-ko-light.svg" alt="문서"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftDependencyInjection/tree/main/Examples"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/button-examples-ko-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/button-examples-ko-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/button-examples-ko-light.svg" alt="예제"></picture></a>
</p>

> 이 문서는 영어 README의 번역본입니다. 내용이 다를 경우 영어 버전이 최신입니다.

<!-- brand:end -->

SwiftDependencyInjection은 반복적인 부분을 코드로 생성해 주는 Swift 6용 수동 dependency injection 라이브러리입니다. 의존성을 하나의 final class 안에 computed property로 나열하면 `@DependencyContainer` 매크로가 그 클래스를 컨테이너로 만듭니다. `shared` 의존성은 한 번만 생성되어 스레드 안전하게 캐시되고, `transient` 의존성은 읽을 때마다 새로 생성됩니다. 테스트에서는 생성된 타입 지정 `override`로 어떤 의존성이든 교체할 수 있으며, 의존성 순환은 컴파일 오류가 됩니다. 전역 컨테이너도, 런타임에 실패할 수 있는 조회도 없습니다. 의존성은 곧 프로퍼티이므로 빠진 의존성이 있으면 컴파일되지 않습니다.

## 주요 기능

- **컴파일러가 검사합니다** — 의존성은 프로퍼티이므로 빠졌거나 타입이 틀리면 컴파일 오류가 됩니다. 매크로는 순환(`api → tokens → api`), 잘못된 위치의 provider, override로 교체할 수 없는 의존성을 보고하며, 모든 메시지에 해결 방법이 함께 나옵니다.
- **타입이 지정된 테스트 override** — 모든 컨테이너에는 의존성마다 필드가 하나씩 있는 `Overrides` 구조체가 생성되며, 타입은 프로퍼티와 같습니다: `$0.api = { StubProfileAPI(…) }`.
- **전역 상태가 없습니다** — 인스턴스와 override는 하나의 컨테이너 인스턴스에 속합니다. 각자 컨테이너를 만드는 테스트는 병렬로 실행할 수 있고, 자식 컨테이너는 로그인한 사용자 같은 하나의 스코프입니다.
- **Swift 6 동시성** — 여러 스레드가 읽더라도 shared 의존성은 정확히 한 번만 생성됩니다. `@MainActor` 컨테이너는 `@MainActor` override를, 그 외 컨테이너는 `@Sendable` override를 받습니다.
- **순환은 런타임에도 잡아냅니다** — 매크로가 볼 수 없는 순환(메서드나 클로저를 거치는 경우)은 스택 오버플로 대신 같은 경로를 보여 주며 프로세스를 중단합니다.
- **읽을 수 있는 그래프** — 모든 컨테이너에는 컴파일 시점에 작성되는 `dependencyGraph`가 있으며 Graphviz 출력도 지원합니다.

## 빠른 시작

**1. 패키지 추가**

Xcode에서 **File › Add Package Dependencies…**를 선택하고 저장소 URL을 입력하세요.

```text
https://github.com/muhittincamdali/SwiftDependencyInjection.git
```

**2. 모듈 가져오기**

```swift
import SwiftDependencyInjection
```

**3. 컨테이너 선언**

각 의존성은 getter가 해당 프로퍼티의 key path를 넘기는 `shared` 또는 `transient` 호출 하나로 이루어진 computed property입니다
([ReadmeSamples.swift](Examples/DependencyDemo/DependencyDemo/ReadmeSamples.swift)).

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

컨테이너는 한 번만 만들고 필요한 것을 읽으면 됩니다. `AppDependencies().profileStore`는 처음 사용할 때 API와 store를 생성하고, 이후에는 같은 store를 반환합니다. key path 덕분에 각 인스턴스는 프로퍼티의 타입을 갖게 되므로 `api`는 `any ProfileAPI`로 저장되며, 테스트에서는 이를 준수하는 다른 어떤 타입으로든 교체할 수 있습니다.

## 설치

### Swift Package Manager

Xcode에서 **File › Add Package Dependencies…**를 선택하고 저장소 URL을 입력하세요.

```text
https://github.com/muhittincamdali/SwiftDependencyInjection.git
```

또는 `Package.swift`의 `dependencies`에 추가하세요.

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

이 패키지에는 Swift 매크로가 들어 있으므로 Xcode가 신뢰 여부를 한 번 묻고(**Trust & Enable**), 빌드에는 [swift-syntax](https://github.com/swiftlang/swift-syntax)(602~604)를 사용합니다.

## 사용법

아래 예제는 예제 앱이 빌드하는
[`ReadmeSamples.swift`](Examples/DependencyDemo/DependencyDemo/ReadmeSamples.swift)와
[`DependencyDemoApp.swift`](Examples/DependencyDemo/DependencyDemo/DependencyDemoApp.swift), 그리고 테스트 스위트가 실행하는
[`ReadmeSamplesTests.swift`](Tests/SwiftDependencyInjectionTests/ReadmeSamplesTests.swift)에서 가져온 것입니다.

### 컨테이너는 한 번만 만들기

앱이 컨테이너를 소유하고, 컨테이너 자체나 필요한 의존성을 아래로 전달합니다.

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

객체는 initializer(`ProfileStore(api:)`)를 통해 의존성을 받으므로, 각 객체는 테스트에서 컨테이너 없이도 단독으로 만들 수 있습니다.

### 테스트에서 의존성 교체하기

`override(_:)`는 생성된 `Overrides`의 필드를 설정하는 클로저를 받습니다. `nil`로 둔 필드는 실제 의존성을 그대로 사용합니다. 실제 `profileStore` provider가 실행되어 stub을 읽습니다.

```swift
let dependencies = AppDependencies()
dependencies.override {
    $0.api = { StubProfileAPI(profiles: [Profile(id: 1, name: "Ada", role: "Analyst")]) }
}

let store = dependencies.profileStore
try await store.refresh()

#expect(store.profiles.map(\.name) == ["Ada"])
```

각 테스트가 자기만의 컨테이너를 만들기 때문에 override가 테스트 사이로 새어 나가지 않으며, Swift Testing이 테스트를 병렬로 실행할 수 있습니다. 미리보기에서도 같은 호출을 사용합니다.

### 의존성을 세션으로 한정하기

컨테이너 인스턴스는 하나의 스코프입니다. 자식 컨테이너는 부모 컨테이너와 스코프의 값을 stored property로 가지므로, 그 안의 어떤 코드도 사용자가 없는 경우를 처리할 필요가 없습니다.

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

사용자가 로그인할 때 하나를 만들고 로그아웃할 때 해제하세요. shared 인스턴스도 함께 사라지지만, `app.profileStore`는 모든 세션이 계속 공유합니다.

### 컴파일러가 순환을 찾게 하기

직접적으로든 다른 의존성을 거쳐서든 자기 자신을 필요로 하는 provider는 컴파일되지 않습니다.

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

[`DiagnosticTests.swift`](Tests/SwiftDependencyInjectionMacrosTests/DiagnosticTests.swift)는 이 예제를 매크로로 전개하고 오류 문구가 정확히 같은지 확인합니다.

중첩된 클로저 안의 읽기는 추적하지 않습니다. 콜백은 보통 생성이 끝난 뒤에 실행되기 때문입니다. 그런 클로저가 생성 중에 실행되면 컨테이너는 스택 오버플로 대신 `dependency cycle in AppDependencies: api → tokens → api` 메시지와 함께 프로세스를 중단합니다.

## 데모

[DependencyDemo](Examples/DependencyDemo) 앱은 각 아이디어를 실제 라이브러리로 실행해 보여 줍니다. 스크린샷은 iOS 27 시뮬레이터에서 앱을 [`scripts/capture-example-screens.sh`](scripts/capture-example-screens.sh)로 캡처한 것입니다.

| 실제 API와 override한 API | Shared, transient, 세션 | 생성된 그래프 |
| --- | --- | --- |
| <picture><source media="(prefers-color-scheme: dark)" srcset="docs/images/demo-overrides-dark.png"><img src="docs/images/demo-overrides-light.png" width="260" alt="두 컨테이너가 프로필을 불러옵니다: 실제 컨테이너는 DemoServerAPI를 주입했고 약 600 ms가 걸렸으며, override한 컨테이너는 StubProfileAPI를 주입했습니다"></picture> | <picture><source media="(prefers-color-scheme: dark)" srcset="docs/images/demo-scopes-dark.png"><img src="docs/images/demo-scopes-light.png" width="260" alt="읽기 로그: profileStore는 같은 인스턴스를 두 번 반환하고, profileEditor는 매번 새 인스턴스를 반환하며, 두 세션이 앱의 store를 공유합니다"></picture> | <picture><source media="(prefers-color-scheme: dark)" srcset="docs/images/demo-graph-dark.png"><img src="docs/images/demo-graph-light.png" width="260" alt="AppDependencies와 SessionDependencies의 의존성, 각각의 수명, 그리고 둘 사이의 읽기"></picture> |

실행하려면 [Examples/DependencyDemo](Examples/DependencyDemo)의 `DependencyDemo.xcodeproj`를 Xcode 26 이상으로 열고, iPhone 시뮬레이터 또는 **My Mac**을 선택한 다음 **Run**을 누르세요. 각 화면은 [Examples/README.md](Examples/README.md)에서 설명합니다.

## Factory나 swift-dependencies를 대신 선택해야 할 때

[Factory](https://github.com/hmlongco/Factory)와
[swift-dependencies](https://github.com/pointfreeco/swift-dependencies)는 가장 널리 쓰이는 Swift dependency injection 라이브러리이며, 이 패키지가 하지 않는 일도 합니다.

- **Factory를 선택하세요**: 컨테이너를 전달하지 않고 `@Injected`로 어디에서나 주입하고 싶을 때, 매개변수가 있는 factory, 더 많은 스코프(cached, weak shared, graph, custom), decorator, 미리보기·테스트·디버그 빌드에서 구현을 자동으로 바꿔 주는 context가 필요할 때.
- **swift-dependencies를 선택하세요**: The Composable Architecture를 쓰면서 시계, 날짜, UUID 같은 의존성이 task local을 통해 모든 코드에 닿길 원할 때, 또는 테스트에서 의존성이 예상치 못하게 사용되면 테스트를 실패시키고 싶을 때.
- **[SafeDI](https://github.com/dfed/SafeDI)를 선택하세요**: 생성된 initializer와 mock으로 모듈을 가로지르는 전체 객체 그래프를 컴파일 시점에 검증하고 싶을 때.
- **이 패키지를 선택하세요**: 스코프마다 컨테이너 클래스 하나를 두는 명시적인 constructor injection, 타입이 지정된 override, 컴파일러가 보고하는 순환을 원할 때.

[Choosing a dependency injection library](https://muhittincamdali.github.io/SwiftDependencyInjection/documentation/swiftdependencyinjection/choosingadependencyinjectionlibrary) 문서는 이들을 기능별로 비교하고 이 패키지의 한계를 정리합니다.

## 문서

API 레퍼런스와 문서:

- [SwiftDependencyInjection 레퍼런스](https://muhittincamdali.github.io/SwiftDependencyInjection/documentation/swiftdependencyinjection/)
- [시작하기](https://muhittincamdali.github.io/SwiftDependencyInjection/documentation/swiftdependencyinjection/gettingstarted)
- [override를 사용한 테스트](https://muhittincamdali.github.io/SwiftDependencyInjection/documentation/swiftdependencyinjection/testingwithoverrides)
- [스코프와 수명](https://muhittincamdali.github.io/SwiftDependencyInjection/documentation/swiftdependencyinjection/scopesandlifetimes)
- [dependency injection 라이브러리 선택하기](https://muhittincamdali.github.io/SwiftDependencyInjection/documentation/swiftdependencyinjection/choosingadependencyinjectionlibrary)

## 가이드

- [시작하기](Sources/SwiftDependencyInjection/SwiftDependencyInjection.docc/GettingStarted.md)
  — 컨테이너 선언, isolation 선택, 의존성 전달, 그리고 컴파일러가 검사하는 내용.
- [override를 사용한 테스트](Sources/SwiftDependencyInjection/SwiftDependencyInjection.docc/TestingWithOverrides.md)
  — override의 타입 지정, 스코프, 캐시, 격리 방식과 미리보기에서의 사용법.
- [스코프와 수명](Sources/SwiftDependencyInjection/SwiftDependencyInjection.docc/ScopesAndLifetimes.md)
  — shared와 transient, 자식 컨테이너, 순환, 의존성 그래프.
- [dependency injection 라이브러리 선택하기](Sources/SwiftDependencyInjection/SwiftDependencyInjection.docc/ChoosingADependencyInjectionLibrary.md)
  — Factory, swift-dependencies, SafeDI, 그리고 이 패키지를 나란히 비교.

## 요구 사항

| 플랫폼 | 최소 버전 |
| --- | --- |
| iOS | 16 |
| macOS | 13 |
| tvOS | 16 |
| watchOS | 9 |
| visionOS | 1 |
| 툴체인 | Swift 6.2 · Xcode 26+ |

## 아키텍처

이 패키지에는 라이브러리 하나와 매크로 target 하나가 있습니다.

| Target | 내용 |
| --- | --- |
| `SwiftDependencyInjection` | `DependencyContainer`(`shared`와 `transient`를 가진 프로토콜), `DependencyStorage`, `DependencyGraph`, `@DependencyContainer` 선언 |
| `SwiftDependencyInjectionMacros` | 매크로: 클래스 본문을 읽어 멤버를 생성하고, 순환을 찾고, 잘못된 사용을 보고합니다 |

설계 결정:

- **등록이 아니라 프로퍼티.** 의존성은 computed property이므로 컴파일러가 모든 사용처를 검사합니다. 실행 시점에 등록하는 것이 없으니 런타임에 빠지는 것도 없습니다.
- **key path가 곧 키입니다.** `shared(\.api)`는 프로퍼티의 key path를 키로 인스턴스를 저장하며, 이는 인스턴스의 타입도 프로퍼티의 타입으로 고정합니다. 그래서 이를 준수하는 다른 타입의 override도 맞고, 두 프로퍼티가 같은 항목을 공유하는 일도 없습니다.
- **컨테이너마다 재귀 락 하나.** provider가 실행되는 동안 이 락을 잡고 있습니다. shared 의존성은 정확히 한 번만 생성되고, provider끼리 서로 읽을 수 있으며, 생성 중인 체인이 런타임 순환 검사를 겸합니다.
- **override는 이름으로 저장하지 않고 생성합니다.** 매크로가 의존성마다 타입이 지정된 필드를 작성하고, 클로저에 컨테이너의 isolation을 부여합니다.
- **컨테이너가 곧 스코프입니다.** 전역 상태가 없으니 테스트 사이에 초기화할 것도, 숨은 수명도 없습니다. 컨테이너의 인스턴스는 컨테이너가 존재하는 동안만 살아 있습니다.

## 로드맵

- 프로퍼티처럼 override할 수 있는 매개변수가 있는 의존성(`func editor(for: Profile)`).
- 선택적 weak 수명: 무언가가 붙들고 있는 동안은 인스턴스 하나를 유지하고, 그 이후에는 다시 생성합니다.
- 큰 컨테이너를 디버깅하기 위한, 한 번의 resolve 중에 무엇이 생성되었는지에 대한 trace.

## 기여하기

기여를 환영합니다. pull request를 열기 전에 [기여 가이드](https://github.com/muhittincamdali/SwiftDependencyInjection/blob/main/CONTRIBUTING.md)와 [행동 강령](https://github.com/muhittincamdali/SwiftDependencyInjection/blob/main/CODE_OF_CONDUCT.md)을 읽어 주세요. 보안 문제는 [보안 정책](https://github.com/muhittincamdali/SwiftDependencyInjection/blob/main/SECURITY.md)에 따라 비공개로 제보해 주세요.

## 라이선스

MIT 라이선스로 배포됩니다. 자세한 내용은 [LICENSE](LICENSE)를 참고하세요.
