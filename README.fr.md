<!-- i18n-source: README.md@db0ca6cfacb99492bf497614f3316a072a7016fa status=reviewed -->
<!-- brand:start -->

<p align="center"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/banner-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/banner-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/banner-light.svg" alt="SwiftDependencyInjection: Dependency containers for Swift 6 that the compiler checks, with typed test overrides and no global state."></picture></p>

<!-- lang-selector:start -->
<p align="center"><a href="README.md">English</a> · <a href="README.tr.md">Türkçe</a> · <a href="README.zh-CN.md">简体中文</a> · <a href="README.ja.md">日本語</a> · <a href="README.ko.md">한국어</a> · <a href="README.es.md">Español</a> · <a href="README.de.md">Deutsch</a> · <a href="README.fr.md">Français</a> · <a href="README.pt-BR.md">Português (Brasil)</a> · <a href="README.ru.md">Русский</a></p>
<!-- lang-selector:end -->

<p align="center">
<a href="https://github.com/muhittincamdali/SwiftDependencyInjection/actions/workflows/ci.yml"><img src="https://github.com/muhittincamdali/SwiftDependencyInjection/actions/workflows/ci.yml/badge.svg" alt="État de la CI"></a>
<a href="https://github.com/muhittincamdali/SwiftDependencyInjection/releases"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/badge-version-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/badge-version-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/badge-version-light.svg" alt="Dernière version: v1.0.0"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftDependencyInjection/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/badge-platforms-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/badge-platforms-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/badge-platforms-light.svg" alt="Plateformes prises en charge: iOS 16+ · macOS 13+ · tvOS 16+ · watchOS 9+ · visionOS 1+"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftDependencyInjection/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/badge-language-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/badge-language-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/badge-language-light.svg" alt="Version du langage: Swift 6.2+ · Swift 6 mode"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftDependencyInjection/blob/main/LICENSE"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/badge-license-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/badge-license-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/badge-license-light.svg" alt="Licence: MIT"></picture></a>
</p>

<p align="center">
<a href="#démarrage-rapide"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/button-start-fr-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/button-start-fr-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/button-start-fr-light.svg" alt="Commencer"></picture></a>
<a href="https://muhittincamdali.github.io/SwiftDependencyInjection/documentation/swiftdependencyinjection/"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/button-docs-fr-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/button-docs-fr-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/button-docs-fr-light.svg" alt="Documentation"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftDependencyInjection/tree/main/Examples"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/button-examples-fr-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/button-examples-fr-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/button-examples-fr-light.svg" alt="Exemples"></picture></a>
</p>

> Ceci est une traduction du README anglais. En cas de différence, la version anglaise fait foi.

<!-- brand:end -->

SwiftDependencyInjection est une injection de dépendances manuelle pour Swift 6 dont les parties répétitives sont générées. Vous déclarez vos dépendances sous forme de propriétés calculées d’une seule classe `final` ; la macro `@DependencyContainer` en fait un conteneur : chaque dépendance `shared` est construite une fois et mise en cache de façon thread-safe, chaque dépendance `transient` est construite à chaque lecture, les tests remplacent n’importe laquelle d’entre elles grâce à un `override` typé généré, et un cycle de dépendances est une erreur de compilation. Il n’y a ni conteneur global ni recherche pouvant échouer à l’exécution : une dépendance est une propriété, donc une dépendance manquante ne compile pas.

## Points forts

- **Vérifié par le compilateur** — une dépendance est une propriété : si elle manque ou si son type est faux, c’est une erreur de compilation. La macro signale les cycles (`api → tokens → api`), les providers mal placés et les dépendances qu’un override ne pourrait pas remplacer, chaque message indiquant la correction.
- **Overrides de test typés** — chaque conteneur reçoit une structure `Overrides` avec un champ par dépendance, typé comme la propriété : `$0.api = { StubProfileAPI(…) }`.
- **Aucun état global** — les instances et les overrides appartiennent à une seule instance de conteneur. Des tests qui créent chacun leur conteneur peuvent s’exécuter en parallèle ; un conteneur enfant est un scope, par exemple un utilisateur connecté.
- **Concurrence de Swift 6** — une dépendance shared est construite exactement une fois, même quand de nombreux threads la lisent. Les conteneurs `@MainActor` reçoivent des overrides `@MainActor`, les autres des overrides `@Sendable`.
- **Cycles détectés aussi à l’exécution** — un cycle que la macro ne voit pas, via une méthode ou une closure, arrête le processus avec le même chemin au lieu de faire déborder la pile.
- **Un graphe lisible** — chaque conteneur possède un `dependencyGraph`, écrit à la compilation, avec une sortie Graphviz.

