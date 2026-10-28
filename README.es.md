<!-- i18n-source: README.md@db0ca6cfacb99492bf497614f3316a072a7016fa status=reviewed -->
<!-- brand:start -->

<p align="center"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/banner-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/banner-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/banner-light.svg" alt="SwiftDependencyInjection: Dependency containers for Swift 6 that the compiler checks, with typed test overrides and no global state."></picture></p>

<!-- lang-selector:start -->
<p align="center"><a href="README.md">English</a> · <a href="README.tr.md">Türkçe</a> · <a href="README.zh-CN.md">简体中文</a> · <a href="README.ja.md">日本語</a> · <a href="README.ko.md">한국어</a> · <a href="README.es.md">Español</a> · <a href="README.de.md">Deutsch</a> · <a href="README.fr.md">Français</a> · <a href="README.pt-BR.md">Português (Brasil)</a> · <a href="README.ru.md">Русский</a></p>
<!-- lang-selector:end -->

<p align="center">
<a href="https://github.com/muhittincamdali/SwiftDependencyInjection/actions/workflows/ci.yml"><img src="https://github.com/muhittincamdali/SwiftDependencyInjection/actions/workflows/ci.yml/badge.svg" alt="Estado de CI"></a>
<a href="https://github.com/muhittincamdali/SwiftDependencyInjection/releases"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/badge-version-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/badge-version-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/badge-version-light.svg" alt="Última versión: v1.0.0"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftDependencyInjection/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/badge-platforms-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/badge-platforms-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/badge-platforms-light.svg" alt="Plataformas compatibles: iOS 16+ · macOS 13+ · tvOS 16+ · watchOS 9+ · visionOS 1+"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftDependencyInjection/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/badge-language-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/badge-language-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/badge-language-light.svg" alt="Versión del lenguaje: Swift 6.2+ · Swift 6 mode"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftDependencyInjection/blob/main/LICENSE"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/badge-license-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/badge-license-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/badge-license-light.svg" alt="Licencia: MIT"></picture></a>
</p>

<p align="center">
<a href="#inicio-rápido"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/button-start-es-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/button-start-es-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/button-start-es-light.svg" alt="Empezar"></picture></a>
<a href="https://muhittincamdali.github.io/SwiftDependencyInjection/documentation/swiftdependencyinjection/"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/button-docs-es-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/button-docs-es-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/button-docs-es-light.svg" alt="Documentación"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftDependencyInjection/tree/main/Examples"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/button-examples-es-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/button-examples-es-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/button-examples-es-light.svg" alt="Ejemplos"></picture></a>
</p>

> Esta es una traducción del README en inglés. Si hay diferencias, la versión en inglés es la vigente.

<!-- brand:end -->

SwiftDependencyInjection es inyección de dependencias manual para Swift 6 con las partes repetitivas generadas. Declaras tus dependencias como propiedades computadas de una sola clase `final`; la macro `@DependencyContainer` la convierte en un contenedor: cada dependencia `shared` se construye una vez y se guarda en caché de forma segura entre hilos, cada dependencia `transient` se construye en cada lectura, los tests reemplazan cualquiera de ellas mediante un `override` tipado y generado, y un ciclo de dependencias es un error de compilación. No hay contenedor global ni búsquedas que puedan fallar en tiempo de ejecución: una dependencia es una propiedad, así que si falta una, no compila.

## Lo más destacado

- **Comprobado por el compilador** — una dependencia es una propiedad, así que una que falte o que tenga un tipo incorrecto es un error de compilación. La macro informa de ciclos (`api → tokens → api`), de providers en el lugar equivocado y de dependencias que un override no podría reemplazar, cada uno con la solución en el mensaje.
- **Overrides tipados para tests** — cada contenedor recibe una estructura `Overrides` con un campo por dependencia, con el mismo tipo que la propiedad: `$0.api = { StubProfileAPI(…) }`.
- **Sin estado global** — las instancias y los overrides pertenecen a una única instancia de contenedor. Los tests que crean cada uno su contenedor pueden ejecutarse en paralelo; un contenedor hijo es un ámbito, por ejemplo un usuario con la sesión iniciada.
- **Concurrencia de Swift 6** — una dependencia shared se construye exactamente una vez aunque la lean muchos hilos. Los contenedores `@MainActor` reciben overrides `@MainActor`; los demás, overrides `@Sendable`.
- **Ciclos detectados también en tiempo de ejecución** — un ciclo que la macro no puede ver, a través de un método o de un closure, detiene el proceso con la misma ruta en lugar de desbordar la pila.
- **Un grafo que puedes leer** — cada contenedor tiene un `dependencyGraph`, escrito en tiempo de compilación, con salida en formato Graphviz.

