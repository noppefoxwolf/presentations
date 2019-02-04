footer: 🦊
slidenumbers: true

# SceneKitでふんわりした影を作る
## potatotips 58


---

# ライブ配信アプリPococha

![inline fit](pococha.jpeg)

https://medium.com/pococha-engineering

---

#[fit] noppe
## @noppefoxwolf

💻 Pococha[^0] iOSエンジニア
🦊 きつねかわいい
📱 iOSDCで描画周りの話をした
🛩 最近ARに興味あり

![right](profile.png)

[^0]:ライブ配信アプリ

---

# iOS12からusdzをサポート

usdz: AppleとPixerで共同開発した3Dファイルフォーマット

^ SceneKit使ってますか、AppleがARメガネ出したらUnityで開発とか出来ないと思うのでがんばりましょう

---

![fit center](qr.png)

---

# FileでプレビューやAR配置も可能

![right fit](IMG_2803.PNG)

---

# Fileのプレビューの影に注目⇨

![right fit](IMG_2801.PNG)

^ シェードとシャドーがありますけど、シャドーの方
^ すごい綺麗
^ 自作のモデルでも描画される

---

# WWDC2018でContact Shadowと表現[^1]

![inline center](wwdc_contact_shadow.png)

[^1]:https://developer.apple.com/videos/play/wwdc2018/603/?time=417

---

# Contact Shadow（接触影）とは

"接地感・重なり感を出すためのもの"[^2]

![right fit](contact_shadow_diff.gif)

[^2]:https://twitter.com/unrealenginejp/status/800973173814480896

---

# Contact Shadow使ってみたい！

---

# SceneKitで影をつけてみる

- SCNLightのcastsShadowをONにする
- directionalか、spotタイプを使う[^3]

[^3]:https://developer.apple.com/documentation/scenekit/scnlight/1523816-castsshadow

---

```swift
// オブジェクト
let scene = SCNScene(named: "stratocaster.scn")!

// ライト
let light = SCNLight()
light.type = .directional
light.castsShadow = true
let lightNode = SCNNode()
lightNode.light = light

// 床
let floor = SCNFloor()
...
```

---

SCNLightでははっきりした影になってしまう。

![right fit](IMG_2808.PNG)

---

一応ShdaowRadiusもあるが、ボカし方が雑

```swift
lightNode.light!.shadowRadius = 16
lightNode.light!.shadowSampleCount = 16
```

![right fit](IMG_2809.PNG)

---

ググっていると、ゲームの記事がヒット[^5]

![inline](ambient.png)

[^5]:https://game.watch.impress.co.jp/docs/series/3dcg/538525.html

---

[.autoscale: true]

# screen-space ambient occlusion

物体が近接して狭くなったところや部屋の隅などに、周囲の光（環境光）が遮られることによって影が現れる現象をアンビエント・オクルージョン（環境遮蔽/環境閉塞、英: ambient occlusion）と呼ぶ。SSAOは3D画面のレンダリング結果に後処理をかけるポストエフェクトの一種であり、擬似的なレンダリング結果に追加するものである。[^4]

[^4]:https://ja.wikipedia.org/wiki/SSAO

---

# SSAO

```swift
camera?.screenSpaceAmbientOcclusionIntensity = 5
camera?.screenSpaceAmbientOcclusionNormalThreshold = 0.1
camera?.screenSpaceAmbientOcclusionDepthThreshold = 0.08
camera?.screenSpaceAmbientOcclusionBias = 0.33
camera?.screenSpaceAmbientOcclusionRadius = 3.0
```

---

![](ssao.jpeg)

---

![inline center](ssaokana.jpeg)

接地面以外の箇所の影もある

---

# ふんわりした影は自前で描画しないとダメそう

---

# SCNTechnique

- マルチパスレンダリングのためのクラス
画面１回の更新の間に、異なるシーンを複数回レンダリングして合成した結果を表示する機能。
MetalやOpenGLESでシェーダを書く事が出来る。
入力にシーンの色情報や深度情報が使える

---

![inline center](technique.png)

---

# やってみた

カメラを二つ配置して、下からの入力を深度に変換してブラーをかける。

---

[^5]

![inline fit](mirror_passes.png)

[^5]:http://blog.simonrodriguez.fr/articles/26-08-2015_a_few_scntechnique_examples.html

^ 分かりやすい画像作っている方がいたので拾ってきました
^ これは水面に反射する飛行機を描画する例なんですけど
^ 一番左が下からのカメラで映した映像
^ それを水面っぽいエフェクトかけます、隣が上からのカメラ映像
^ それを平面と飛行機のデプスから手前にあるものだけを描画してこんな感じ

---

# 影だけ作ってみた

- よくみるとモアレ（縞模様）が…
- そもそもカメラ2台置くのは…
- シェーダ真面目に書こうとするとサクッと出来なそう

![right fit](IMG_2792.jpg)

---

# 代替案を探す

---

# gobo

SCNLightの影を自前の画像で描画する機能

影を発射するライト

リアルタイムで更新は出来ない

![right fit](IMG_2812.jpg)

^ なんとか影を作って、goboにセットすれば良さそう

---

# gobo

- SCNTechniqueで深度画像に変換

- SCNViewのsnapshotでUIImageを取得

- CIFilterでブラーをかける

- SCNLightのgoboに画像をセット

---

# 結果

![right fit](IMG_2802.PNG)

---

# 課題

- 影の濃淡などまだFileの表現に達していない

- SCNTechniqueで全て完結出来るかも

- shaderModifiersでライティングシェーダが弄れる

^ オブジェクト自体につく影のトゥーンシェーダとかやっている人いた

---

# ありがとうございました！
