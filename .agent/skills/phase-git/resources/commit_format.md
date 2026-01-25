# コミットメッセージフォーマット

## 基本形式

```
<type>: <description>

[optional body]

[optional footer]
```

## Type一覧

| Type | 説明 | 例 |
|------|------|-----|
| **feat** | 新機能追加 | `feat: ユーザー認証機能を追加` |
| **fix** | バグ修正 | `fix: ログイン時のエラーを修正` |
| **refactor** | リファクタリング | `refactor: UserCardコンポーネントを分割` |
| **docs** | ドキュメント変更 | `docs: READMEにセットアップ手順を追加` |
| **test** | テスト追加・修正 | `test: ユーザー認証のテストを追加` |
| **style** | コードスタイル変更 | `style: フォーマットを統一` |
| **chore** | ビルド・ツール変更 | `chore: ESLint設定を更新` |
| **perf** | パフォーマンス改善 | `perf: 画像読み込みを最適化` |

## Description

- 簡潔に変更内容を説明（50文字以内推奨）
- 日本語または英語
- 命令形を使用（「追加する」ではなく「追加」）
- 末尾にピリオド不要

## 良い例

```bash
git commit -m "feat: パスワードリセット機能を追加"
git commit -m "fix: Safariでボタンが押せない問題を修正"
```

## 悪い例

```bash
git commit -m "更新"
git commit -m "機能追加とバグ修正とリファクタリング"
git commit -m "fix"
```
