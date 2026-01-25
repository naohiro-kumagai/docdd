# 命名規約

## 基本ルール

| 種類 | 規約 | 例 |
|------|------|-----|
| 型/インターフェース | PascalCase | `UserProfile`, `ApiResponse` |
| クラス | PascalCase | `UserService`, `HttpClient` |
| 変数/関数 | camelCase | `userName`, `fetchUsers` |
| 定数 | UPPER_SNAKE_CASE | `MAX_RETRIES`, `API_BASE_URL` |
| プライベート | _prefix | `_internalState` |
| Boolean | is/has/can prefix | `isActive`, `hasPermission` |

## インターフェース

```typescript
// ✅ Props接尾辞
interface ButtonProps {
  label: string;
  onClick: () => void;
}

// ✅ 機能を表す名前
interface Serializable {
  serialize(): string;
}

// ❌ Iプレフィックス（避ける）
interface IUser { }
```

## ファイル命名

| 種類 | 規約 | 例 |
|------|------|-----|
| コンポーネント | kebab-case | `user-card.tsx` |
| ユーティリティ | kebab-case | `date-utils.ts` |
| 型定義 | kebab-case | `user.types.ts` |
| テスト | `.test.ts` | `user-card.test.tsx` |
| Storybook | `.stories.tsx` | `user-card.stories.tsx` |
