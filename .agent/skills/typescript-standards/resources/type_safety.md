# 型安全性ガイド

## 禁止事項

### anyの禁止

```typescript
// ❌ 禁止
function process(data: any): any {
  return data.value;
}

// ✅ 正しい
function process<T extends { value: unknown }>(data: T): T['value'] {
  return data.value;
}
```

### @ts-ignoreの禁止

```typescript
// ❌ 禁止
// @ts-ignore
someProblematicCode();

// ✅ 問題を解決する
// 型エラーの根本原因を修正
```

## 推奨パターン

### Union型でnull/undefinedを明示

```typescript
// ✅ nullの可能性を明示
function findUser(id: string): User | null {
  // ...
}
```

### 型ガードの活用

```typescript
function isUser(obj: unknown): obj is User {
  return typeof obj === 'object' && obj !== null && 'id' in obj;
}

// 使用
if (isUser(data)) {
  console.log(data.id); // 型安全
}
```

### Branded Types

```typescript
type UserId = string & { readonly __brand: unique symbol };

function createUserId(id: string): UserId {
  return id as UserId;
}
```
