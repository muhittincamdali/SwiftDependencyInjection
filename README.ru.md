<!-- i18n-source: README.md@d3e5028bcdb1a540aaf4809f97c3e9aed8c662a8 status=reviewed -->
<!-- brand:start -->

<p align="center"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/banner-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/banner-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/banner-light.svg" alt="SwiftDependencyInjection: Dependency containers for Swift 6 that the compiler checks, with typed test overrides and no global state."></picture></p>

<!-- lang-selector:start -->
<p align="center"><a href="README.md">English</a> · <a href="README.tr.md">Türkçe</a> · <a href="README.zh-CN.md">简体中文</a> · <a href="README.ja.md">日本語</a> · <a href="README.ko.md">한국어</a> · <a href="README.es.md">Español</a> · <a href="README.de.md">Deutsch</a> · <a href="README.fr.md">Français</a> · <a href="README.pt-BR.md">Português (Brasil)</a> · <a href="README.ru.md">Русский</a></p>
<!-- lang-selector:end -->

<p align="center">
<a href="https://github.com/muhittincamdali/SwiftDependencyInjection/actions/workflows/ci.yml"><img src="https://github.com/muhittincamdali/SwiftDependencyInjection/actions/workflows/ci.yml/badge.svg" alt="Статус CI"></a>
<a href="https://github.com/muhittincamdali/SwiftDependencyInjection/releases"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/badge-version-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/badge-version-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/badge-version-light.svg" alt="Последняя версия: v2.0.0"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftDependencyInjection/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/badge-platforms-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/badge-platforms-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/badge-platforms-light.svg" alt="Поддерживаемые платформы: iOS 16+ · macOS 13+ · tvOS 16+ · watchOS 9+ · visionOS 1+"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftDependencyInjection/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/badge-language-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/badge-language-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/badge-language-light.svg" alt="Версия языка: Swift 6.2+ · Swift 6 mode"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftDependencyInjection/blob/main/LICENSE"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/badge-license-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/badge-license-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/badge-license-light.svg" alt="Лицензия: MIT"></picture></a>
</p>

<p align="center">
<a href="#быстрый-старт"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/button-start-ru-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/button-start-ru-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/button-start-ru-light.svg" alt="Начать"></picture></a>
<a href="https://muhittincamdali.github.io/SwiftDependencyInjection/documentation/swiftdependencyinjection/"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/button-docs-ru-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/button-docs-ru-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/button-docs-ru-light.svg" alt="Документация"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftDependencyInjection/tree/main/Examples"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/button-examples-ru-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/button-examples-ru-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/button-examples-ru-light.svg" alt="Примеры"></picture></a>
</p>

> Это перевод README на английском языке. Если они расходятся, актуальна английская версия.

<!-- brand:end -->

SwiftDependencyInjection — это ручное внедрение зависимостей для Swift 6, в котором повторяющиеся части генерируются. Вы перечисляете зависимости как вычисляемые свойства одного `final`-класса; макрос `@DependencyContainer` превращает его в контейнер: каждая `shared`-зависимость создаётся один раз и потокобезопасно кэшируется, каждая `transient`-зависимость создаётся при каждом чтении, тесты подменяют любую из них через сгенерированный типизированный `override`, а цикл зависимостей — это ошибка компиляции. Нет глобального контейнера и нет поиска, который мог бы завершиться ошибкой во время выполнения: зависимость — это свойство, поэтому отсутствующая зависимость не скомпилируется.

## Основные возможности

- **Проверяется компилятором** — зависимость является свойством, поэтому отсутствующая или неверного типа зависимость — ошибка компиляции. Макрос сообщает о циклах (`api → tokens → api`), о провайдерах не на своём месте и о зависимостях, которые override не смог бы подменить, и в каждом сообщении указано, как исправить.
- **Типизированные override для тестов** — каждый контейнер получает структуру `Overrides` с полем на каждую зависимость; тип поля совпадает с типом свойства: `$0.api = { StubProfileAPI(…) }`.
- **Нет глобального состояния** — экземпляры и override принадлежат одному экземпляру контейнера. Тесты, каждый из которых создаёт свой контейнер, могут выполняться параллельно; дочерний контейнер — это scope, например вошедший в систему пользователь.
- **Конкурентность Swift 6** — shared-зависимость создаётся ровно один раз, даже когда её читают много потоков. Контейнеры `@MainActor` получают override с `@MainActor`, остальные — с `@Sendable`.
- **Циклы ловятся и во время выполнения** — цикл, который макрос не видит (через метод или замыкание), останавливает процесс с тем же путём вместо переполнения стека.
- **Граф, который можно прочитать** — у каждого контейнера есть `dependencyGraph`, создаваемый при компиляции, с выводом в формате Graphviz.

