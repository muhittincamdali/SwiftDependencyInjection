<!-- i18n-source: README.md@fe1b1436375ad6c38c0fa56ad238003e76254a1f status=reviewed -->
<!-- brand:start -->

<p align="center"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/banner-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/banner-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/banner-light.svg" alt="SwiftDependencyInjection: Dependency containers for Swift 6 that the compiler checks, with typed test overrides and no global state."></picture></p>

<!-- lang-selector:start -->
<p align="center"><a href="README.md">English</a> · <a href="README.tr.md">Türkçe</a> · <a href="README.zh-CN.md">简体中文</a> · <a href="README.ja.md">日本語</a> · <a href="README.ko.md">한국어</a> · <a href="README.es.md">Español</a> · <a href="README.de.md">Deutsch</a> · <a href="README.fr.md">Français</a> · <a href="README.pt-BR.md">Português (Brasil)</a> · <a href="README.ru.md">Русский</a></p>
<!-- lang-selector:end -->

<p align="center">
<a href="https://github.com/muhittincamdali/SwiftDependencyInjection/actions/workflows/ci.yml"><img src="https://github.com/muhittincamdali/SwiftDependencyInjection/actions/workflows/ci.yml/badge.svg" alt="Status da CI"></a>
<a href="https://github.com/muhittincamdali/SwiftDependencyInjection/releases"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/badge-version-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/badge-version-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/badge-version-light.svg" alt="Versão mais recente: v1.0.0"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftDependencyInjection/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/badge-platforms-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/badge-platforms-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/badge-platforms-light.svg" alt="Plataformas compatíveis: iOS 16+ · macOS 13+ · tvOS 16+ · watchOS 9+ · visionOS 1+"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftDependencyInjection/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/badge-language-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/badge-language-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/badge-language-light.svg" alt="Versão da linguagem: Swift 6.2+ · Swift 6 mode"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftDependencyInjection/blob/main/LICENSE"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/badge-license-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/badge-license-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/badge-license-light.svg" alt="Licença: MIT"></picture></a>
</p>

<p align="center">
<a href="#início-rápido"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/button-start-pt-BR-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/button-start-pt-BR-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/button-start-pt-BR-light.svg" alt="Começar"></picture></a>
<a href="https://muhittincamdali.github.io/SwiftDependencyInjection/documentation/swiftdependencyinjection/"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/button-docs-pt-BR-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/button-docs-pt-BR-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/button-docs-pt-BR-light.svg" alt="Documentação"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftDependencyInjection/tree/main/Examples"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/button-examples-pt-BR-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/button-examples-pt-BR-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/button-examples-pt-BR-light.svg" alt="Exemplos"></picture></a>
</p>

> Esta é uma tradução do README em inglês. Se houver diferença, vale a versão em inglês.

<!-- brand:end -->

SwiftDependencyInjection é injeção de dependências manual para Swift 6 com as partes repetitivas geradas. Você lista suas dependências como propriedades computadas de uma única classe `final`; a macro `@DependencyContainer` a transforma em um contêiner: cada dependência `shared` é criada uma vez e guardada em cache de forma thread-safe, cada dependência `transient` é criada a cada leitura, os testes substituem qualquer uma delas por meio de um `override` tipado e gerado, e um ciclo de dependências é um erro de compilação. Não há contêiner global nem busca que possa falhar em tempo de execução: uma dependência é uma propriedade, então uma que esteja faltando não compila.

## Destaques

