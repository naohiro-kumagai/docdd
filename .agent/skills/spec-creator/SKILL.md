---
name: "Spec-Creator-Skill"
description: "機能仕様、API仕様、アーキテクチャ仕様を作成するスキル"
version: "1.0.0"
---

# Spec Creator Skill

## 目的

機能仕様、API仕様、アーキテクチャドキュメントを構造化された形式で作成・保守します。

## 起動条件

- 新しい機能仕様、API仕様、アーキテクチャドキュメントを作成する
- 既存コードから仕様をリバースエンジニアリングする
- ドキュメント構造を標準化する

## 使用リソース

- resources/spec_types.md
- resources/reverse_engineering.md
- examples/feature_spec.md

## 実行手順

### フォワードエンジニアリング
1. ドキュメントタイプを決定（feature, api, architecture等）
2. テンプレート構造に従って仕様書を生成
3. プロジェクト基準との一貫性を確認

### リバースエンジニアリング
1. 対象コードを特定
2. コード構造を分析（MCP使用）
3. 情報を抽出し仕様を生成
4. 実装と照らし合わせて正確性を確認
