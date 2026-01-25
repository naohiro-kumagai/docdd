---
name: "Phase-Git-Skill"
description: "Phase 10-11: GitコミットとPushフェーズのスキル"
version: "1.0.0"
---

# Phase Git Skill

## 目的

適切なコミットメッセージで変更を記録し、リモートにプッシュします。

## 起動条件

- 品質チェックがすべてパス
- 検証が完了

## 使用リソース

- resources/commit_format.md

## コミットメッセージフォーマット

```
<type>: <description>

[optional body]

[optional footer]
```

### Type

| Type | 説明 |
|------|------|
| **feat** | 新機能追加 |
| **fix** | バグ修正 |
| **refactor** | リファクタリング |
| **docs** | ドキュメント変更 |
| **test** | テスト追加・修正 |
| **style** | コードスタイル変更 |
| **chore** | ビルド・ツール変更 |
| **perf** | パフォーマンス改善 |

## コミット例

```bash
git add .
git commit -m "feat: ユーザープロフィール編集機能を追加"
```

## プッシュ

```bash
# 現在のブランチをプッシュ
git push

# 初回プッシュ（ブランチを追跡）
git push -u origin <branch-name>
```

## 注意事項

- コミットは原子的（1つの論理的変更）
- コミットメッセージは将来の自分への説明
- 大きすぎるコミットは分割する
