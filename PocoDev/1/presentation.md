# 立ち上げ時のライブ配信アプリに最適な開発環境・技術的ノウハウとは

---

# 自己紹介

---

## プロダクト開発
### ライブサービスの最小構成とは
### サーバ構成図
### フィルタ
### チャット周り
### 配信周り
### アイテム再生周り
### フィルタ周り
## 運用
### クラッシュ問題
### 低遅延への取り組み
### 配信クオリティの測定
### ＊＊あと何か欲しい＊＊

---

# 初期メンバー
3、４人
インキュベーション出身

# プラットフォーム選定
iOS/Android/WEB
初期はiOSを選択
インキュベーション環境に既に立ち上げの為のインフラが整っていたから

# ライブサービスの最小構成
配信
チャット
アイテム
ハート

## チャット周り
firebaseが良さそう
今はbcserverを使っている
完全にfirebaseにするとNGとかできないのでサーバを通す

## 配信周り
Showroomの配信基盤を使っている
wowzaを使っていたが、内製の配信サーバになりつつある
一般的にはwowza立てましょう

azure media servicesでも良いね
https://azure.microsoft.com/ja-jp/services/media-services/

awsもあるよ
https://aws.amazon.com/jp/media-services/

gcpにもあるよ
https://cloud.google.com/solutions/media-entertainment/use-cases/live-streaming/?hl=JA

またクライアントは内製のblsplayer/flvplayback
blsplayerはバッファや
一般的にはHaishinKitを使うのが良さそう

## アイテム再生周り
Kitsunebi
詳しくはiOSDCの話

## フィルター周り
GPUImage
SenseMe

## ハート周り
バッファリング必須

## アーキテクチャ
Reduxでもよかったかも
MVVMもよかった

## 遅延に関する取り組み
https://www.slideshare.net/akirahiguchi/dena-112412583

