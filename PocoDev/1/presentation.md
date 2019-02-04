# 立ち上げ時のライブ配信アプリに最適な開発環境・技術的ノウハウとは
## Poco dev meetup

---

# noppe

---

# Agenda

- プロダクト開発
- 運用の取り組み
- 最新の環境

---

# プロダクト開発

---

# 2017年

- エンジニア2,3名
- 速度優先

^ インキュベーション出身

---

# 開発の方針

資産を生かしてクイックに作る

---

# 資産

- 分析基盤
- インキュベーションで作った共通ライブラリ
- SHOWROOMの配信基盤
- BaaS

^ これらをパズルのように合わせて作っていった

---

# 資産から逆算して初期リリースから削った要素

- Android版
- WEB版
- 非同期コミュニティ要素
- ラジオ
- 認証はtwitterのみ

---

# 初期で実装を決めた要素

- ライブ配信
- 有料アイテム
- 視聴中のテキストチャット
- ハート
- フィルタ機能

---

# 初期で実装を決めた要素

- ライブ配信
    - SHOWROOM配信基盤
- 有料アイテム
    - 新規実装
- 視聴中のテキストチャット
    - Firebase

---

# 配信映像周り

- wowza
- blsplayer

---

# 配信映像周り

一般的な選択肢



---

# 美肌フィルター

GPUImage

---

# ライブ中のイベント

Firebaseで管理

- コメント
- アイテム
- フォロー

---

# 運用

---

# クラッシュ周りの検知
Fabric/Crashlitics
主に配信周りでクラッシュが多かった

--- 

# 低遅延への取り組み

wowza -> blsserver

---

# 配信クオリティの測定

aws image recognition

---

# 最新の環境

---

GPUImage -> SenseMe

---

連番PNG -> Kitsunebi

---




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

