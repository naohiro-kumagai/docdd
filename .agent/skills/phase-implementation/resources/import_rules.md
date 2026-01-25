# インポート規則

## バレルインポートを使用しない（重要）

```typescript
// ✅ 正しい: 明示的インポート
import { Button } from '@/components/ui/button'
import { Card } from '@/components/ui/card'
import { formatDate } from '@/lib/utils/date'

// ❌ 間違い: バレルインポート
import { Button, Card } from '@/components/ui'
import { formatDate } from '@/lib/utils'
```

## 型インポート

```typescript
// 型のみの場合は type キーワードを使用
import { type User } from '@/types/user'
import type { ComponentProps } from 'react'
```

## パス構成

```
@/components/  - UIコンポーネント
@/lib/         - ユーティリティ、ヘルパー
@/types/       - 型定義
@/hooks/       - カスタムフック
@/actions/     - Server Actions
```
