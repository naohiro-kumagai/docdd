---
applyTo: "**/*"
---

# Phase 10: Git Commit（コミットフェーズ）専用指示

このフェーズでは、**適切なコミットメッセージで変更を記録**します。

## コミットメッセージフォーマット

```
<type>: <description>

[optional body]

[optional footer]
```

### Type（必須）

| Type | 説明 | 例 |
|------|------|-----|
| **feat** | 新機能追加 | `feat: ユーザー認証機能を追加` |
| **fix** | バグ修正 | `fix: ログイン時のエラーを修正` |
| **refactor** | リファクタリング | `refactor: UserCard コンポーネントを分割` |
| **docs** | ドキュメント変更 | `docs: README にセットアップ手順を追加` |
| **test** | テスト追加・修正 | `test: ユーザー認証のテストを追加` |
| **style** | コードスタイル変更（機能に影響なし） | `style: フォーマットを統一` |
| **chore** | ビルド・ツール変更 | `chore: ESLint 設定を更新` |
| **perf** | パフォーマンス改善 | `perf: 画像読み込みを最適化` |

### Description（必須）

- 簡潔に変更内容を説明（50文字以内推奨）
- 日本語または英語
- 命令形を使用（「追加する」ではなく「追加」）
- 末尾にピリオド不要

### Body（任意）

- 変更の理由や背景を説明
- 複雑な変更の場合に使用
- 72文字で改行

### Footer（任意）

- 破壊的変更（BREAKING CHANGE）の記載
- Issue番号の参照

## コミット例

### 基本的なコミット

```bash
git add .
git commit -m "feat: ユーザープロフィール編集機能を追加"
```

### 詳細な説明付き

```bash
git commit -m "fix: ログイン時のセッションエラーを修正

セッションの有効期限が正しく設定されていなかったため、
ログイン直後にセッション切れが発生していた。

Closes #123"
```

### 複数ファイルの変更

```bash
# 関連する変更をまとめてコミット
git add src/components/UserCard.tsx src/lib/user-utils.ts
git commit -m "refactor: ユーザー表示ロジックを utils に分離"
```

### 段階的コミット

```bash
# ステップ1: 型定義を追加
git add src/types/user.ts
git commit -m "feat: User 型定義を追加"

# ステップ2: コンポーネントを実装
git add src/components/UserCard.tsx
git commit -m "feat: UserCard コンポーネントを実装"

# ステップ3: テストを追加
git add src/components/UserCard.test.tsx
git commit -m "test: UserCard のテストを追加"
```

## コミット前チェックリスト

- [ ] Phase 8（品質チェック）がすべてパス
- [ ] 不要なファイルが含まれていない（node_modules等）
- [ ] コミットメッセージが適切な type を使用
- [ ] description が変更内容を明確に説明
- [ ] 1コミットは1つの論理的変更単位
- [ ] コミット後もコードが動作する状態

## ベストプラクティス

### ✅ 良いコミット

```bash
# 明確で具体的
git commit -m "feat: パスワードリセット機能を追加"

# 関連する変更をまとめる
git commit -m "refactor: 認証ロジックを auth.ts に分離"

# 問題と解決を明示
git commit -m "fix: Safari でボタンが押せない問題を修正"
```

### ❌ 悪いコミット

```bash
# 曖昧
git commit -m "更新"

# 複数の無関係な変更
git commit -m "機能追加とバグ修正とリファクタリング"

# 説明不足
git commit -m "fix"
```

## 増分コミット戦略

大きな機能は小さなコミットに分割:

```bash
# 1. 型定義
git commit -m "feat: ユーザー設定の型定義を追加"

# 2. API実装
git commit -m "feat: ユーザー設定 API を実装"

# 3. UI実装
git commit -m "feat: ユーザー設定画面を実装"

# 4. テスト
git commit -m "test: ユーザー設定のテストを追加"

# 5. ドキュメント
git commit -m "docs: ユーザー設定機能の使い方を追加"
```

## Git コマンドリファレンス

```bash
# ステージング状態確認
git status

# 変更内容確認
git diff

# ステージング追加
git add <file>
git add .  # すべて

# コミット
git commit -m "message"

# 直前のコミットを修正
git commit --amend

# コミット履歴確認
git log --oneline
```

## 注意事項

- コミットは原子的（1つの論理的変更）
- コミットメッセージは将来の自分への説明
- 大きすぎるコミットは分割する
- 小さすぎるコミット（タイポ修正等）は --amend で統合
