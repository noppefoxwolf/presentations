slidenumber: true

# Spice up your notifications 🥳

## noppe (Tomoya Hirano)

^ みなさんこんにちは、では早速初めていきましょう。

---

# 1999

- NTT Docomo created 176 emojis.[^1] ☀️
- That can add emotion to messages.

![right fit](moma.png)

^ 1999年、NTTドコモは176種類の絵文字を作りました。
^ これはメッセージに感情を加えることができます。

[^1]: https://www.moma.org/collection/works/196070

---

# 2019

- Unicode now includes over 3,000 emojis.
- Allowing for a wider range of expressions.

![right fit](unicode-emojis.png)

^ 2019年には、Unicodeの絵文字は3000種類を超えました。
^ これにより、より多くの表現が可能になりました。

---

# 2024

![right fit](genmoji.png)

^ そして去年、Genmojiが登場しました。

---

# Genmoji

- Apple Intelligence can generate emojis.
- ♾️ emojis variations 🤯

![right fit](genmojis.png)


^ Genmojiは、Apple Intelligenceが生成する絵文字です。
^ 種類は…無限です。
^ つまり、ハイコンテキストな表現が可能になりました。

---

# ♾️ ≠ All

^ しかし、ご存知の通り、無限とは全てではありません

---

# Custom Emoji[^2]

- Users can upload images as emojis.
- This feature is supported on platforms like `Slack`, `Twitch`, `Discord`, `Mastodon`, and more.
- AI is unable to generate memes.

![right fit](slackemoji.png)

[^2]: https://slackmojis.com

^ そう、私たちはミームの絵文字も使います。
^ SlackやMastodon, Discordでは、ユーザーが絵文字を登録することができます。

---

# Custom Emoji[^3]

- Custom emojis are **not** just memes.
- Emoji creators are well-known professionals in Japan.
- キツネイモリ (`Fox-Newt`) was created by my wife.

![right fit](lineemoji.png)

[^3]: ©kitsune-imori.lineem2018

^ カスタム絵文字はミームだけではありません。
^ 日本では、多くの絵文字クリエイターが活動しています。
^ 私の妻も、絵文字クリエイターです。
^ これは彼女の作ったキャラクターです。fox-newtと呼ばれています。
^ カスタム絵文字は、ユーザーの個性を強調することができます。

---

![inline](appicon.png)

^ さて、絵文字は送信しなければ無意味です。
^ なので、私は今日のトークために、メッセージアプリを作りました。
^ このアプリは、Fox-Newtの絵文字を送る事ができます。

---

![inline](send-message.png)

^ 早速送信してみましょう。
^ かわいいfox-newtですね。送信！

---

![](a-few-minutes-later.jpg)

^ ♪

---

![inline](received-notification.png)

^ いいね！相手に通知が届きました。

---

![inline](received-notification-zoom.png)

^ あぁ、なんということでしょう！
^ もう通知には、可愛らしいfox-newtはいません。
^ 代わりに(Heart)と書かれています。
^ これはいけませんね。
^ 通知にカスタム絵文字を表示することは出来ないのですか？

---

# Back to WWDC24.

^ OK, 去年のWWDCを思い出してみましょう。

---

![inline](INSendMessageIntent.png)

^ これです！見えますか？

---

![inline](INSendMessageIntent-zoom.png)

^ Genmojiは通知に表示する事が出来ます。

---

# 🦊💡

^ あぁ、良いことを思いつきました。

---

# Can ![inline](zenmoji-emoji.png) spoof as AI generated ![inline](genmoji-emoji.heic)?

^ カスタム絵文字をGenmojiに偽装することは出来るでしょうか？
^ 試してみましょう！

---

# 1. Type any Genmoji into the UITextView

![inline](adaptiveglyph.jpeg)

^ まずは、GenmojiをUITextViewにタイプします。

---

# 2. Export Genmoji data

```swift
let range = NSRange(location: 0, length: attributedText.length)
attributedText.enumerateAttribute(
    .adaptiveImageGlyph,
    in: range,
    using: { value, _, _ in
        let imageGlyph = value as! NSAdaptiveImageGlyph
        let data: Data = imageGlyph.imageContent
        data.write()
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

[.code-highlight: all]
[.code-highlight: 2]

# 3. Metadata of Genmoji HEIC

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

# 4. Make fake Genmoji with custom image

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
^ tiff:DocumentNameにはランダムなUUIDをセットします。
^ このデータで、NSAdaptiveImageGlythを作ってみましょう。

---

![inline](send-message.png)

^ さぁ、もう一度送信してみましょう。

---

![inline](notifications.png)

^ Awesome! 通知に可愛らしいfox-newtが表示されました。
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
