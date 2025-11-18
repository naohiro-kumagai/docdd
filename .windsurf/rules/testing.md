# テスト戦略と規約

## テストフレームワーク

### 単体・統合テスト
- **フレームワーク**: Vitest
- **コンポーネントテスト**: React Testing Library
- **カバレッジ目標**: クリティカルパスは100%ブランチカバレッジ

### E2Eテスト
- **フレームワーク**: Playwright
- **実行環境**: Docker（`mcr.microsoft.com/playwright`）
- **ブラウザ**: Chromium, Firefox, WebKit（必要に応じて）

## テスト記述規約

### AAAパターン（必須）
すべてのテストはArrange-Act-Assertパターンに従う。

```typescript
import { describe, expect, test } from 'vitest'
import { calculateTotal } from './cart-utils'

describe('calculateTotal', () => {
  test('商品が空の場合、0を返すこと', () => {
    // Arrange: テストデータの準備
    const items = []
    const expected = 0

    // Act: テスト対象の実行
    const actual = calculateTotal(items)

    // Assert: 結果の検証
    expect(actual).toBe(expected)
  })

  test('複数商品の合計を正しく計算すること', () => {
    // Arrange
    const items = [
      { price: 1000, quantity: 2 },
      { price: 500, quantity: 1 }
    ]
    const expected = 2500

    // Act
    const actual = calculateTotal(items)

    // Assert
    expect(actual).toBe(expected)
  })
})
```

### テストタイトル形式（日本語・必須）

**フォーマット**: `[条件]の場合、[期待される結果]こと`

```typescript
// ✅ 良い例: 条件と期待が明確
test('ユーザーがログイン済みの場合、ダッシュボードを表示すること', () => {})
test('入力値が空の場合、バリデーションエラーを返すこと', () => {})
test('disabled=trueの場合、クリックできないこと', () => {})

// ❌ 悪い例: 曖昧
test('正常系', () => {})
test('テスト1', () => {})
test('works', () => {})
```

## コンポーネントテスト

### React Testing Library使用例
```typescript
import { render, screen, fireEvent } from '@testing-library/react'
import { describe, expect, test, vi } from 'vitest'
import { Button } from './button'

describe('Button', () => {
  test('クリック時にonClickハンドラーが呼ばれること', () => {
    // Arrange
    const handleClick = vi.fn()
    render(<Button onClick={handleClick}>クリック</Button>)

    // Act
    const button = screen.getByRole('button', { name: 'クリック' })
    fireEvent.click(button)

    // Assert
    expect(handleClick).toHaveBeenCalledTimes(1)
  })

  test('disabled時はクリックできないこと', () => {
    // Arrange
    const handleClick = vi.fn()
    render(<Button onClick={handleClick} disabled>クリック</Button>)

    // Act
    const button = screen.getByRole('button', { name: 'クリック' })
    fireEvent.click(button)

    // Assert
    expect(handleClick).not.toHaveBeenCalled()
    expect(button).toBeDisabled()
  })
})
```

## テストカバレッジ要件

### 必須カバレッジ
- **ビジネスロジック**: 100%ブランチカバレッジ
- **ユーティリティ関数**: 90%以上
- **UIコンポーネント**: 主要な条件分岐とイベントハンドラ

### カバレッジ対象外（許容）
- 型定義のみのファイル
- 自動生成コード
- モックデータ

## モック戦略

### API呼び出しのモック
```typescript
import { vi } from 'vitest'

// ✅ 関数レベルでモック
vi.mock('@/lib/api', () => ({
  fetchUser: vi.fn().mockResolvedValue({
    id: '1',
    name: 'テストユーザー'
  })
}))

test('ユーザー情報を取得して表示すること', async () => {
  // モックされたAPIを使用
  const user = await fetchUser('1')
  expect(user.name).toBe('テストユーザー')
})
```

### 環境変数のモック
```typescript
import { vi } from 'vitest'

test('API_URLが設定されていること', () => {
  // Arrange
  vi.stubEnv('API_URL', 'https://api.test.com')

  // Act & Assert
  expect(process.env.API_URL).toBe('https://api.test.com')

  // Cleanup
  vi.unstubAllEnvs()
})
```

## E2Eテスト

### Playwright基本構成
```typescript
import { test, expect } from '@playwright/test'

test.describe('ユーザー認証フロー', () => {
  test('ログインに成功した場合、ダッシュボードにリダイレクトされること', async ({ page }) => {
    // Arrange: ログインページに移動
    await page.goto('http://localhost:3000/login')

    // Act: 認証情報を入力してログイン
    await page.fill('input[name="email"]', 'test@example.com')
    await page.fill('input[name="password"]', 'password123')
    await page.click('button[type="submit"]')

    // Assert: ダッシュボードに遷移
    await expect(page).toHaveURL('http://localhost:3000/dashboard')
    await expect(page.locator('h1')).toContainText('ダッシュボード')
  })
})
```

## テスト実行と品質保証

### コミット前チェック（Phase 8必須）
```bash
# 1. 型チェック
npm run type-check

# 2. リント
npm run lint

# 3. テスト実行
npm run test

# 4. ビルド確認
npm run build
```

### CI/CDでの実行
- すべてのプルリクエストでテスト実行必須
- カバレッジレポートの自動生成
- E2Eテストは本番環境デプロイ前に実行

## Storybookによるビジュアルテスト

### ストーリー作成（推奨）
```typescript
import type { Meta, StoryObj } from '@storybook/react'
import { Button } from './button'

const meta: Meta<typeof Button> = {
  title: 'UI/Button',
  component: Button,
  tags: ['autodocs']
}

export default meta
type Story = StoryObj<typeof Button>

export const Primary: Story = {
  args: {
    variant: 'primary',
    children: 'プライマリボタン'
  }
}

export const Disabled: Story = {
  args: {
    variant: 'primary',
    disabled: true,
    children: '無効化ボタン'
  }
}

export const Loading: Story = {
  args: {
    variant: 'primary',
    loading: true,
    children: '読み込み中'
  }
}
```

## テスト作成のタイミング

### Phase 6: Testing & Stories
- 新機能実装後、必ずテストを追加
- ロジック変更時はテストも更新
- バグ修正時は再現テストを先に作成（TDD的アプローチ）

### テストスキップが許容されるケース
- UIのみの変更でロジックなし
- ドキュメントのみの更新
- ただし、Phase 7（コードレビュー）で正当化が必要
