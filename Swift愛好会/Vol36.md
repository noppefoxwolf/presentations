UILayoutGuide

Autolayoutのおさらい
ViewのAnchorとの位置関係でレイアウトを決定する。
ios9から

---

# UILayoutGuide

Autolayoutの機能を持った表示されないビューのようなもの
Anchorしか持たないシンプルなクラス

例：view.safeAreaLayoutGuide

---

# UILayoutGuide

||UIView|UILayoutGuide|
|---|---|---|
|Anchor|`view.topAnchor`|`layoutGuide.topAnchor`|
|追加|`addSubView(view)`| `addLayoutGuide(layoutGuide)` |
|削除|`view.removeFromSuperview()`| `removeLayoutGuide(layoutGuide)` |
|subView|`view.addSubView(subView)`| なし |

---

# UILayoutGuide

||UIView|UILayoutGuide|
|---|---|---|
|Autolayout|○|○|
|レンダリングコスト|×|○|
|機能のシンプルさ|レイアウトに不要な機能が存在|最低限|
|ビューヒエラルキの更新|される|されない|

^ addSubViewなど、不要な機能が存在します
^ iOS9未満にはUILayoutGuideがないので、ワークアラウンドとしてビューを使う事もあったかもしれませんが、今は不要です

---

# 自作のUILayoutGuideを生やす

---

- safaAreaLayoutGuideなどデフォルト実装もあり
- UILayoutGuideは自分で追加することも可能

^ さきほど紹介したように、UILayoutGuideは自分で追加することが出来ます。

---

# 自作のUILayoutGuideを生やすメリット

- 動的な制約の変化を隠蔽出来る
- 

---


自作のlayoutguideを生やす
・動的な制約の変化を隠蔽出来る
ビューは適用メソッドとインタラクションの監視で膨れ上がっている。
アニメーションもビューに書きますか？

活用するのは難しいが、良い例を用意しました。
keyboardとテキストコンテナです。
前者はキーボードの上部にアンカーを生やす
後者はテキストコンテナの短径領域にアンカーを生やす
それぞれこういうUIを作るときに嬉しい。普通はこうしますよね。
テキストコンテナのやつはキーボードのやつを参考に作りました。

作り方を解説します。
〜作り方



