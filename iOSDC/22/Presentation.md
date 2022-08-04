slidenumbers: true

^ こんにちは、noppeです。株式会社ディー・エヌ・エーでiOSアプリエンジニアをしています。
また、個人ではEditormodeというドット絵向けのデジタルイラストレーションアプリを開発しています。
^ このアプリはCoreGraphicsとUIKitで作られています。
^ デジタルイラストレーションのアプリは、一般的にメモリ上にキャンバスのデータを展開し、それを編集する作業を繰り返します。
^ CoreGraphicsは、画像データをメモリに展開・編集するAPIを提供しています。iOS2.0から存在する歴史の長いフレームワークですが一方で当初から非常にシンプルで使いやすいインターフェイスが提供されています。
^ 今日はこのようなドット絵を描くためのアプリを、CoreGraphicsのAPIでどのように実現しているのかを紹介します。

---

1. ドット絵とは
2. シンプルなドット絵エディタを作る
3. CoreGraphicsの拡張
4. パフォーマンスの改善

^ まずは、ドット絵についての歴史やトレンドを確認してこれから扱うドット絵とはどんなものなのかを理解します。
^ 続いて、実際にCoreGraphicsとUIKitを使ってシンプルなドット絵お絵描きアプリを開発して、お絵描きアプリのプロセスやCoreGraphicsのベーシックな使い方を説明します。
^ その後、CoreGraphicsに存在しないAPIやよりドット絵を扱うアプリとしての完成度を上げるための方法を学びます。
^ 最後にMetalやCoreImageを使って、ドット絵アプリのパフォーマンスを向上させるコツについてお話しします。
^ それでは、ドット絵について見ていきましょう

---

# ドット絵とは

![](wwdc.jpeg)

^ 最近ドット絵が話題になった例として、今年のWWDCがあります。

---

![](wwdc.jpeg)

^ 今年はモノクロームピクセルアートチャレンジが開催されて、現代のアプリアイコンを白と黒の２色のアイコンに描き直すというチャレンジが開催されました。
^ これらはWWDCのデイリーダイジェストで見ることが出来る作品です。
^ 薄い色を白と黒のチェック模様で再現したり、重要で無い要素を省いたりと、有限なリソースの中で最大限表現するための工夫が散りばめられています。
^ こういったいくつかのドット絵の工夫をツールとして提供することも、ドット絵専用アプリの価値と言えるでしょう。

---

![center fit](moof.jpg)

^ ドット絵は、このような小さな解像度の中で絵を描く表現方法です。
^ 描画に割けるメモリが小さいコンピューターや解像度の小さいゲーム機などで2000年台までに広く使われていました。
^ デバイスの進化とともに、ドット絵は使われる色が増えたり、細かくなっていきます。
^ 現代で使われる画像のほとんどはベクターや写真といった画像が一般的になり、手作業で描かれたドット絵はアートの側面で使われることが多くなりました。
^ このように、ドット絵はデバイスのスペックに合わせて徐々に姿を変えたこともあり、どれほど小さければドット絵なのか定義が難しい表現方法でもあります。
^ 解像度の制約の強い環境ほど、自然にドット絵らしく見えるため、ドット絵を扱うアプリは、この制約を再実装し再現しているのも面白いところです。
^ Editormodeのようなドット絵専用のアプリの意義とは、こういった制約を付けた環境を提供して、ユーザーが自然にドット絵をかけるような環境を用意することにあると考えています。

---

```swift
imageView.contentMode = .center
imageView.image = UIImage(named: "watch")
```

![right fit](scale00.png)

---

```swift
imageView.contentMode = .scaleAspectFit
imageView.image = UIImage(named: "watch")
```

![right fit](scale01.png)

---

```swift
imageView.contentMode = .scaleAspectFit
imageView.layer.magnificationFilter = .nearest
imageView.image = UIImage(named: "watch")
```

```swift
// SwiftUI
Image(...).interpolation(.none)
```

![right fit](scale02.png)


