slidenumbers: true
autoscale: true

# ソーシャルライブサービスにおけるデジタル化粧の仕組みと実装

## noppe at DeNA

[.footer: iOSDC 2019/09/07 13:30~ Track A 30min.]

---

# noppe

- DeNA inc
- Pococha
- 💖🦊
- Github: noppefoxwolf

![right fit](profile.png)

---

# noppe

- 書籍

^ ここにwebdbとか

---

![fill](pococha.png)

---

# Pococha 

- **ソーシャルライブサービス**
- アイテムによる動画演出 ( iOSDC 2018 )
- デジタル化粧による映像補正　←　今日の話

---

# デジタル化粧

^ とはなんでしょうか

---

# デジタル化粧

- 映像を加工する事でリアルタイムに補正をかける技術

^ ここ画像欲しい

^ デジタル化粧という言葉に明確な定義がないので本トークでは、「映像を加工する事でリアルタイムに補正をかける技術」と定義します。

---

# デジタル化粧の利点

- 実際にメイクせずに撮影を開始することができる

- メイクのかかり具合を調整できる

- 現実では出来ないメイクが出来る

^ デジタル化粧の利点は〜
^ では、具体的にどのような機能が世の中にはあるでしょうか？

---

# デジタル化粧の種類

- コスプレ
- メイク
- 整形

<!-- パネル横に3枚 -->

^ 今日は大きく３つに分けてみました。
^ そして、今日はこの３つの実装方法を紹介します。
^ それぞれの実装をしていく前に共通する技術の選定をします。

---

# 共通する技術

- 顔認識
- 画像加工

---

# 顔認識技術の選定

・ CIDetector　・Vision
・ ARKit　・MLKit
・ OpenCV　・SenseMe
・ ByteDanceSDK

---

# CIDetector

- iOS 5.0+
- 10fps (iPhoneX)
- 鼻や目の位置は取れるが輪郭は取れない

---

# Vision.framework

- iOS 11.0+
- 10fps (iPhone X)
- 各部位の輪郭と位置が取れる

---

# MLKit

- Firebase
- 無料
- 15fps (iPhone X)
- 132 points
- 各部位の輪郭と位置が取れる

^ https://firebase.google.com/docs/ml-kit/detect-faces?hl=ja
^ https://firebase.google.com/docs/ml-kit/face-detection-concepts

---

# SenseMe

- SenseTime Group Ltd
- 有料
- **Pocochaで利用中**
- 60fps
- 106 point
- **美白や整形なども出来る全部乗せ**

^ https://dena.com/jp/press/004432

---

# ARKit

- iOS11+ (Require True depth camera)
- 30, 60fps
- 1220 points
- 三次元空間の特徴点しか取れない

^ シミュレータで使えない

---

![fit](iphone-x-top.png)

---

# 比較

|名称|価格|fps|landmark|
|---|---|---|---|
|CIDetector|**無料**|10|△|
|Vision|**無料**|10|⭕|
|MLKit|**無料**|15|⭕|
|SenseMe|有料|**60**|⭕|
|ARKit|**無料**|**60**|×|

---

# ???

- 二次元座標を提供
- landmarkを提供

---

# 共通する技術

- 顔認識 - ARKit
- 画像加工 - CoreImage

^ CoreImageの採用理由は、複数のフィルタを重ねがけしても最適化してくれるから。多分パフォーマンスはあんま良くない。

---

# コスプレ

---

# コスプレ

- 現実にないパーツをオーバーレイする機能

<!-- ビデオ -->

---

# コスプレ機能に必要な技術

- 顔認識
- 合成

---

# 実装

- pngからCIImageを生成
- CISourceOverCompositingで合成

^ 本当は角度も入れたい

---

# 応用例

アニメーションさせたり

^ アニメーションなど

---

# メイク

---

# メイク

ここでは肌質を良くするフィルタを描いてみます。

---

# メイク機能に必要な技術



---

# 処理の過程

ステッカーで実装することも出来ます（チークなど）
Photoshopの加工例
<!-- https://liginc.co.jp/web/design/photoshop/129524 -->
high pass skin smoothingが有名、これを解説します。

---

# 解説

ガウシアンブラーかける
ハイパスかける
//https://qiita.com/secang0/items/f3a3ff629988dc660d87#ハイパスフィルター
//https://askjapan.me/q/photoshop-35033779880

---

# 実装

---

# 整形

---

# 整形

- 歪ませる

---

# 整形機能に必要な技術

- Warp Shader

---

# ???

- WarpGeometryをCIFIlterとして提供

---

# プロダクトへの応用難易度

ソーシャルライブにおけるデジタル化粧は、自然さや外れないことも重要
その瞬間に映像は配信されるので求められる品質は非常に高い
