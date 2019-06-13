# WWDC報告会
## グラフィックス編

---

# noppe

きつねすきすきエンジニア
ソーシャルライブ「Pococha」

---

# Pococha

カメラから取得した映像にフィルタをかける箇所と、アイテムの再生部分にOpenGLESを利用
iOSDC18で解説しました。

フロントカメラから取得した映像にAR機能を使って装飾するデジタル化粧

---

# Agenda

- Metal
- RealityKit

---

# Metal

- ついにシミュレータでの実行が可能に！
- **family**
- shared memoryは再現実行になる
- シミュレータは全体でハードウェアアクセラレーションが有効になった
- MapKitのプレビューがスムーズに

---

# ARKit3

- SwiftStrike

---

# RealityKit

より写実的な表現が可能になった
ARKitは

---

# USDZプレビュー

レンダリングが変わったぽい、つるつるになった…。

# Xcode Debugging
熱問題の再現
ネットワークのコンディション再現




---

# ARKit

- People Occlusion
- Motion Capture

---

# People Occulustion

- 3Dオブジェクトを身体で遮れるようになった

---

```swift
let configuration = ARWorldTrackingConfiguration()
configuration.frameSemantics = .personSegmentation
session.run(configuration)
```

---

# Motion Capture

- 2次元および3次元のモーションキャプチャができるようになった
- A12 ~ 

---

```
let configuration = ARWorldTrackingConfiguration()
configuration.frameSemantics = .bodyDetection
session.run(configuration)
```

---

リグの名称が揃っていれば転送しただけでいい感じに動く？

---

# ARCoachingOverlayView

iPhoneをどうやって動かせばよいか教えるためのビューが追加！

```
coachingOverlay.session = sceneView.session
```

---

# RealityKit

---

# RealityKit

SceneKitの表現を拡張するフレームワーク

---





---