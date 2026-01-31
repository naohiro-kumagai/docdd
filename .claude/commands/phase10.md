# Phase 10: Git Commit（コミットフェーズ）

このフェーズでは、**変更内容の確認とコミット作成**を行います。

## 前提確認

- [ ] Phase 8の品質チェックがすべてパス
- [ ] Phase 9Aのランタイム確認が完了

## 実行手順

### 1. 変更内容の確認

```bash
# 変更されたファイルを確認
git status

# 差分を確認
git diff

# 直近のコミット履歴を確認
git log --oneline -5
```

### 2. コミットメッセージ作成

**フォーマット**: `<type>: <description>`

**タイプ一覧**:
- `feat`: 新機能
- `fix`: バグ修正
- `refactor`: リファクタリング
- `docs`: ドキュメント
- `test`: テスト
- `style`: スタイル（コードの動作に影響しない変更）
- `chore`: ビルド、ツール関連

**例**:
```
feat: ユーザー認証フローを追加
fix: ログイン時のバリデーションエラーを修正
refactor: UserCardコンポーネントを分割
docs: APIエンドポイントのドキュメントを追加
test: calculateTotal関数のテストを追加
```

### 3. コミット実行

```bash
# ファイルをステージング（個別に追加を推奨）
git add src/components/user/UserCard.tsx
git add src/utils/validation.ts

# または全ファイル（注意して使用）
git add .

# コミット作成
git commit -m "feat: 機能の説明

詳細な説明（必要に応じて）

Co-Authored-By: Claude Opus 4.5 <noreply@anthropic.com>"
```

## 注意事項

- **センシティブファイルを含めない**: `.env`、認証情報などは除外
- **大きすぎる変更は分割**: 論理的にまとまった単位でコミット
- **コミットメッセージは簡潔に**: 1行目は50文字以内を目安

## 完了チェックリスト

- [ ] git statusで意図しないファイルが含まれていない
- [ ] コミットメッセージが適切
- [ ] 変更内容が論理的にまとまっている
- [ ] センシティブな情報が含まれていない

## 次のステップ

コミットが完了したら、必要に応じてプッシュします。

```bash
git push origin <branch-name>
```

---

**質問**: コミットを作成しますか？変更内容を確認して適切なコミットメッセージを提案します。