^ 解像度の低いデバイスでドット絵を描画するには、メモリ内にあるドット絵をそのまま画面に描画すれば良いです。
^ しかし、現代のような高い解像度のデバイスではユーザーインターフェイスに合わせて拡大して表示する必要があります。
^ UIImageViewはcontentModeによって自身のビューサイズに拡大して描画をしてくれますが、同時に画像の補完も行なってしまいます。
^ 拡大時の補完のアルゴリズムはCALayerのmagnificationFilterが担っており、これをnearestにすることでドット絵をクッキリと描画することができます。
^ SwiftUIではinterpolationをnoneにすることで同じ結果を得ることができます。
間違っても自分で画像をリサイズしないようにしましょう。

---

# シンプルなドット絵エディタを作る

![fit](simple-workflow.png)

---

![fit](simple-workflow.png)

^ では、シンプルなアプリの開発に移りましょう。
^ ドット絵を描くには、ただ描画するだけでは成り立ちません。
^ タップした位置を塗りつぶし、それを描画するには仮想的なキャンバスが必要になります。
^ ここではキャンバスにあたるCGContextを紹介します。

---

```swift
let imageView = UIImageView()
let tapGesture = UITapGestureRecognizer()
let context = CGContext()

func setup() {

	imageView.addGesture(tapGesture) // 1

	tapGesture.onTap = { point in
		context.fill(point) // 2
		imageView.image = context.makeImage() // 3
	}
}
```

^ 疑似的なUIKitのコードにすると次のようになります。
^ まずは、ImageViewにタップジェスチャーを追加します。
^ 次にタップのハンドラで、contextにタップされた位置のピクセルを塗りつぶすことを要求します。
^ 最後にcontextから画像を取り出してImageViewに描画します。

---

![](simple-app-preview.mov)

^ このようにCGContextを使うことで、簡単に画像を操作することができます。

---

```swift
let context = CGContext(
    data: nil,
    width: 16,
    height: 16,
    bitsPerComponent: 8,
    bytesPerRow: 1 * 16,
    space: CGColorSpaceCreateDeviceGray(),
    bitmapInfo: CGImageAlphaInfo.none.rawValue
)
```

^ 先ほどは疑似的なコードで省略しましたが、実際には次のようにしてCGContextを生成します。
^ dataは、CGContextが扱う画像のメモリ領域です。nilを与えると自動で生成されるためnilを与えています。
^ width, heightは画像のサイズです。

---

![right](learn-bits-per-component)

^ bitsPerComponentは、一つの色が何階調なのかを指定します。
^ 今回は256階調のグレースケールにするので、8ビットを指定します。
^ bytesPerRowは、画像の横一列が何バイトになるのかを指定します。
^ 今回は１ピクセルが１バイトになるので、横のピクセル分16をかけて、1x16で16を指定します。
^ spaceは色空間の指定です。グレースケールなのでCGColorSpaceCreateDeviceGrayを指定します。
^ bitmapInfoには、アルファの位置やバイトオーダーなどを指定します。今回は透過度は無いのでnoneを指定します。

---

// グレースケールが16x16に敷き詰められてる画像

^ これで256色の色が使えるCGContextを作ることができました。
^ フルカラーのCGContextが使いたい場合は、次のように指定します。

---

```swift
CGContext(
    data: nil,
    width: 16,
    height: 16,
    bitsPerComponent: 8,
    bytesPerRow: 4 * 16,
    space: CGColorSpaceCreateDeviceRGB(),
    bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue
)
```

^ フルカラーの場合、１ピクセルのカラーはRGBAの４つのコンポーネントで構成されます。
^ そのため、１ピクセルは4バイトになり、bytesPerrowは4 * 16で64を指定します。
^ 色空間もRGBを指定します。
^ bitmapInfoは、不透明度が無い場合はskipLastを指定して４つ目のコンポーネントを無視するようにします。

---

// フルカラーが敷き詰められている画像

// 横からグレースケールもスライドイン

^ フルカラーの場合は、コンポーネントがグレースケールに比べて４倍になるため同じサイズの画像でもメモリを１６倍確保することになります。
^ この問題の解決策については後半で説明します。

