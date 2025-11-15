---
applyTo: "**/*"
---

# Phase 7: Code Review（コードレビューフェーズ）専用指示

このフェーズでは、**コード品質とパフォーマンスの最適化**を行います。

## 実行すべきケース

- コード品質に懸念がある場合
- 複雑なロジックを実装した場合
- パフォーマンス最適化が必要な場合
- リファクタリング時

## レビュー観点

### 1. SOLID原則チェック

```typescript
// ✅ 良い例: 単一責任の原則（SRP）
class UserValidator {
  validate(user: User): ValidationResult {
    // バリデーションのみに集中
  }
}

class UserRepository {
  save(user: User): Promise<void> {
    // データ永続化のみに集中
  }
}

// ❌ 悪い例: 複数の責任
class UserManager {
  validate(user: User) { /* ... */ }
  save(user: User) { /* ... */ }
  sendEmail(user: User) { /* ... */ }
  generateReport(user: User) { /* ... */ }
}
```

### 2. コードスメル検出

#### 長すぎる関数
```typescript
// ❌ 悪い例: 100行を超える関数
function processOrder(order: Order) {
  // ... 100行以上のロジック
}

// ✅ 良い例: 小さな関数に分割
function processOrder(order: Order) {
  validateOrder(order)
  calculateTotal(order)
  applyDiscounts(order)
  updateInventory(order)
  sendConfirmation(order)
}
```

#### 重複コード
```typescript
// ❌ 悪い例: 重複
function formatUserName(user: User) {
  return `${user.firstName} ${user.lastName}`
}

function formatAuthorName(author: Author) {
  return `${author.firstName} ${author.lastName}`
}

// ✅ 良い例: 共通化
function formatFullName(person: { firstName: string; lastName: string }) {
  return `${person.firstName} ${person.lastName}`
}
```

### 3. パフォーマンス考慮

```typescript
// ❌ 悪い例: 不要な再レンダリング
function Parent() {
  const [count, setCount] = useState(0)
  
  return (
    <div>
      <button onClick={() => setCount(c => c + 1)}>
        カウント: {count}
      </button>
      <ExpensiveChild data={someData} />
    </div>
  )
}

// ✅ 良い例: メモ化で最適化
function Parent() {
  const [count, setCount] = useState(0)
  const memoizedData = useMemo(() => someData, [])
  
  return (
    <div>
      <button onClick={() => setCount(c => c + 1)}>
        カウント: {count}
      </button>
      <MemoizedExpensiveChild data={memoizedData} />
    </div>
  )
}

const MemoizedExpensiveChild = memo(ExpensiveChild)
```

### 4. セキュリティチェック

```typescript
// ❌ 悪い例: XSS脆弱性
function UserProfile({ bio }: { bio: string }) {
  return <div dangerouslySetInnerHTML={{ __html: bio }} />
}

// ✅ 良い例: エスケープ処理
function UserProfile({ bio }: { bio: string }) {
  return <div>{bio}</div>
}

// または: サニタイズライブラリ使用
import DOMPurify from 'dompurify'

function UserProfile({ bio }: { bio: string }) {
  const sanitized = DOMPurify.sanitize(bio)
  return <div dangerouslySetInnerHTML={{ __html: sanitized }} />
}
```

## レビューチェックリスト

### コード品質
- [ ] SOLID原則に従っている
- [ ] 関数は1つの責任のみを持つ
- [ ] コードの重複がない
- [ ] 命名が明確でわかりやすい
- [ ] マジックナンバーを使用していない

### パフォーマンス
- [ ] 不要な再レンダリングがない
- [ ] 重い計算はメモ化されている
- [ ] 大きなリストは仮想化されている
- [ ] 画像は最適化されている
- [ ] バンドルサイズが適切

### セキュリティ
- [ ] XSS対策がされている
- [ ] 機密情報がログに出力されていない
- [ ] 入力値のバリデーションがある
- [ ] 認証・認可が適切に実装されている

### 保守性
- [ ] テストが十分にある
- [ ] コメントが適切にある
- [ ] 依存関係が最小限
- [ ] 設定が環境変数で管理されている

## 出力フォーマット

レビュー結果は以下の構造で提示してください：

```markdown
## コードレビュー結果

### 良い点
- ○○が適切に実装されている
- △△のパターンが優れている

### 改善提案
1. **ファイル名**: `src/components/UserCard.tsx`
   - 問題: ××が冗長
   - 提案: □□に変更
   - 理由: ◇◇のため

2. **ファイル名**: `src/lib/utils.ts`
   - 問題: パフォーマンス懸念
   - 提案: メモ化を追加
   - 理由: 頻繁に呼ばれるため

### ADR更新
- パターン変更があれば、ADRを更新してください
```

## 注意事項

- 完璧を求めすぎない（実用的な品質を目指す）
- リファクタリングは段階的に
- パフォーマンス最適化は測定してから
