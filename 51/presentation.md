# [fit] intrinsic content size
# [fit] でもっとAutolayoutを活用する

---

# [fit] noppe

iOS apps developer

🦉 🐙 **@noppefoxwolf**

💖 Swift / iOS / 🦊

![right](IMG_0726.PNG)

---

# [fit] intrinsic content size
知ってますか？

---

![](スクリーンショット 2018-05-18 7.25.54.png)

---

![](スクリーンショット 2018-05-18 7.25.42.png)

---

# [fit] ビュー自身が持つ推奨のサイズ = Intrinsic Content Size

---



---

# UIViewのサイズ
Storyboardからサイズを指定するのではなく、UILabelのようにコンポーネント自体がサイズを決めるようにする
UIStackViewの性質を応用してintrinsic content sizeを自動で決める

# UITableViewCell
同様の事をcellで行う事で高さを自動で計算出来る

# pros cons

## pros
圧倒的に記述が減る
Storyboardがスッキリ

## cons
レイアウト処理が重くなる