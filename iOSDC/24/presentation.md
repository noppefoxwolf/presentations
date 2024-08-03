slidenumbers: true
slidecount: true
slide-transition: false
slide-dividers: #, ##, ###, ####

# How to access hidden iOS APIs and enhance development efficacy.

2024/08/23 10:50〜
Track B
Regular talk（20 min）

^ こんにちは。本日は「iOSの隠されたAPIを解明し、開発効率を向上させる方法」というタイトルでトークをします。

# noppe

- DeNA Co., Ltd.
- Indie app developer

^ noppeと言います。
^ 今回のトークとは関連はありませんが、DeNAという会社でライブストリーミングアプリの開発をしています。
^ また、個人でアプリを開発しています。
^ きつねが好きで、このアイコンで活動しています。

# Agenda

- What's a hidden api?
- What's the best usecase?
- How to find it?

^ 今日のトークでは、「隠されたAPIを解明し、開発効率を向上させる方法」を紹介します。
^ 当然隠されているものなので、時に便利で、時に危険な手法です。
^ しかし、そういったものが存在していることを知っておくことや、安全な範囲で活用することは、開発において重要だと思います。
^ 今日は、まず隠されたAPIとは何かについてや、それらを実行する方法について説明します。
^ 次に、隠されたAPIの最適な使用例について説明します。
^ 最後に、隠されたAPIを見つける方法について説明します。
^ でははじめます。

# What's a hidden api?

- non code completion codes

^ 隠されたAPIとは何でしょうか？
^ これは今回のトークのためにある程度の余白を持って付けた言葉です。
^ その意味は曖昧なので、今日はコード補完に表示されないAPIのことを今回は隠されたAPIと呼ぶことにしましょう。

# What's a hidden api?

```swift
private func getAIModel() -> MLModel {
    let model = try! MyModel(configuration: .init())
    return model
}
```

^ 例えばこのコードでは、メソッドにprivateが付いているため、外部から呼び出す際にはコード補完が効きません。
^ このようなメソッドは、外部から見れば隠されたAPIと呼べるかと思います。

## What's kind of hidden api?

^ では、他にどのような隠されたAPIがあるでしょうか？まずは基本的なものを紹介します。

## What's kind of hidden api?

ObjC Private API

```ObjC

-  (void)setForgroundStyle:(Style *)style;

// Public API
-  (void)setForgroundStyle:(Style *)style {
    [self _setBackgroudColor:[style getUIColor]];
}

// Private API 💎
-  (void)_setBackgroudColor:(UIColor *)color {
    // ...
}
```

^ ObjCもSwiftと同様に、公開を明示的に指定しなければメソッドを非公開にすることができます。
^ UIKitやFoundationなどのフレームワークはObjCで書かれているため、非公開APIが多く存在します。

## What's kind of hidden api?

Xcode hides APIs

```swift
let vc = UIHostingController(rootView: ContentView())
vc._disableSafeArea = true
```

^ そして公開されているAPIでも、Xcodeがコード補完を表示しないことがあります。
^ 例えば、UIHostingControllerの_disableSafeAreaプロパティは、UIHostingControllerのsafeAreaを無効化するメソッドですが、コード補完に表示されません。
^ VSCodeのSwift Language Serverでは補完されるので恐らくXcodeが非表示にしているのでしょう。

## What's kind of hidden api?[^1]

Swift Unstable API

```swift
extension View {
    @_disfavoredOverload
    func badge(_ count: Int) -> some View {
        // ...
    }
}
```

[^1]:https://github.com/swiftlang/swift/blob/main/docs/ReferenceGuides/UnderscoredAttributes.md

^ 一部のアトリビュートも補完に表示されない隠れたAPIの一つです。
^ 例えば、@_disfavoredOverloadは同名のメソッドが呼ばれる際の優先度を下げることができます。
^ Swiftのリポジトリには、UnderscoredAttributesというドキュメントがありますが、ここに書いてあるAPIはアプリ開発での利用は推奨されていません。
^ これは雑談ですが、隠されたAPIの先頭は_で始まることが多いということを覚えておくといいかもしれません。

# How to use hidden API

^ さて、これらのAPIはどのようにして使うことができるのでしょうか？

# How to use hidden API

Xcode hides APIs

```swift
extension View {
    @_disfavoredOverload
    func badge(_ count: Int) -> some View {
        // ...
    }
}
```

```swift
let vc = UIHostingController(rootView: ContentView())
vc._disableSafeArea = true
```

^ 先ほど紹介したXcodeが隠しているAPIは、補完こそ効かないものの、コードに記載すればそのままコンパイルすることができます。

# How to use hidden API

