footer: 🦊 @noppefoxwolf, 2018
slidenumbers: true

> ライブ配信アプリのアイテム再生をMetalで実装する事になった話
-- iOSDC Track B 2018/09/02 11:20〜

---

#[fit] noppe

📱 iOSアプリ開発8年目
🦊 きつね好き
👨🏻‍💻 株式会社ディー・エヌ・エー


![right](IMG_0726.PNG)

---

# 本トークについて
自分はMetal初心者
自分はOpenGLES初心者
学ぶ為に手頃な例を見つけたので紹介

# サービスの紹介
ライブ配信知ってますか
ライブ配信サービスの最近の動向
配信するだけではなく、アイテムを使って配信を盛り上げる流れに
アイテムの派手さや楽しさが差別要素に
DeNAで自分はPocochaというサービスをやっている
Pocochaのアイテムを見て欲しい
[動画]
これをどのように実装したかを順を追って解説

# 要件の確認
アイテム再生＝画面全体にアニメーションを表示する
//動画の仕様
//lottieフレとく？
一番最初に実装したのはUIImageViewのanimateImages
movを連番pngに変換します
再生
[動画]
ダメでした。
animateImagesのタイミングでメモリが確保される？

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

# iOSでは再生できない話
movが一番良さそう。
再生してみる、iOSではできない。

透過できないとなると、MP4の方が良さそう。
どうすれば透過出来るのか

# 透過動画の再生手法の紹介
alpha maskを行う CIFilter
二つのmp4をデコードしながらマスク

UIImageView.imageへ描画

MP4 -> SampleBuffer -> CIImage -> CIFilter -> UIImage -> 描画（UIImageView）
重い
オーバーヘッドが大きい
CIImageはレシピのようなものでイメージでは無い
レンダリングのタイミングで初めて処理が走る
CIFilterのoutputを待ってからになってしまう

MP4 -> SampleBuffer -> CIImage -> CIFilter -> UIImage -> 描画（EAGLView）
変わらない？

MP4 -> SampleBuffer -> CIImage -> シェーダーで描画（EAGLView）
早くなった！これで良いじゃん！
Kitsunebi

OpenGLES deplicated

MP4 -> SampleBuffer -> CIImage -> シェーダーで描画（MTLView）
OpenGLESのシェーダから書き直す
早くなった、大きいテクスチャ使えるようになった。
オーバーヘッドが少ないらしい
Kitsunebi_Metal

シミュレータビルド出来ないので注意

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