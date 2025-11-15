---
applyTo: "**/*"
---

# Phase 11: Push（プッシュフェーズ）専用指示

このフェーズでは、**変更をリモートリポジトリにプッシュ**します。

## 基本コマンド

```bash
# 現在のブランチをプッシュ
git push

# 初回プッシュ（ブランチを追跡）
git push -u origin <branch-name>

# 強制プッシュ（注意: 慎重に使用）
git push --force-with-lease
```

## プッシュ前チェックリスト

- [ ] Phase 10（Git Commit）が完了
- [ ] すべてのコミットが適切なメッセージを持つ
- [ ] プッシュするブランチが正しい
- [ ] リモートリポジトリのURLが正しい
- [ ] 機密情報（API キー等）が含まれていない

## ブランチ戦略

### Feature Branch

```bash
# 1. feature ブランチ作成
git checkout -b feature/user-authentication

# 2. 変更を実装・コミット
git add .
git commit -m "feat: ユーザー認証機能を追加"

# 3. プッシュ
git push -u origin feature/user-authentication
```

### Main/Master Branch

```bash
# main ブランチへの直接プッシュは避ける
# プルリクエスト経由を推奨
```

## プッシュ後の確認

### GitHub/GitLab での確認

1. **リモートリポジトリを確認**
   - コミットが反映されているか
   - コミットメッセージが正しいか

2. **CI/CD パイプライン確認**
   - 自動テストがパスしているか
   - ビルドが成功しているか
   - デプロイが正常か

3. **プルリクエスト作成**
   - 変更内容の説明を記載
   - レビュアーを指定
   - 関連 Issue を紐付け

## プルリクエストテンプレート

```markdown
## 変更内容

- ユーザー認証機能を追加
- ログイン/ログアウト機能を実装
- セッション管理を実装

## 変更の種類

- [ ] 新機能追加
- [ ] バグ修正
- [ ] リファクタリング
- [ ] ドキュメント更新
- [ ] その他（説明: ）

## チェックリスト

- [x] すべての品質チェックがパス
- [x] テストを追加/更新
- [x] ドキュメントを更新
- [x] 動作確認済み

## スクリーンショット（該当する場合）

[画像を添付]

## 関連Issue

Closes #123
```

## トラブルシューティング

### プッシュが拒否される

```bash
# エラー: rejected - non-fast-forward
# 原因: リモートに新しいコミットがある

# 解決策1: プル後にプッシュ
git pull --rebase
git push

# 解決策2: マージ後にプッシュ
git pull
git push
```

### 間違ったブランチにプッシュした

```bash
# リモートブランチを削除
git push origin --delete <wrong-branch-name>

# 正しいブランチで再プッシュ
git checkout <correct-branch>
git push -u origin <correct-branch>
```

### 機密情報をプッシュしてしまった

```bash
# 1. 直前のコミットを削除
git reset --hard HEAD~1
git push --force-with-lease

# 2. API キー等は即座に無効化
# 3. Git 履歴から完全削除（必要に応じて）
git filter-branch --force --index-filter \
  "git rm --cached --ignore-unmatch <file>" \
  --prune-empty --tag-name-filter cat -- --all
```

## ブランチ管理

### ブランチ一覧確認

```bash
# ローカルブランチ
git branch

# リモートブランチ
git branch -r

# すべてのブランチ
git branch -a
```

### 不要なブランチ削除

```bash
# ローカルブランチ削除
git branch -d <branch-name>

# リモートブランチ削除
git push origin --delete <branch-name>
```

## ベストプラクティス

### ✅ 良い習慣

```bash
# 1. 作業前に最新を取得
git pull

# 2. feature ブランチで作業
git checkout -b feature/new-feature

# 3. 小さなコミットを頻繁に
git commit -m "feat: 機能Aを追加"
git commit -m "test: 機能Aのテストを追加"

# 4. 定期的にプッシュ
git push
```

### ❌ 避けるべき習慣

```bash
# main ブランチへの直接プッシュ
git checkout main
git push

# 巨大なコミット
git add .
git commit -m "色々修正"

# 長期間プッシュしない（数日〜数週間）
```

## CI/CD統合

### GitHub Actions

```yaml
# .github/workflows/ci.yml
name: CI

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Setup Node.js
        uses: actions/setup-node@v3
      - name: Install dependencies
        run: npm ci
      - name: Run tests
        run: npm test
      - name: Build
        run: npm run build
```

## 完了確認

- [ ] プッシュが成功
- [ ] リモートリポジトリに反映されている
- [ ] CI/CD パイプラインがパス
- [ ] プルリクエストを作成（該当する場合）
- [ ] レビュアーに通知（該当する場合）

これでワークフローの全11フェーズが完了です！