## Inicio rápido

**1. Añade el paquete**

En Xcode, elige **File › Add Package Dependencies…** e introduce la URL del repositorio:

```text
https://github.com/muhittincamdali/SwiftDependencyInjection.git
```

**2. Importa el módulo**

```swift
import SwiftDependencyInjection
```

**3. Declara un contenedor**

Cada dependencia es una propiedad computada cuyo getter es una única llamada a `shared` o `transient` con el key path de esa propiedad
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

Créalo una sola vez y lee lo que necesites: `AppDependencies().profileStore` construye la API y el store en el primer uso y después devuelve el mismo store. El key path da a cada instancia el tipo de su propiedad, por lo que `api` se guarda como `any ProfileAPI` y un test puede reemplazarla por cualquier otro tipo que cumpla el protocolo.

## Instalación

### Swift Package Manager

En Xcode, elige **File › Add Package Dependencies…** e introduce la URL del repositorio:

```text
https://github.com/muhittincamdali/SwiftDependencyInjection.git
```

O añádelo a las `dependencies` de tu `Package.swift`:

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

El paquete contiene una macro de Swift, así que Xcode te pide una vez que confíes en ella (**Trust & Enable**) y la compilación usa [swift-syntax](https://github.com/swiftlang/swift-syntax) (de la 602 a la 604).

## Uso

Los ejemplos de abajo están copiados de
[`ReadmeSamples.swift`](Examples/DependencyDemo/DependencyDemo/ReadmeSamples.swift) y
[`DependencyDemoApp.swift`](Examples/DependencyDemo/DependencyDemo/DependencyDemoApp.swift), que compila la app de ejemplo, y de
[`ReadmeSamplesTests.swift`](Tests/SwiftDependencyInjectionTests/ReadmeSamplesTests.swift), que ejecuta la suite de tests.

### Crea el contenedor una sola vez

La app es dueña de su contenedor y lo pasa hacia abajo, o pasa las dependencias necesarias:

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

Los objetos reciben sus dependencias por medio de sus initializers (`ProfileStore(api:)`), de modo que cada uno también se puede construir por separado en un test, sin contenedor.

### Reemplaza dependencias en un test

`override(_:)` recibe un closure que asigna campos del `Overrides` generado; los campos que se dejan en `nil` conservan la dependencia real. El provider real de `profileStore` se ejecuta y lee el stub:

```swift
let dependencies = AppDependencies()
dependencies.override {
    $0.api = { StubProfileAPI(profiles: [Profile(id: 1, name: "Ada", role: "Analyst")]) }
}

let store = dependencies.profileStore
try await store.refresh()

#expect(store.profiles.map(\.name) == ["Ada"])
```

Cada test crea su propio contenedor, así que los overrides nunca se filtran de un test a otro y Swift Testing puede ejecutarlos en paralelo. Las previsualizaciones usan la misma llamada.

### Limita las dependencias a una sesión

Una instancia de contenedor es un ámbito. Un contenedor hijo guarda a su padre y los valores del ámbito como propiedades almacenadas, de modo que nada en su interior tiene que manejar la ausencia de un usuario:

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

Crea uno cuando un usuario inicie sesión y suéltalo cuando la cierre; sus instancias shared desaparecen con él, mientras que `app.profileStore` sigue compartido por todas las sesiones.

### Deja que el compilador encuentre los ciclos

Un provider que se necesita a sí mismo, directamente o a través de otras dependencias, no compila:

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

[`DiagnosticTests.swift`](Tests/SwiftDependencyInjectionMacrosTests/DiagnosticTests.swift) expande este ejemplo con la macro y comprueba el texto exacto del error.

Las lecturas dentro de closures anidados no se siguen, porque un callback suele ejecutarse después de la construcción. Si un closure así se ejecuta durante la construcción, el contenedor detiene el proceso con `dependency cycle in AppDependencies: api → tokens → api` en lugar de desbordar la pila.

## Demo

La app [DependencyDemo](Examples/DependencyDemo) ejecuta cada idea con la biblioteca real. Las capturas salen de la app en un simulador de iOS 27 y las toma [`scripts/capture-example-screens.sh`](scripts/capture-example-screens.sh):

| API real y con override | Shared, transient y sesiones | Grafo generado |
| --- | --- | --- |
| <picture><source media="(prefers-color-scheme: dark)" srcset="docs/images/demo-overrides-dark.png"><img src="docs/images/demo-overrides-light.png" width="260" alt="Dos contenedores cargan perfiles: el real inyectó DemoServerAPI y tardó unos 600 ms, el que tiene override inyectó StubProfileAPI"></picture> | <picture><source media="(prefers-color-scheme: dark)" srcset="docs/images/demo-scopes-dark.png"><img src="docs/images/demo-scopes-light.png" width="260" alt="Registro de lecturas: profileStore devuelve la misma instancia dos veces, profileEditor una nueva cada vez, y dos sesiones comparten el store de la app"></picture> | <picture><source media="(prefers-color-scheme: dark)" srcset="docs/images/demo-graph-dark.png"><img src="docs/images/demo-graph-light.png" width="260" alt="Las dependencias de AppDependencies y SessionDependencies con sus ciclos de vida y las lecturas entre ellas"></picture> |

Para ejecutarla, abre `DependencyDemo.xcodeproj` en [Examples/DependencyDemo](Examples/DependencyDemo) con Xcode 26 o posterior, elige un simulador de iPhone o **My Mac** y pulsa **Run**. [Examples/README.md](Examples/README.md) describe cada pantalla.

## Cuándo elegir Factory o swift-dependencies en su lugar

[Factory](https://github.com/hmlongco/Factory) y
[swift-dependencies](https://github.com/pointfreeco/swift-dependencies) son las bibliotecas de inyección de dependencias para Swift más usadas, y hacen cosas que este paquete no hace:

- **Elige Factory** para inyectar en cualquier lugar con `@Injected` sin pasar un contenedor, para factories con parámetros, más ámbitos (cached, weak shared, graph, custom), decorators y contextos que cambian las implementaciones automáticamente en previsualizaciones, tests y compilaciones de depuración.
- **Elige swift-dependencies** con The Composable Architecture, cuando dependencias como el reloj, la fecha y los UUID deban llegar a cualquier código a través de task locals, o cuando un uso inesperado de una dependencia en un test deba hacerlo fallar.
- **Elige [SafeDI](https://github.com/dfed/SafeDI)** para validar en tiempo de compilación todo un grafo de objetos entre módulos, con initializers y mocks generados.
- **Elige este paquete** para una inyección explícita por constructor con una clase de contenedor por ámbito, overrides tipados y ciclos que informa el compilador.

El artículo
[Elegir una biblioteca de inyección de dependencias](https://muhittincamdali.github.io/SwiftDependencyInjection/documentation/swiftdependencyinjection/choosingadependencyinjectionlibrary)
las compara característica por característica y enumera los límites de este paquete.

## Documentación

Referencia de la API y artículos:

- [Referencia de SwiftDependencyInjection](https://muhittincamdali.github.io/SwiftDependencyInjection/documentation/swiftdependencyinjection/)
- [Primeros pasos](https://muhittincamdali.github.io/SwiftDependencyInjection/documentation/swiftdependencyinjection/gettingstarted)
- [Tests con overrides](https://muhittincamdali.github.io/SwiftDependencyInjection/documentation/swiftdependencyinjection/testingwithoverrides)
- [Ámbitos y ciclos de vida](https://muhittincamdali.github.io/SwiftDependencyInjection/documentation/swiftdependencyinjection/scopesandlifetimes)
- [Elegir una biblioteca de inyección de dependencias](https://muhittincamdali.github.io/SwiftDependencyInjection/documentation/swiftdependencyinjection/choosingadependencyinjectionlibrary)

## Guías

- [Primeros pasos](Sources/SwiftDependencyInjection/SwiftDependencyInjection.docc/GettingStarted.md)
  — cómo declarar un contenedor, elegir su aislamiento, pasar las dependencias hacia abajo y qué comprueba el compilador.
- [Tests con overrides](Sources/SwiftDependencyInjection/SwiftDependencyInjection.docc/TestingWithOverrides.md)
  — cómo se tipan, acotan, guardan en caché y aíslan los overrides, y cómo usarlos en previsualizaciones.
- [Ámbitos y ciclos de vida](Sources/SwiftDependencyInjection/SwiftDependencyInjection.docc/ScopesAndLifetimes.md)
  — shared y transient, contenedores hijos, ciclos y el grafo de dependencias.
- [Elegir una biblioteca de inyección de dependencias](Sources/SwiftDependencyInjection/SwiftDependencyInjection.docc/ChoosingADependencyInjectionLibrary.md)
  — Factory, swift-dependencies, SafeDI y este paquete, lado a lado.

## Requisitos

| Plataforma | Versión mínima |
| --- | --- |
| iOS | 16 |
| macOS | 13 |
| tvOS | 16 |
| watchOS | 9 |
| visionOS | 1 |
| Herramientas | Swift 6.2 · Xcode 26+ |

## Arquitectura

El paquete tiene una biblioteca y un target de macro:

| Target | Contenido |
| --- | --- |
| `SwiftDependencyInjection` | `DependencyContainer` (el protocolo con `shared` y `transient`), `DependencyStorage`, `DependencyGraph`, la declaración de `@DependencyContainer` |
| `SwiftDependencyInjectionMacros` | La macro: lee el cuerpo de la clase, genera los miembros, encuentra ciclos e informa del mal uso |

Decisiones de diseño:

- **Propiedades, no registros.** Una dependencia es una propiedad computada, así que el compilador comprueba cada uso. No se registra nada al arrancar, por lo que no puede faltar nada en tiempo de ejecución.
- **El key path es la clave.** `shared(\.api)` guarda la instancia bajo el key path de su propiedad, lo que además fija su tipo al de la propiedad; así encajan los overrides de otro tipo que cumpla el protocolo y dos propiedades nunca pueden compartir una entrada.
- **Un lock recursivo por contenedor.** Se mantiene mientras se ejecuta un provider: una dependencia shared se construye exactamente una vez, los providers pueden leerse entre sí y la cadena que se está construyendo hace además de comprobación de ciclos en tiempo de ejecución.
- **Los overrides se generan, no se guardan por nombre.** La macro escribe un campo tipado por dependencia y da a los closures el aislamiento del contenedor.
- **El contenedor es el ámbito.** Sin estado global no hay que reiniciar nada entre tests ni hay ciclos de vida ocultos: las instancias de un contenedor viven exactamente lo que vive él.

## Hoja de ruta

- Dependencias con parámetros (`func editor(for: Profile)`) que se puedan reemplazar con overrides igual que las propiedades.
- Un ciclo de vida weak opcional: una sola instancia mientras algo la retenga, reconstruida después.
- Una traza de lo que se construyó durante una resolución, para depurar contenedores grandes.

## Contribuir

Las contribuciones son bienvenidas. Lee la [guía de contribución](https://github.com/muhittincamdali/SwiftDependencyInjection/blob/main/CONTRIBUTING.md) y el [código de conducta](https://github.com/muhittincamdali/SwiftDependencyInjection/blob/main/CODE_OF_CONDUCT.md) antes de abrir una pull request. Informa de los problemas de seguridad de forma privada, como se describe en la [política de seguridad](https://github.com/muhittincamdali/SwiftDependencyInjection/blob/main/SECURITY.md).

## Licencia

Publicado bajo la licencia MIT. Consulta [LICENSE](LICENSE).
