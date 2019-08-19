slidenumbers: true
autoscale: true

# ソーシャルライブサービスにおけるデジタル化粧の仕組みと実装

## noppe at DeNA

[.footer: iOSDC 2019/09/07 13:30~ Track A 30min.]

---

# noppe

- DeNA inc
- **Pococha**
- 💖🦊
- Github: noppefoxwolf

![right fill](profile.png)

---

![fill](pococha.png)

---

# Pococha

- **ソーシャルライブサービス**
- アイテムによる動画演出 ( iOSDC 2018 )
- デジタル化粧による映像補正　←　今日の話

^ 生放送を通してコミュニケーションをする

---

# デジタル化粧

^ さて、デジタル化粧とはなんでしょうか

---

# デジタル化粧

- 映像を加工する事でリアルタイムに補正をかける技術

- 主にセルフィーアプリや、ライブアプリで採用されることが多い

![right fit autoplay](preview.mov)

^ デジタル化粧という言葉に明確な定義がないので本トークでは、「映像を加工する事でリアルタイムに補正をかける技術」と定義します。
^ セルフィーアプリや、ライブアプリで採用されることが多いので見たことがある方も多いのでは無いでしょうか？

---

# デジタル化粧の利点

- 実際にメイクせずに撮影を開始することができる

- メイクのかかり具合を調整できる

- 現実では出来ないメイクが出来る

^ デジタル化粧にはどんな利点があるでしょうか
^ では、具体的にどのような機能が世の中にはあるでしょうか？

---

# デジタル化粧の機能種別

- コスプレ
- メイク
- 整形

^ 今日は大きく３つに分けてみました。
^ そして、今日はこの３つの実装方法を紹介します。
^ それぞれの実装をしていく前に共通する技術の選定をします。

---

# 実装に必要な技術

- 顔認識
- シェーディング

^ これらは、顔認識とシェーダーによる処理によって実現できます。
^ そこで、まずはiOSにおける顔認識をどのように行うかを決めましょう。

---

# 顔認識技術の選定

・ CIDetector　・Vision
・ ARKit　・MLKit ・SenseMe ...etc

^ iOSでは、標準でいくつかの顔認識をすることができるフレームワークがあります。
^ また、サードパーティのライブラリも存在します。
^ 今回調査したフレームワークを比較してみましょう。

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
- 60fps
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

![inline](AR2DFaceDetector.png)

^ 使いやすいようにするライブラリを作りました

---

# noppefoxwolf/AR2DFaceDetector

- ジオメトリの二次元座標を提供
- ジオメトリの頂点から擬似landmarkを提供

---

# シェーディング

**CoreImage.framework**

Metal Shader Languageを使ってフィルタが書けるフレームワーク
標準フィルタも充実している

---

# 早速実装をしていきましょう！

---

# 1.コスプレ

---

# コスプレ

- スタンプ画像をオーバーレイする機能

<!-- ビデオ -->

---

<!-- 図の画像欲しい -->

^ 映像と位置を調整したスタンプ画像を合成する

---

# 実装

[.code-highlight: 2, 3, 4-5]

```
let stickerImage = CIImage()
let captureImage = frame.captureImage

let filter = CIFilter.sourceOverCompositing()
filter.inputImage = stickerImage
filter.backgroundImage = captureImage
let outputImage = filter.outputImage
```

---

# 応用例

アニメーションさせたり

^ アニメーションなど

---

# 2.メイク

---

# メイク

- 肌質を良くするフィルタを描いてみましょう
- Photoshopのチュートリアルを探すのがオススメ
- https://www.creativebloq.com/tutorial/high-pass-skin-smoothing-photoshop-812591
- https://retamame.com/high-pass-skin-retouch

---

# 処理の過程

- ハイパスフィルタを階調反転したものをマスクでオーバーレイ合成する

---

# 解説

ハイパスフィルタ・高周波だけの画像になる（大きく色が変化する箇所）
階調反転：ネガポジにする
マスク：マスク
オーバーレイ：http://www.cg-ya.net/2dcg/aboutimage/composite-is-math/
スクリーンと乗算を出しわける


ハイパスでエッジ強調、反転でエッジ部分が白に
オーバーレイでエッジ部分にスクリーン効果があたり、明るくなる



打ち消すようになる？

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
