限定的なimportの明示とその効果

普段なんとなく書いているimportですがサブモジュールや特定の要素を明示的に指定することができます。
このセッションではこれらのimportの仕様を振り返り、またバイナリサイズやパフォーマンスに与える影響を考えていきます。

---

https://www.youtube.com/watch?v=E65lXzau_0Y&index=6&list=PLCl5NM4qD3u92PwamgwWr3e_j3GmKRVTs&t=0s

https://nshipster.com/import/

https://docs.swift.org/swift-book/ReferenceManual/Declarations.html

---


# 限定的なimportの明示とその効果

noppe
@DeNA

---

import文の仕様
submodule明示指定の効果
バイナリの比較
意味はない？

---

今日話をするのは、Swiftのimportについてです。
importは、外部のフレームワークやモジュールで定義された関数やプロパティを呼び出す時に利用します。

普段何気なく書いているimportですが、どのような構造になっているかご存知でしょうか。
実はこのような構造になっています。

attributes? import import-kind? import-path

これはswiftのソースコードから見つけることができます。
普段書いているimport文よりも複雑であることが分かります。

kindは
struct, class, enum, protocol, typealias, func, let ,var

ObjectiveCは？

submoduleは、限定的なimportができます。
import SceneKit.ModelIO
選択できるイニシャライザが増えましたね。

importをするとバイナリサイズは増えるでしょうか？

submodule importを利用するとコンパイル時間は減るでしょうか？