- **Verificado pelo compilador** — uma dependência é uma propriedade, então uma dependência ausente ou de tipo errado é um erro de compilação. A macro reporta ciclos (`api → tokens → api`), providers no lugar errado e dependências que um override não conseguiria substituir, cada um com a correção na mensagem.
- **Overrides tipados para testes** — cada contêiner ganha uma struct `Overrides` com um campo por dependência, tipado como a propriedade: `$0.api = { StubProfileAPI(…) }`.
- **Sem estado global** — instâncias e overrides pertencem a uma única instância de contêiner. Testes que criam cada um o seu contêiner podem rodar em paralelo; um contêiner filho é um escopo, como um usuário autenticado.
- **Concorrência do Swift 6** — uma dependência shared é criada exatamente uma vez, mesmo quando muitas threads a leem. Contêineres `@MainActor` recebem overrides `@MainActor`; os demais, overrides `@Sendable`.
- **Ciclos detectados também em tempo de execução** — um ciclo que a macro não consegue ver, passando por um método ou um closure, interrompe o processo com o mesmo caminho, em vez de estourar a pilha.
- **Um grafo que você consegue ler** — cada contêiner tem um `dependencyGraph`, escrito em tempo de compilação, com saída em Graphviz.

## Início rápido

**1. Adicione o pacote**

No Xcode, escolha **File › Add Package Dependencies…** e informe a URL do repositório:

```text
https://github.com/muhittincamdali/SwiftDependencyInjection.git
```

**2. Importe o módulo**

```swift
import SwiftDependencyInjection
```

**3. Declare um contêiner**

Cada dependência é uma propriedade computada cujo getter é uma única chamada a `shared` ou `transient` com o key path dessa propriedade
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

Crie-o uma só vez e leia o que precisar: `AppDependencies().profileStore` cria a API e o store no primeiro uso e depois devolve o mesmo store. O key path dá a cada instância o tipo da sua propriedade, então `api` é guardada como `any ProfileAPI` e um teste pode substituí-la por qualquer outro tipo que esteja em conformidade.

## Instalação

### Swift Package Manager

No Xcode, escolha **File › Add Package Dependencies…** e informe a URL do repositório:

```text
https://github.com/muhittincamdali/SwiftDependencyInjection.git
```

Ou adicione-o às `dependencies` do seu `Package.swift`:

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

