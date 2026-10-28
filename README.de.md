<!-- i18n-source: README.md@fe1b1436375ad6c38c0fa56ad238003e76254a1f status=reviewed -->
<!-- brand:start -->

<p align="center"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/banner-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/banner-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/banner-light.svg" alt="SwiftDependencyInjection: Dependency containers for Swift 6 that the compiler checks, with typed test overrides and no global state."></picture></p>

<!-- lang-selector:start -->
<p align="center"><a href="README.md">English</a> · <a href="README.tr.md">Türkçe</a> · <a href="README.zh-CN.md">简体中文</a> · <a href="README.ja.md">日本語</a> · <a href="README.ko.md">한국어</a> · <a href="README.es.md">Español</a> · <a href="README.de.md">Deutsch</a> · <a href="README.fr.md">Français</a> · <a href="README.pt-BR.md">Português (Brasil)</a> · <a href="README.ru.md">Русский</a></p>
<!-- lang-selector:end -->

<p align="center">
<a href="https://github.com/muhittincamdali/SwiftDependencyInjection/actions/workflows/ci.yml"><img src="https://github.com/muhittincamdali/SwiftDependencyInjection/actions/workflows/ci.yml/badge.svg" alt="CI-Status"></a>
<a href="https://github.com/muhittincamdali/SwiftDependencyInjection/releases"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/badge-version-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/badge-version-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/badge-version-light.svg" alt="Aktuelle Version: v1.0.0"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftDependencyInjection/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/badge-platforms-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/badge-platforms-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/badge-platforms-light.svg" alt="Unterstützte Plattformen: iOS 16+ · macOS 13+ · tvOS 16+ · watchOS 9+ · visionOS 1+"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftDependencyInjection/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/badge-language-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/badge-language-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/badge-language-light.svg" alt="Sprachversion: Swift 6.2+ · Swift 6 mode"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftDependencyInjection/blob/main/LICENSE"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/badge-license-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/badge-license-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/badge-license-light.svg" alt="Lizenz: MIT"></picture></a>
</p>

<p align="center">
<a href="#schnellstart"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/button-start-de-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/button-start-de-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/button-start-de-light.svg" alt="Loslegen"></picture></a>
<a href="https://muhittincamdali.github.io/SwiftDependencyInjection/documentation/swiftdependencyinjection/"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/button-docs-de-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/button-docs-de-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/button-docs-de-light.svg" alt="Dokumentation"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftDependencyInjection/tree/main/Examples"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/button-examples-de-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/button-examples-de-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/button-examples-de-light.svg" alt="Beispiele"></picture></a>
</p>

> Dies ist eine Übersetzung der englischen README. Bei Abweichungen gilt die englische Fassung.

<!-- brand:end -->

SwiftDependencyInjection ist manuelle Dependency Injection für Swift 6, bei der die sich wiederholenden Teile generiert werden. Du listest deine Abhängigkeiten als berechnete Properties einer einzigen `final class` auf; das Makro `@DependencyContainer` macht daraus einen Container: Jede `shared`-Abhängigkeit wird einmal erzeugt und threadsicher zwischengespeichert, jede `transient`-Abhängigkeit wird bei jedem Lesen neu erzeugt, Tests ersetzen jede davon über ein generiertes, typisiertes `override`, und ein Abhängigkeitszyklus ist ein Compilerfehler. Es gibt keinen globalen Container und keine Suche, die zur Laufzeit fehlschlagen kann: Eine Abhängigkeit ist eine Property, und fehlt eine, kompiliert der Code nicht.

## Highlights

- **Vom Compiler geprüft** — Eine Abhängigkeit ist eine Property, daher ist eine fehlende oder falsch typisierte ein Compilerfehler. Das Makro meldet Zyklen (`api → tokens → api`), Provider an der falschen Stelle und Abhängigkeiten, die ein Override nicht ersetzen könnte, jeweils mit der Lösung in der Meldung.
- **Typisierte Test-Overrides** — Jeder Container erhält ein `Overrides`-Struct mit einem Feld pro Abhängigkeit, typisiert wie die Property: `$0.api = { StubProfileAPI(…) }`.
- **Kein globaler Zustand** — Instanzen und Overrides gehören zu genau einer Container-Instanz. Tests, die jeweils einen eigenen Container erstellen, können parallel laufen; ein Child-Container ist ein Scope, etwa ein angemeldeter Benutzer.
- **Swift-6-Nebenläufigkeit** — Eine Shared-Abhängigkeit wird genau einmal erzeugt, auch wenn viele Threads sie lesen. `@MainActor`-Container erhalten `@MainActor`-Overrides, andere Container `@Sendable`-Overrides.
- **Zyklen werden auch zur Laufzeit erkannt** — Ein Zyklus, den das Makro nicht sehen kann, etwa über eine Methode oder eine Closure, beendet den Prozess mit demselben Pfad, statt den Stack zu überlaufen.
- **Ein Graph, den du lesen kannst** — Jeder Container hat einen zur Compilezeit erzeugten `dependencyGraph` mit Graphviz-Ausgabe.