---

```swift
let cgImage = context.makeImage()!
let uiImage = UIImage(cgImage: cgImage)
imageView.image = uiImage
```

^ contextからUIImageViewにイメージを渡すには、makeImage関数によって生成されたCGImageを経由します。
^ CGImageは実際のメモリ上の画像を参照するイメージクラスです。
^ そして、普段意識することはありませんが、UIImageはCGImageを始めとした様々な画像データをそのデータ構造を意識せずに使えるようにしたラッパークラスです。
^ 今回のように既にメモリ上に展開された画像を扱うこともあれば、ベクターデータを受け取って内部で展開することもあります。
^ UIImageにさえ出来てしまえば、UIImageViewやSwiftUIで簡単に描画することができます。

---

```swift
let imageSize = CGSize(width: 16, height: 16)
let targetView = tapGesture.view!
let location = tapGesture.location(in: targetView)
let x = Int(location.x * (imageSize.width / targetView.bounds.width))
let y = Int(location.y * (imageSize.height / targetView.bounds.height))
let point = CGPoint(x: x, y: y)
```

^ 画面上のタップ位置はUIGestureRecognizerのlocationInViewから得ることが出来ます。
^ それがドット絵上のどのポイントを指しているかを計算しやすくするために、UIImageViewのサイズは描画する画像と同じアスペクト比にしておくと良いでしょう。

---

```swift
context.setFillColor(gray: 1, alpha: 1)
context.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
```

^ 最後にcontextで色を塗る処理を紹介します。
^ contextのsetFillColorで塗りつぶしの色を指定し、fillで塗りつぶします。
^ これでドット絵を描くアプリを作ることが出来ました。
^ それでは、このアプリの完成度を上げていきましょう。

---

# CoreGraphicsの拡張

---

// code

^ 先ほど作ったアプリの続きです
^ UIPanGestureRecognizerとCGContextのellipseメソッドを使って、楕円を描画する機能を追加してみました。

---

// 動画

^ しかし、実行してみると違和感があることに気が付きます。
^ 円の縁に小さなドットが描画されてしまうのです。
^ これが、ドット絵のアプリを作る上で厄介なところです。

---

// Editormodeと比較

^ CGContextの描画関数は補完処理がかかることを前提として実装されています。
^ そのため、特に曲線部分では補完を無効にすると違和感のある見た目になることがあります。
^ これを防ぐには、独自に描画関数を実装する必要があります。

---

```swift
extension CGContext {
    func fillEllipseLine(in rect: CGRect) {
				let points = plotEllipse(in: rect)
        for point in points {
            let rect = CGRect(origin: point, size: CGSize(width: 1, height: 1))
            let path = UIBezierPath(rect: rect).cgPath
            addPath(path)
        }
        fillPath()
    }
}
```

^ CGContextに独自の関数を生やすのは難しいことではありません。
^ CGContextには、CGPathを塗り潰すfillPath関数が生えています。
^ なので、アルゴリズムを使って塗り潰すpointの配列さえ手に入ればそれらをaddPathすることで簡単に自作の描画関数を生やすことが出来ます。

---

// ブレゼンハム

^ ドット絵の円や線は、ブレゼンハムの線分描画アルゴリズムを使うことで綺麗に描くことが出来ます。
^ ここではアルゴリズムの詳しい説明は省きますが、このアルゴリズムはコンピュータの最初期に生まれたもので、多くの低解像度なモニターで使われてきた実績のあるアルゴリズムです。
^ 今回、このトークをするにあたってこのアルゴリズムをCGContextで扱えるようにしたライブラリを用意しました。

---

```diff
- context.fillEllipse(in: rect)
+ context.fillEllipsePlotLine(in: rect)
```

^ このように書き換えることで、ブレゼンハムの線分描画アルゴリズムに則った線を描くことが出来ます。
^ swift-bresenham-line-algorithmは、他にも単純な線や正円もサポートしています。

---

# CoreGraphicsの拡張2

---


