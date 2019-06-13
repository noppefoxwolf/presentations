# ソーシャルライブから見たWWDC
### iOS de KANPAI !【WWDC 2019 報告会】

[.footer: DeNAは、本イベントの内容、並びにお客様が本イベントを通じて入手した情報等について、その完全性、正確性、確実性、有用性等につき、いかなる責任も負わないものとします。]

---

# noppe

きつねすきすきエンジニア
ソーシャルライブ「Pococha」

---

# Pococha

- 誰でも気軽にライブ配信出来るサービス

---

# Pocochaで使われている技術

---

# GPUレンダリング

- カメラのフィルタやアイテムの再生に利用

- iOSDC18でアイテム再生の話をしました

---

# AR

- 顔の輪郭補正や肌質の変更

- iOSDC19でCfP応募しました

---

# 今日の内容

- GPU周りの更新
- AR周りの更新

---

# GPU

---

# GPU

- 今年もOpenGLESがdeprecatedと念押し
- 分かってるけど、シミュレータでMetalは動かないんじゃ…

---

# Metalのシミュレータ対応！

---

# Metalのシミュレータ対応

- macOS 10.15, Xcode11 ~
- MTLGPUFamilyApple2相当のGPUとして実行される
- GPUアクセラレーションが効くようになった

^ UIKitとかMapKitとかもパフォーマンス向上している

---

# MTLGPUFamilyApple2

- Apple A8 GPU（iPhone 6）相当の機能が使える
- Metal3からより抽象的なfamily表現になった（以前はiOSやtvOSごとにfamilyがあった

[.footer: https://developer.apple.com/metal/Metal-Feature-Set-Tables.pdf]

---

# Metal on Simuratorの注意点

- Texture Storege

iOSのMetalはCPUとGPUのメモリを共有するが、Macは出来ない
シミュレータの時はStorageModeをprivateにする必要がある。

---

![](shared_memory.png)

---

# Metal on Simuratorの注意点

```swift
#if targetEnvironment(simulator)
textureDescriptor.storageMode = .private
#else
textureDescriptor.storageMode = .shared
#endif
```

メモリを共有したい場合は、自前でコピーする必要あり

[.footer: https://developer.apple.com/documentation/metal/developing_metal_apps_that_run_in_simulator]

---

# ARKit3

---

- SwiftStrike

//SwiftStrikeの動画貼る

---

# ARKit 3

- People Occlusion
- Motion Capture

---

# People Occlusion

A12 ~

---



---

# RealityKit

より写実的な表現が可能になった
ARKitは

---

# USDZプレビュー

レンダリングが変わったぽい、つるつるになった…。