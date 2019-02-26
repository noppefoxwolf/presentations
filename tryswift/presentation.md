slidenumbers: true

<!-- 
限定的なimportの明示とその効果

普段なんとなく書いているimportですがサブモジュールや特定の要素を明示的に指定することができます。
このセッションではこれらのimportの仕様を振り返り、またバイナリサイズやパフォーマンスに与える影響を考えていきます。

---

https://www.youtube.com/watch?v=E65lXzau_0Y&index=6&list=PLCl5NM4qD3u92PwamgwWr3e_j3GmKRVTs&t=0s

https://nshipster.com/import/

https://docs.swift.org/swift-book/ReferenceManual/Declarations.html

https://github.com/apple/swift/blob/81c5a674891f6a37cb500ef6e631046f63686256/lib/Sema/NameBinding.cpp

https://thoughtbot.com/blog/swift-imports



なので、基本は使わなくて良いです。

ではどういう時に良いのか

１・異なるモジュールを依存させる時
import SceneKit.ModelIO
import Foundation.NSString

https://github.com/realm/SwiftLint/issues/2594#issuecomment-457936688

作り方
https://github.com/realm/realm-cocoa/blob/master/Realm/Realm.modulemap

umbrella frameworkじゃないとダメかも
これはObjCのフレームワークを利用する時くらいにしか利用できない。


２・同名の関数を持つ時

Core
func say()

Core2
func say()

import func Core.say

say()

protocolの名前をシンプルにしていて良いということ？
UIFontCompleteとSwiftyAttibutes

https://medium.com/@bittudavis/how-to-create-an-umbrella-framework-in-swift-ca964d0a2345

Xcode9からSwift native static library

---

import文の仕様
submodule明示指定の効果
バイナリの比較
意味はない？
どういう時に効果的なのか


-->

#[fit] What's effect of individual import.
## 限定的なimportの明示とその効果
### try! swift tokyo noppe @DeNA

^ // ここにプロフ画像入れる

^ 私の名前はnoppeです。
^ Hello, My name is noppe.
^ 今日は初めての英語のプレゼンテーションです。よろしくお願いします。
^ Today is the first time for me to give a presentation in English. 
^ DeNAという会社でiOSアプリエンジニアをしています。
^ I'm an iOS app developer at DeNA in Tokyo

---

# import

^ 今日話をするのは、Swiftのimportについてです。
^ Today, I'll talk about import which is a function of Swift.
^ import宣言は、外部のシンボルを呼び出す時に利用します。
<!-- It's used for import to your code functions and properties -->

---

# import UIKit

^ import宣言をみたことが無い人はいないでしょう。
^ I guess here is no developer who haven't seen a import declaration.
^ XcodeからSwiftファイルを作ると、UIKitがimportされているファイルが自動的に作られるからです。
^ Because a file is made by xcode automatically that imported an UIKit when we make a Swift file.
^ 普段何気なく書いているimportですが、どのようなシンタックスなのかご存知でしょうか。
^ We write import with no attention.
^ Then, do you know what consist of it?
//syntax?

---


```
[attributes] import [module]
[attributes] import [module].[submodule]
[attributes] import [import kind] [module].[symbol name]
```

[^1]

[^1]: https://docs.swift.org/swift-book/ReferenceManual/Declarations.html

^ 実はこのような構造になっています。
^ Look. These are all syntax of import. 
^ この仕様は、Swiftのドキュメントから見つけることができます。
^ You can find the syntax in every swift documents.
^ 普段書いているimport文よりも複雑であることが分かります。
^ Some tokens add to the import syntax we usually use.
^ それではそれぞれのtokenについて説明します。
^ Let's look at each tokens.

---

# attributes

^ まずはattributesについて見てみましょう
^ At first, I introduce attributes.

---

## @testable import MyFramework


^ attributesには@testableがあるのを知っていますか。
^ Do you know @testable which is a kind of attributes.
^ これはテストで利用するattributesです。
^ @testableを付けると、internalメソッドにもアクセス出来るようになります。
^ If you write it before import, you can acsess some internal methods. 
^ テストのために元のコードを変更する必要がなくなります。

---

# attributes
## @_exported import SubModule
### Important⚠︎: private method

^ @_exportedは自分自身のコードのようにシンボルをインポートします。
^ https://github.com/typelift/SwiftCheck/pull/114/files#r44612923
^ 例えば、SwiftでUmbrellaFrameworkを作る際に利用できます。
^ アンダースコアで始まっているのはプライベートな宣言です。
^ 非推奨なので、開発時の利用に留める事をおすすめします。
^ ABI安定化に対して影響を与える可能性もあります。

---

