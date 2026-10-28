<!-- i18n-source: README.md@db0ca6cfacb99492bf497614f3316a072a7016fa status=reviewed -->
<!-- brand:start -->

<p align="center"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/banner-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/banner-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/banner-light.svg" alt="SwiftDependencyInjection: Dependency containers for Swift 6 that the compiler checks, with typed test overrides and no global state."></picture></p>

<!-- lang-selector:start -->
<p align="center"><a href="README.md">English</a> · <a href="README.tr.md">Türkçe</a> · <a href="README.zh-CN.md">简体中文</a> · <a href="README.ja.md">日本語</a> · <a href="README.ko.md">한국어</a> · <a href="README.es.md">Español</a> · <a href="README.de.md">Deutsch</a> · <a href="README.fr.md">Français</a> · <a href="README.pt-BR.md">Português (Brasil)</a> · <a href="README.ru.md">Русский</a></p>
<!-- lang-selector:end -->

<p align="center">
<a href="https://github.com/muhittincamdali/SwiftDependencyInjection/actions/workflows/ci.yml"><img src="https://github.com/muhittincamdali/SwiftDependencyInjection/actions/workflows/ci.yml/badge.svg" alt="CI ステータス"></a>
<a href="https://github.com/muhittincamdali/SwiftDependencyInjection/releases"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/badge-version-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/badge-version-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/badge-version-light.svg" alt="最新バージョン: v1.0.0"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftDependencyInjection/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/badge-platforms-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/badge-platforms-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/badge-platforms-light.svg" alt="対応プラットフォーム: iOS 16+ · macOS 13+ · tvOS 16+ · watchOS 9+ · visionOS 1+"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftDependencyInjection/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/badge-language-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/badge-language-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/badge-language-light.svg" alt="言語バージョン: Swift 6.2+ · Swift 6 mode"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftDependencyInjection/blob/main/LICENSE"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/badge-license-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/badge-license-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/badge-license-light.svg" alt="ライセンス: MIT"></picture></a>
</p>

<p align="center">
<a href="#クイックスタート"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/button-start-ja-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/button-start-ja-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/button-start-ja-light.svg" alt="はじめる"></picture></a>
<a href="https://muhittincamdali.github.io/SwiftDependencyInjection/documentation/swiftdependencyinjection/"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/button-docs-ja-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/button-docs-ja-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/button-docs-ja-light.svg" alt="ドキュメント"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftDependencyInjection/tree/main/Examples"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/button-examples-ja-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/button-examples-ja-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/button-examples-ja-light.svg" alt="サンプル"></picture></a>
</p>

> このドキュメントは英語版 README の翻訳です。内容が異なる場合は英語版が最新です。

<!-- brand:end -->

SwiftDependencyInjection は、Swift 6 向けの手動の dependency injection で、繰り返しの多い部分はコードを生成してくれます。依存関係を 1 つの final class の computed property として並べると、`@DependencyContainer` マクロがそのクラスをコンテナにします。`shared` の依存関係は 1 度だけ生成されてスレッドセーフにキャッシュされ、`transient` の依存関係は読み取るたびに生成されます。テストでは、生成された型付きの `override` を通じてどの依存関係でも差し替えられ、依存関係の循環はコンパイルエラーになります。グローバルなコンテナも、実行時に失敗しうる検索もありません。依存関係はプロパティなので、足りないものはコンパイルが通りません。

## 主な特長

- **コンパイラがチェックする** — 依存関係はプロパティなので、足りないものや型の違うものはコンパイルエラーになります。マクロは循環（`api → tokens → api`）、置き場所の誤った provider、override で差し替えられない依存関係を報告し、どのメッセージにも修正方法が添えられています。
- **型付きのテスト用 override** — すべてのコンテナに、依存関係ごとに 1 つのフィールドを持つ `Overrides` 構造体が生成されます。型はプロパティと同じです：`$0.api = { StubProfileAPI(…) }`。
- **グローバルな状態がない** — インスタンスと override は 1 つのコンテナインスタンスに属します。それぞれがコンテナを作成するテストは並列に実行できます。子コンテナはスコープで、たとえばサインイン中のユーザーを表せます。
- **Swift 6 の並行処理** — 多くのスレッドから読み取られても、shared の依存関係はちょうど 1 度だけ生成されます。`@MainActor` のコンテナには `@MainActor` の override、それ以外のコンテナには `@Sendable` の override が生成されます。
- **実行時にも循環を検出** — メソッドやクロージャ経由でマクロには見えない循環は、スタックオーバーフローになる代わりに、同じ経路を示してプロセスを停止します。
- **読めるグラフ** — すべてのコンテナに、コンパイル時に生成される `dependencyGraph` があり、Graphviz 形式でも出力できます。

