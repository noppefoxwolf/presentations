slidenumbers: true

# google/mediapipe で始めるARアプリ開発

<!-- 
mediapipeって何？何ができるの？
もしかしてMLとかいうやつ？難しそう
デモ
他にもこんなことができます。
これからこんな解説をします。
・ビルドの仕方
・使ってみる
・ARKitとの連携
・できること、できないこと
ゴール
mediapipeとARKitを使ってアプリを作る
 -->

## レギュラートーク（20分）

### noppe

^ 今日はmediapipeを使ったARアプリの開発についてトークをします


---

# noppe

- DeNA
- vear
  ReplayKitでスマホから配信できるVTuberアプリ

![right fit](profile.png)

<!-- 私はnoppeという名前で、DeNAでライブ配信アプリのエンジニアをしていたり、個人でVTuber向けの自撮りアプリを開発しています。 -->

---

# mediapipe とは？

<!-- そもそもmediapipeとは何でしょうか -->

---

# github.com/google/mediapipe

ブロックのようにMLの処理を繋げてパイプライン（Graph）を構築するツール

- 手のトラッキングであれば
  "手のひらを見つける"→"指の関節を見つける"

![right](graph.png)

---

# github.com/google/mediapipe

繋げる処理（Culculator）は、実装済みの物が使える

---

# github.com/google/mediapipe

構築したGraphはフレームワークとしてビルドすることができる

→自分のアプリに組み込むことができる

---

# デモ

---

# 実装済みのGraph

これらの実装はすぐに使える

今日はこれを使う流れを解説

![right fit](solutions.png)

---

# アジェンダ

- フレームワークのビルド
- ARKitとの連携
- できる事・できない事

---

# フレームワークのビルド

---

# フレームワークのビルド

デモで紹介したハンドトラッカーをフレームワークとしてビルド
後半はこのフレームワークを使ってARKitと連携します

---

# フレームワークのビルド

ビルドツールを使ってビルドを行う

- bazelbuild/bazel

---

# フレームワークのビルド

Xcodeでもビルドができる[^tulsi]
- bazelbuild/tulsi

[^tulsi]:BuildPhaseScriptでbazelを叩くだけなので、必須ではない

<!-- bazel自体はmediapipe専用のツールというわけではなく、汎用的なビルドツール -->
<!-- bazelを実行するRunScriptを持つxcodeprojを生成する -->

---

# ビルドの流れ

- ObjCでコードを書く
- BUILDファイルに成果物の情報や依存性などを記述する
- bazelでbuildする
- ipaやframeworkが出来上がる

---

# ObjCでコードを書く

---

# ObjCでコードを書く

1. binarypbを読み込んでMPPGraphを作る
2. MPPGraphを開始する
3. MPPGraphに画像を送る
4. delegateで結果を受け取る

^ binarypbって何？

---

# binarypbを読み込んでMPPGraphを作る

```objc
NSURL* url = [NSURL ...@"hand_landmarks.binarypb"];

NSData* data = [NSData dataWithContentsOfURL:url options:0 error:nil];

mediapipe::CalculatorGraphConfig config;

config.ParseFromArray(data.bytes, data.length);

MPPGraph* graph = [[MPPGraph alloc] initWithGraphConfig:config];
```

---

# MPPGraphを開始する

Graph内で利用する各種コンポーネントの初期化が行われる

```objc
[graph startWithError: nil];
```

---

# MPPGraphに画像を送る

```objc
- (void)sendPixelBuffer:(CVPixelBufferRef)pixelBuffer {
    [self.mediapipeGraph sendPixelBuffer:pixelBuffer
                              intoStream:@"input_video"
                              packetType:MPPPacketTypePixelBuffer];
}
```

---

# delegateで結果を受け取る

```objc
- (void)mediapipeGraph:(MPPGraph*)graph
       didOutputPacket:(const ::mediapipe::Packet&)packet
            fromStream:(const std::string&)streamName
{
    const auto& timestamp = packet.Timestamp().Value();

    const auto& landmarks = packet.Get<::mediapipe::NormalizedLandmarkList>();
}
```

---

# NormalizedLandmarkListの構造

