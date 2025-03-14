slidenumber: true

# Spice up your notifications

## noppe (Tomoya Hirano)

^ みなさんこんにちは、では早速初めていきましょう。

---

# 1999: NTT Docomo 176 Emojis [^1]

![right fit](moma.png)

^ 1999年、NTTドコモは176種類の絵文字を作りました。

[^1]: https://www.moma.org/collection/works/196070

---

# 2019: Unocode emojis over 3000+.

![right fit](unicode-emojis.png)

^ 2019年には、Unicodeの絵文字は3000種類を超えました。

---

# 2024

![right fit](genmoji.png)

^ そして2024年、Genmojiが登場しました。

---

# Genmoji

- AI generated emojis
- Inifinity emojis types

![right fit](genmojis.png)


^ Genmojiは、Apple Intelligenceが生成する絵文字です。
^ 種類は…無限です。

---

# Infinity is not all

---

# Custom Emoji[^2]

- Uploaded user emojis
- Slack, Twitch, Discord
- Meme

![right fit](slackemoji.png)

[^2]: https://slackmojis.com

^ さらに、私たちはユニークな絵文字も使います。
^ SlackやMastodon, Discordでは、ユーザーが絵文字を登録することができます。
^ ミームの絵文字は、私も大好きです。

---

# Custom Emoji[^3]

- Everyone can make emoji

![right fit](lineemoji.png)

[^3]: ©kitsune-imori.lineem2018

---

// icon

^ さて、絵文字は送信しなければ意味がありません。
^ 今日のために、私の妻が作った絵文字が使えるメッセージアプリを作りました。

---

![inline](send-message.png)

---

![](a-few-minutes-later.jpg)

---

![inline](received-notification.png)

^ （一息おいて…）
^ 「猫ミームのメッセージ(OK)」
^ あぁ、なんということでしょう。
^ もう通知には、可愛らしいトカゲはいません。代わりに(OK)と書かれています。

---

# Notifications are silence?

^ 通知にカスタム絵文字を表示することは出来ないのでしょうか？
^ 今年のWWDCを思い出してみましょう。

---

# WWDC

^ これです！Genmojiは通知に表示する事が出来ます。

---

# Can custom emojis spoof Genmoji?

^ カスタム絵文字を、Genmojiに装うことは出来るでしょうか？
^ 試してみましょう

---

# Extract Genmoji

![Screenshot of UITextView]()

^ まずは、Genmojiを解剖してみましょう。
^ UITextViewにGenmojiをタイプします。

---

![Screenshot of attributedString runs]()

^ attributesを参照します。
^ Genmojiの正体は、NSAdaptiveImageGlyphです。

---

![Screenshot of NSAdaptiveIamgeGlyph documents]()

^ NSAdapativeImageGlyphは、imageContentというDataでinitする事ができます。
^ つまり、このimageContentを作ればカスタム絵文字のNSAdapativeImageGlyphが作れそうです。

---

![Screenshot of look Data header]()

^ NSAdapativeImageGlyphのimageContentを書き出します。
^ ヘッダーを見ると、heicであると分かりました。

---

![Screenshot of metadata]()

^ このデータのメタデータを見てみましょう。
^ いくつかキーがあります。時間がないので答えを言います。
^ tiff:DocumentName。これが重要です。

---

![Screenshot of create own Data]()

^ 用意したイメージデータとtiff:DocumentNameを組み合わせてheicファイルを作ります。
^ このデータで、NSAdaptiveImageGlythを作ってみましょう。

---

![gif of work with custom emoji as Genmoji]()

^ ビンゴ！動きました。
^ 通知にも表示されます。
^ 私の妻も喜んでいます。

---

# See more

https://github.com/noppefoxwolf/Zenmoji

^ 今回のコードはオープンソースとして公開しています。
^ 私の名前はTomoyaです。Mastodonアプリを開発しています。
^ この後もtry!Swiftをお楽しみください！
