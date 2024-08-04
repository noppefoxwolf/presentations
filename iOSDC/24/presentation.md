slidenumbers: true
slidecount: true
slide-transition: false
slide-dividers: #, ##, ###, ####
autoscale: true
theme: Inter 2.0, 2
background-color: #F6F5F7
header: text-scale(0.6)

# How to access hidden iOS APIs and enhance development efficacy.

2024/08/23 10:50〜
Track B
Regular talk（20 min）

# noppe

- Indie app developer
    - DAWN for mastodon
    - vear - VTuber camera app

![right](Alpha.png)

^ こんにちは、noppeと言います。
^ 個人でmastodonのサードパーティアプリや、Vtuber向けのカメラアプリを開発しています。
^ きつねが好きで、このアイコンで活動していますのでSNSで見かけた際はぜひ話しかけてください。
^ なお、トークは日本語で行いますが、日本のエンジニアイベントに興味を持ってくれた海外の方にも楽しんでいただけるように、英語でスライドを表示しています。
^ 今日のトークでは「iOSの隠されたAPIを解明し、開発効率を向上させる方法」をお話しします。

---

![inline](public.png)

^ 我々が日々アプリ開発をする際には、SwiftやObjCなどのプログラミング言語や、SwiftUIやUIKitなどのフレームワークを使ってアプリを構築しています。
^ フレームワークは特定の用途に特化していて、それらの開発を快適に進められるようにしたり、開発者が多くを学ばずともプロダクトの開発に集中できるようなAPIを提供しています。

---

![inline](public-and-private.png)

^ 一方で、そういったフレームワークを構築するためのAPIは隠されており、公開されていません。
^ これらのAPIは非公開APIと呼ばれ、もちろん通常の開発では利用することができません。
^ しかし、非公開APIを使うことで、開発効率を向上させることができる場合があります。

# Agenda

- Perform
- Usecase
- Find

![right fit](b04b44a097f4e025f8b6c20c0f1f8838f1fd0612.png)

^ まずは、非公開APIを実行するデモンストレーションをしましょう。
^ 非公開APIには色々な種類があり、それぞれ実行する方法が異なります。
^ デモンストレーションの後に、非公開APIの最適なユースケースとリスクについて考えてみます。
^ これが、このトークのメインテーマです。
^ 最後に、非公開APIを見つける方法についてお話しします。
^ 全てのトピックに共通するのは、手段とリスクを理解することです。
^ このトークを通じて、自分なりの手段の使いどころを見つけられればと思います

## Agenda

- **Perform**
- Usecase
- Find

^ それでは、最初に非公開APIを実行する方法について理解していきましょう。
^ 非公開APIは、公開されていないAPIなので、通常の方法では呼び出すことができません。

### ObjC Private API

![inline](objc.png)

^ まずはObjCのAPIについて見ていきましょう。
^ ObjCでは、ヘッダーファイルと実装ファイルに定義が分かれています。
^ ヘッダーファイルにメソッドやクラスを書くことで、他のクラスにこのクラスの機能を知らせることができます。
^ つまり、ヘッダーファイルに書かれていない実装ファイルのメソッドは非公開APIということになります。

### ObjC Private API

```ObjC
Sample *object = [Sample new];

// Success
[object send]; 

// Error
[object validate]; 
```

^ 例えば、先ほどのSampleでは、sendメソッドはヘッダーファイルに書かれているので呼び出すことができます。
^ しかし、validateメソッドはヘッダーファイルに書かれていないので呼び出すことができません。
^ このような非公開APIを呼び出すためには、別の方法を使う必要があります。

### ObjC Private API

Add header file.

```ObjC
@interface Sample (Private)
- (BOOL)validate;
@end
```

```ObjC
// Success
[objcect validate];
```

^ 方法の一つは、自分でヘッダーファイルを拡張し、メソッドの宣言を追加することです。
^ これにより、実装を公開することができ、他のクラスから呼び出すことができるようになります。

### ObjC Private API

Manually dynamic dispatch

```ObjC
[object performSelector:NSSelectorFromString(@"validate")];
```

^ もう一つの方法は、Dynamic Dispatchを使うことです。
^ ObjCでは、各実装はメソッド名によって識別されるため、メソッド名を文字列で指定することで呼び出すことができます。
^ これを使うことで、非公開APIでもメソッド名がわかれば呼び出すことができます。
^ ObjCで一般的に使われているNSObjectには、performSelectorメソッドが用意されているので、これを使うことで文字列からメソッドを簡単に呼び出すことができます。

### ObjC Private API

```ObjC
object.isValidate = YES;
```

```ObjC
object.performSelector(
    NSSelectorFromString(@"setIsValidate:"), 
    withObject: @(YES)
);
```

