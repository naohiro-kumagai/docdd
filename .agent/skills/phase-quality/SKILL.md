---
name: "Phase-Quality-Skill"
description: "Phase 8: 品質チェックフェーズのスキル"
version: "1.0.0"
---

# Phase Quality Skill

## 目的

すべての品質チェックを実行し、コミット前の品質を担保します。

## 起動条件

- 実装完了後
- コミット前

## 使用リソース

- scripts/quality_check.sh
- resources/quality_checklist.md

## 必須チェック

コミット前に以下をすべて実行し、すべてパスする必要があります。

### 0. エディタ上のエラー確認【最優先】
- Pylanceエラーが0件である
- ファイルタブに赤い×印がない
- 「問題」パネルが空である

### 1. 型チェック
```bash
npm run type-check
```

### 2. リントチェック
```bash
npm run lint
```

### 3. テスト実行
```bash
npm run test
```

### 4. ビルドチェック
```bash
npm run build
```

## 注意事項

- **すべてのチェックがパス必須**
- エラーを無視しない（`@ts-ignore`、`eslint-disable`は禁止）
- 修正が難しい場合は設計を見直す
