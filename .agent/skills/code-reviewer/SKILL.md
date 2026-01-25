---
name: "Code-Reviewer-Skill"
description: "コードレビューの品質を一定化するためのスキル"
version: "1.0.0"
---

# Code Reviewer Skill

## 目的

レビュー対象のコードに対して、
1) 機械的なミス検出、2) 品質観点の網羅、3) 伝え方の統一を行います。

## 起動条件

- 「コードレビューして」などの依頼がある
- 変更差分や対象ファイルが提示される

## 使用リソース

- scripts/simple_linter.py
- resources/review_checklist.md
- examples/review_style.md

## 実行手順

1. `scripts/simple_linter.py` を実行し、機械的な問題を抽出する
2. `resources/review_checklist.md` を参照し、観点漏れを防ぐ
3. `examples/review_style.md` のフォーマットに従って指摘をまとめる

## 出力フォーマット

- 「良い点」「改善提案」「次のアクション」の順で簡潔に記載する
- 指摘は具体的な修正案を伴う
- トーンは丁寧で建設的にする
