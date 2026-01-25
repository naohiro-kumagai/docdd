---
name: "UI-Advisor-Skill"
description: "UI/UXとアクセシビリティの観点をレビューするスキル"
version: "1.0.0"
---

# UI Advisor Skill

## 目的

アクセシビリティと視覚的階層の観点から、UIの改善点を抽出します。

## 起動条件

- UI/UXレビューの依頼がある
- レスポンシブやアクセシビリティの確認が必要

## 使用リソース

- scripts/accessibility_checker.py
- resources/design_system.md
- resources/a11y_checklist.md
- examples/component_examples.tsx

## 実行手順

1. `scripts/accessibility_checker.py` を実行して機械的な問題を抽出
2. `resources/a11y_checklist.md` を用いて観点漏れを防止
3. `resources/design_system.md` のガイドラインに合わせて改善案を提示
