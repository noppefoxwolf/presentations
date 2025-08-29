---
title: "SNSアプリを作る時に必要なものを用意しました！"
emoji: "🦣"
type: "tech"
topics:
  - "ios"
  - "swift"
  - "mastodon"
  - "fediverse"
published: true
published_at: "2023-12-11 23:21"
---

iOS Advent Calendar 2023 14日目の記事になります。
https://qiita.com/advent-calendar/2023/ios

---

こんにちは、noppeです。
Nightfox DAWN for mastodonというiOSのマストドンクライアントを作っています。
https://apps.apple.com/jp/app/nightfox-dawn-for-mastodon/id1668645019

実は、このDAWNではマストドンアプリでよく使う処理をオープンソースで提供しています。
今日はDAWNから産まれたオープンソースライブラリを紹介します。どれもMITライセンスなので、マストドンアプリでもそうでなくても自由に使っていただけます。
READMEには採用アプリの紹介欄も設けていますので、ぜひアプリで使ったら教えてくださいね！

# DAWNText

https://github.com/noppefoxwolf/DAWNText

DAWNTextは、SwiftUI上でTextKit2を利用するライブラリです。
SwiftUIのTextでは範囲選択や、NSTextAttachmentによる絵文字の埋め込みが出来ないため開発しました。
セルフリサイズにも対応しており、SwiftUIのTextと同じような感覚で利用できます。

![](https://storage.googleapis.com/zenn-user-upload/0cf29111ad68-20231211.jpeg)

↑はUIHostingConfigurationを使ってSwiftUIで作っています。SwiftUIでもハイパフォーマンスに絵文字を描画する事ができています。

# RefreshControl

https://github.com/noppefoxwolf/RefreshControl

![](https://storage.googleapis.com/zenn-user-upload/ed8a962b77ef-20231211.gif)

高機能なUIRefreshControlのサブクラスです。
モダンなデザインでありつつ、サブクラスなのでUIRefreshControlと同じように扱えます。
mastodonではレスポンスが返ってくることが遅い事があるので、一定の時間が経過したらメッセージを表示するtimeover/timeout機能も付いています。

# ContinueControl

https://github.com/noppefoxwolf/ContinueControl

![](https://storage.googleapis.com/zenn-user-upload/93e30f48d7f0-20231211.gif)

下までスクロールした時に、トリガーするコントロールです。
Hapticフィードバックも実装していて、純正に近い動きをします。
一回画面の外に出ないと再トリガーされないセーフティ機構も付いています。

# MediaViewer

https://github.com/noppefoxwolf/MediaViewer

![](https://storage.googleapis.com/zenn-user-upload/d82676ba134b-20231211.gif)

動画や画像を表示できるプレビュービューアです。類似のライブラリでは画像だけ表示するものが多いですが、動画にも対応しておりシークバーなどの実装も標準で備わっています。

# AnimatedImage

https://github.com/noppefoxwolf/AnimatedImage

![](https://storage.googleapis.com/zenn-user-upload/34d680fbf204-20231211.gif)

GIF, APNG, WebPなどのアニメーション画像をハイパフォーマンスに描画するライブラリです。
この辺の仕組みは今度別の記事で紹介したい。

# Swinub

https://github.com/noppefoxwolf/Swinub

mastodonのAPIを叩くためのAPIライブラリです。
Request protocolに準拠したAPIの定義があります。
URLSessionと同じ感覚でasync awaitのリクエストする事ができます。
認証用のASAuthorizationSessionの実装も含まれています。

```swift
let authorization = ...
let request = GetV1TimelinesHome(authorization: authorization)
let (statuses, httpResponse) = try await URLSession.shared.response(request)
```

# TabBar

https://github.com/noppefoxwolf/TabBar

アイコンのみのタブバーなどを作れるUITabBarのサブクラスです。
比較的雑に作っています。使ってみて問題があったらPRください。

![](https://storage.googleapis.com/zenn-user-upload/74fb0d0093a1-20231211.png)

# SemanticVersioning

https://github.com/noppefoxwolf/SemanticVersioning

マストドンのサーバーバージョンなどをパースするためのセマンティックバージョニングのライブラリです。
内部的にSwiftのRegexを使って作っています。

# BuildAtPlugin

https://github.com/noppefoxwolf/BuildAtPlugin

アプリのビルドした時間を取得するプラグインです。Xcodeが時々古いビルドを実行するので、これを入れて早めに気が付けるようにしています。

# VideoEditor

https://github.com/noppefoxwolf/VideoEditor

カスタマイズできるUIVideoEditorControllerのクローン。
選択した範囲を表示時に渡せる

# DrawerPresentation

https://github.com/noppefoxwolf/DrawerPresentation

![](https://storage.googleapis.com/zenn-user-upload/33c92ac67e93-20240119.gif)

スワイプで左から出せるドロワーメニュー。
カスタムモーダルアニメーションとして実装されており、ViewControllerを汚染しない。

# Pager

https://github.com/noppefoxwolf/Pager

![](https://storage.googleapis.com/zenn-user-upload/924cc4c5e0d7-20240202.gif)

UICollectionViewベースのページコントローラ。
UIPageViewControllerに比べてカスタマイズしやすい

# RelativeDateFormat

https://github.com/noppefoxwolf/RelativeDateFormat

相対時間を1sや1mといったSNSのタイムラインで使う短いフォーマットにする。

# SwipePopInteraction

https://github.com/noppefoxwolf/SwipePopInteraction

全画面スワイプで画面を戻るやつ

# ConsoleKit

https://github.com/noppefoxwolf/ConsoleKit

OSLogをアプリ内で見るやつ

# MediaOptimizer

https://github.com/noppefoxwolf/MediaOptimizer

画像や動画を良い感じのサイズや容量に収めるやつ

# EventNotification

https://github.com/noppefoxwolf/EventNotification

型付きのNotificationCenter

# おわり

いかがでしたか？DAWNでは、mastodonをより自然に使えるように多くの工夫を凝らしています。
![](https://storage.googleapis.com/zenn-user-upload/a8be03cbe8fa-20231211.png)

ユーザーはもちろん、同じmastodonアプリを作る開発者も盛り上げることでmastodonの繁栄にも寄与出来ればと思っています。
ぜひ今回紹介したライブラリを使って、アプリを作ってみてください！Github starの方もお待ちしております！

https://apps.apple.com/jp/app/nightfox-dawn-for-mastodon/id1668645019