# Phase 5: Implementation（実装フェーズ）

このフェーズでは、**高品質なコードの実装**を行います。

## 前提確認

- [ ] Phase 1のADR確認が完了していること
- [ ] Phase 4で計画が立案されていること
- [ ] UI変更がある場合、Phase 3で承認を得ていること

## 使用ツール

- **Serena MCP**: シンボルベース編集
- **Bash**: コマンド実行

## コーディング標準

### 1. インポート規則（重要）

```typescript
// ✅ 良い例: 明示的インポート
import { Button } from '@/components/ui/button'
import { formatDate } from '@/lib/utils/date'
import { type User } from '@/types/user'

// ❌ 悪い例: バレルインポート（禁止）
import { Button, formatDate, User } from '@/lib'
```

### 2. 型安全性（非交渉事項）

```typescript
// ✅ 良い例: 厳格な型付け
interface UserProps {
  id: string
  name: string
  age: number
}

// ❌ 悪い例: any使用（禁止）
function UserCard(props: any) {}  // 禁止
// @ts-ignore  // 禁止
```

### 3. コメント規則

- すべてのコメントは**日本語**で記述
- 複雑なロジックには必ず説明を追加

```typescript
/**
 * ユーザー情報を取得する
 * @param userId - ユーザーID
 * @returns ユーザー情報、存在しない場合はnull
 */
async function fetchUser(userId: string): Promise<User | null> {
  // APIエンドポイントを呼び出し
  const response = await fetch(`/api/users/${userId}`)
  return response.json()
}
```

### 4. エラーハンドリング

```typescript
// ✅ 非同期操作: .then().catch()を優先
fetchUser(userId)
  .then(user => console.log('取得成功:', user))
  .catch(error => console.error('取得失敗:', error))

// ✅ 同期エラー: try-catch
try {
  const result = JSON.parse(jsonString)
} catch (error) {
  console.error('JSON解析失敗:', error)
}
```

### 5. Reactパターン

```typescript
// ✅ Server Component優先
async function UserList() {
  const users = await fetchUsers()
  return <UserListPresenter users={users} />
}

// ✅ 必要な場合のみClient Component
'use client'
function Counter() {
  const [count, setCount] = useState(0)
  return <button onClick={() => setCount(c => c + 1)}>{count}</button>
}
```

## Serena MCPの使用例

### シンボルの置換
```javascript
mcp__serena__replace_symbol_body({
  name_path: 'UserAuth/validateToken',
  relative_path: 'src/auth/user.ts',
  body: '新しい関数実装'
})
```

### 新しいコードの挿入
```javascript
mcp__serena__insert_after_symbol({
  name_path: 'UserAuth',
  relative_path: 'src/auth/user.ts',
  body: '新しいメソッドの実装'
})
```

## 完了チェックリスト

- [ ] バレルインポートを使用していない
- [ ] `any`型を使用していない
- [ ] `@ts-ignore`を使用していない
- [ ] 複雑なロジックに日本語コメントを追加
- [ ] エラーハンドリングを適切に実装
- [ ] Server/Client Componentsを適切に使い分け
- [ ] TodoWriteで進捗更新済み

---

**質問**: 実装するタスクを教えてください。
