# Repository Guidelines

## Project Structure & Module Organization
- `presentation.md`: 発表本文（スライド原稿＋スピーカーノート）。
- `docs/animatedimage-spec.md`: AnimatedImageの実装/運用の参考資料。
- `docs/article.md`: 関連ブログ原稿（参考情報）。
- `docs/talkscript-spec.md`: 話し方・進行トーンの指針。

## Build, Test, and Development Commands
- Preview: お使いのエディタのMarkdownプレビューを使用。
- Lint (任意): `markdownlint **/*.md` を推奨（導入している場合）。
- Link check (任意): 外部リンクはプレビューで手動確認し、無効URLを修正。

## Coding Style & Naming Conventions
- 見出し: `#` → タイトル、`##` → 大見出し。節は簡潔に。
- 箇条書き: `-` を使用。1行は原則100字以内で短文に。
- コード/コマンド: 逆引用符で囲む（例: `swift test`）。
- 言語: 日本語。落ち着いた講義調、断定を避けつつ簡潔に。
- ファイル: 発表本文は `presentation.md` に一本化。補足は `docs/` に配置。

## Slides & Talk Script Conventions
- スライド区切り: スライドの境界は行単体の `---` を使用。
- トークスクリプト: 話者メモの先頭に `^` を付ける（本文直下に配置）。
- 例:
  
  ```md
  ## 背景と課題感
  Mastodonは分散型のため…
  
  ^ 分散ゆえ形式が多様→必要性を一言で

  -----
  
  ## 目標と定義
  UIスレッドを極力ブロックしない…
  ```

## Testing Guidelines
- 構成確認: セクション順序が「背景→定義→設計→実装→検証→まとめ」になっているか確認。
- スピーカーノート: 各セクションに要点・強調点があるか確認。
- リンク/画像: 404・表示崩れがないかプレビューで確認。
 - 区切り/記法: スライド区切りは `---`、トークスクリプトは `^` で始まるか確認。

## Commit & Pull Request Guidelines
- コミット: 命令形・短く範囲を限定（例: "Refine decimation section", "Add speaker notes"）。
- PR要件:
  - 目的・変更概要・影響範囲を記載。
  - スクリーンショット/プレビュー差分（可能なら）を添付。
  - 参照資料（`docs/*`）との整合を明記。
- マージ前チェック: プレビューで誤字脱字・リンク切れ・体裁崩れを再確認。

## Security & Configuration Tips
- 秘密情報・個人情報・契約情報は記載しない。
- 大容量バイナリは含めない（外部ストレージ/リンクを使用）。
- 外部資産は出典を明記し、安定URLを使用。

## Contributor Notes
- 変更は小さく分割し、1 PR = 1 目的を徹底。
- 議論はPRのコメントで行い、合意事項は本文に反映してください。
