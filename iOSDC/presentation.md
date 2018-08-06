footer: 🦊 @noppefoxwolf, 2018
slidenumbers: true

> ライブ配信アプリのアイテム再生をMetalで実装する事になった話
-- iOSDC Track B 2018/09/02 11:20〜

---

DeNAのライブ配信アプリPocochaで実装した画面全体に再生されるエフェクトの実装の話をします。
iOSでは再生出来ない透過動画の再生を行う実装や、それらの実装の中で利用した巨大なシーケンス画像群の再生に最適なアーキテクチャをAPNG/WEBPなどのフォーマットやUIImageView/OpenGLES/Metalなどのパフォーマンス比較から読み解きます。

70枚前後にしたい

# 自己紹介
# 本トークについて
# サービスの紹介
# 要件の確認
# 透過動画の再生手法の紹介
## iOSでは再生できない話
### 透過に対応しているフォーマットとライブラリの仕組み

コラム
```
https://github.com/airbnb/lottie-ios
```

### デコードパフォーマンス
# 各種フォーマットの検証
## UIImage+UIImageView
## CIImage+OpenGL
## PixelBuffer+Metal
# まとめ

---

動画の方でメインスレッド使っている

