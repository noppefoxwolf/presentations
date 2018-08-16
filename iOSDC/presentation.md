footer: 🦊 @noppefoxwolf, 2018
slidenumbers: true

> ライブ配信アプリのアイテム再生をMetalで実装する事になった話
-- iOSDC Japan Track B 2018/09/02 11:20〜

^ ライブ配信アプリのアイテム再生をMetalで実装する事になった話というタイトルで発表します。
^ トークの目的は、実際のユースケースを元に画像の編集・表示の領域に関して興味を持っていただくこと
^ Metalを仕事で使っている人はいますか
^ 多くの人がMetal

---

#[fit] noppe

📱 iOSアプリ開発8年目
🦊 きつね好き
🏢 株式会社ディー・エヌ・エー

![right](IMG_0726.PNG)

^ こんにちは、株式会社ディー・エヌ・エーのnoppeです

<!-- # 本トークについて
自分はMetal初心者
自分はOpenGLES初心者
まだまだ知らないことが多いです、分からないところは逆に教えて
OpenGLやMetalを学ぶ為に手頃な例を見つけたので紹介
ライブ配信自体についてはほとんどしません、（一応タイトルに書いてあるしやらないとダメかも
実際のプロダクトと仕様が異なる箇所がある -->

---

今日の話
・Pocochaの紹介
・透過情報を持った動画の再生手法
・UIKit/GLKit/MetalKitの描画
・本当にMetalで実装しないといけないのか
・Metalのデバッグ手法
・まとめ

---

Pocochaの紹介

---

配信サービス
//画像

^ どんなサービス
^ いつリリース

---

特徴
・アイテムで盛り上げる

---

# 透過情報を持った動画の再生手法

---

アイテムの再生を見てみましょう
//動画
^ アイテムが採用された経緯、サービス市場とか

---

どういったものが再生されているか
750 × 1334 60fps rgba nosound
^ デバイス環境

---

再生されるリソース作成の流れ
・アウトソーシング
・ガイドライン

---

どうやって再生する？

---

直接AVPlayerに投げる
> movはサポートしているが、透過はサポートしてない

---

UIImageView.animate
//詳細

---

`ffmpeg -i M_sea30fps.mov M_sea30fps/output_%04d.png`
du -h
288M    ./M_sea60fps

---

実行
開始命令から開始まで非常に遅い
メモリ1GB程度占有、これなんでだ
^ 極端なことをするのは無駄ではない、勉強になった
^ パフォーマンスを意識する上で気にかけることができる

---

二つの問題
・容量
・再生パフォーマンス

^ メモリを圧迫することでCPUやバッテリーに影響が
^ 配信もしているのでそんなに余裕はない

---

・8fpsくらいに落として運用

^ 半年くらい
^ 最初はそんなに派手なエフェクトではなかったので大丈夫だった。
^ 半年後にアイテムの表現をリッチにすることになった

---

まずは容量
movファイル：493MB
連番PNG:302MB

^容量が多いとなぜ困るか
^アプリの起動中に取ってくる

---

圧縮する必要がある
そこで守らないといけない点
・透過情報を持っている
・fpsを落とさない
・サイズを変更しない

^ 透過はしないと真っ暗になる
^ 下二つはクオリティの劣化に直接通じるから

---

一つは動画フォーマット
一つはアニメーションをサポートした画像フォーマット

---

MOV
Webm VP8 with alpha
https://www.reddit.com/r/explainlikeimfive/comments/2p4a6c/eli5_the_difference_between_html5_video_webm_and/
GIF
APNG
WEBP

残念ながらmp4は透過に対応していない

---

- WEBM
https://github.com/brion/OGVKit

透過対応してなかったりする、あと不安定
ハードウェアデコーダとソフトウェアデコードの観点
h265の圧縮効率

---

- PNG/JPG
ネイティブサポート

---

- GIF
https://github.com/kirualex/SwiftyGif
GIFを1フレームごとにUIImageに変換して、独自のループの中でUIImageView.imageを差し替えている
一般的な非対応フォーマットの対応の仕方
普通はUIImageViewを使うので使い勝手が良い

---

- APNG
https://github.com/onevcat/APNGKit
libpng
APNGImageView: UIView
一度UIImageに変換してからCGImageをlayer.contentsに設定
これはUIImageViewと同じ仕組み

---

- WEBP
libWEBP

---

- MP4
h264
透過情報持てない
デフォで対応

---

- MOV
透過情報が持てる

---

表
|iOSで再生できるか|圧縮率|透過|

^計測
^なかなか良さげなフォーマットがない

---

昔ゲームを作っていた時
透過PNGが使えなかった当時、jpgでalpha maskして透過していた。
この手法は今回使えそう。

---

非透過のビデオA・非透過のビデオB
毎フレーム透過合成していく、それを描画
^ 容量比較

---

// ======================================================

