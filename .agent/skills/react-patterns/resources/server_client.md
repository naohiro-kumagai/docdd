# Server Component vs Client Component

## Server Component（デフォルト）

### 使用するケース
- データフェッチング
- バックエンドリソースへの直接アクセス
- 機密情報（APIキー等）の使用
- 大きな依存関係のサーバー保持

### 特徴
- サーバーでのみ実行
- クライアントバンドルに含まれない
- async/awaitが使用可能

## Client Component

### 使用するケース
- インタラクティブ性が必要（onClick等）
- ブラウザAPIの使用
- useState、useEffectの使用
- カスタムフックの使用

### 宣言方法
```typescript
'use client';

function InteractiveButton() {
  const [count, setCount] = useState(0);
  return <button onClick={() => setCount(c => c + 1)}>{count}</button>;
}
```

## 境界パターン

```typescript
// Server Component（親）
async function Page() {
  const data = await fetchData();
  return <ClientComponent data={data} />;
}

// Client Component（子）
'use client';
function ClientComponent({ data }) {
  const [state, setState] = useState(data);
  // ...
}
```
