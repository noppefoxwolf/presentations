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

<!-- umbrella frameworkじゃないとダメかも -->
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


# 限定的なimportの明示とその効果

noppe
@DeNA

---

import文の仕様
submodule明示指定の効果
バイナリの比較
意味はない？
どういう時に効果的なのか

---

今日話をするのは、Swiftのimportについてです。
importは、外部のフレームワークで定義された関数やプロパティを呼び出す時に利用します。

```
import UIKit
```

import宣言をみたことが無い人はいないでしょう。XcodeからSwiftファイルを作ると、UIKitがimportされているファイルか作られるからです。
普段何気なく書いているimportですが、どのような構造になっているかご存知でしょうか。
実はこのような構造になっています。

```
[attributes] import [module]
[attributes] import [module].[submodule]
[attributes] import [import kind] [module].[symbol name]
```

この仕様は、
`https://docs.swift.org/swift-book/ReferenceManual/Declarations.html`
から見つけることができます。
普段書いているimport文よりも複雑であることが分かります。

```
@testable import MyFramework
```

attributesには例えば@testableがあります。
@testableを付けると、internalメソッドにもアクセス出来るようになります。

```
@_exported import SubModule
```
@_exportedは自分自身のコードのようにシンボルをインポートします。
https://github.com/typelift/SwiftCheck/pull/114/files#r44612923
例えば、UmbrellaFrameworkのように複数のライブラリを単一のimportで取り込むライブラリを作る際に利用できます。
アンダースコアで始まっているのはプライベートな宣言だからです。ABI安定化に対して影響を与える可能性もあります。

```
[attributes] import [module].[submodule]
import MyLibrary.SubModule
```

submoduleを指定すると、submoduleの実装だけをimportすることができます。

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

これは基本的にはmodulemapのexplictで宣言されたモジュールを指します。
Swiftは単一のモジュールとして定義されるため、サブモジュールを宣言できるのはObjective-Cのフレームワークだけです。
あなたはSwiftでモジュールを書くでしょうから、実際は、自分で作ったライブラリでこの宣言をすることは多く無いかもしれません。

```
import SceneKit.ModelIO
```
SceneKitでは、サブモジュールを上手に利用しています。
SceneKitはModelIOのクラスからSceneを作ったり、SceneからModelを作る拡張があります。
しかし、これらの実装をSceneKitに含むとSceneKitはModelIOの利用に関わらず依存することになります。
そこで、SceneKitはModelIOの拡張をサブモジュールとして定義しています。
サブモジュールを指定してimportすることで、SCNSceneのコンストラクタが増えることが確認できます。

```
[attributes] import [import kind] [module].[symbol name]
import class Core.Object
```

kindを指定すると、指定した要素を取り込みます。

```
struct, class, enum, protocol, typealias, func, let ,var
```

kindはsturct, class, enum, protocol, typealias, func, let, varが指定できます。
それぞれSwiftでみたことのある要素と同じ意味です。
kindを指定した場合、moduleの後に指定するのはサブモジュール名ではありません。要素の実装名を指定します。

ちなみにclassを指定した場合は、classに実装されたメソッドやプロパティも含まれます。
ここで指定するletやfuncはtop-levelの実装を指します。

また、同名の関数をswiftでは定義することができます。
```
func function(_ value: String) {

}

func function(_ value: Int) {

}
```
この場合は、個別にimportすることはできません。
両方のfunctionがimportされることになります。

`importを詳細に書くことの効果`

importを詳細に書くことで、多くの定義がある場合に補間が明瞭になります。
では、他に影響はあるでしょうか？

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
gybで10000000個のメソッドを作って、リリースビルドをして比較します。

```
~/D/w/p/t/c/B/.b/x86_64-apple-macosx10.10 (master|✚4) $ time swift build -c release
Compile Swift Module 'Core' (2 sources)
Compile Swift Module 'BinarySize' (1 sources)
Linking ./release/BinarySize
       20.00 real        19.52 user         0.46 sys
~/D/w/p/t/c/B/.b/x86_64-apple-macosx10.10 (master|✚4) $ time swift build -c release
Compile Swift Module 'Core' (2 sources)
Compile Swift Module 'BinarySize' (1 sources)
Linking ./release/BinarySize
       19.97 real        19.51 user         0.48 sys
```

結果はほとんど変りませんでした。

`binary size`

では、バイナリサイズは変わるでしょうか？
先ほどのビルドのサイズを比較してみます。

//-rwxr-xr-x  1 noppe  staff  777092  2 15 23:41 .build/x86_64-apple-macosx10.10/release/BinarySize
//-rwxr-xr-x  1 noppe  staff  777092  2 15 23:41 .build/x86_64-apple-macosx10.10/release/BinarySize

同じ。そして、md5も同じものが出来上がりました。

Swiftコンパイラが最適化を行なっているので、結果は同じようです。

ProsConsです。つまり、importを詳細に記述する必要性は無いということです。
これは日常的に書く必要のあるものではなく、名前の解決に問題がある時にだけ必要に応じて書けば良いものということです。

以上になります。ありがとうございました。
