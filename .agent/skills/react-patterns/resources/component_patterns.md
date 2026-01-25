# コンポーネントパターン

## Presenterパターン

```typescript
// ✅ ロジック層
export async function UserPage({ userId }: Props) {
  const user = await fetchUser(userId);
  const permissions = await checkPermissions(userId);
  
  return <UserPagePresenter user={user} canEdit={permissions.canEdit} />;
}

// ✅ 表示層（すべてprops経由で制御）
function UserPagePresenter({ user, canEdit }: PresenterProps) {
  return (
    <div>
      <h1>{user.name}</h1>
      {canEdit && <EditButton />}
    </div>
  );
}
```

## Props経由の条件制御

```typescript
// ✅ すべての条件分岐はprops経由
interface CardProps {
  title: string;
  showFooter: boolean;
  variant: 'default' | 'highlighted';
}

function Card({ title, showFooter, variant }: CardProps) {
  return (
    <div className={variant === 'highlighted' ? 'bg-blue' : 'bg-white'}>
      <h2>{title}</h2>
      {showFooter && <CardFooter />}
    </div>
  );
}
```

## useEffect最小化

```typescript
// ❌ 避ける: 不要なuseEffect
useEffect(() => {
  setFilteredData(data.filter(item => item.active));
}, [data]);

// ✅ 推奨: 直接計算
const filteredData = data.filter(item => item.active);
```
