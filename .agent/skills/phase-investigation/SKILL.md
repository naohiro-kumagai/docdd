---
name: "Phase-Investigation-Skill"
description: "Phase 1: 調査・リサーチフェーズのスキル"
version: "1.0.0"
---

# Phase Investigation Skill

## 目的

既存コードの理解とADRの確認を最優先し、実装前の調査を行います。

## 起動条件

- 新しいタスクや機能実装を開始する
- 既存コードベースの理解が必要
- アーキテクチャ決定との整合性を確認する

## 使用リソース

- resources/investigation_checklist.md

## 実行手順

1. **ADR確認（最優先）**
   - `docs/adr/index.json`を確認
   - 関連するADRファイルを読む
   - 既存の決定との一貫性を検証

2. **コードベース調査**
   - Kiri MCPの`context_bundle`で関連コードを取得
   - `files_search`で具体的な関数/クラスを検索
   - `deps_closure`で依存関係を分析

3. **ライブラリドキュメント確認**
   - Context7 MCPで最新ドキュメントを取得
   - API使用パターンを検証

## 出力フォーマット

```markdown
## 調査結果サマリー

### ADR確認
- 確認したADR: ADR-XXXX, ADR-YYYY
- 関連する決定: [要約]
- 一貫性: ✅/⚠️

### コードベース分析
- 関連ファイル: [リスト]
- 既存パターン: [説明]
- 依存関係: [重要な依存]

### 推奨アプローチ
[実装方針]
```
