



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