## Démarrage rapide

**1. Ajouter le paquet**

Dans Xcode, choisissez **File › Add Package Dependencies…** et saisissez l’URL du dépôt :

```text
https://github.com/muhittincamdali/SwiftDependencyInjection.git
```

**2. Importer le module**

```swift
import SwiftDependencyInjection
```

**3. Déclarer un conteneur**

Chaque dépendance est une propriété calculée dont le getter est un seul appel à `shared` ou `transient` avec le key path de cette propriété
([ReadmeSamples.swift](Examples/DependencyDemo/DependencyDemo/ReadmeSamples.swift)) :

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

Créez-le une seule fois et lisez ce dont vous avez besoin : `AppDependencies().profileStore` construit l’API et le store à la première utilisation, puis renvoie ensuite le même store. Le key path donne à chaque instance le type de sa propriété ; ainsi `api` est stockée comme `any ProfileAPI` et un test peut la remplacer par n’importe quel autre type conforme.

## Installation

### Swift Package Manager

Dans Xcode, choisissez **File › Add Package Dependencies…** et saisissez l’URL du dépôt :

```text
https://github.com/muhittincamdali/SwiftDependencyInjection.git
```

Ou ajoutez-le aux `dependencies` de votre `Package.swift` :

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

Le paquet contient une macro Swift ; Xcode vous demande donc une fois de lui faire confiance (**Trust & Enable**), et la compilation utilise [swift-syntax](https://github.com/swiftlang/swift-syntax) (602 à 604).

## Utilisation

Les exemples ci-dessous sont copiés depuis
[`ReadmeSamples.swift`](Examples/DependencyDemo/DependencyDemo/ReadmeSamples.swift) et
[`DependencyDemoApp.swift`](Examples/DependencyDemo/DependencyDemo/DependencyDemoApp.swift), que l’app d’exemple compile, ainsi que depuis
[`ReadmeSamplesTests.swift`](Tests/SwiftDependencyInjectionTests/ReadmeSamplesTests.swift), que la suite de tests exécute.

### Créer le conteneur une seule fois

L’app possède son conteneur et le transmet vers le bas, ou transmet les dépendances nécessaires :

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

Les objets reçoivent leurs dépendances par leurs initializers (`ProfileStore(api:)`) ; chacun peut donc aussi être construit seul dans un test, sans conteneur.

### Remplacer des dépendances dans un test

`override(_:)` prend une closure qui renseigne des champs de l’`Overrides` généré ; les champs laissés à `nil` conservent la dépendance réelle. Le vrai provider de `profileStore` s’exécute et lit le stub :

```swift
let dependencies = AppDependencies()
dependencies.override {
    $0.api = { StubProfileAPI(profiles: [Profile(id: 1, name: "Ada", role: "Analyst")]) }
}

let store = dependencies.profileStore
try await store.refresh()

#expect(store.profiles.map(\.name) == ["Ada"])
```

Chaque test crée son propre conteneur : les overrides ne fuient donc jamais d’un test à l’autre et Swift Testing peut les exécuter en parallèle. Les previews utilisent le même appel.

### Limiter les dépendances à une session

Une instance de conteneur est un scope. Un conteneur enfant conserve son parent et les valeurs du scope sous forme de propriétés stockées ; rien à l’intérieur n’a donc à gérer l’absence d’utilisateur :

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

Créez-en un quand un utilisateur se connecte et libérez-le quand il se déconnecte ; ses instances shared disparaissent avec lui, tandis que `app.profileStore` reste partagé par toutes les sessions.

### Laisser le compilateur trouver les cycles

Un provider qui a besoin de lui-même, directement ou via d’autres dépendances, ne compile pas :

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

[`DiagnosticTests.swift`](Tests/SwiftDependencyInjectionMacrosTests/DiagnosticTests.swift) développe cet exemple avec la macro et vérifie le texte exact de l’erreur.

Les lectures à l’intérieur de closures imbriquées ne sont pas suivies, car un callback s’exécute en général après la construction. Si une telle closure s’exécute pendant la construction, le conteneur arrête le processus avec `dependency cycle in AppDependencies: api → tokens → api` au lieu de faire déborder la pile.

## Démo

L’app [DependencyDemo](Examples/DependencyDemo) fait tourner chaque idée avec la vraie bibliothèque. Les captures d’écran proviennent de l’app dans un simulateur iOS 27 et ont été prises par [`scripts/capture-example-screens.sh`](scripts/capture-example-screens.sh) :

| API réelle et remplacée | Shared, transient et sessions | Graphe généré |
| --- | --- | --- |
| <picture><source media="(prefers-color-scheme: dark)" srcset="docs/images/demo-overrides-dark.png"><img src="docs/images/demo-overrides-light.png" width="260" alt="Deux conteneurs chargent des profils : le conteneur réel a injecté DemoServerAPI et a pris environ 600 ms, celui dont l’API est remplacée a injecté StubProfileAPI"></picture> | <picture><source media="(prefers-color-scheme: dark)" srcset="docs/images/demo-scopes-dark.png"><img src="docs/images/demo-scopes-light.png" width="260" alt="Journal de lectures : profileStore renvoie deux fois la même instance, profileEditor une nouvelle à chaque fois, deux sessions partagent le store de l’app"></picture> | <picture><source media="(prefers-color-scheme: dark)" srcset="docs/images/demo-graph-dark.png"><img src="docs/images/demo-graph-light.png" width="260" alt="Les dépendances d’AppDependencies et de SessionDependencies avec leurs durées de vie et les lectures entre elles"></picture> |

Pour la lancer, ouvrez `DependencyDemo.xcodeproj` dans [Examples/DependencyDemo](Examples/DependencyDemo) avec Xcode 26 ou version ultérieure, choisissez un simulateur d’iPhone ou **My Mac**, puis appuyez sur **Run**. [Examples/README.md](Examples/README.md) décrit chaque écran.

## Quand choisir Factory ou swift-dependencies à la place

[Factory](https://github.com/hmlongco/Factory) et
[swift-dependencies](https://github.com/pointfreeco/swift-dependencies) sont les bibliothèques d’injection de dépendances les plus utilisées pour Swift, et elles font des choses que ce paquet ne fait pas :

- **Choisissez Factory** pour injecter n’importe où avec `@Injected` sans transmettre de conteneur, pour des factories paramétrées, davantage de scopes (cached, weak shared, graph, custom), des decorators et des contextes qui changent automatiquement d’implémentation pour les previews, les tests et les builds de debug.
- **Choisissez swift-dependencies** avec The Composable Architecture, quand des dépendances comme l’horloge, la date et les UUID doivent atteindre n’importe quel code via les task locals, ou quand une utilisation inattendue d’une dépendance dans un test doit le faire échouer.
- **Choisissez [SafeDI](https://github.com/dfed/SafeDI)** pour valider à la compilation tout un graphe d’objets à travers les modules, avec des initializers et des mocks générés.
- **Choisissez ce paquet** pour une injection explicite par constructeur avec une classe de conteneur par scope, des overrides typés et des cycles signalés par le compilateur.

L’article
[Choisir une bibliothèque d’injection de dépendances](https://muhittincamdali.github.io/SwiftDependencyInjection/documentation/swiftdependencyinjection/choosingadependencyinjectionlibrary)
les compare fonctionnalité par fonctionnalité et énumère les limites de ce paquet.

## Documentation

Référence de l’API et articles :

- [Référence de SwiftDependencyInjection](https://muhittincamdali.github.io/SwiftDependencyInjection/documentation/swiftdependencyinjection/)
- [Premiers pas](https://muhittincamdali.github.io/SwiftDependencyInjection/documentation/swiftdependencyinjection/gettingstarted)
- [Tester avec des overrides](https://muhittincamdali.github.io/SwiftDependencyInjection/documentation/swiftdependencyinjection/testingwithoverrides)
- [Scopes et durées de vie](https://muhittincamdali.github.io/SwiftDependencyInjection/documentation/swiftdependencyinjection/scopesandlifetimes)
- [Choisir une bibliothèque d’injection de dépendances](https://muhittincamdali.github.io/SwiftDependencyInjection/documentation/swiftdependencyinjection/choosingadependencyinjectionlibrary)

## Guides

- [Premiers pas](Sources/SwiftDependencyInjection/SwiftDependencyInjection.docc/GettingStarted.md)
  — déclarer un conteneur, choisir son isolation, transmettre les dépendances et ce que le compilateur vérifie.
- [Tester avec des overrides](Sources/SwiftDependencyInjection/SwiftDependencyInjection.docc/TestingWithOverrides.md)
  — comment les overrides sont typés, délimités, mis en cache et isolés, et comment les utiliser dans les previews.
- [Scopes et durées de vie](Sources/SwiftDependencyInjection/SwiftDependencyInjection.docc/ScopesAndLifetimes.md)
  — shared et transient, conteneurs enfants, cycles et graphe de dépendances.
- [Choisir une bibliothèque d’injection de dépendances](Sources/SwiftDependencyInjection/SwiftDependencyInjection.docc/ChoosingADependencyInjectionLibrary.md)
  — Factory, swift-dependencies, SafeDI et ce paquet côte à côte.

## Prérequis

| Plateforme | Version minimale |
| --- | --- |
| iOS | 16 |
| macOS | 13 |
| tvOS | 16 |
| watchOS | 9 |
| visionOS | 1 |
| Chaîne d’outils | Swift 6.2 · Xcode 26+ |

## Architecture

Le paquet contient une bibliothèque et une cible de macro :

| Cible | Contenu |
| --- | --- |
| `SwiftDependencyInjection` | `DependencyContainer` (le protocole avec `shared` et `transient`), `DependencyStorage`, `DependencyGraph`, la déclaration de `@DependencyContainer` |
| `SwiftDependencyInjectionMacros` | La macro : lit le corps de la classe, génère les membres, trouve les cycles et signale les mauvais usages |

Décisions de conception :

- **Des propriétés, pas des enregistrements.** Une dépendance est une propriété calculée : le compilateur vérifie donc chaque utilisation. Rien n’est enregistré au lancement, donc rien ne peut manquer à l’exécution.
- **Le key path est la clé.** `shared(\.api)` stocke l’instance sous le key path de sa propriété, ce qui fixe aussi son type à celui de la propriété ; les overrides d’un autre type conforme conviennent donc, et deux propriétés ne peuvent jamais partager une entrée.
- **Un verrou récursif par conteneur.** Il est détenu pendant l’exécution d’un provider : une dépendance shared est construite exactement une fois, les providers peuvent se lire entre eux, et la chaîne en cours de construction sert aussi de contrôle de cycles à l’exécution.
- **Les overrides sont générés, pas stockés par nom.** La macro écrit un champ typé par dépendance et donne aux closures l’isolation du conteneur.
- **Le conteneur est le scope.** L’absence d’état global signifie aucune réinitialisation entre les tests et aucune durée de vie cachée : les instances d’un conteneur vivent exactement aussi longtemps que lui.

## Feuille de route

- Des dépendances paramétrées (`func editor(for: Profile)`) qui peuvent être remplacées comme des propriétés.
- Une durée de vie weak facultative : une seule instance tant que quelque chose la retient, reconstruite ensuite.
- Une trace de ce qui a été construit pendant une résolution, pour déboguer de grands conteneurs.

## Contribuer

Les contributions sont les bienvenues. Lisez le [guide de contribution](https://github.com/muhittincamdali/SwiftDependencyInjection/blob/main/CONTRIBUTING.md) et le [code de conduite](https://github.com/muhittincamdali/SwiftDependencyInjection/blob/main/CODE_OF_CONDUCT.md) avant d’ouvrir une pull request. Signalez les problèmes de sécurité en privé, comme indiqué dans la [politique de sécurité](https://github.com/muhittincamdali/SwiftDependencyInjection/blob/main/SECURITY.md).

## Licence

Publié sous licence MIT. Voir [LICENSE](LICENSE).
