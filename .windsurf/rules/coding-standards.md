# コーディング規約

## 命名規則

### TypeScript/JavaScript
- **変数・関数**: キャメルケース（`camelCase`）
- **定数**: 大文字スネークケース（`UPPER_SNAKE_CASE`）
- **型・インターフェース・クラス**: パスカルケース（`PascalCase`）
- **ファイル名**: ケバブケース（`kebab-case.tsx`）

### React コンポーネント
- **コンポーネント名**: パスカルケース（`UserProfile.tsx`）
- **hooks**: `use` プレフィックス必須（`useAuth`, `useUserData`）
- **ファイル構成**: 1コンポーネント = 1ファイル

## コメント方針

### 日本語でのコメント（必須）
```typescript
// ✅ 良い例: 意図を明確に説明
/**
 * ユーザー認証トークンを検証し、有効期限をチェックする
 * @param token - JWTトークン文字列
 * @returns トークンが有効な場合はtrue
 */
function validateToken(token: string): boolean {
  // トークンのフォーマット検証
  if (!token.startsWith('Bearer ')) {
    return false
  }
  
  // 有効期限チェック（24時間以内）
  const expiresAt = parseTokenExpiry(token)
  return Date.now() < expiresAt
}
```

### 不要なコメント（避ける）
```typescript
// ❌ 悪い例: コード自体が説明している
// iを1増やす
i++

// ❌ 悪い例: 古い情報
// TODO: あとで修正 (作成: 2023年) ← 現在2025年
```

## エラーハンドリング標準

### 非同期処理
```typescript
// ✅ 推奨: .then().catch() パターン
fetchUserData(userId)
  .then(user => {
    updateUserProfile(user)
  })
  .catch(error => {
    console.error('ユーザーデータ取得失敗:', error)
    showErrorNotification('データの読み込みに失敗しました')
  })
```

### 同期処理
```typescript
// ✅ try-catch は同期エラー用に予約
try {
  const data = JSON.parse(rawData)
  processData(data)
} catch (error) {
  handleParseError(error)
}
```

## インポート規則

### 明示的パスインポート（必須）
```typescript
// ✅ 良い例: 明示的な @/ インポート
import { Button } from '@/components/ui/button'
import { formatDate } from '@/lib/utils/date'
import { UserService } from '@/services/user-service'

// ❌ 悪い例: バレルインポート禁止
import { Button, formatDate, UserService } from '@/lib'
```

### インポート順序
1. React・Next.js等のフレームワーク
2. サードパーティライブラリ
3. `@/` で始まる内部モジュール
4. 相対パス（`./`, `../`）
5. 型定義のインポート（`import type`）

## 型定義の徹底

### 厳格な型付け
```typescript
// ✅ 良い例: 明確な型定義
interface User {
  id: string
  name: string
  email: string
  createdAt: Date
}

function getUserById(id: string): Promise<User> {
  return fetch(`/api/users/${id}`).then(res => res.json())
}

// ❌ 悪い例: any型の使用
function processData(data: any) { // 禁止
  return data.map((item: any) => item.value) // 禁止
}
```

### 型推論の活用
```typescript
// ✅ 推論可能な場合は型注釈省略可
const count = 0 // number と推論される
const users = [] as User[] // 明示的な初期化が必要な場合
```

## コード品質の保証

### 非交渉事項
- すべての品質チェック（type-check, lint, test, build）がパス必須
- `@ts-ignore` や `eslint-disable` の使用禁止
- コミット前の品質確認必須

### 例外処理が必要な場合
- 必ずコードレビューで正当化する
- ADR（アーキテクチャ決定記録）として文書化する