```
message NormalizedLandmarkList {
  repeated NormalizedLandmark landmark = 1;
}

message NormalizedLandmark {
  optional float x = 1;
  optional float y = 2;
  optional float z = 3;
  optional float visibility = 4;
}
```

---

# BUILDファイル書く

---

# BUILDファイルとは

bazelでビルドするファイルや依存関係を記述したファイル

---

```
objc_library(
    name = "HandTrackerLibrary",
    hdrs = ["HandTracker.h"],
    srcs = ["HandTracker.mm"],
    data = [
      hand_tracking:hand_tracking_mobile_gpu_binary_graph",
      ...
    ],
    deps = [
        "//mediapipe/objc:mediapipe_framework_ios",
        "//mediapipe/objc:mediapipe_input_sources_ios",
        "//mediapipe/graphs/hand_tracking:mobile_calculators",
        "//mediapipe/framework/formats:landmark_cc_proto",
    ],
    ),
)
```

---

# bazelでビルドする

```
$ bazel build mediapipe/iosdc:HandTracker
```

---

# frameworkが出来上がる

githubに置いておきました

https://github.com/noppefoxwolf/HandTracker

---

# ARKitとの連携

---

# ARKitとの連携

ARKitの仕様上出来ない事をmediapipeで補うことで、表現力を解放できる

- ARKit非対応アプリも対応させる
- AR空間上のオブジェクトを手で操作する
- 検出したオブジェクトの横にキャラクターを配置する
- 顔の骨格を補正しながら髪色を変える[^hair]

[^hair]:Hair Segmentationは現状iOS非対応ですが

---

# ARKitとの連携アプリ開発

こんなものを作ります

---

# 動画

---

# ARKit連携の流れ

- ARSessionDelegateを使ってcaptureImageを取り出す
- PixelFormatを変換
- Trackerへ送る
- Delegateで結果を受け取って何かする

---

# ARSessionDelegateを使ってcaptureImageを取り出す

ARKitでカメラから取り込まれた映像を取り出すことができます

```swift
// ARSessionDelegate
func session(_ session: ARSession, didUpdate frame: ARFrame) {
  let captureImage = frame.capturedImage
}
```

---

# PixelFormatを変換

pixelformatとは、画像データがどのように格納されているかを表している。

ARKitではYUV420形式
mediapipeはBGRAのみを受け取れる
→変換の必要がある

---

# BGRA

1ピクセル32bitで表現するフォーマット

B:FF G:FF R:FF A:FF -> 白

---

# YUV420

２枚のY, CbCrの組み合わせで１フレームを表現するフォーマット


---

# YUV420からBGRAへの変換

- vImage
- Metal Shader

GPUを使う分Metalの方が高速

---

# YUV420からBGRAへの変換

次の計算式で変換ができる

![画像]()

---

# BlueDress

YUV420からBGRAに高速コンバートするライブラリ

https://github.com/noppefoxwolf/BlueDress

---

# Trackerへ送る

```swift
let captureImage = frame.capturedImage
let bgraCaptureImage = try! converter.convertToBGRA(imageBuffer: captureImage)
handTracker.send(bgraCaptureImage)
```

---

# Delegateで結果を受け取って何かする

関節の位置はX,Y,Zで取れます…が、世界座標系では無く
X,Y: Screen座標系
Z: 手首からの奥行き
しか取れません。残念！

---

# Delegateで結果を受け取って何かする

今回はx,yの位置にEntityがあれば、isPressをtrueにする

```swift
func handTracker(_ handTracker: HandTracker!, didOutputLandmarks landmarks: [Landmark]!) {
  let indexFinderPosition = landmarks[8]
  let screenLocation: CGPoint = ...(indexFinderPosition)
  self.isPress = arView
    .entities(at: screenLocation)
    .contains(where: { $0.id == self.buttonEntity.id })
}
```

---

あとRealityKitに設定

![]()

---

# Delegateで結果を受け取って何かする

```swift
private func press() {
  self.scene.notifications.press.post()
  count += 1
  changeText("\(count)")
}
```

---

![]()

---

# できる事できない事

---

# HandTracker

世界座標系で取れるわけではない事に注意

各関節の回転も取れない

---

# Links

mediapipe

awesome mediapipe
