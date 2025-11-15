---
applyTo: "**/*.ts,**/*.tsx,**/*.js,**/*.jsx"
---

# Phase 5: Implementation（実装フェーズ）専用指示

このフェーズでは、**高品質なコードの実装**を行います。

## 必須ツール

- **Serena MCP**: シンボルベース編集
- **@terminal**: コマンド実行、パッケージインストール

## コーディング標準

### 1. インポート規則

```typescript
// ✅ 良い例: 明示的インポート
import { Button } from '@/components/ui/button'
import { formatDate } from '@/lib/utils/date'
import { type User } from '@/types/user'

// ❌ 悪い例: バレルインポート（禁止）
import { Button, formatDate, User } from '@/lib'
```

### 2. 型安全性

```typescript
// ✅ 良い例: 厳格な型付け
interface UserProps {
  id: string
  name: string
  age: number
}

function UserCard({ id, name, age }: UserProps) {
  // 実装
}

// ❌ 悪い例: any使用（禁止）
function UserCard(props: any) {
  // @ts-ignore も禁止
}
```

### 3. コメント規則

```typescript
/**
 * ユーザー情報を取得する
 * @param userId - ユーザーID
 * @returns ユーザー情報、存在しない場合はnull
 */
async function fetchUser(userId: string): Promise<User | null> {
  // APIエンドポイントを呼び出し
  const response = await fetch(`/api/users/${userId}`)
  
  // 404の場合はnullを返す
  if (response.status === 404) {
    return null
  }
  
  return response.json()
}
```

### 4. エラーハンドリング

```typescript
// ✅ 良い例: 非同期操作
fetchUser(userId)
  .then(user => {
    if (user) {
      console.log('ユーザー取得成功:', user.name)
    }
  })
  .catch(error => {
    console.error('ユーザー取得失敗:', error)
    showErrorToast('ユーザー情報の取得に失敗しました')
  })

// ✅ 良い例: 同期エラー
try {
  const result = JSON.parse(jsonString)
  return result
} catch (error) {
  console.error('JSON解析失敗:', error)
  return null
}
```

### 5. Reactパターン

```typescript
// ✅ 良い例: Server Component優先
async function UserList() {
  const users = await fetchUsers() // サーバーで実行
  
  return (
    <ul>
      {users.map(user => (
        <li key={user.id}>{user.name}</li>
      ))}
    </ul>
  )
}

// ✅ 良い例: 必要な場合のみClient Component
'use client'

function Counter() {
  const [count, setCount] = useState(0)
  
  return (
    <button onClick={() => setCount(c => c + 1)}>
      カウント: {count}
    </button>
  )
}
```

## 実装チェックリスト

- [ ] バレルインポートを使用していない
- [ ] `any`型を使用していない
- [ ] `@ts-ignore`を使用していない
- [ ] 複雑なロジックに日本語コメントを追加
- [ ] エラーハンドリングを適切に実装
- [ ] Server ComponentsとClient Componentsを適切に使い分け
- [ ] ビジネスロジックをユーティリティに分離

## 注意事項

- コミット前に必ず型チェックとリントを実行
- 大きな変更は小さなコミットに分割
- 各コミットは動作する状態を保つ
