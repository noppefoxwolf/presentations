slidenumbers: true
slidecount: true
slide-transition: false
slide-dividers: #, ##, ###, ####

# App Intentで広がるアプリの活用

WWDC Recap 2024 (30min)
noppe

# 自己紹介

noppe

- 株式会社ディー・エヌ・エー
- 個人アプリ開発者
- キツネが好き

![right fill](profile.png)

## WWDC24 行ってきました

- WWDC19 以来2回目
- DeNAはPococha事業部から２名参加

![](dc.jpeg)

---

![fit](wwdc-dawn.png)

---

# ![](dawn.png) DAWN for mastodon

- personal work
- 3rd party mastodon app
- 100% Swift Project
- iOS, iPadOS, macOS (Catalyst), visionOS
- Supports **App Intents**

# Agenda

- App Intentの基本
- WWDC24で何が変わったのか
- App Intentを意識したアプリ開発
- まとめ

# App Intentの基本

- アプリが出来ること、扱うデータについて表明すること
- 例えば…
  - このアプリは、𝕏にポスト出来ます
  - このアプリは、コーヒの淹れ方を表示できます
  - このアプリは、

## 表明すると、何がいいことがあるの？

- システムが検出して勝手に統合してくれる
  - 表明している機能に応じて、適切な場所から実行できるようにする
  - 表明しているデータに応じて、Siriが検索してくれる

## 適切な場所から実行出来るメリット

- ユーザーはアプリを行き交うことなく、滑らかな体験ができる

## App Intentの応用

- WidgetKitの中でApp Intentを呼び出すことで…
  - ウィジェットをタップした時のアクションとして使う
  - コントロールウィジェット
  - ライブアクティビティ

# WWDC24で何が変わったのか

## Intentの追加

- CameraCaptureIntent
- OpenURLIntent
- URLRepresentableIntent
- SetValueIntent

- ControlConfigurationIntent

## Widgetの追加

- Control Widget
- Lock Screen Widget

---

App Intentの目的
- アプリの起動動線を柔軟にする
  - 普通はアイコンをタップして起動する
    - でも、AppLibraryの登場でホーム画面にすら置いてもらえないこともあります
  - Siriで起動する
  - https://developer.apple.com/wwdc24/10210
  - Spotlight
  - Widget
  - Control Center
  - Shortcut
  - Apple Pencil Squize?
  - Action Button
  - ...etc
  - これらのベースにあるものがApp Intent。対応すれば全てに対応できる
  
- 起動を柔軟にできるということは、最初にどのタブを表示するかなども拡張できる

- アプリを起動するのではなく、機能を呼び出すのにも使える

https://developer.apple.com/jp/news/?id=jdqxdx0y
https://developer.apple.com/documentation/AppIntents

iOS 16で登場

アプリのコンテンツとアクションを外部公開するための機能

外部公開すると嬉しいところは？

- 適切な場所でアプリを使ってもらえる
  - アプリをわざわざ開くことが正しいUXではないケースもある
  - 例えば、ロック画面の懐中電灯をわざわざアプリを開くとすると…？
- ユーザーが処理を連携できる
- AppIntentsとして切り出すコツ

- アクセシビリティ関係ある？
- App Intents Package

# 休憩


# まとめ