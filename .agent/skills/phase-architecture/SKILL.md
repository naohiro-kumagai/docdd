---
name: "Phase-Architecture-Skill"
description: "Phase 2: アーキテクチャ設計フェーズのスキル"
version: "1.0.0"
---

# Phase Architecture Skill

## 目的

システム構造の設計とADR記録を行います。

## 起動条件

- 新機能や大規模変更時
- 既存パターンに完全に従わない場合

## スキップ可能なケース

- 既存パターンに完全に従う場合
- 1ファイル以内の小さな修正
- ドキュメントやスタイルのみの変更

## 使用リソース

- resources/architecture_checklist.md

## 実行手順

1. **ファイル配置設計**
   - ディレクトリ構造を決定
   - 命名規則の一貫性を確保
   - 既存の構造パターンに従う

2. **状態管理アプローチ**
   - どこでどのように状態を管理するか定義
   - React Context、props drilling、外部ライブラリの選択
   - 決定理由をADRに記録

3. **コンポーネント階層設計**
   - コンポーネントの責務を明確化
   - データフローを設計（props/context/イベント）
   - Presenterパターンなど確立されたパターンを適用

4. **ADR記録**
   - 重要な決定は必ずADRとして文書化
   - `docs/adr/`に構造化形式で保存
