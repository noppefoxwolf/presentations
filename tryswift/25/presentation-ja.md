slidenumber: true

# Spice up your notifications

## noppe (Tomoya Hirano)

^ みなさんこんにちは、では早速初めていきましょう。

---

# 1999

NTT Docomo 176 Emojis [^1] ☀️

![right fit](moma.png)

^ 1999年、NTTドコモは176種類の絵文字を作りました。

[^1]: https://www.moma.org/collection/works/196070

---

# 2019

Unicode emojis over 3000+. 🧜‍♀️

![right fit](unicode-emojis.png)

^ 2019年には、Unicodeの絵文字は3000種類を超えました。

---

# 2024

![right fit](genmoji.png)

^ そして去年、Genmojiが登場しました。

---

# Genmoji

- AI generated emojis
- ♾️ emojis types 🤯

![right fit](genmojis.png)


^ Genmojiは、Apple Intelligenceが生成する絵文字です。
^ 種類は…無限です。

---

# ♾️ ≠ All

^ ご存知の通り、無限とは全てではありません

---

# Custom Emoji[^2]

- Users can uploaded image as emojis.
- Slack, Twitch, Discord, Mastodon and more.
- AI can't generate memes.

![right fit](slackemoji.png)

[^2]: https://slackmojis.com

^ 私たちはユニークな絵文字も使います。
^ SlackやMastodon, Discordでは、ユーザーが絵文字を登録することができます。

---

# Custom Emoji[^3]

- Emoji creater is famous job in Japan.
- Creater sale own emojis in Messenger app.
- This character made by my wife. →

![right fit](lineemoji.png)

[^3]: ©kitsune-imori.lineem2018

^ 私の妻は絵文字クリエイターでもあります。
^ これは彼女の作ったnewtのキャラクターです。
^ そう、カスタム絵文字は自分の感情だけでなく、趣向を表現する事ができます。
^ カスタム絵文字はハイコンテキストなものなのです。

---

![inline](appicon.png)

^ さて、絵文字は送信しなければ意味がありません。
^ 今日のために、メッセージアプリを作りました。
^ このアプリでは、私の妻が作った絵文字を送る事ができます。

---

![inline](send-message.png)

^ 早速送信してみましょう。
^ かわいいnewtですね。送信！

---

![](a-few-minutes-later.jpg)

---

![inline](received-notification.png)

^ ♪ 通知が届きました。
^ あぁ、なんということでしょう！
^ もう通知には、可愛らしいnewtはいません。
^ 代わりに(Heart)と書かれています。
^ これはいけませんね。
^ 通知にカスタム絵文字を表示することは出来ますか？

---

# Back to WWDC24.

^ 去年のWWDCを思い出してみましょう。

---

![inline](INSendMessageIntent.png)

^ これです！見えますか？

---

![inline](INSendMessageIntent-zoom.png)

^ Genmojiは通知に表示する事が出来ます。

---

# 💡

^ あぁ、良いことを思いつきました。

---

# Can ![inline](zenmoji-emoji.png) spoof as ![inline](genmoji-emoji.heic)?

^ カスタム絵文字をGenmojiに偽装することは出来るでしょうか？
^ 試してみましょう！

---

# Extract Genmoji

![inline](adaptiveglyph.jpeg)

^ まずは、GenmojiをUITextViewにタイプします。

---

```swift
let range = NSRange(location: 0, length: attributedText.length)
attributedText.enumerateAttribute(
    .adaptiveImageGlyph,
    in: range,
    using: { value, _, _ in
        let imageGlyph = value as! NSAdaptiveImageGlyph
        let data: Data = imageGlyph.imageContent
    }
)
```

^ それから、attributedStringにいるGenmojiを見てみましょう。
^ Genmojiは、NSAdaptiveImageGlyphです。
^ imageContentというデータを持っています。
^ このデータをエクスポートします。

---

![inline](heic.png)

^ エクスポートしたデータはheicイメージとして見る事ができます。
^ つまり、Genmojiはheicイメージです。

---

## Metadata of Genmoji HEIC

```xml
<CGImageMetadata 0x103812be0> (
    tiff:DocumentName = 142D3296-51E6-40E2-AC35-0FAD3C5E965C0
    tiff:XPosition = 0/1
    tiff:TileWidth = 160
    tiff:YPosition = 0/1
    dc:description = ()
    Iptc4xmpExt:DigitalSourceType = ...
    tiff:TileLength = 160
    photoshop:Credit = Apple Image Playground
    tiff:Orientation = 1
    iio:hasXMP = True
    xmp:CreatorTool = Apple TextKit
)
```

^ それから、このデータのメタデータを見てみましょう。
^ いくつかキーがあります。
^ 時間がないので答えを言います。
^ tiff:DocumentName、これが重要なピースです。
^ これがあればGenmojiとして認識されます。

---

```swift
func imageContent() -> Data {
    let imageContent = NSMutableData()
    let destination = CGImageDestinationCreateWithData(
        imageContent,
        NSAdaptiveImageGlyph.contentType.identifier
    )!

    let metadata = CGImageMetadataCreateMutable()
    metadata["tiff:DocumentName"] = UUID().uuidString
    
    let image = UIImage(resource: .emoji)
    destination.add(image.cgImage!, metadata)
    
    destination.finalize()
    return imageContent as Data
}
```

^ イメージデータとtiff:DocumentNameを組み合わせてheicファイルを作ります。
^ tiff:DocumentNameにはUUIDをセットします。
^ このデータで、NSAdaptiveImageGlythを作ってみましょう。

---

![inline](send-message.png)

^ さぁ、もう一度送信してみましょう。

---

![inline](notifications.png)

^ YES!通知に可愛らしいnewtが表示されました。
^ きっと、私の妻も喜んでいます。

---

# Thank you for listening

https://github.com/noppefoxwolf/Zenmoji

## My name is Tomoya

- Solo iOS app developer
- DAWN for Mastodon
- WWDC24 attendee

![right fit](Original@512x512.png)

^ 今回のソースコードはZenmojiという名前でオープンソースとして公開しています。
^ 私の名前はTomoyaです。Mastodonアプリを開発しています。
^ 最後までtry!Swiftをお楽しみください！
^ Thank you!
