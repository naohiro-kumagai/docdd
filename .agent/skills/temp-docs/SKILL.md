---
name: "Temp-Docs-Skill"
description: "一時ドキュメント管理スキル"
version: "1.0.0"
---

# Temporary Documents Skill

## 目的

AI Agentの作業中に生成される一時的なドキュメントを適切に管理します。

## 起動条件

- 分析レポート作成時
- 作業計画書作成時
- 技術検証・調査メモ作成時

## 使用リソース

- resources/temp_doc_rules.md
- resources/templates.md

## 保存場所

**必須**: `.github/tmp/` ディレクトリに保存

理由:
- ✅ Git で管理されない（`.gitignore` で除外）
- ✅ 正式ドキュメントと明確に区別
- ✅ 自動クリーンアップ対象

## 命名規則

```
{YYYY-MM-DD}_{対象}_{種別}.md

例:
- 2024-01-15_database-design_analysis.md
- 2024-01-15_auth-flow_investigation.md
- 2024-01-16_refactoring_plan.md
```

## 作成すべきでないもの（正式配置が必要）

| 内容 | 正しい配置先 |
|------|-------------|
| ADR | `docs/adr/decisions/` |
| 実装ガイド | `docs/` |
| APIリファレンス | `docs/` |
| ユーザー向けドキュメント | `README.md`, `docs/` |
