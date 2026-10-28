<!-- i18n-source: README.md@d3e5028bcdb1a540aaf4809f97c3e9aed8c662a8 status=reviewed -->
<!-- brand:start -->

<p align="center"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/banner-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/banner-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/banner-light.svg" alt="SwiftDependencyInjection: Dependency containers for Swift 6 that the compiler checks, with typed test overrides and no global state."></picture></p>

<!-- lang-selector:start -->
<p align="center"><a href="README.md">English</a> · <a href="README.tr.md">Türkçe</a> · <a href="README.zh-CN.md">简体中文</a> · <a href="README.ja.md">日本語</a> · <a href="README.ko.md">한국어</a> · <a href="README.es.md">Español</a> · <a href="README.de.md">Deutsch</a> · <a href="README.fr.md">Français</a> · <a href="README.pt-BR.md">Português (Brasil)</a> · <a href="README.ru.md">Русский</a></p>
<!-- lang-selector:end -->

<p align="center">
<a href="https://github.com/muhittincamdali/SwiftDependencyInjection/actions/workflows/ci.yml"><img src="https://github.com/muhittincamdali/SwiftDependencyInjection/actions/workflows/ci.yml/badge.svg" alt="CI durumu"></a>
<a href="https://github.com/muhittincamdali/SwiftDependencyInjection/releases"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/badge-version-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/badge-version-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/badge-version-light.svg" alt="Son sürüm: v2.0.0"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftDependencyInjection/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/badge-platforms-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/badge-platforms-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/badge-platforms-light.svg" alt="Desteklenen platformlar: iOS 16+ · macOS 13+ · tvOS 16+ · watchOS 9+ · visionOS 1+"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftDependencyInjection/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/badge-language-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/badge-language-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/badge-language-light.svg" alt="Dil sürümü: Swift 6.2+ · Swift 6 mode"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftDependencyInjection/blob/main/LICENSE"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/badge-license-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/badge-license-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/badge-license-light.svg" alt="Lisans: MIT"></picture></a>
</p>

<p align="center">
<a href="#hızlı-başlangıç"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/button-start-tr-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/button-start-tr-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/button-start-tr-light.svg" alt="Başlayın"></picture></a>
<a href="https://muhittincamdali.github.io/SwiftDependencyInjection/documentation/swiftdependencyinjection/"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/button-docs-tr-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/button-docs-tr-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/button-docs-tr-light.svg" alt="Dokümantasyon"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftDependencyInjection/tree/main/Examples"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/button-examples-tr-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/button-examples-tr-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftDependencyInjection/main/.github/brand/button-examples-tr-light.svg" alt="Örnekler"></picture></a>
</p>

> Bu belge İngilizce README'nin çevirisidir. İkisi arasında fark varsa güncel olan İngilizce sürümdür.

<!-- brand:end -->

SwiftDependencyInjection, Swift 6 için manuel dependency injection kütüphanesidir; tekrarlayan kısımları sizin yerinize üretir. Bağımlılıklarınızı tek bir `final class` içinde computed property olarak sıralarsınız; `@DependencyContainer` makrosu bu sınıfı bir container'a dönüştürür: her `shared` bağımlılık bir kez oluşturulur ve thread-safe biçimde önbelleğe alınır, her `transient` bağımlılık her okunduğunda yeniden oluşturulur, testler bunların herhangi birini üretilen, tür güvenli bir `override` ile değiştirir ve bağımlılık döngüsü derleme hatasıdır. Global container yoktur, çalışma zamanında başarısız olabilecek bir arama da yoktur: bağımlılık bir property'dir, dolayısıyla eksik olan derlenmez.

## Öne çıkanlar

- **Derleyici tarafından denetlenir** — bağımlılık bir property'dir; eksik olan ya da türü yanlış olan derleme hatası verir. Makro döngüleri (`api → tokens → api`), yanlış yerdeki provider'ları ve bir override'ın değiştiremeyeceği bağımlılıkları bildirir; her mesajda çözüm de yazar.
- **Tür güvenli test override'ları** — her container, her bağımlılık için property ile aynı türde bir alan içeren bir `Overrides` struct'ı alır: `$0.api = { StubProfileAPI(…) }`.
- **Global durum yok** — örnekler ve override'lar tek bir container örneğine aittir. Her biri kendi container'ını oluşturan testler paralel çalışabilir; alt container bir kapsamdır, örneğin oturum açmış bir kullanıcı.
- **Swift 6 eşzamanlılığı** — shared bağımlılık, onu birçok thread okusa bile tam olarak bir kez oluşturulur. `@MainActor` container'lar `@MainActor` override'lar, diğer container'lar `@Sendable` override'lar alır.
- **Döngüler çalışma zamanında da yakalanır** — makronun göremediği bir döngü (bir metot ya da closure üzerinden), yığını taşırmak yerine süreci aynı yol bilgisiyle durdurur.
- **Okunabilir bir grafik** — her container'ın derleme zamanında yazılmış bir `dependencyGraph`'ı vardır ve Graphviz çıktısı verir.

