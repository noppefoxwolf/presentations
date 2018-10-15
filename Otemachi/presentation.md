footer: 🦊
slidenumbers: true

# CodableでカオスなJSONに対応していく

### Otemachi.swift \#02 noppe (@noppefoxwolf)

---

#[fit] noppe

💻 iOSアプリ
🏢 ディー・エヌ・エー
🦊 きつねかわいい

![right fit](profile.png)

---

# こんなJSONばかり扱っていませんか？

![inline](normal_json.png)

---

# 世の中にはカオスなJSONがある🤯

---

# カオス １/２

---

# このJSON何がおかしいですか

![inline](snake_and_kebab_json.png)

---

# snake_caseとkebab-caseが混合している！ 

![](snake_and_kebab_json.png)

---

# snake_case以外が混ざっているとKeyDecodingStrategyが使えない…

---

# KeyDecodingStrategyとは？

Swift 4.1 〜
JSONキー名->プロパティ名のルールを指定する事で、`init(from decoder:)`を実装せずにマッピング出来る

```swift
let decoder = JSONDecoder()
decoder.keyDecodingStrategy = .convertFromSnakeCase
let obj = try decoder.decode(Response.self, from: data)
```

^ snakeCaseでないものがあるとtryで弾かれる
^ では、init(from:decoder)を実装しなきゃいけないのか？

---

# 大丈夫

---

# カスタムデコードルール

```swift
decoder.keyDecodingStrategy = .custom { keys in
    let lastComponent = keys.last!.stringValue.camelCase
    return AnyKey(stringValue: String(lastComponent))!
}
```

カスタムなkeyDecodingStrategyを作る事ができる。

^ codingKeysを受け取ってCodingKeyを返す実装
^ keysには探索したキーの経路が入っている
^ stringValueで文字列が取り出せる
^ キーをプロパティ名に変換してAnyKey(CodingKey)につめて返す

---

# snake_case or kebab-case to camelCase

```swift
extension String {
  internal var camelCase: String {
    return self.replacingOccurrences(of: "-", with: "_")
               .components(separatedBy: "_")
               .enumerated()
               .map { 0 == $0 ? $1 : $1.capitalized }
               .joined()
    
  }
}
```

---

```swift
struct AnyKey : CodingKey {
  var stringValue: String
  var intValue: Int?
  
  init(stringValue: String) {
    self.stringValue = stringValue
  }
  
  init(intValue: Int) {
    self.stringValue = "\(intValue)"
  }
}
```

AnyKeyは単純に受け取った文字列をキー名として解釈する

---

# カオス２/２

---

# このJSON何がおかしいですか

![inline](any_json_1.png)

---

![inline](any_json_2.png)

---

# 型が不定

![](any_json_2.png)

---

# 型が不定

一回Anyに詰めて、取り出す時に型を付けてあげる

AnyやAnyObjectをDecodable準拠する事はできないので注意

---

# 型が不定

Anyプロパティを包んで`init(from decoder: Decoder)`を直接書く範囲を減らす

```swift
struct IndefiniteObject<T: Decodable>: Decodable {
  let value: Any
  
  init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    print("hoge")
    if let value = try? container.decode(T.self) {
      self.value = value
    } else if let value = try? container.decode([T].self) {
      self.value = value
    } else {
      preconditionFailure()
    }
  }
}
```

---

# 型が不定

使うときはswitchなどで分岐

```swift
switch object.data.value {
case let value as Media:
  print(value.id)
case let value as [Media]:
  print(value.compactMap({ $0.id }))
default: break
}
```

---

# noppefoxwolf/GabKit

gab.comという海外のSNSのAPIを叩くライブラリ

今回のテクニックで実装してます🤯