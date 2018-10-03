# アプリのリソース管理

# 自己紹介
# Pocochaの紹介

# リソースの種類

画像
色
効果音
Storyboard
フォント
動画

# XCAssetsとは

画像とjsonを内包するディレクトリ
更に管理しておくと最適化の恩恵も受けれる

# XCAssetsを呼び出す

文字列だと微妙
SwiftGen

# XIB/Storyboard

画像は指定しない、コンパイル時に分からなくなる
画像を使ってUIImageViewのサイズを指定したい時はintrinsicContentsize
Inabaで見つけられる

# 構造と命名

見た目の名前をつける
NameSpaceを切ったほうがいい

# ラスタライズ
pdfからラスタライズ
ランタイムでもラスタライズできる

# アプリのアイコン
なぜかpdfで作れない（要検証）
AppIconGenで作れる（重複処理も大丈夫）

# 差分のある画像
ランタイムで生成
