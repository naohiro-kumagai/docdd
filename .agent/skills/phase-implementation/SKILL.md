---
name: "Phase-Implementation-Skill"
description: "Phase 5: 実装フェーズのスキル"
version: "1.0.0"
---

# Phase Implementation Skill

## 目的

高品質なコードの実装を行います。

## 起動条件

- 計画フェーズ完了後
- コードの新規作成または修正

## 使用リソース

- resources/coding_standards.md
- resources/import_rules.md
- examples/error_handling.ts

## 必須ツール

- **Serena MCP**: シンボルベース編集
- **@terminal**: コマンド実行、パッケージインストール

## コーディング標準

### インポート規則
- バレルインポート禁止
- `@/`エイリアスを使用した明示的インポート

### 型安全性
- `any`禁止
- `@ts-ignore`禁止
- すべての関数に明示的な戻り値の型

### コメント
- 日本語で記述
- 複雑なロジックには必ず説明を追加

### エラーハンドリング
- 非同期操作には`.then().catch()`
- 同期エラーには`try-catch`

### Reactパターン
- Server Component優先
- 必要な場合のみClient Component
