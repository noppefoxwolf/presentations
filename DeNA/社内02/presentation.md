footer: 🦊
slidenumbers: true

# DI勉強会

---

# DI

= Dependency Injection
= 依存性の注入

実装パターンの名称

---

# 実装から見てみる

```
class Animal {
    private let soul: Soul

    init(soul: Soul) {
        self.soul = soul
    }

    func say() {
        soul.say()
    }
}

Animal(CatSoul()).say() // mew
Animal(FoxSoul()).say() // yelp
```

^ animalはSoulプロトコルに依存していて、Soulを与えると挙動が決定する
^ 別にinitじゃなくても良い

---

# 利点

・実装の差し替えが容易
・同じモジュール内に実装が無くても良い

^ 実装後回しに出来るとかあるけど

---

# ユースケース1（実装の差し替えが容易）

```
class TimelineViewController: UIViewController {
    private var apiClient: APIClient!
    static func make(apiClient: APIClient) -> TimelineViewController {
        let vc = TimelineViewController()
        vc.apiClient = apiClient
        return vc
    }

    func reload() {
        apiClient.fetchLives({ (lives) in
            // do something
        })
    }
}
```

^ これはさっきの猫の例と同じ
^ この例が分かりやすいのはさっきの「実装の差し替えが容易」という点の利点が明確なところ

---

# ユースケース1（実装の差し替えが容易）

```
struct AppAPIClient: APIClient {
    func fetchLives(_ completions:(([Live]) -> Void)) {
        request("https://live-love.com/lives", { (lives) in
            completions(lives)
        })
    }
}

TimelineViewController.make(AppAPIClient())
```

実際にAPIリクエストをする`TimelineViewController`が出来る

---

# ユースケース1（実装の差し替えが容易）

```
struct DummyAPIClient: APIClient {
    func fetchLives(_ completions:(([Live]) -> Void)) {
        completions([Live.makeDummy(1), Live.makeDummy(2), Live.makeDummy(3)])
    }
}

TimelineViewController.make(DummyAPIClient())
```

ダミーライブを表示する`TimelineViewController`が出来る

^ isDebugみたいなフラグを渡してTimelineViewController内で分岐書きまくるより可読性もミスのリスクも少なそう
^ テスト時にisTestみたいなの作ってコードが汚れることもなくなる

---

# ユースケース2（同じモジュール内に実装が無くても良い）

[ModuleA] <- [ModuleB]

前提：ModuleAがModuleBに依存する時、循環参照の仕様からModuleBはModuleAをimport出来ない。

ModuleBがModuleAの実装に依存するコードはDIで書くと楽

---

# ユースケース2の例

アプリ側にユーザーモデルが存在し、フレームワーク側でユーザーIDが自分かどうかで分岐する処理を書きたい時

```
func showProfile(userId: Int) {
    if User.current.id == userId { // undefined User

    } else {

    }
}
```

---

```
// App側
struct UserChecker: UserCheckable {
    func isMe(_ id: Int) -> Bool {
        return User.current.id == id
    }
}
```

```
// フレームワーク側
func showProfile(userId: Int) {
    if userChecker.isMe(userId) { // undefined User

    } else {

    }
}
```

---

# 実装方法の種類

コンストラクタインジェクション

```
struct Animal {
    let soul: Soul
    init(soul: Soul) {
        self.soul = soul
    }
}
```

---

# 実装方法の種類

メソッドインジェクション

```
struct Animal {
    var soul: Soul!

    func inject(soul: Soul) {
        self.soul = soul
    }
}
```

---

# 実装方法の種類

セッターインジェクション

```
struct Animal {
    var soul: Soul!
}
```

強制アンラップが必要無いコンストラクタインジェクションがSwiftの場合は良いと思う。

---

# DIの課題点

```
struct Animal {
    let soul: Soul
    let kind: Kind
    let kenami: Kenami
    let history: History
    init(
        soul: Soul,
        kind: Kind,
        kenami: Kenami,
        history: History
    ) {
        self.soul = soul
    }
}
```

依存関係が複雑になる程、コンストラクタが爆発する

---

# DIコンテナについて

依存関係を登録しておいて、必要な時に取り出す**フレームワーク**

- Swinject
- DIKit
- 自分で作る

---

# DIコンテナについて

```
// 起動時にコンテナに依存関係を登録
Container.shared.register("API", DummyAPIClient())

// 使う時にコンテナから取り出す
let api = Container.shared.resolve("API")
```

---

# おしまい