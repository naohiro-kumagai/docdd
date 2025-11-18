# バグ修正ワークフロー

バグ報告から修正、検証、デプロイまでの体系的なワークフロー。

## 実行方法
Windsurf Cascadeで `/fix-bug` と入力してください。

---

## Phase 1: Investigation & Research

### Step 1-1: バグの再現
1. バグ報告の内容を確認
2. 再現手順を特定
3. 期待される動作と実際の動作を明確化

### Step 1-2: 原因特定
1. エラーログ、スタックトレースを分析
2. 関連するコードファイルを特定
3. デバッガまたはconsole.logで原因箇所を絞り込む

### Step 1-3: 影響範囲の調査
1. 同様のバグが他の箇所にないか確認
2. 修正が他の機能に影響しないか評価

---

## Phase 4: Planning

### Step 2-1: 修正計画の作成
1. 修正アプローチを複数検討
2. 最もシンプルで安全な方法を選択
3. 必要な変更ファイルをリストアップ

### Step 2-2: テストケースの設計
1. バグを再現するテストケースを設計
2. 修正後の期待される振る舞いを定義

---

## Phase 5: Implementation

### Step 3-1: 再現テストの作成（TDD）
1. バグを再現するテストを先に作成
2. テストが失敗することを確認

```typescript
test('バグ再現: ユーザー名が空の場合、エラーが発生すること', () => {
  // Arrange
  const user = { name: '', email: 'test@example.com' }
  
  // Act & Assert
  expect(() => validateUser(user)).toThrow('ユーザー名は必須です')
})
```

### Step 3-2: バグ修正
1. 特定した原因箇所を修正
2. コーディング標準に従う
3. 修正理由をコメントで明記

```typescript
// バグ修正: ユーザー名の空文字チェックが漏れていた
if (!user.name || user.name.trim() === '') {
  throw new Error('ユーザー名は必須です')
}
```

### Step 3-3: テストの確認
1. 再現テストがパスすることを確認
2. 関連する既存テストがすべてパスすることを確認

---

## Phase 6: Testing

### Step 4-1: 追加テストの作成
1. エッジケースを網羅するテストを追加
2. 類似のバグが再発しないことを保証

```typescript
test('ユーザー名が空白のみの場合、エラーが発生すること', () => {
  const user = { name: '   ', email: 'test@example.com' }
  expect(() => validateUser(user)).toThrow('ユーザー名は必須です')
})

test('正常なユーザー名の場合、エラーが発生しないこと', () => {
  const user = { name: '山田太郎', email: 'test@example.com' }
  expect(() => validateUser(user)).not.toThrow()
})
```

---

## Phase 8: Quality Checks

### Step 5: 品質チェック
```bash
npm run type-check
npm run lint
npm run test
npm run build
```

すべてのチェックがパスすることを確認。

---

## Phase 9A: Runtime Verification

### Step 6-1: 開発環境での動作確認
```bash
npm run dev
```

### Step 6-2: 手動テスト
1. バグ報告と同じ手順で操作
2. バグが修正されていることを確認
3. 周辺機能が正常に動作することを確認

---

## Phase 9B: Browser Verification（UIバグの場合）

### Step 7: ブラウザでの検証
1. 各ブラウザで動作確認（Chrome, Firefox, Safari）
2. レスポンシブ表示の確認（モバイル、タブレット）
3. コンソールにエラーが出ていないことを確認

---

## Phase 10: Git Commit

### Step 8: コミット
```bash
git add .
git commit -m "fix: <バグの説明>

<詳細な説明>

Closes #<Issue番号>"
```

**例**:
```bash
git commit -m "fix: ユーザー名が空の場合にエラーが発生しない問題を修正

ユーザー名のバリデーションで空文字と空白のみのケースを
チェックしていなかったため、エラーが発生せずに処理が
続行されていた。

- validateUser関数にtrim()チェックを追加
- エッジケースのテストを追加

Closes #123"
```

---

## Phase 11: Push

### Step 9: プッシュとPR作成
```bash
git push origin fix/user-validation
```

### PR記載内容
- **バグの説明**: どのような問題があったか
- **原因**: なぜバグが発生したか
- **修正内容**: どのように修正したか
- **テスト**: どのようにテストしたか
- **影響範囲**: 他の機能への影響はあるか

---

## 完了

バグ修正ワークフローが完了しました！🐛✅

次のステップ:
- PRレビューの依頼
- QAチームへの検証依頼
- リリースノートへの記載