## Hızlı başlangıç

**1. Paketi ekleyin**

Xcode'da **File › Add Package Dependencies…** menüsünü seçin ve depo adresini girin:

```text
https://github.com/muhittincamdali/SwiftDependencyInjection.git
```

**2. Modülü içe aktarın**

```swift
import SwiftDependencyInjection
```

**3. Bir container tanımlayın**

Her bağımlılık, getter'ı tek bir `shared` ya da `transient` çağrısından oluşan ve çağrıya o property'nin key path'ini veren bir computed property'dir
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

Container'ı bir kez oluşturun ve ihtiyacınız olanı okuyun: `AppDependencies().profileStore` ilk kullanımda API'yi ve store'u oluşturur, sonraki okumalarda aynı store'u döndürür. Key path her örneğe kendi property'sinin türünü verir; bu yüzden `api`, `any ProfileAPI` olarak saklanır ve bir test onu protokole uyan başka herhangi bir türle değiştirebilir.

## Kurulum

### Swift Package Manager

Xcode'da **File › Add Package Dependencies…** menüsünü seçin ve depo adresini girin:

```text
https://github.com/muhittincamdali/SwiftDependencyInjection.git
```

Ya da `Package.swift` dosyanızdaki `dependencies` listesine ekleyin:

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

Paket bir Swift makrosu içerir; bu yüzden Xcode ona güvenmenizi bir kez ister (**Trust & Enable**) ve derleme [swift-syntax](https://github.com/swiftlang/swift-syntax) kütüphanesini (602 ile 604 arası sürümler) kullanır.

## Kullanım

Aşağıdaki örnekler, örnek uygulamanın derlediği
[`ReadmeSamples.swift`](Examples/DependencyDemo/DependencyDemo/ReadmeSamples.swift) ve
[`DependencyDemoApp.swift`](Examples/DependencyDemo/DependencyDemo/DependencyDemoApp.swift) dosyalarından ve test paketinin çalıştırdığı
[`ReadmeSamplesTests.swift`](Tests/SwiftDependencyInjectionTests/ReadmeSamplesTests.swift) dosyasından kopyalanmıştır.

### Container'ı bir kez oluşturun

Uygulama container'ına sahiptir ve onu ya da ihtiyaç duyulan bağımlılıkları aşağıya iletir:

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

Nesneler bağımlılıklarını initializer'ları üzerinden alır (`ProfileStore(api:)`); bu sayede her biri testte container olmadan tek başına da oluşturulabilir.

### Bir testte bağımlılıkları değiştirin

`override(_:)`, üretilen `Overrides` struct'ının alanlarını ayarlayan bir closure alır; `nil` bırakılan alanlar gerçek bağımlılığı korur. Gerçek `profileStore` provider'ı çalışır ve stub'ı okur:

```swift
let dependencies = AppDependencies()
dependencies.override {
    $0.api = { StubProfileAPI(profiles: [Profile(id: 1, name: "Ada", role: "Analyst")]) }
}

let store = dependencies.profileStore
try await store.refresh()

#expect(store.profiles.map(\.name) == ["Ada"])
```

Her test kendi container'ını oluşturur; bu yüzden override'lar testler arasında sızmaz ve Swift Testing testleri paralel çalıştırabilir. Önizlemeler de aynı çağrıyı kullanır.

### Bağımlılıkları bir oturuma bağlayın

Bir container örneği bir kapsamdır. Alt container, üst container'ını ve kapsamın değerlerini stored property olarak tutar; böylece içindeki hiçbir şeyin eksik kullanıcıyı ele alması gerekmez:

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

Kullanıcı oturum açtığında bir tane oluşturun, oturumu kapattığında bırakın; shared örnekleri de onunla birlikte gider, `app.profileStore` ise her oturum tarafından paylaşılmaya devam eder.

### Döngüleri derleyiciye buldurun

Doğrudan ya da başka bağımlılıklar üzerinden kendine ihtiyaç duyan bir provider derlenmez:

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

[`DiagnosticTests.swift`](Tests/SwiftDependencyInjectionMacrosTests/DiagnosticTests.swift) bu örneği makroyla genişletir ve hata metninin birebir aynı olduğunu denetler.

İç içe closure'ların içindeki okumalar izlenmez; çünkü bir callback genellikle oluşturma bittikten sonra çalışır. Böyle bir closure oluşturma sırasında çalışırsa container, yığını taşırmak yerine süreci `dependency cycle in AppDependencies: api → tokens → api` mesajıyla durdurur.

## Demo

[DependencyDemo](Examples/DependencyDemo) uygulaması her fikri gerçek kütüphaneyle çalıştırır. Ekran görüntüleri, uygulamanın bir iOS 27 simülatöründeki halinden [`scripts/capture-example-screens.sh`](scripts/capture-example-screens.sh) ile alınmıştır:

| Canlı ve override edilmiş API | Shared, transient ve oturumlar | Üretilen grafik |
| --- | --- | --- |
| <picture><source media="(prefers-color-scheme: dark)" srcset="docs/images/demo-overrides-dark.png"><img src="docs/images/demo-overrides-light.png" width="260" alt="İki container profilleri yüklüyor: canlı olan DemoServerAPI'yi enjekte etti ve yaklaşık 600 ms sürdü, override edilmiş olan StubProfileAPI'yi enjekte etti"></picture> | <picture><source media="(prefers-color-scheme: dark)" srcset="docs/images/demo-scopes-dark.png"><img src="docs/images/demo-scopes-light.png" width="260" alt="Okuma günlüğü: profileStore iki kez aynı örneği döndürüyor, profileEditor her seferinde yeni bir örnek, iki oturum uygulamanın store'unu paylaşıyor"></picture> | <picture><source media="(prefers-color-scheme: dark)" srcset="docs/images/demo-graph-dark.png"><img src="docs/images/demo-graph-light.png" width="260" alt="AppDependencies ve SessionDependencies bağımlılıkları; ömürleri ve aralarındaki okumalar"></picture> |

Çalıştırmak için [Examples/DependencyDemo](Examples/DependencyDemo) içindeki `DependencyDemo.xcodeproj` dosyasını Xcode 26 veya üstüyle açın, bir iPhone simülatörü ya da **My Mac** seçin ve **Run**'a basın. [Examples/README.md](Examples/README.md) her ekranı anlatır.

## Bunun yerine Factory veya swift-dependencies ne zaman seçilmeli

[Factory](https://github.com/hmlongco/Factory) ve
[swift-dependencies](https://github.com/pointfreeco/swift-dependencies), en yaygın kullanılan Swift dependency injection kütüphaneleridir ve bu paketin yapmadığı şeyleri yaparlar:

- **Factory'yi seçin**: container taşımadan `@Injected` ile her yerde enjeksiyon yapmak, parametreli factory'ler, daha fazla kapsam (cached, weak shared, graph, custom), decorator'lar ve önizleme, test ve debug derlemeleri için uygulamaları otomatik değiştiren context'ler istiyorsanız.
- **swift-dependencies'i seçin**: The Composable Architecture ile çalışıyorsanız, saat, tarih ve UUID gibi bağımlılıkların task local'lar üzerinden her koda ulaşmasını istiyorsanız ya da bir testte bir bağımlılığın beklenmedik kullanımının testi başarısız kılmasını istiyorsanız.
- **[SafeDI](https://github.com/dfed/SafeDI)'ı seçin**: üretilen initializer'lar ve mock'larla tüm nesne grafiğini modüller arası derleme zamanında doğrulamak istiyorsanız.
- **Bu paketi seçin**: kapsam başına bir container sınıfıyla açık constructor injection, tür güvenli override'lar ve derleyicinin bildirdiği döngüler istiyorsanız.

[Bir dependency injection kütüphanesi seçmek](https://muhittincamdali.github.io/SwiftDependencyInjection/documentation/swiftdependencyinjection/choosingadependencyinjectionlibrary) makalesi bunları özellik özellik karşılaştırır ve bu paketin sınırlarını listeler.

## Dokümantasyon

API başvuru belgeleri ve makaleler:

- [SwiftDependencyInjection başvurusu](https://muhittincamdali.github.io/SwiftDependencyInjection/documentation/swiftdependencyinjection/)
- [Başlarken](https://muhittincamdali.github.io/SwiftDependencyInjection/documentation/swiftdependencyinjection/gettingstarted)
- [Override'larla test etme](https://muhittincamdali.github.io/SwiftDependencyInjection/documentation/swiftdependencyinjection/testingwithoverrides)
- [Kapsamlar ve ömürler](https://muhittincamdali.github.io/SwiftDependencyInjection/documentation/swiftdependencyinjection/scopesandlifetimes)
- [Bir dependency injection kütüphanesi seçmek](https://muhittincamdali.github.io/SwiftDependencyInjection/documentation/swiftdependencyinjection/choosingadependencyinjectionlibrary)

## Rehberler

- [Başlarken](Sources/SwiftDependencyInjection/SwiftDependencyInjection.docc/GettingStarted.md)
  — container tanımlama, izolasyonunu seçme, bağımlılıkları aşağıya iletme ve derleyicinin neleri denetlediği.
- [Override'larla test etme](Sources/SwiftDependencyInjection/SwiftDependencyInjection.docc/TestingWithOverrides.md)
  — override'ların nasıl türlendirildiği, kapsamlandığı, önbelleğe alındığı ve yalıtıldığı; önizlemelerde nasıl kullanılacağı.
- [Kapsamlar ve ömürler](Sources/SwiftDependencyInjection/SwiftDependencyInjection.docc/ScopesAndLifetimes.md)
  — shared ve transient, alt container'lar, döngüler ve bağımlılık grafiği.
- [Bir dependency injection kütüphanesi seçmek](Sources/SwiftDependencyInjection/SwiftDependencyInjection.docc/ChoosingADependencyInjectionLibrary.md)
  — Factory, swift-dependencies, SafeDI ve bu paket yan yana.

## Gereksinimler

| Platform | En düşük sürüm |
| --- | --- |
| iOS | 16 |
| macOS | 13 |
| tvOS | 16 |
| watchOS | 9 |
| visionOS | 1 |
| Araç zinciri | Swift 6.2 · Xcode 26+ |

## Mimari

Paketin bir kütüphane ve bir makro hedefi vardır:

| Hedef | İçerik |
| --- | --- |
| `SwiftDependencyInjection` | `DependencyContainer` (`shared` ve `transient` içeren protokol), `DependencyStorage`, `DependencyGraph`, `@DependencyContainer` bildirimi |
| `SwiftDependencyInjectionMacros` | Makro: sınıf gövdesini okur, üyeleri üretir, döngüleri bulur ve yanlış kullanımı bildirir |

Tasarım kararları:

- **Kayıt değil, property.** Bağımlılık bir computed property'dir; bu yüzden derleyici her kullanımı denetler. Açılışta hiçbir şey kaydedilmez, dolayısıyla çalışma zamanında hiçbir şey eksik olamaz.
- **Anahtar, key path'tir.** `shared(\.api)` örneği property'sinin key path'i altında saklar; bu da türünü property'nin türüne sabitler. Böylece protokole uyan başka bir türün override'ı uyar ve iki property asla aynı girdiyi paylaşamaz.
- **Container başına bir özyinelemeli (recursive) kilit.** Provider çalışırken tutulur: shared bağımlılık tam olarak bir kez oluşturulur, provider'lar birbirini okuyabilir ve oluşturulmakta olan zincir aynı zamanda çalışma zamanı döngü denetimi görevi görür.
- **Override'lar isimle saklanmaz, üretilir.** Makro her bağımlılık için tür güvenli bir alan yazar ve closure'lara container'ın izolasyonunu verir.
- **Kapsam, container'ın kendisidir.** Global durum olmaması, testler arasında sıfırlama gerekmemesi ve gizli bir ömür olmaması demektir: bir container'ın örnekleri tam olarak container kadar yaşar.

## Yol haritası

- Property'ler gibi override edilebilen parametreli bağımlılıklar (`func editor(for: Profile)`).
- İsteğe bağlı zayıf (weak) ömür: bir şey tuttuğu sürece tek örnek, sonrasında yeniden oluşturulur.
- Büyük container'ların hata ayıklaması için, bir çözümleme sırasında nelerin oluşturulduğunu gösteren bir iz.

## Katkıda bulunma

Katkılarınızı bekliyoruz. Pull request açmadan önce [katkı rehberini](https://github.com/muhittincamdali/SwiftDependencyInjection/blob/main/CONTRIBUTING.md) ve [davranış kurallarını](https://github.com/muhittincamdali/SwiftDependencyInjection/blob/main/CODE_OF_CONDUCT.md) okuyun. Güvenlik açıklarını [güvenlik politikasında](https://github.com/muhittincamdali/SwiftDependencyInjection/blob/main/SECURITY.md) anlatıldığı gibi gizli olarak bildirin.

## Lisans

MIT lisansıyla yayımlanmıştır. Ayrıntılar için [LICENSE](LICENSE) dosyasına bakın.
