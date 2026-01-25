---
name: "Test-Generator-Skill"
description: "テスト方針の統一とサンプル生成を支援するスキル"
version: "1.0.0"
---

# Test Generator Skill

## 目的

テスト方針の統一と、最小限の検証パターンを確実に実装できるように支援します。

## 起動条件

- テスト追加や更新を依頼されたとき
- 重要な分岐のテストが不足しているとき

## 使用リソース

- scripts/coverage_checker.py
- resources/test_patterns.md
- examples/sample_tests.tsx

## 実行手順

1. 変更対象のファイルを `scripts/coverage_checker.py` に渡して現状を確認
2. `resources/test_patterns.md` を参照してテスト観点を整理
3. `examples/sample_tests.tsx` に沿ってテストを作成