---

UIKit/GLKit/MetalKitの描画

^ 先ほどの毎フレーム合成した透過画像を表示したい。
^ ここでは、どうやって、何に表示するのかの話

---

透過の方法

・CIFilterを利用する

^CIFilterの説明
^フィルタがいくつかある
^自分で書くこともできる
^内部的にMetal/OpenGLESを切り替えてくれる

---

表示の方法
・UIImageViewに表示する

---

これで実装して見た
[動画]

---

この後の流れ
再生できてない
fpsが取れないと思う

---

どこが遅いのか
CIFilterの生成

---

CIFilterのoutputが遅いということは、CGImageがどこかで作られている？（デモとしてCGImage作って適用でもいいかも）
OpenGL使ってみた
^ 理由は？
^ シェーダー上で合成を行えば、その結果を表示すればいいだけなので効率的かもしれないと思った.
^ CIFilterは連続して利用されるときに辛い？
^ そもそもビデオのpixelBufferをCIImageに入れて処理するタイミングでCGImageへの変換が走っているかも
^ CIFilter遅いって言われていた（2013ごろ
^ この時点でMetalの選択肢もあったが、iPhone5cやiPad 3rdをアプリがサポートしていた
^ CPU GPU間の転送は非常にコストが大きい。
^ wwdcで効率的な事言ってたけどiOS10だとまだ最適化されてないのかも


---

とりあえず実際に実装してみた
OpenGLESはUIKitでアプリを開発するエンジニアには馴染みがないかもしれない。
僕もなかった。初めて触る、早い印象。高い互換性
そして、ハローワールドが難しい。
GPUImageでも利用されている。
昔からある、
OpenGLESは簡単に言えば、渡された画像をどのように表示するか＆表示を担う。
これはCIFilterとUIImageViewの両方

GLKitを利用すると簡単に作れる
GLKViewやGLKViewController
OpenGLESで

透過する際のシェーダーのコード

実際に実装して表示してみました。
早い？遅い？
早い！
^ なんでだろう
^ OpenGL/Metalの分岐が重い？
^ リアルタイム処理には最適化されていない
^ 中間バッファの生成コストがある
^ 効率化の為にキャッシュしているから遅い

Instrumentsでみてみましょう。
GPU Driverがいい。
Xcode7をダウンロードしよう。

---

OpenGLESがdeplicatedになったのでMetal使って行きましょう
toolsetでシェーダー書ける
OpenGLESがなんとなく分かれば、Metalはもっとわかりやすい。
なぜなら、Metalはリッチなinterfaceだから

---

Metalを使う上でまだ辛いところ
iOS9/10などのMetal非対応機種を含むOSではOpenGLESと一緒に実装が必要
→デバッグ工数が増える
シミュレータビルドができない

いいところ
OpenGLESよりも効率的にGPUへデータを転送できる
高機能なデバッガーが利用できる
シェーダを書くときにコンパイラが走る
圧倒的に分かりやすいインターフェイス（もはや低レイヤーではない）

---

結局Metalで実装する必要はあるの？

```
UIImage(ciimage:)
```
使えば不要かも

適切にUIImageを利用することで不要になる
CIFilterで十分かもしれない。
CIFilterは早いぞ
でもさ、Metalを知っていることで、書くことで
低いレイヤーを使うことの利点
Metalは機械学習で使えるかも

---

----------------------------------

# サービスの紹介

ライブ配信知ってますか
ライブ配信サービスの最近の動向
配信するだけではなく、アイテムを使って配信を盛り上げる流れに
アイテムの派手さや楽しさが差別要素に
DeNAで自分はPocochaというサービスをやっている
アイテムとはどんなものなのか

---

具体的にイメージしてもらうために動画
Pocochaのアイテムを見て欲しい
[動画]
これをどのように実装したかを順を追って解説

---

このように、アニメーションを表示させる

# 要件の確認
どんな手法があるか
・動画プレイヤーのレイヤーを重ねる
・描画
・映像のエンコードに混ぜちゃうとか
・配信をしながらなので、低燃費に動作する必要がある

アイテム再生＝画面全体にアニメーションを表示する
//動画の仕様
750 × 1334 60fps
実際はもう少し低いが比較のためにこのスペック

一番最初に実装したのはUIImageViewのanimateImages
ffmpeg -i M_sea30fps.mov M_sea30fps/output_%04d.png

du -h
288M    ./M_sea60fps

animateImagesが悪い？（ドキュメントみる
movを連番pngに変換します
再生
[動画]
ダメでした。
animateImagesのタイミングでメモリが確保される？
//始まるまで遅い
    //メモリ使用量とfps
    //シミュレータだと意外と動く...
    //そもそもシーケンスの容量


