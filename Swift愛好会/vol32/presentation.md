footer: 🦊 @noppefoxwolf, 2018
slidenumbers: true

# [fit] Runtime for Swift

---

# noppe

🦊 きつね好き
iOSアプリエンジニア

//TODO

![right](IMG_0726.PNG)

---

# Runtimeとは

**実行時**という意味

コンパイル時に解決できない実装を実行時に実装する時に利用される。
Ex:コンパイル時に存在しないプロパティをクラスに生やす/コンパイル時に存在しないクラスを生成する

---

# ObjectiveC runtime API

`#import <objc/runtime.h>`

objcの標準ランタイムAPIはimportするだけで利用できる
Swiftの場合は`import ObjectiveC`

---

# objc_setAssociatedObject

```swift
var animal = Animal()
objc_setAssociatedObject(animal, &Key, "hello!", .OBJC_ASSOCIATION_RETAIN)
objc_getAssociatedObject(animal, &Key) as! String // hello
```

実行時にクラスにオブジェクトを保有させる例

SwiftのextensionでStored Propertyを生やそうとする時にお世話になる事が多い。

---

# objc_setAssociatedObject

```
struct Animal {}
var Key: UInt8 = 0
var animal = Animal()
objc_setAssociatedObject(animal, &Key, "hello!", .OBJC_ASSOCIATION_RETAIN)
objc_getAssociatedObject(animal, &Key) // nil
```

//TODO:ここnsobject継承しなくてもできてしまった・・・
objc_setAssociatedObjectはstructでは使う事ができない。
^ObjCのStructTypeでも同様

---

# Swift runtime API?

https://github.com/apple/swift/blob/master/docs/Runtime.md

`The final runtime interface is currently a work-in-progress`
なさそう。

---

# valueForKey

```
class Person : NSObject {
  @objc var name = ""
}

var p1 = Person()
p1.setValue("Jhone Doe", forKey: #keyPath(Person.name))
```

---

# Properties

```
var count: UInt32 = 0
let properties = class_copyPropertyList(Person.self, &count)
for i in 0..<Int(count) {
  let prop = properties![i]
  let propName = String(cString: property_getName(prop))
  print(propName)
}
```

---

# Swift runtime API

https://github.com/wickwirew/Runtime
文字列による変数代入やインスタンスの生成
各種構造体のメタデータダンプ

https://github.com/Meniny/DynamicKit
https://github.com/Zewo/Reflection

//TODO :ここで使われているようなのを例にしたい

---

# Properties

流れ
構造体をメタデータ構造体へマッピングしてプロパティ情報を取得

---

## 構造体をメタデータ構造体へマッピング

let base = unsafeBitCast(type, to: UnsafeMutablePointer<Int>.self)
ポインターを取得
let metadataPointer = base.advanced(by: valueWitnessTableOffset).raw
メタデータのポインターを取得（-1ずらす。ドキュメント参照）
let metadata = metadataPointer.assumingMemoryBound(to: StructMetadataLayout.self)

StructMetadataLayout {
  var valueWitnessTable: UnsafePointer<ValueWitnessTable>
  var kind: Int
  var nominalTypeDescriptor: UnsafeMutablePointer<NominalTypeDescriptor>
}
https://github.com/apple/swift/blob/master/docs/ABI/TypeMetadata.rst

NominalTypeDescriptorはここ
https://github.com/apple/swift/blob/master/docs/ABI/TypeMetadata.rst#nominal-type-descriptor

//TODO: 取れる情報一覧出したい

注意：Swift4.1でのレイアウトなので変更する可能性ありSwift5のABI安定化で破壊されるかも
//TODO: 参考文献見つけられればここに春

---

 ## どの構造か判別

 https://github.com/apple/swift/blob/master/docs/ABI/TypeMetadata.rst#common-metadata-layout
 
 Kind見ればおk

---

## プロパティの代入と取得



---

## インスタンスを生成する




---

## 実行環境による差分

---

Runtimeとは実行時のこと

https://github.com/wickwirew/Runtime

SwiftでRuntime集

Metadata
Factory
GetSet(Struct|Class)
ValueWitnessTable

---

# Metadata



Runtimeの応用
Runtimeを使って作ってみた

---

# words

ABI:Application Binary Interface
http://developer.hatenastaff.com/entry/learn-about-swift-3-point-0-from-swift-evolution#ABI-Stability