## Schnellstart

**1. Paket hinzufügen**

Wähle in Xcode **File › Add Package Dependencies…** und gib die Repository-URL ein:

```text
https://github.com/muhittincamdali/SwiftDependencyInjection.git
```

**2. Modul importieren**

```swift
import SwiftDependencyInjection
```

**3. Container deklarieren**

Jede Abhängigkeit ist eine berechnete Property, deren Getter aus einem einzigen `shared`- oder `transient`-Aufruf mit dem Key Path dieser Property besteht
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

Erstelle den Container einmal und lies, was du brauchst: `AppDependencies().profileStore` erzeugt beim ersten Zugriff die API und den Store und gibt danach denselben Store zurück. Der Key Path gibt jeder Instanz den Typ ihrer Property, daher wird `api` als `any ProfileAPI` gespeichert, und ein Test kann sie durch jeden anderen konformen Typ ersetzen.

## Installation

### Swift Package Manager

Wähle in Xcode **File › Add Package Dependencies…** und gib die Repository-URL ein:

```text
https://github.com/muhittincamdali/SwiftDependencyInjection.git
```

Oder füge es zu den `dependencies` in deiner `Package.swift` hinzu:

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

Das Paket enthält ein Swift-Makro. Deshalb fragt Xcode einmal, ob du ihm vertraust (**Trust & Enable**), und der Build verwendet [swift-syntax](https://github.com/swiftlang/swift-syntax) (602 bis 604).

## Verwendung

Die folgenden Beispiele sind kopiert aus
[`ReadmeSamples.swift`](Examples/DependencyDemo/DependencyDemo/ReadmeSamples.swift) und
[`DependencyDemoApp.swift`](Examples/DependencyDemo/DependencyDemo/DependencyDemoApp.swift), die die Beispiel-App baut, sowie aus
[`ReadmeSamplesTests.swift`](Tests/SwiftDependencyInjectionTests/ReadmeSamplesTests.swift), das die Test-Suite ausführt.

### Den Container einmal erstellen

Die App besitzt ihren Container und reicht ihn oder die benötigten Abhängigkeiten nach unten weiter:

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

Objekte erhalten ihre Abhängigkeiten über ihre Initializer (`ProfileStore(api:)`), sodass sich jedes auch einzeln in einem Test ohne Container erstellen lässt.

### Abhängigkeiten in einem Test ersetzen

`override(_:)` nimmt eine Closure, die Felder des generierten `Overrides` setzt; Felder, die `nil` bleiben, behalten die echte Abhängigkeit. Der echte Provider von `profileStore` läuft und liest den Stub:

```swift
let dependencies = AppDependencies()
dependencies.override {
    $0.api = { StubProfileAPI(profiles: [Profile(id: 1, name: "Ada", role: "Analyst")]) }
}

let store = dependencies.profileStore
try await store.refresh()

#expect(store.profiles.map(\.name) == ["Ada"])
```

Jeder Test erstellt seinen eigenen Container, daher gelangen Overrides nie von einem Test in einen anderen, und Swift Testing kann die Tests parallel ausführen. Previews verwenden denselben Aufruf.

### Abhängigkeiten auf eine Sitzung beschränken

Eine Container-Instanz ist ein Scope. Ein Child-Container hält seinen Parent und die Werte des Scopes als Stored Properties, sodass nichts darin mit einem fehlenden Benutzer umgehen muss:

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

Erstelle einen, wenn sich ein Benutzer anmeldet, und gib ihn frei, wenn er sich abmeldet; seine Shared-Instanzen verschwinden mit ihm, während `app.profileStore` weiterhin von allen Sitzungen geteilt wird.

### Zyklen vom Compiler finden lassen

Ein Provider, der sich selbst braucht, direkt oder über andere Abhängigkeiten, lässt sich nicht kompilieren:

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

Lesezugriffe in verschachtelten Closures werden nicht verfolgt, weil ein Callback meist erst nach dem Erzeugen läuft. Läuft eine solche Closure während des Erzeugens, beendet der Container den Prozess mit `dependency cycle in AppDependencies: api → tokens → api`, statt den Stack zu überlaufen.

## Demo

Die App [DependencyDemo](Examples/DependencyDemo) führt jede Idee mit der echten Bibliothek aus. Die Screenshots stammen aus der App in einem iOS-27-Simulator und wurden mit [`scripts/capture-example-screens.sh`](scripts/capture-example-screens.sh) aufgenommen:

| Echte und überschriebene API | Shared, transient und Sitzungen | Generierter Graph |
| --- | --- | --- |
| <picture><source media="(prefers-color-scheme: dark)" srcset="docs/images/demo-overrides-dark.png"><img src="docs/images/demo-overrides-light.png" width="260" alt="Zwei Container laden Profile: Der echte injizierte DemoServerAPI und brauchte etwa 600 ms, der überschriebene injizierte StubProfileAPI"></picture> | <picture><source media="(prefers-color-scheme: dark)" srcset="docs/images/demo-scopes-dark.png"><img src="docs/images/demo-scopes-light.png" width="260" alt="Lese-Log: profileStore gibt zweimal dieselbe Instanz zurück, profileEditor jedes Mal eine neue, zwei Sitzungen teilen sich den Store der App"></picture> | <picture><source media="(prefers-color-scheme: dark)" srcset="docs/images/demo-graph-dark.png"><img src="docs/images/demo-graph-light.png" width="260" alt="Die Abhängigkeiten von AppDependencies und SessionDependencies mit ihren Lebensdauern und den Lesezugriffen dazwischen"></picture> |

Zum Ausführen öffnest du `DependencyDemo.xcodeproj` in [Examples/DependencyDemo](Examples/DependencyDemo) mit Xcode 26 oder neuer, wählst einen iPhone-Simulator oder **My Mac** und drückst **Run**. [Examples/README.md](Examples/README.md) beschreibt jeden Bildschirm.

## Wann stattdessen Factory oder swift-dependencies die bessere Wahl sind

[Factory](https://github.com/hmlongco/Factory) und
[swift-dependencies](https://github.com/pointfreeco/swift-dependencies) sind die am weitesten verbreiteten Dependency-Injection-Bibliotheken für Swift, und sie können Dinge, die dieses Paket nicht kann:

- **Wähle Factory**, um überall mit `@Injected` zu injizieren, ohne einen Container weiterzureichen, für parametrisierte Factories, mehr Scopes (cached, weak shared, graph, custom), Decorators und Kontexte, die Implementierungen für Previews, Tests und Debug-Builds automatisch austauschen.
- **Wähle swift-dependencies** mit The Composable Architecture, wenn Abhängigkeiten wie Uhr, Datum und UUIDs über Task Locals jeden Code erreichen sollen oder wenn eine unerwartete Verwendung einer Abhängigkeit in einem Test diesen fehlschlagen lassen soll.
- **Wähle [SafeDI](https://github.com/dfed/SafeDI)**, um einen ganzen Objektgraphen über Module hinweg zur Compilezeit zu validieren, mit generierten Initializern und Mocks.
- **Wähle dieses Paket** für explizite Constructor Injection mit einer Container-Klasse pro Scope, typisierte Overrides und Zyklen, die der Compiler meldet.

Der Artikel
[Eine Dependency-Injection-Bibliothek auswählen](https://muhittincamdali.github.io/SwiftDependencyInjection/documentation/swiftdependencyinjection/choosingadependencyinjectionlibrary)
vergleicht sie Funktion für Funktion und nennt die Grenzen dieses Pakets.

## Dokumentation

API-Referenz und Artikel:

- [SwiftDependencyInjection-Referenz](https://muhittincamdali.github.io/SwiftDependencyInjection/documentation/swiftdependencyinjection/)
- [Erste Schritte](https://muhittincamdali.github.io/SwiftDependencyInjection/documentation/swiftdependencyinjection/gettingstarted)
- [Testen mit Overrides](https://muhittincamdali.github.io/SwiftDependencyInjection/documentation/swiftdependencyinjection/testingwithoverrides)
- [Scopes und Lebensdauern](https://muhittincamdali.github.io/SwiftDependencyInjection/documentation/swiftdependencyinjection/scopesandlifetimes)
- [Eine Dependency-Injection-Bibliothek auswählen](https://muhittincamdali.github.io/SwiftDependencyInjection/documentation/swiftdependencyinjection/choosingadependencyinjectionlibrary)

## Anleitungen

- [Erste Schritte](Sources/SwiftDependencyInjection/SwiftDependencyInjection.docc/GettingStarted.md)
  — einen Container deklarieren, seine Isolation wählen, Abhängigkeiten weiterreichen und was der Compiler prüft.
- [Testen mit Overrides](Sources/SwiftDependencyInjection/SwiftDependencyInjection.docc/TestingWithOverrides.md)
  — wie Overrides typisiert, eingegrenzt, zwischengespeichert und isoliert werden und wie du sie in Previews nutzt.
- [Scopes und Lebensdauern](Sources/SwiftDependencyInjection/SwiftDependencyInjection.docc/ScopesAndLifetimes.md)
  — shared und transient, Child-Container, Zyklen und der Abhängigkeitsgraph.
- [Eine Dependency-Injection-Bibliothek auswählen](Sources/SwiftDependencyInjection/SwiftDependencyInjection.docc/ChoosingADependencyInjectionLibrary.md)
  — Factory, swift-dependencies, SafeDI und dieses Paket im Vergleich.

## Voraussetzungen

| Plattform | Mindestversion |
| --- | --- |
| iOS | 16 |
| macOS | 13 |
| tvOS | 16 |
| watchOS | 9 |
| visionOS | 1 |
| Toolchain | Swift 6.2 · Xcode 26+ |

## Architektur

Das Paket hat eine Bibliothek und ein Makro-Target:

| Target | Inhalt |
| --- | --- |
| `SwiftDependencyInjection` | `DependencyContainer` (das Protokoll mit `shared` und `transient`), `DependencyStorage`, `DependencyGraph`, die Deklaration von `@DependencyContainer` |
| `SwiftDependencyInjectionMacros` | Das Makro: liest den Klassenrumpf, generiert die Member, findet Zyklen und meldet Fehlgebrauch |

Designentscheidungen:

- **Properties statt Registrierungen.** Eine Abhängigkeit ist eine berechnete Property, daher prüft der Compiler jede Verwendung. Beim Start wird nichts registriert, also kann zur Laufzeit auch nichts fehlen.
- **Der Key Path ist der Schlüssel.** `shared(\.api)` speichert die Instanz unter dem Key Path ihrer Property, was auch ihren Typ auf den der Property festlegt. So passen Overrides eines anderen konformen Typs, und zwei Properties können sich nie einen Eintrag teilen.
- **Ein rekursiver Lock pro Container.** Er wird gehalten, während ein Provider läuft: Eine Shared-Abhängigkeit wird genau einmal erzeugt, Provider können einander lesen, und die gerade aufgebaute Kette dient zugleich als Zyklusprüfung zur Laufzeit.
- **Overrides werden generiert, nicht unter einem Namen gespeichert.** Das Makro schreibt pro Abhängigkeit ein typisiertes Feld und gibt den Closures die Isolation des Containers.
- **Der Container ist der Scope.** Kein globaler Zustand bedeutet kein Zurücksetzen zwischen Tests und keine versteckte Lebensdauer: Die Instanzen eines Containers leben genau so lange wie er.

## Roadmap

- Parametrisierte Abhängigkeiten (`func editor(for: Profile)`), die sich wie Properties überschreiben lassen.
- Eine optionale schwache Lebensdauer: eine Instanz, solange etwas sie hält, danach neu erzeugt.
- Ein Trace dessen, was bei einer Auflösung erzeugt wurde, zum Debuggen großer Container.

## Mitwirken

Beiträge sind willkommen. Lies vor einem Pull Request den [Leitfaden für Beiträge](https://github.com/muhittincamdali/SwiftDependencyInjection/blob/main/CONTRIBUTING.md) und den [Verhaltenskodex](https://github.com/muhittincamdali/SwiftDependencyInjection/blob/main/CODE_OF_CONDUCT.md). Sicherheitsprobleme meldest du vertraulich, wie in der [Sicherheitsrichtlinie](https://github.com/muhittincamdali/SwiftDependencyInjection/blob/main/SECURITY.md) beschrieben.

## Lizenz

Veröffentlicht unter der MIT-Lizenz. Siehe [LICENSE](LICENSE).