# module.submodule

```
[attributes] import [module].[submodule]
import SceneKit.ModelIO
```

^ 次にサブモジュールの指定方法を見てみましょう。
^ submoduleを指定すると、submoduleの実装をimportすることができます。
^ 例えばSceneKitでは、サブモジュールを上手に利用しています。
^ SceneKitはModelIOのクラスからSceneを作ったり、SceneからModelを作る拡張があります。
^ しかし、これらの実装をSceneKitに含むとSceneKitはModelIOの利用に関わらず依存することになります。
^ そこで、SceneKitはModelIOの拡張をサブモジュールとして定義しています。
^ サブモジュールを指定してimportすることで、SCNSceneのコンストラクタが増えることが確認できます。

---

# module.submodule

module.modulemap

```
framework module Umbrella {
  umbrella header "Umbrella.h"
  
  export *
  module * { export * }
  
  explicit module SubModule {
    header "RxSwift.h"
  }
}
```

^ サブモジュールのあるフレームワークを作るには、modulemapでexplictを使って宣言します。
^ Swiftは単一のモジュールとして定義されるため、サブモジュールを宣言できるのはObjective-Cのフレームワークだけです。
^ あなたはSwiftでモジュールを書くでしょうから、実際は、自分で作ったライブラリでこの宣言をすることは多く無いかもしれません。

---

```
[attributes] import [import kind] [module].[symbol name]
import class Core.Object

Object().isKind
```

^ 次に3つ目の記法を紹介します。
^ kindを指定すると、指定した要素を取り込みます。
^ kindを指定した場合、moduleの後に指定するのはサブモジュール名ではありません。要素の実装名を指定します。

---

# Kind

```
struct, class, enum, protocol, typealias, func, let ,var
```

^ kindはsturct, class, enum, protocol, typealias, func, let, varが指定できます。
^ それぞれSwiftでみたことのある要素と同じ意味です。

---

# kindを指定する場合の注意点

^ ここでは２つの注意点があります。

---

# classを指定した場合、classの持つ要素もimportされる。

```
import class Core.Object

Object().isKind //accessable property
```

^ 一つは、classやsturctのimportについてです。
^ classやstructを指定した場合は、実装されたメソッドやプロパティも含まれます。
^ ここで指定するletやfuncはtop-levelの実装を指します。

---

# 同名関数を個別にimportすることはできない。

```
func function(_ value: String) {

}

func function(_ value: Int) {

}
```

^ 二つ目は同名メソッドに関してです。
^ 同名の関数をswiftでは定義することができます。
^ この場合は、個別にimportすることはできません。
^ 両方のfunctionがimportされることになります。

---

# importを詳細に書くことの効果

保管が明瞭になる
...他は？

^ さて、importの
^ importを詳細に書くことで、多くの定義がある場合に補間が明瞭になります。
では、他に影響はあるでしょうか？

---

`ビルド時間`

ビルド時間を計測してみましょう。


`gyb Extensions.swift.gyb -o output.swift`

```
% for i in range(10000):
public func function${i}() {
    print(${i})
}
% end
```

^ テンプレートエンジンのgybを使って、10000000個のメソッドを作りました。
^ これをKindを指定した場合としない場合でリリースビルドをして比較します。

---

```
$ time swift build -c release
Compile Swift Module 'Core' (2 sources)
Compile Swift Module 'BinarySize' (1 sources)
Linking ./release/BinarySize
       20.00 real        19.52 user         0.46 sys
$ time swift build -c release
Compile Swift Module 'Core' (2 sources)
Compile Swift Module 'BinarySize' (1 sources)
Linking ./release/BinarySize
       19.97 real        19.51 user         0.48 sys
```

結果はほとんど変りませんでした。

^ 結果はほとんど変りませんでした。

---

# binary size

^ では、バイナリサイズは変わるでしょうか？
^ 先ほどのビルドのサイズを比較してみます。

---

//-rwxr-xr-x  1 noppe  staff  777092  2 15 23:41 .build/x86_64-apple-macosx10.10/release/BinarySize
//-rwxr-xr-x  1 noppe  staff  777092  2 15 23:41 .build/x86_64-apple-macosx10.10/release/BinarySize

^ 同じ。そして、md5も同じものが出来上がりました。
^ Swiftコンパイラが最適化を行なっているので、結果は同じようです。

---

|a|a|
|---|---|
|a|a|

^ ProsConsです。つまり、importを詳細に記述する必要性は無いということです。
^ これは日常的に書く必要のあるものではなく、名前の解決に問題がある時にだけ必要に応じて書けば良いものということです。

---

# Thank you listenning

^ 以上になります。ありがとうございました。