^ 続いて、同じ色を塗り潰すバケツ機能を作ってみましょう。
^ CGContextは矩形に塗り潰すことしか出来ないため、これも自作の関数を作る必要があります。
^ フラッドフィルと呼ばれる方法で塗るポイントを探していきます。

---

^ フラッドフィルでは、横方向に同じ色が存在すれば指定した色で塗り、指定した色で塗り尽くしたら次の行に移動します。
^ そのため、この探索を実現するにはCGContextから指定した座標の色を取得・反映する処理が必要になります。

---

^ CGContextから色を取り出すAPIは生えていませんが、CGContext内のメモリを直接参照するためのdataというプロパティが生えています。
^ これを使って色を取り出すAPIを自作していきます。
^ 色を取り出す前に、CGContextの内部でどのように画像が配置されているかを見てみましょう。

---

```
(lldb) frame var -L ctxData
0x000000016d5379e8: (UnsafeMutableRawPointer) ctxData = 0x600000c51670
```

^ 2x2のCGContextに４色のグレーを付けて、lldbでメモリのアドレスを確認します。
^ Debug > Debug Workflow > View Memory
^ から、メモリ内を参照すると次のように色が並んでいることがわかります。
^ つまり、シンプルに左下から右上にかけての色が格納されていることが分かりました。
^ フルカラーの場合も同様に、RGBAの値が並んでいます。

---

```swift
struct RGBAColor {
  let red: UInt8
  let green: UInt8
  let blue: UInt8
  let alpha: UInt8
}

data.load(as: RGBAColor.self)
data.storeBytes(of: color, toByteOffset: offset, as: RGBAColor.self)
```

^ Swiftはload関数を使うことでポインタから型を指定して値を取り出すことが出来ます。
^ 型はメモリレイアウト上のサイズや並びを再現して宣言する必要があります。
^ fromByteOffsetに、型のサイズとindexをかけた値を渡すと任意のポイントの色を取得することが出来ます。
^ メモリへの書き込みも、storeBytesを使うことで型を使って行うことが出来ます。

---

^ ドット絵は解像度の低い画像ですが、フラッドフィルのような処理は反復して多くのfor-loopを行う可能性があります。
^ 処理を短時間で終わらせるためには、このようにメモリを直接操作したり余分な計算を減らす必要があります。
^ 最後にドット絵のパフォーマンスを向上させるための工夫を見てみましょう。

---

# パフォーマンスの改善

---

^ ドット絵は一般的に全体で使用する色数が少なくなります。
^ この特徴を利用して、メモリ上の画像サイズを減らす工夫をしてみます。

---

^ 作戦はこうです。
^ まず、グレースケールで画像を保持します。先ほど解説した通りグレースケールであれば画像のサイズは1/16になります。
^ グレースケールは256階調のグレーが使えますが、これに256色を対応させます。
^ レンダリングのタイミングでこの色を対応表通りに戻してあげることでディスプレイに表示されるタイミングでは色がついて見えるようになります。
^ これをインデックスカラーと言います。
^ 昔のゲームの2Pカラーなどがこの仕組みを使っていたりします。

---

![](lut-workflow.png)

^ 残念ながらCGContextにはインデックスカラーの機能が無いため、これも自前で実装することになります。
^ グレースケールのCGContextからCGImageを取り出して、それをCIFilterにかけて着色します。
^ CIFilterにはColorCubeというLookupTableのフィルタがあるのですが、これはカラーの画像に対してかけるフィルタなので、Metalで自作します。
^ 着色した画像をCIFilterから取り出して、UIImageViewに表示すれば完成です。

---

```
#include <metal_stdlib>
using namespace metal;
#include <CoreImage/CoreImage.h>

extern "C" { namespace coreimage {
    float4 lookupTable(sampler src, sampler lut) {
        float2 pos = src.coord();
        float4 pixelColor = src.sample(pos);
        int index = pixelColor.r * 255;
        int x = index % int(lut.size().x);
        int y = index / int(lut.size().y);
        float2 lutPos = float2(x, y);
        float4 lutColor = lut.sample(lutPos);
        return lutColor;
    }
}}
```

---

# Recap

---