^ プロパティの場合も、同様にperformSelectorを使って呼び出すことができます。
^ ObjCではプロパティは内部的にsetter/getterメソッドが呼び出されるため、これを使ってプロパティを操作することができます。
^ setterのように引数がある場合は、withObjectを使って引数を渡すことができます。

### Swift Hidden API

- Swift does not have header file
- Dynamic Link Framework has Swift module data

^ 次にSwiftのAPIについて見ていきましょう。
^ Swiftにはヘッダーファイルがないため、非公開APIを呼び出す方法限られます。
^ 現状では、Swiftで書かれたDynamic Link Frameworkに限って、Swiftモジュールの情報が公開されたファイルを持っており、非公開のAPIを見つけることができます。

### Swift Hidden API

- tbd
    - dynamic library stub for Eager linking [^4]
    - public and internal api list

- swiftinterface
    - public api list

[^4]: https://developer.apple.com/jp/videos/play/wwdc2022/110364/

^ モジュールの情報が公開されたファイルは、tbdファイルとswiftinterfaceファイルがあります。
^ tbdファイルには、publicとinternalのAPIリストが含まれています。
^ swiftinterfaceファイルには、publicのAPIリストが含まれています。

### Swift Hidden API

```
/Applications
    /Xcode.app
        /Contents
            /Developer
                /Platforms
                    /iPhoneSimulator.platform
                        /Developer
                            /SDKs
                                /iPhoneSimulator.sdk
                                    /System
                                        /Library
                                            /Frameworks
                                                /SwiftUI.framework
```

^ 実際にSwiftUIのフレームワークを見てみましょう。
^ SwiftUIのフレームワークは、XcodeにバンドルされているSDKの中にあります。
^ 少しパスが長いので、私はクリップボードヒストリーなどに保存して呼び出しています。

### Swift Hidden API

[.code-highlight: all]
[.code-highlight: 8, 10, 12]

```
SwiftUI.framework
├── Headers
│   ├── SwiftUI.h
│   └── SwiftUI_Metal.h
├── Modules
│   ├── SwiftUI.swiftmodule
│   │   ├── arm64-apple-ios-simulator.swiftdoc
│   │   ├── arm64-apple-ios-simulator.swiftinterface
│   │   ├── x86_64-apple-ios-simulator.swiftdoc
│   │   └── x86_64-apple-ios-simulator.swiftinterface
│   └── module.modulemap
└── SwiftUI.tbd
```

^ フレームワークは次のような構造になっています。
^ APIのリストが含まれたファイルは、このswiftinterfaceとtbdファイルです。
^ まずはswiftinterfaceファイルを見てみましょう。

### Swift Hidden API

```swift

@_Concurrency.MainActor
open class UIHostingController<Content> : UIKit.UIViewController 
where Content : SwiftUICore.View {

    @_Concurrency.MainActor @preconcurrency 
    public var _disableSafeArea: Swift.Bool {
        get
        set
    }

}
```

^ swiftinterfaceファイルは、通常のswiftと同じように読めるテキストファイルです。
^ 実装は含まれていないので、protocolのようにメソッドの宣言だけが含まれています。
^ この例では、UIHostingControllerの_disableSafeAreaプロパティが宣言されています。

### Swift API

```swift
let vc = UIHostingController(rootView: ContentView())
vc._disableSafeArea = true
```

^ そして公開されているAPIでも、ドキュメントに載っていないAPIが存在します。
^ 例えば、UIHostingControllerはセーフエリアを無効化する_disableSafeAreaプロパティを持っているのですが、これはドキュメントには記載されていません。

#### UnderscoredAttributes[^1]

```swift
extension View {
    @_disfavoredOverload
    func badge(_ count: Int) -> some View {
        // ...
    }
}
```

[^1]:https://github.com/swiftlang/swift/blob/main/docs/ReferenceGuides/UnderscoredAttributes.md

^ また、Swiftの言語機能にはリポジトリにドキュメントがあるものの、通常の開発では非推奨のAPIも存在します。
^ 例えば、@_disfavoredOverloadは同名のメソッドが呼ばれる際の優先度を下げることができます。
^ Swiftのリポジトリには、UnderscoredAttributesというドキュメントがありますが、ここに書いてあるAPIはアプリ開発での利用は推奨されていません。
^ これらのAPIは、Appleのドキュメントでは積極的に登場しないので、隠されたAPIとして紹介します。
^ これは雑談ですが、隠されたAPIの先頭は_で始まることが多いということを覚えておくといいかもしれません。

### How to use hidden APIs?

^ さて、これらのAPIはどのようにして使うことができるのでしょうか？

#### ObjC Private API

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

#### Undocumented API

```swift
let vc = UIHostingController(rootView: ContentView())
vc._disableSafeArea = true
```

^ SwiftのUndocumented APIについては、公開されているものは直接呼び出すことができます。
^ 公開されているか否かについては、後ほど詳しく解説します。

#### UnderscoredAttributes