## Быстрый старт

**1. Добавьте пакет**

В Xcode выберите **File › Add Package Dependencies…** и введите адрес репозитория:

```text
https://github.com/muhittincamdali/SwiftDependencyInjection.git
```

**2. Импортируйте модуль**

```swift
import SwiftDependencyInjection
```

**3. Объявите контейнер**

Каждая зависимость — это вычисляемое свойство, геттер которого состоит из одного вызова `shared` или `transient` с key path этого свойства
([ReadmeSamples.swift](Examples/DependencyDemo/DependencyDemo/ReadmeSamples.swift)):

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

Создайте контейнер один раз и читайте то, что нужно: `AppDependencies().profileStore` при первом обращении создаёт API и store, а потом возвращает тот же store. Key path задаёт каждому экземпляру тип его свойства, поэтому `api` хранится как `any ProfileAPI`, и тест может заменить его любым другим типом, соответствующим протоколу.

## Установка

### Swift Package Manager

В Xcode выберите **File › Add Package Dependencies…** и введите адрес репозитория:

```text
https://github.com/muhittincamdali/SwiftDependencyInjection.git
```

Или добавьте его в `dependencies` вашего `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/muhittincamdali/SwiftDependencyInjection.git", from: "2.0.0")
],
targets: [
    .target(name: "YourApp", dependencies: [
        .product(name: "SwiftDependencyInjection", package: "SwiftDependencyInjection")
    ])
]
```

