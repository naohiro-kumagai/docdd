---
applyTo: "**/*.ts,**/*.tsx"
---

# TypeScript専用コーディング規約

## 型安全性（非交渉事項）

- `any`の使用は**絶対禁止**
- `@ts-ignore`、`@ts-expect-error`の使用は**絶対禁止**
- すべての関数に明示的な戻り値の型を定義
- すべてのパラメータに型注釈を付ける

## インポート規約

**バレルインポートを使用しない**（重要）

```typescript
// ✅ 正しい: 明示的インポート
import { Button } from '@/components/ui/button'
import { Card } from '@/components/ui/card'
import { formatDate } from '@/lib/utils/date'

// ❌ 間違い: バレルインポート
import { Button, Card } from '@/components/ui'
import { formatDate } from '@/lib/utils'
```

## 命名規約

- コンポーネント: PascalCase（例: `UserProfile`）
- 関数/変数: camelCase（例: `getUserData`）
- 定数: UPPER_SNAKE_CASE（例: `MAX_RETRY_COUNT`）
- 型/インターフェース: PascalCase、`I`接頭辞なし（例: `User`、`UserProfile`）

## コメント

- すべてのコメントは**日本語**で記述
- 複雑なロジックには必ず説明を追加
- TODO、FIXME、HACKには必ず担当者と日付を記載

```typescript
// ✅ 良い例
// ユーザーの認証状態を確認し、トークンの有効期限をチェックする
// TODO(kumagai, 2025-11-14): リフレッシュトークン対応を追加
const validateToken = (token: string): boolean => {
  // ...
}
```