```swift
extension View {
    @_disfavoredOverload
    func badge(_ count: Int) -> some View {
        // ...
    }
}
```

^ UnderscoredAttributesについても、通常のメソッドと同様に呼び出すことができます。



- Uncompliance in review guildeline 2.5.1[^2]

[^2]:https://developer.apple.com/jp/app-store/review/guidelines/

^ 最後に、本番のアプリで隠されたAPIを使うとAppStoreの審査基準に違反する可能性があります。
^ ガイドライン2.5.1には「アプリでは公開APIのみ使用する」と記載されており、Appleのドキュメントページにリンクしてあるところから察するに、アンドキュメントなAPIを使うことは推奨されないと捉えて良いと思います。

## What's the best usecase?

^ それでは、隠されたAPIの最適な使用例について考えてみましょう。

### What's the best usecase?

|Development Phase|Suitable|
|---|---|
|Concept Development| :+1: |
|Testing| :warning: |
|Product Development| :bomb: |

### Concept Development

- Troublesome implementation
- Difficult implementation
- Complex visual effect
- Mocking-up cycle more quickly

#### UITextView._setPlaceholder

// codes

#### UINavigationItem._setWeeTitle

// codes

#### CIFilter

// codes

#### _UIHostingView

// codes

### Testing 

// TBD

### Product Development

Using hidden API is risky.

But, You can learn design from hidden API.

### API Naming, Archtectures. 

// codes

### What's the best usecase?

- Hidden API can quicken development cycle
- But 

#### instrument stacktrace

### Hidden API's risk

API design factor

- Framework has clear porpose
- Cases
    - Declarative UI framework hides imperative API
    - Easy framework hides complex API

^ では、こんなに便利なAPIたちは、なぜ隠されているのでしょうか？
^ 理由の一つは、APIデザインの過程で非公開になったAPIがあるためです。
^ フレームワークには明確な目的があり、その目的に沿ったAPIが公開されています。
^ 例えば、フレームワーク利用者に宣言的UIを提供するフレームワークには、命令的なAPIは非公開になっていますし、簡単に使うためのフレームワークからは複雑なAPIは非公開になっています。

#### All hidden apis are NOT deisgned performing

^ そして、これが意味するのは、隠されたAPIは我々が呼び出すことを想定して設計されているわけではないということです。
^ そのため、隠されたAPIを利用する際には、リスクが付きまといます。

#### Hidden API's risk

- Undocumented
- Unstable
- AppStrore Rejection

^ 隠されたAPIを呼び出すリスクと対策について考えてみましょう。

#### Undocumented

- Poor performance?
- Runtime argument validation?
- Method combination needed?

+ E2E testing

^ まずは、ドキュメントがないことです。
^ ドキュメントが無いということは、どんな挙動をするかわからないということです。
^ 呼び出すパフォーマンスがとても悪い可能性、ランタイムで引数が検証される可能性や、事前に他のメソッドを呼ぶ必要があるなどの可能性があります。
^ これらのリスクは、E2Eテストを行うことである程度カバーすることができます。

#### Unstable

- breakable from any update

- schedule testing
- use beta version

^ そして、非公開APIはいつでも変更される可能性があります。
^ OSのアップデートや、フレームワークのアップデートで、メソッド自体が無くなったり挙動が変わるリスクがあることを覚えておきましょう。
^ 対策としては、定期的なテストを行うことで壊れたことに気づくことができます。
^ また、OSやフレームワークのベータ版を使うことで、早期に変更を検知することもできます。

#### AppStrore Rejection

## How to find hidden APIs?

- header
- swiftinterface
- swift repository
- stacktrace
- SNS

#### Headers

- Use `class-dump`
- perform `_methodDescription`

[^3]:https://www.developer.limneos.net/

#### swiftinterface

```
/Applications/
    Xcode.app/
        Contents/
            Developer/
                Platforms/
                    iPhoneSimulator.platform/
                        Developer/
                            SDKs/
                                iPhoneSimulator.sdk/
                                    System/
                                        Library/
                                            Frameworks/
```

#### Stacktrace

// Add Image

- Breakpoint, Instruments

#### Sharing

- Survey in SNS, gist and more.

# Advanced techniques

- xcframework

# Next steps

- You can use hidden APIs.
- Hidden APIs are useful for some development phases.
- But, using hidden APIs is risky.
- You can find hidden APIs by header, swiftinterface, swift repository, stacktrace, SNS.

# Thank you for listening!

--- 

# Memo

https://www.jacklandrin.com/2018/05/16/method-in-objective-c-messgae-passing/

https://xta0.me/2023/06/28/Swift-modules-1.html

```
@available(watchOS, introduced: 6.0, deprecated: 9.4, message: "Use UIHostingController/safeAreaRegions or _UIHostingView/safeAreaRegions")
  @_Concurrency.MainActor @preconcurrency public var _disableSafeArea: Swift.Bool {
```