//パフォーマンス測定
描画周りのパフォーマンス計測は非常に難しい
Instrumentなどがあるが…
目で見てやるのが良い
実際の環境で行うのが良い
古い端末、古いOSでやろう
今回は5s
最初はこうしていた
こういう実装のアプリもあるんじゃないでしょうか

次に毎フレームimageを切り替えていく
これはどうかな

ここまでで二つの問題
・容量の問題
・描画の問題

# 容量の問題
圧縮する必要がある。
アニメーションする画像に最適なフォーマット=動画
動画から毎フレーム画像を取り出せば、サイズは軽いままバンドルできる
GIF/APNG/WEBP/MP4/MOV
透過できるか、仕組み、公式に対応しているか、デコード負荷、容量、表現力

- PNG/JPG
ネイティブサポート

- GIF
https://github.com/kirualex/SwiftyGif
GIFを1フレームごとにUIImageに変換して、独自のループの中でUIImageView.imageを差し替えている
一般的な非対応フォーマットの対応の仕方
普通はUIImageViewを使うので使い勝手が良い

- APNG
https://github.com/onevcat/APNGKit
libpng
APNGImageView: UIView
一度UIImageに変換してからCGImageをlayer.contentsに設定
これはUIImageViewと同じ仕組み

- WEBP
libWEBP

- MP4
h264
透過情報持てない
デフォで対応

- MOV
透過情報が持てる

対応しているものも対応していないものも基本は同じ
ファイルをデコード→ピクセル単位の色情報→描画
デコード処理はCPUで行われる
https://developer.apple.com/videos/play/wwdc2018/219/
https://github.com/koher/EasyImagy
容量とトレードオフにデコード
drawinrect使うと最適化の恩恵が受けられない

# iOSでは再生できない話
movが一番良さそう。
再生してみる、iOSではできない。

透過出来るのが良さそうだけど…
そもそもデコードは毎フレーム画像作っている
容量と画質のバランスが良いものを選んで後から透過すればいい
どうすれば透過出来るのか
今回はmp4を選んだ
・デコーダが公式提供されている


# 透過動画の再生手法の紹介
alpha maskを行う CIFilter
二つのmp4をデコードしながらマスク
デフォルトでFilterがある

UIImageView.imageへ描画

MP4 -> SampleBuffer -> CIImage -> CIFilter -> UIImage -> 描画（UIImageView）
重い
オーバーヘッドが大きい
CIImageはレシピのようなものでイメージでは無い
レンダリングのタイミングで初めて処理が走る
CIFilterのoutputを待ってからになってしまう
CIIMahgeは実態を持たない、UIImageViewでレンダリングされるタイミングでGPUによって処理される

MP4 -> SampleBuffer -> CIImage -> CIFilter -> UIImage -> 描画（EAGLView）
変わらない？
シェーダーとは
UIImageViewは十分に高速、OpenGLESを直接使う意味は？
シェーダーを使うことに意味がある

CIFilterはoutputImageを受け取って、UIImageViewへ渡す
GPU->CPU->GPU
メモリが共存しているから良い？OpenGLESは共存していない。
シェーダーならGPUから帰ってこない

MP4 -> SampleBuffer -> CIImage -> シェーダーで描画（EAGLView）
早くなった！これで良いじゃん！
CIFilter使うならメタル非対応機種のパフォーマンスも確認しておくべき
Kitsunebi

OpenGLES deplicated!!

MP4 -> SampleBuffer -> CIImage -> シェーダーで描画（MTLView）
OpenGLESのシェーダから書き直す
早くなった、大きいテクスチャ使えるようになった。
オーバーヘッドが少ないらしい
Kitsunebi_Metal

シミュレータビルド出来ないので注意
対応OSによっては辛い

これはシェーダーを使ったMetalの良いサンプルになるかもしれない

# まだ効率化できる箇所はあります
AVAssetReader -> 低レイヤーで実装してみよう
オレオレAVPlayer
俺コン、技術書展で発表

---
めも

DeNAのライブ配信アプリPocochaで実装した画面全体に再生されるエフェクトの実装の話をします。
iOSでは再生出来ない透過動画の再生を行う実装や、それらの実装の中で利用した巨大なシーケンス画像群の再生に最適なアーキテクチャをAPNG/WEBPなどのフォーマットやUIImageView/OpenGLES/Metalなどのパフォーマンス比較から読み解きます。

70枚前後にしたい


CPU/GPUのメモリは同じ場所にあるが、OpenGLESでは共有されていない
http://dsas.blog.klab.org/archives/52168462.html

https://developer.apple.com/documentation/metal/fundamental_lessons/cpu_and_gpu_synchronization

60fpsの大きめのやつ用意出来るか

Metalファミリー

mov -> mp4 alpha
ffmpeg -i sample.mov -vf alphaextract,format=yuv420p output.mov

mov -> 連番png
OpenGLよりもMetalのが簡単

PyCoreImage
CoreImage Kernel langはdeplicated
