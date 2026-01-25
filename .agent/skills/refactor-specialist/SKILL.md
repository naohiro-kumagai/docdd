---
name: "Refactor-Specialist-Skill"
description: "Reactコンポーネントのリファクタリング専門スキル"
version: "1.0.0"
---

# Refactor Specialist Skill

## 目的

Reactコンポーネントの構造整理、ロジック抽出、Presenterパターン適用、ディレクトリ再編成を行います。

## 起動条件

- UIとビジネスロジックが混在している
- 内部状態で制御される条件分岐が多い
- ディレクトリ構造や命名が不統一

## 使用リソース

- resources/refactor_principles.md
- resources/directory_structure.md
- examples/presenter_pattern.tsx

## 実行手順

1. コンポーネントの責務、条件分岐、ディレクトリ構造を調査
2. 必要なファイル作成/移動/インポート更新を特定
3. 構造整理 → ロジック抽出 → Presenter作成 → 条件分岐UI分離の順で実装
4. 命名規則と依存関係が適切に整理されていることを検証

## 制約

- 外部コントラクト（props、型定義）を厳密に保持
- 新しい`any`、`@ts-ignore`を導入しない
- すべてのESLint/Biome警告を解決