## クイックスタート

**1. パッケージを追加する**

Xcode で **File › Add Package Dependencies…** を選び、リポジトリの URL を入力します。

```text
https://github.com/muhittincamdali/SwiftDependencyInjection.git
```

**2. モジュールをインポートする**

```swift
import SwiftDependencyInjection
```

**3. コンテナを宣言する**

各依存関係は computed property で、その getter は、そのプロパティ自身の key path を渡した `shared` または `transient` の呼び出し 1 つだけです
（[ReadmeSamples.swift](Examples/DependencyDemo/DependencyDemo/ReadmeSamples.swift)）。

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

コンテナは 1 度だけ作成し、必要なものを読み取ります。`AppDependencies().profileStore` は初回の利用時に API と store を生成し、以降は同じ store を返します。key path によって各インスタンスにはプロパティの型が与えられるため、`api` は `any ProfileAPI` として保存され、テストではそれに準拠する任意の別の型で差し替えられます。

## インストール

### Swift Package Manager

Xcode で **File › Add Package Dependencies…** を選び、リポジトリの URL を入力します。

```text
https://github.com/muhittincamdali/SwiftDependencyInjection.git
```

または `Package.swift` の `dependencies` に追加します。

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

このパッケージには Swift マクロが含まれるため、Xcode が一度だけ信頼するかどうかを確認します（**Trust & Enable**）。ビルドでは [swift-syntax](https://github.com/swiftlang/swift-syntax)（602 から 604）を使います。

## 使い方

以下のサンプルは、サンプルアプリがビルドしている
[`ReadmeSamples.swift`](Examples/DependencyDemo/DependencyDemo/ReadmeSamples.swift) と
[`DependencyDemoApp.swift`](Examples/DependencyDemo/DependencyDemo/DependencyDemoApp.swift)、およびテストスイートが実行している
[`ReadmeSamplesTests.swift`](Tests/SwiftDependencyInjectionTests/ReadmeSamplesTests.swift) からコピーしたものです。

### コンテナを 1 度だけ作成する

アプリがコンテナを所有し、コンテナそのもの、または必要な依存関係を下位に渡します。

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

オブジェクトは initializer を通じて依存関係を受け取ります（`ProfileStore(api:)`）。そのため、どのオブジェクトもテストの中でコンテナなしに単独で生成できます。

### テストで依存関係を差し替える

`override(_:)` は、生成された `Overrides` のフィールドを設定するクロージャを受け取ります。`nil` のままにしたフィールドは本物の依存関係がそのまま使われます。本物の `profileStore` の provider が実行され、stub を読み取ります。

```swift
let dependencies = AppDependencies()
dependencies.override {
    $0.api = { StubProfileAPI(profiles: [Profile(id: 1, name: "Ada", role: "Analyst")]) }
}

let store = dependencies.profileStore
try await store.refresh()

#expect(store.profiles.map(\.name) == ["Ada"])
```

各テストが自分のコンテナを作成するので、override がテスト間で漏れることはなく、Swift Testing はテストを並列に実行できます。プレビューでも同じ呼び出しを使います。

### 依存関係をセッションに限定する

コンテナのインスタンスはスコープです。子コンテナは、親コンテナとスコープの値を stored property として保持するため、内部では「ユーザーがいない」場合を考慮する必要がありません。

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

ユーザーがサインインしたときに作成し、サインアウトしたときに解放します。shared のインスタンスも一緒に解放されますが、`app.profileStore` はすべてのセッションで共有されたままです。

### 循環をコンパイラに見つけてもらう

直接または他の依存関係を介して自分自身を必要とする provider は、コンパイルできません。

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

[`DiagnosticTests.swift`](Tests/SwiftDependencyInjectionMacrosTests/DiagnosticTests.swift) はこのサンプルをマクロで展開し、エラーメッセージが一字一句同じであることを確認します。

ネストしたクロージャ内の読み取りは追跡しません。コールバックは通常、生成が終わってから実行されるためです。そのようなクロージャが生成中に実行された場合、コンテナはスタックオーバーフローになる代わりに、`dependency cycle in AppDependencies: api → tokens → api` というメッセージでプロセスを停止します。

## デモ

[DependencyDemo](Examples/DependencyDemo) アプリは、それぞれの考え方を本物のライブラリで動かして見せます。スクリーンショットは iOS 27 シミュレータ上のアプリから、[`scripts/capture-example-screens.sh`](scripts/capture-example-screens.sh) で撮影したものです。

| 本物の API と差し替えた API | Shared、transient、セッション | 生成されたグラフ |
| --- | --- | --- |
| <picture><source media="(prefers-color-scheme: dark)" srcset="docs/images/demo-overrides-dark.png"><img src="docs/images/demo-overrides-light.png" width="260" alt="2 つのコンテナがプロフィールを読み込んでいる：本物のコンテナは DemoServerAPI を注入して約 600 ms かかり、override したコンテナは StubProfileAPI を注入した"></picture> | <picture><source media="(prefers-color-scheme: dark)" srcset="docs/images/demo-scopes-dark.png"><img src="docs/images/demo-scopes-light.png" width="260" alt="読み取りログ：profileStore は同じインスタンスを 2 回返し、profileEditor は毎回新しいインスタンスを返し、2 つのセッションがアプリの store を共有している"></picture> | <picture><source media="(prefers-color-scheme: dark)" srcset="docs/images/demo-graph-dark.png"><img src="docs/images/demo-graph-light.png" width="260" alt="AppDependencies と SessionDependencies の依存関係と、そのライフタイム、およびそれらの間の読み取り"></picture> |

実行するには、[Examples/DependencyDemo](Examples/DependencyDemo) にある `DependencyDemo.xcodeproj` を Xcode 26 以降で開き、iPhone シミュレータまたは **My Mac** を選んで **Run** を押します。各画面については [Examples/README.md](Examples/README.md) を参照してください。

## 代わりに Factory や swift-dependencies を選ぶ場合

[Factory](https://github.com/hmlongco/Factory) と
[swift-dependencies](https://github.com/pointfreeco/swift-dependencies) は、Swift の dependency injection ライブラリとして最も広く使われており、このパッケージにはできないこともできます。

- **Factory を選ぶ場合**：コンテナを渡さずに `@Injected` でどこにでも注入したい、パラメータ付きの factory、より多くのスコープ（cached、weak shared、graph、custom）、decorator、プレビュー・テスト・デバッグビルドで実装を自動的に切り替える context が必要なとき。
- **swift-dependencies を選ぶ場合**：The Composable Architecture を使っているとき、時計・日付・UUID のような依存関係を task local 経由でどのコードにも届けたいとき、またはテストで依存関係が想定外に使われたらテストを失敗させたいとき。
- **[SafeDI](https://github.com/dfed/SafeDI) を選ぶ場合**：生成された initializer と mock によって、モジュールをまたぐオブジェクトグラフ全体をコンパイル時に検証したいとき。
- **このパッケージを選ぶ場合**：スコープごとに 1 つのコンテナクラスを持つ明示的な constructor injection、型付きの override、コンパイラが報告する循環が欲しいとき。

記事
[Choosing a dependency injection library](https://muhittincamdali.github.io/SwiftDependencyInjection/documentation/swiftdependencyinjection/choosingadependencyinjectionlibrary)
では、機能ごとにこれらを比較し、このパッケージの限界も挙げています。

## ドキュメント

API リファレンスと解説記事：

- [SwiftDependencyInjection リファレンス](https://muhittincamdali.github.io/SwiftDependencyInjection/documentation/swiftdependencyinjection/)
- [はじめに](https://muhittincamdali.github.io/SwiftDependencyInjection/documentation/swiftdependencyinjection/gettingstarted)
- [override を使ったテスト](https://muhittincamdali.github.io/SwiftDependencyInjection/documentation/swiftdependencyinjection/testingwithoverrides)
- [スコープとライフタイム](https://muhittincamdali.github.io/SwiftDependencyInjection/documentation/swiftdependencyinjection/scopesandlifetimes)
- [dependency injection ライブラリの選び方](https://muhittincamdali.github.io/SwiftDependencyInjection/documentation/swiftdependencyinjection/choosingadependencyinjectionlibrary)

## ガイド

- [はじめに](Sources/SwiftDependencyInjection/SwiftDependencyInjection.docc/GettingStarted.md)
  — コンテナの宣言、isolation の選択、依存関係の受け渡し、コンパイラが何をチェックするか。
- [override を使ったテスト](Sources/SwiftDependencyInjection/SwiftDependencyInjection.docc/TestingWithOverrides.md)
  — override の型付け、スコープ、キャッシュ、isolation の仕組みと、プレビューでの使い方。
- [スコープとライフタイム](Sources/SwiftDependencyInjection/SwiftDependencyInjection.docc/ScopesAndLifetimes.md)
  — shared と transient、子コンテナ、循環、依存関係グラフ。
- [dependency injection ライブラリの選び方](Sources/SwiftDependencyInjection/SwiftDependencyInjection.docc/ChoosingADependencyInjectionLibrary.md)
  — Factory、swift-dependencies、SafeDI、このパッケージの比較。

## 動作要件

| プラットフォーム | 最小バージョン |
| --- | --- |
| iOS | 16 |
| macOS | 13 |
| tvOS | 16 |
| watchOS | 9 |
| visionOS | 1 |
| ツールチェーン | Swift 6.2 · Xcode 26+ |

## アーキテクチャ

このパッケージには、ライブラリ 1 つとマクロ target 1 つがあります。

| Target | 内容 |
| --- | --- |
| `SwiftDependencyInjection` | `DependencyContainer`（`shared` と `transient` を持つプロトコル）、`DependencyStorage`、`DependencyGraph`、`@DependencyContainer` の宣言 |
| `SwiftDependencyInjectionMacros` | マクロ：クラス本体を読み取り、メンバーを生成し、循環を見つけ、誤った使い方を報告する |

設計上の判断：

- **登録ではなくプロパティ。** 依存関係は computed property なので、コンパイラがすべての利用箇所をチェックします。起動時に何も登録しないため、実行時に足りないものもありません。
- **key path がキー。** `shared(\.api)` は、そのプロパティの key path をキーにしてインスタンスを保存します。これによりインスタンスの型はプロパティの型に固定されるので、準拠する別の型の override も使え、2 つのプロパティが同じエントリを共有することもありません。
- **コンテナごとに再帰ロックを 1 つ。** provider の実行中はこのロックを保持します。shared の依存関係はちょうど 1 度だけ生成され、provider は互いに読み取ることができ、生成中の連鎖がそのまま実行時の循環チェックを兼ねます。
- **override は名前で保存せず、生成する。** マクロは依存関係ごとに型付きのフィールドを書き出し、クロージャにコンテナの isolation を与えます。
- **コンテナがスコープ。** グローバルな状態がないので、テスト間のリセットも、隠れたライフタイムもありません。コンテナのインスタンスは、そのコンテナと同じ期間だけ存在します。

## ロードマップ

- プロパティと同じように override できる、パラメータ付きの依存関係（`func editor(for: Profile)`）。
- オプションの weak ライフタイム：何かが保持している間は 1 つのインスタンスを使い、その後は再生成する。
- 大きなコンテナをデバッグするための、1 回の解決中に何が生成されたかのトレース。

## コントリビューション

コントリビューションを歓迎します。pull request を作成する前に[コントリビューションガイド](https://github.com/muhittincamdali/SwiftDependencyInjection/blob/main/CONTRIBUTING.md)と[行動規範](https://github.com/muhittincamdali/SwiftDependencyInjection/blob/main/CODE_OF_CONDUCT.md)をお読みください。セキュリティ上の問題は[セキュリティポリシー](https://github.com/muhittincamdali/SwiftDependencyInjection/blob/main/SECURITY.md)に従って非公開で報告してください。

## ライセンス

MIT ライセンスで公開しています。詳細は [LICENSE](LICENSE) を参照してください。