ObjC Private API

```swift
final class User: NSObject {
    private(set) var name: String = "Placeholder"
    
    @objc(_setUserName:)
    private func _setUserName(_ name: String) {
        self.name = name
    }
}

let selector = Selector("_setUserName:")
user.perform(selector, with: "John Doe")
```

^ ObjCの非公開APIは、基底クラスであるNSObjectを使って呼び出すことができます。
^ Selectorを使って文字列でメソッド名を指定し、performメソッドを呼び出すことで非公開APIを呼び出すことができます。

## Why hidden api is hidden?

^ では、こんなに便利なAPIたちは、なぜ隠されているのでしょうか？

## Why hidden api is hidden?

API design factor

- Framework has clear porpose
- Cases
    - Declarative UI framework hides imperative API
    - Easy framework hides complex API

^ 理由の一つは、APIデザインの過程で非公開になったAPIがあるためです。
^ フレームワークには明確な目的があり、その目的に沿ったAPIが公開されています。
^ 例えば、フレームワーク利用者に宣言的UIを提供するフレームワークには、命令的なAPIは非公開になっていますし、簡単に使うためのフレームワークからは複雑なAPIは非公開になっています。

## All hidden apis are NOT deisgned performing

^ そして、これが意味するのは、隠されたAPIは我々が呼び出すことを想定して設計されているわけではないということです。
^ そのため、隠されたAPIを利用する際には、リスクが付きまといます。

# Hidden API's risk

- Undocumented
- Unstable
- AppStrore Rejection

^ 隠されたAPIを呼び出すリスクと対策について考えてみましょう。

## Undocumented

- Poor performance?
- Runtime argument validation?
- Method combination needed?

+ E2E testing

^ まずは、ドキュメントがないことです。
^ ドキュメントが無いということは、どんな挙動をするかわからないということです。
^ 呼び出すパフォーマンスがとても悪い可能性、ランタイムで引数が検証される可能性や、事前に他のメソッドを呼ぶ必要があるなどの可能性があります。
^ これらのリスクは、E2Eテストを行うことである程度カバーすることができます。

## Unstable

- breakable from any update

- schedule testing
- use beta version

^ そして、非公開APIはいつでも変更される可能性があります。
^ OSのアップデートや、フレームワークのアップデートで、メソッド自体が無くなったり挙動が変わるリスクがあることを覚えておきましょう。
^ 対策としては、定期的なテストを行うことで壊れたことに気づくことができます。
^ また、OSやフレームワークのベータ版を使うことで、早期に変更を検知することもできます。

## AppStrore Rejection

- Uncompliance in review guildeline 2.5.1[^2]

[^2]:https://developer.apple.com/jp/app-store/review/guidelines/

^ 最後に、本番のアプリで隠されたAPIを使うとAppStoreの審査基準に違反する可能性があります。
^ ガイドライン2.5.1には「アプリでは公開APIのみ使用する」と記載されており、Appleのドキュメントページにリンクしてあるところから察するに、アンドキュメントなAPIを使うことは推奨されないと捉えて良いと思います。

# What's the best usecase?

^ それでは、隠されたAPIの最適な使用例について考えてみましょう。

# What's the best usecase?

|Development Phase|Suitable|
|---|---|
|Concept Development| :+1: |
|Testing| :warning: |
|Product Development| :bomb: |

## Concept Development

- Troublesome implementation
- Difficult implementation
- Complex visual effect
- Mocking-up cycle more quickly

### UITextView._setPlaceholder

// codes

### UINavigationItem._setWeeTitle

// codes

### CIFilter

// codes

### _UIHostingView

// codes

## Testing 



### Development case 

- api design
- For example
    - UITextView
- reject risk

### Testing case

- UITesting?
- For example
    - XCUIElement

# How to find it?

- Digging
- Sharing

## Digging

- ObjC headers
- swiftinterface
- Stacktrace

### ObjC headers

- perform _methodDescription

### swiftinterface

- /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator.sdk/System/Library/Frameworks/

- Digging private api is hard and waste time.

### Stacktrace

- breakpoint

## Sharing

- Survey in SNS, gist and more.

# Recap

- Learn API design from APIs (include private)
- It doesn't mean it'll be there tomorrow
- If you known api, you can develop faster.
- If you want to public.
    - Send your feedback to Apple

# References

- Vibrency Effect


--- 

# Idea

```
@available(watchOS, introduced: 6.0, deprecated: 9.4, message: "Use UIHostingController/safeAreaRegions or _UIHostingView/safeAreaRegions")
  @_Concurrency.MainActor @preconcurrency public var _disableSafeArea: Swift.Bool {
```