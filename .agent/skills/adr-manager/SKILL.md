---
name: "ADR-Manager-Skill"
description: "ADRの作成・検証・更新を支援するスキル"
version: "1.0.0"
---

# ADR Manager Skill

## 目的

アーキテクチャ決定記録（ADR）を一貫した形式で作成し、
漏れや誤りを機械的に検証します。

## 起動条件

- ADRの作成や更新を依頼されたとき
- 重要な設計判断を記録する必要があるとき

## 使用リソース

- scripts/adr_validator.py
- resources/adr_template.json
- resources/adr_checklist.md
- examples/sample_adr.json

## 実行手順

1. `resources/adr_template.json` を元にドラフトを作成する
2. `scripts/adr_validator.py` を実行して必須項目を検証する
3. `resources/adr_checklist.md` を参照し、背景・代替案の記述を確認する

## 出力フォーマット

- JSON形式のADR
- `docs/adr/index.json` にインデックス化