O pacote contém uma macro Swift; por isso o Xcode pergunta uma vez se você confia nela (**Trust & Enable**) e a compilação usa o [swift-syntax](https://github.com/swiftlang/swift-syntax) (602 a 604).

## Uso

Os exemplos abaixo foram copiados de
[`ReadmeSamples.swift`](Examples/DependencyDemo/DependencyDemo/ReadmeSamples.swift) e
[`DependencyDemoApp.swift`](Examples/DependencyDemo/DependencyDemo/DependencyDemoApp.swift), que o app de exemplo compila, e de
[`ReadmeSamplesTests.swift`](Tests/SwiftDependencyInjectionTests/ReadmeSamplesTests.swift), que a suíte de testes executa.

### Crie o contêiner uma só vez

O app é dono do seu contêiner e o repassa para baixo, ou repassa as dependências necessárias:

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

Os objetos recebem suas dependências por meio dos initializers (`ProfileStore(api:)`), então cada um também pode ser criado isoladamente em um teste, sem contêiner.

### Substitua dependências em um teste

`override(_:)` recebe um closure que define campos do `Overrides` gerado; os campos deixados como `nil` mantêm a dependência real. O provider real de `profileStore` é executado e lê o stub:

```swift
let dependencies = AppDependencies()
dependencies.override {
    $0.api = { StubProfileAPI(profiles: [Profile(id: 1, name: "Ada", role: "Analyst")]) }
}

let store = dependencies.profileStore
try await store.refresh()

#expect(store.profiles.map(\.name) == ["Ada"])
```

Cada teste cria o seu próprio contêiner, então os overrides nunca vazam de um teste para outro e o Swift Testing pode executá-los em paralelo. As previews usam a mesma chamada.

### Limite as dependências a uma sessão

Uma instância de contêiner é um escopo. Um contêiner filho guarda o pai e os valores do escopo como propriedades armazenadas, de modo que nada dentro dele precisa lidar com a ausência de um usuário:

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

Crie um quando o usuário entrar e libere-o quando ele sair; as instâncias shared vão embora junto com ele, enquanto `app.profileStore` continua compartilhado por todas as sessões.

### Deixe o compilador encontrar os ciclos

Um provider que precisa de si mesmo, direta ou indiretamente por meio de outras dependências, não compila:

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

As leituras dentro de closures aninhados não são acompanhadas, porque um callback costuma rodar depois da criação. Se um closure assim rodar durante a criação, o contêiner interrompe o processo com `dependency cycle in AppDependencies: api → tokens → api`, em vez de estourar a pilha.

## Demonstração

O app [DependencyDemo](Examples/DependencyDemo) executa cada ideia com a biblioteca real. As capturas de tela vêm do app em um simulador de iOS 27 e foram tiradas por [`scripts/capture-example-screens.sh`](scripts/capture-example-screens.sh):

| API real e com override | Shared, transient e sessões | Grafo gerado |
| --- | --- | --- |
| <picture><source media="(prefers-color-scheme: dark)" srcset="docs/images/demo-overrides-dark.png"><img src="docs/images/demo-overrides-light.png" width="260" alt="Dois contêineres carregam perfis: o real injetou DemoServerAPI e levou cerca de 600 ms, o que tem override injetou StubProfileAPI"></picture> | <picture><source media="(prefers-color-scheme: dark)" srcset="docs/images/demo-scopes-dark.png"><img src="docs/images/demo-scopes-light.png" width="260" alt="Registro de leituras: profileStore devolve a mesma instância duas vezes, profileEditor uma nova a cada vez, e duas sessões compartilham o store do app"></picture> | <picture><source media="(prefers-color-scheme: dark)" srcset="docs/images/demo-graph-dark.png"><img src="docs/images/demo-graph-light.png" width="260" alt="As dependências de AppDependencies e SessionDependencies com seus ciclos de vida e as leituras entre elas"></picture> |

Para executá-lo, abra `DependencyDemo.xcodeproj` em [Examples/DependencyDemo](Examples/DependencyDemo) com o Xcode 26 ou posterior, escolha um simulador de iPhone ou **My Mac** e clique em **Run**. [Examples/README.md](Examples/README.md) descreve cada tela.

## Quando escolher Factory ou swift-dependencies em vez deste pacote

[Factory](https://github.com/hmlongco/Factory) e
[swift-dependencies](https://github.com/pointfreeco/swift-dependencies) são as bibliotecas de injeção de dependências mais usadas em Swift, e fazem coisas que este pacote não faz:

- **Escolha Factory** para injetar em qualquer lugar com `@Injected` sem repassar um contêiner, para factories parametrizadas, mais escopos (cached, weak shared, graph, custom), decorators e contextos que trocam implementações automaticamente em previews, testes e builds de debug.
- **Escolha swift-dependencies** com The Composable Architecture, quando dependências como o relógio, a data e UUIDs devem chegar a qualquer código por meio de task locals, ou quando um uso inesperado de uma dependência em um teste deve fazê-lo falhar.
- **Escolha o [SafeDI](https://github.com/dfed/SafeDI)** para validar em tempo de compilação todo um grafo de objetos entre módulos, com initializers e mocks gerados.
- **Escolha este pacote** para injeção explícita por construtor com uma classe de contêiner por escopo, overrides tipados e ciclos reportados pelo compilador.

O artigo
[Como escolher uma biblioteca de injeção de dependências](https://muhittincamdali.github.io/SwiftDependencyInjection/documentation/swiftdependencyinjection/choosingadependencyinjectionlibrary)
compara as bibliotecas recurso por recurso e lista os limites deste pacote.

## Documentação

Referência da API e artigos:

- [Referência do SwiftDependencyInjection](https://muhittincamdali.github.io/SwiftDependencyInjection/documentation/swiftdependencyinjection/)
- [Primeiros passos](https://muhittincamdali.github.io/SwiftDependencyInjection/documentation/swiftdependencyinjection/gettingstarted)
- [Testes com overrides](https://muhittincamdali.github.io/SwiftDependencyInjection/documentation/swiftdependencyinjection/testingwithoverrides)
- [Escopos e ciclos de vida](https://muhittincamdali.github.io/SwiftDependencyInjection/documentation/swiftdependencyinjection/scopesandlifetimes)
- [Como escolher uma biblioteca de injeção de dependências](https://muhittincamdali.github.io/SwiftDependencyInjection/documentation/swiftdependencyinjection/choosingadependencyinjectionlibrary)

## Guias

- [Primeiros passos](Sources/SwiftDependencyInjection/SwiftDependencyInjection.docc/GettingStarted.md)
  — como declarar um contêiner, escolher seu isolamento, repassar dependências e o que o compilador verifica.
- [Testes com overrides](Sources/SwiftDependencyInjection/SwiftDependencyInjection.docc/TestingWithOverrides.md)
  — como os overrides são tipados, delimitados, guardados em cache e isolados, e como usá-los em previews.
- [Escopos e ciclos de vida](Sources/SwiftDependencyInjection/SwiftDependencyInjection.docc/ScopesAndLifetimes.md)
  — shared e transient, contêineres filhos, ciclos e o grafo de dependências.
- [Como escolher uma biblioteca de injeção de dependências](Sources/SwiftDependencyInjection/SwiftDependencyInjection.docc/ChoosingADependencyInjectionLibrary.md)
  — Factory, swift-dependencies, SafeDI e este pacote lado a lado.

## Requisitos

| Plataforma | Versão mínima |
| --- | --- |
| iOS | 16 |
| macOS | 13 |
| tvOS | 16 |
| watchOS | 9 |
| visionOS | 1 |
| Ferramentas | Swift 6.2 · Xcode 26+ |

## Arquitetura

O pacote tem uma biblioteca e um target de macro:

| Target | Conteúdo |
| --- | --- |
| `SwiftDependencyInjection` | `DependencyContainer` (o protocolo com `shared` e `transient`), `DependencyStorage`, `DependencyGraph`, a declaração de `@DependencyContainer` |
| `SwiftDependencyInjectionMacros` | A macro: lê o corpo da classe, gera os membros, encontra ciclos e reporta o uso incorreto |

Decisões de design:

- **Propriedades, não registros.** Uma dependência é uma propriedade computada, então o compilador verifica cada uso. Nada é registrado na inicialização, então nada pode estar faltando em tempo de execução.
- **O key path é a chave.** `shared(\.api)` guarda a instância sob o key path da sua propriedade, o que também fixa o tipo dela ao tipo da propriedade; assim, overrides de outro tipo em conformidade se encaixam e duas propriedades nunca podem compartilhar uma entrada.
- **Um lock recursivo por contêiner.** Ele é mantido enquanto um provider é executado: uma dependência shared é criada exatamente uma vez, os providers podem ler uns aos outros, e a cadeia em construção serve também como verificação de ciclos em tempo de execução.
- **Os overrides são gerados, não guardados por nome.** A macro escreve um campo tipado por dependência e dá aos closures o isolamento do contêiner.
- **O contêiner é o escopo.** Sem estado global, não há reinicialização entre testes nem ciclo de vida oculto: as instâncias de um contêiner vivem exatamente o mesmo tempo que ele.

## Roteiro

- Dependências parametrizadas (`func editor(for: Profile)`) que possam receber override como as propriedades.
- Um ciclo de vida weak opcional: uma instância enquanto algo a mantiver, recriada depois.
- Um trace do que foi criado durante uma resolução, para depurar contêineres grandes.

## Como contribuir

Contribuições são bem-vindas. Leia o [guia de contribuição](https://github.com/muhittincamdali/SwiftDependencyInjection/blob/main/CONTRIBUTING.md) e o [código de conduta](https://github.com/muhittincamdali/SwiftDependencyInjection/blob/main/CODE_OF_CONDUCT.md) antes de abrir um pull request. Relate problemas de segurança de forma privada, como descrito na [política de segurança](https://github.com/muhittincamdali/SwiftDependencyInjection/blob/main/SECURITY.md).

## Licença

Publicado sob a licença MIT. Veja [LICENSE](LICENSE).
