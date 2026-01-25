---
name: "Story-Creator-Skill"
description: "Storybookストーリーの作成とメンテナンススキル"
version: "1.0.0"
---

# Story Creator Skill

## 目的

プロジェクトルールに準拠したStorybookストーリーを作成・保守します。

## 起動条件

- 新規/既存コンポーネントにpropsで制御される視覚的バリエーションがある
- Meta設定やイベントハンドラー実装を標準化する必要がある
- ストーリーの命名やグルーピングを再編成する必要がある

## 使用リソース

- resources/story_rules.md
- examples/basic_story.tsx
- examples/conditional_story.tsx

## 実行手順

1. コンポーネントpropsと表示バリエーションを分析
2. 意味のある視覚的差分のみを抽出
3. 各ストーリーに説明的な名前と適切なargsを付与
4. イベントハンドラーに`fn()`を使用

## アンチパターン
- 内部フックをモック化する必要がある状態のストーリーを強制する
- 視覚的に同一の複数ストーリーを作成する
- ロジック検証や空レンダリングのストーリーを追加する