Пакет содержит макрос Swift, поэтому Xcode один раз попросит ему доверять (**Trust & Enable**), а сборка использует [swift-syntax](https://github.com/swiftlang/swift-syntax) (версии с 602 по 604).

## Использование

Примеры ниже скопированы из
[`ReadmeSamples.swift`](Examples/DependencyDemo/DependencyDemo/ReadmeSamples.swift) и
[`DependencyDemoApp.swift`](Examples/DependencyDemo/DependencyDemo/DependencyDemoApp.swift), которые собирает демонстрационное приложение, а также из
[`ReadmeSamplesTests.swift`](Tests/SwiftDependencyInjectionTests/ReadmeSamplesTests.swift), который выполняет набор тестов.

### Создайте контейнер один раз

Приложение владеет своим контейнером и передаёт вниз его самого или нужные зависимости:

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

Объекты получают зависимости через свои инициализаторы (`ProfileStore(api:)`), поэтому каждый из них можно создать отдельно и в тесте, без контейнера.

### Подмените зависимости в тесте

`override(_:)` принимает замыкание, которое задаёт поля сгенерированной структуры `Overrides`; поля, оставленные `nil`, сохраняют настоящую зависимость. Настоящий провайдер `profileStore` выполняется и читает заглушку:

```swift
let dependencies = AppDependencies()
dependencies.override {
    $0.api = { StubProfileAPI(profiles: [Profile(id: 1, name: "Ada", role: "Analyst")]) }
}

let store = dependencies.profileStore
try await store.refresh()

#expect(store.profiles.map(\.name) == ["Ada"])
```

Каждый тест создаёт собственный контейнер, поэтому override никогда не просачиваются между тестами, а Swift Testing может выполнять их параллельно. Превью используют тот же вызов.

### Ограничьте зависимости сессией

Экземпляр контейнера — это scope. Дочерний контейнер хранит родителя и значения scope как stored-свойства, поэтому внутри не нужно обрабатывать отсутствие пользователя:

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

Создайте такой контейнер, когда пользователь входит в систему, и освободите, когда он выходит; его shared-экземпляры исчезают вместе с ним, а `app.profileStore` по-прежнему общий для всех сессий.

### Пусть компилятор находит циклы

Провайдер, которому нужен он сам — напрямую или через другие зависимости, — не скомпилируется:

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

[`DiagnosticTests.swift`](Tests/SwiftDependencyInjectionMacrosTests/DiagnosticTests.swift) раскрывает этот пример макросом и проверяет точный текст ошибки.

Чтения внутри вложенных замыканий не отслеживаются, потому что колбэк обычно выполняется после создания. Если такое замыкание выполняется во время создания, контейнер останавливает процесс с сообщением `dependency cycle in AppDependencies: api → tokens → api` вместо переполнения стека.

## Демо

Приложение [DependencyDemo](Examples/DependencyDemo) запускает каждую идею с настоящей библиотекой. Скриншоты сделаны в приложении на симуляторе iOS 27 скриптом [`scripts/capture-example-screens.sh`](scripts/capture-example-screens.sh):

| Настоящий и подменённый API | Shared, transient и сессии | Сгенерированный граф |
| --- | --- | --- |
| <picture><source media="(prefers-color-scheme: dark)" srcset="docs/images/demo-overrides-dark.png"><img src="docs/images/demo-overrides-light.png" width="260" alt="Два контейнера загружают профили: настоящий внедрил DemoServerAPI и потратил около 600 мс, подменённый внедрил StubProfileAPI"></picture> | <picture><source media="(prefers-color-scheme: dark)" srcset="docs/images/demo-scopes-dark.png"><img src="docs/images/demo-scopes-light.png" width="260" alt="Журнал чтений: profileStore дважды возвращает один и тот же экземпляр, profileEditor каждый раз новый, две сессии делят store приложения"></picture> | <picture><source media="(prefers-color-scheme: dark)" srcset="docs/images/demo-graph-dark.png"><img src="docs/images/demo-graph-light.png" width="260" alt="Зависимости AppDependencies и SessionDependencies с их временем жизни и чтениями между ними"></picture> |

Чтобы запустить его, откройте `DependencyDemo.xcodeproj` в [Examples/DependencyDemo](Examples/DependencyDemo) в Xcode 26 или новее, выберите симулятор iPhone или **My Mac** и нажмите **Run**. [Examples/README.md](Examples/README.md) описывает каждый экран.

## Когда стоит выбрать Factory или swift-dependencies

[Factory](https://github.com/hmlongco/Factory) и
[swift-dependencies](https://github.com/pointfreeco/swift-dependencies) — самые распространённые библиотеки внедрения зависимостей для Swift, и они умеют то, чего этот пакет не умеет:

- **Выбирайте Factory**, чтобы внедрять где угодно через `@Injected` без передачи контейнера, для параметризованных фабрик, большего числа scope (cached, weak shared, graph, custom), декораторов и контекстов, которые автоматически переключают реализации для превью, тестов и отладочных сборок.
- **Выбирайте swift-dependencies** вместе с The Composable Architecture, когда зависимости вроде часов, даты и UUID должны попадать в любой код через task local, или когда неожиданное использование зависимости в тесте должно приводить к его провалу.
- **Выбирайте [SafeDI](https://github.com/dfed/SafeDI)**, чтобы проверять весь граф объектов между модулями на этапе компиляции, со сгенерированными инициализаторами и mock-объектами.
- **Выбирайте этот пакет** ради явного внедрения через конструктор с одним классом контейнера на scope, типизированных override и циклов, о которых сообщает компилятор.

Статья
[Как выбрать библиотеку внедрения зависимостей](https://muhittincamdali.github.io/SwiftDependencyInjection/documentation/swiftdependencyinjection/choosingadependencyinjectionlibrary)
сравнивает их по возможностям и перечисляет ограничения этого пакета.

## Документация

Справочник API и статьи:

- [Справочник SwiftDependencyInjection](https://muhittincamdali.github.io/SwiftDependencyInjection/documentation/swiftdependencyinjection/)
- [Начало работы](https://muhittincamdali.github.io/SwiftDependencyInjection/documentation/swiftdependencyinjection/gettingstarted)
- [Тестирование с override](https://muhittincamdali.github.io/SwiftDependencyInjection/documentation/swiftdependencyinjection/testingwithoverrides)
- [Scope и время жизни](https://muhittincamdali.github.io/SwiftDependencyInjection/documentation/swiftdependencyinjection/scopesandlifetimes)
- [Как выбрать библиотеку внедрения зависимостей](https://muhittincamdali.github.io/SwiftDependencyInjection/documentation/swiftdependencyinjection/choosingadependencyinjectionlibrary)

## Руководства

- [Начало работы](Sources/SwiftDependencyInjection/SwiftDependencyInjection.docc/GettingStarted.md)
  — объявление контейнера, выбор его изоляции, передача зависимостей дальше и то, что проверяет компилятор.
- [Тестирование с override](Sources/SwiftDependencyInjection/SwiftDependencyInjection.docc/TestingWithOverrides.md)
  — как override типизируются, ограничиваются по scope, кэшируются и изолируются, и как использовать их в превью.
- [Scope и время жизни](Sources/SwiftDependencyInjection/SwiftDependencyInjection.docc/ScopesAndLifetimes.md)
  — shared и transient, дочерние контейнеры, циклы и граф зависимостей.
- [Как выбрать библиотеку внедрения зависимостей](Sources/SwiftDependencyInjection/SwiftDependencyInjection.docc/ChoosingADependencyInjectionLibrary.md)
  — Factory, swift-dependencies, SafeDI и этот пакет бок о бок.

## Требования

| Платформа | Минимальная версия |
| --- | --- |
| iOS | 16 |
| macOS | 13 |
| tvOS | 16 |
| watchOS | 9 |
| visionOS | 1 |
| Инструменты | Swift 6.2 · Xcode 26+ |

## Архитектура

В пакете одна библиотека и один target с макросом:

| Target | Содержимое |
| --- | --- |
| `SwiftDependencyInjection` | `DependencyContainer` (протокол с `shared` и `transient`), `DependencyStorage`, `DependencyGraph`, объявление `@DependencyContainer` |
| `SwiftDependencyInjectionMacros` | Макрос: читает тело класса, генерирует члены, находит циклы и сообщает о неправильном использовании |

Проектные решения:

- **Свойства, а не регистрации.** Зависимость — это вычисляемое свойство, поэтому компилятор проверяет каждое обращение. При запуске ничего не регистрируется, а значит, во время выполнения ничего не может отсутствовать.
- **Ключ — это key path.** `shared(\.api)` хранит экземпляр под key path его свойства, что заодно фиксирует его тип как тип свойства; поэтому подходят override другого соответствующего типа, и два свойства никогда не смогут делить одну запись.
- **Одна рекурсивная блокировка на контейнер.** Она удерживается, пока выполняется провайдер: shared-зависимость создаётся ровно один раз, провайдеры могут читать друг друга, а создаваемая цепочка заодно служит проверкой циклов во время выполнения.
- **Override генерируются, а не хранятся по имени.** Макрос пишет типизированное поле для каждой зависимости и задаёт замыканиям изоляцию контейнера.
- **Контейнер — это scope.** Отсутствие глобального состояния означает, что между тестами нечего сбрасывать и нет скрытого времени жизни: экземпляры контейнера живут ровно столько, сколько он сам.

## План развития

- Параметризованные зависимости (`func editor(for: Profile)`), которые можно подменять через override, как свойства.
- Необязательное слабое (weak) время жизни: один экземпляр, пока кто-то его удерживает, а потом он создаётся заново.
- Трассировка того, что было создано при разрешении зависимостей, для отладки больших контейнеров.

## Участие в разработке

Мы рады вашему участию. Перед открытием pull request прочитайте [руководство для участников](https://github.com/muhittincamdali/SwiftDependencyInjection/blob/main/CONTRIBUTING.md) и [кодекс поведения](https://github.com/muhittincamdali/SwiftDependencyInjection/blob/main/CODE_OF_CONDUCT.md). О проблемах безопасности сообщайте конфиденциально, как описано в [политике безопасности](https://github.com/muhittincamdali/SwiftDependencyInjection/blob/main/SECURITY.md).

## Лицензия

Распространяется по лицензии MIT. Подробнее — в файле [LICENSE](LICENSE).
