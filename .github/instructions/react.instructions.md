---
applyTo: "**/*.tsx,**/components/**/*.ts"
---

# React/Next.js専用開発規約

## コンポーネント設計原則

### Server Components優先

```typescript
// ✅ デフォルトはServer Component
export default async function UserList() {
  const users = await fetchUsers()
  return <UserListPresenter users={users} />
}

// Client Componentは必要な場合のみ
'use client'
export function InteractiveButton() {
  const [count, setCount] = useState(0)
  return <button onClick={() => setCount(c => c + 1)}>{count}</button>
}
```

### Presenterパターンの徹底

ビジネスロジックと表示ロジックを分離：

```typescript
// ✅ ロジック層
export async function UserPage({ userId }: Props) {
  const user = await fetchUser(userId)
  const permissions = await checkPermissions(userId)
  
  return <UserPagePresenter user={user} canEdit={permissions.canEdit} />
}

// ✅ 表示層（すべてprops経由で制御）
function UserPagePresenter({ user, canEdit }: PresenterProps) {
  return (
    <div>
      <h1>{user.name}</h1>
      {canEdit && <EditButton />}
    </div>
  )
}
```

## React 19パターン

### useEffect最小化

```typescript
// ❌ 避ける: 不要なuseEffect
useEffect(() => {
  setFilteredData(data.filter(item => item.active))
}, [data])

// ✅ 推奨: 直接計算
const filteredData = data.filter(item => item.active)
```

### Props経由の条件制御

```typescript
// ✅ すべての条件分岐はprops経由
interface CardProps {
  title: string
  showFooter: boolean  // 条件はpropsで受け取る
  variant: 'default' | 'highlighted'
}

function Card({ title, showFooter, variant }: CardProps) {
  return (
    <div className={variant === 'highlighted' ? 'bg-blue' : 'bg-white'}>
      <h2>{title}</h2>
      {showFooter && <CardFooter />}
    </div>
  )
}
```

## ファイル構成

```
components/
  ui/
    button/
      index.tsx           # メインコンポーネント
      button.presenter.tsx  # 表示ロジック（必要に応じて）
      button.test.tsx      # テスト
      button.stories.tsx   # Storybook
```
