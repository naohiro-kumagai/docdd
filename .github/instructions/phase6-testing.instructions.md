---
applyTo: "**/*.test.ts,**/*.test.tsx,**/*.spec.ts,**/*.spec.tsx,**/*.stories.tsx"
---

# Phase 6: Testing & Stories（テストフェーズ）専用指示

このフェーズでは、**品質保証のためのテストとStorybookストーリー**を作成します。

## スキップ可能なケース

- UIのみの変更でロジックがない
- ドキュメントのみの変更

## テスト作成標準

### 1. AAAパターン

```typescript
import { describe, it, expect } from 'vitest'
import { calculateTotal } from './utils'

describe('calculateTotal', () => {
  it('合計金額を正しく計算する', () => {
    // Arrange（準備）
    const items = [
      { price: 100, quantity: 2 },
      { price: 200, quantity: 1 }
    ]
    
    // Act（実行）
    const result = calculateTotal(items)
    
    // Assert（検証）
    expect(result).toBe(400)
  })
  
  it('空の配列の場合は0を返す', () => {
    // Arrange
    const items: Item[] = []
    
    // Act
    const result = calculateTotal(items)
    
    // Assert
    expect(result).toBe(0)
  })
})
```

### 2. 日本語テストタイトル

```typescript
// ✅ 良い例: わかりやすい日本語
describe('ユーザー認証', () => {
  it('正しい認証情報でログインできる', () => {})
  it('誤った認証情報でログインに失敗する', () => {})
  it('ログアウト後はアクセスできない', () => {})
})

// ❌ 悪い例: 英語や曖昧な表現
describe('Auth', () => {
  it('should work', () => {})
  it('test login', () => {})
})
```

### 3. カバレッジ目標

- **クリティカルパス**: 100%ブランチカバレッジ
- **ビジネスロジック**: 80%以上
- **UIコンポーネント**: 主要なpropsパターン

## Storybookストーリー

### 基本構造

```typescript
import type { Meta, StoryObj } from '@storybook/react'
import { Button } from './button'

const meta: Meta<typeof Button> = {
  title: 'UI/Button',
  component: Button,
  tags: ['autodocs'],
}

export default meta
type Story = StoryObj<typeof Button>

// 基本パターン
export const Default: Story = {
  args: {
    children: 'ボタン',
  },
}

// バリエーション
export const Primary: Story = {
  args: {
    variant: 'primary',
    children: '主要アクション',
  },
}

export const Disabled: Story = {
  args: {
    disabled: true,
    children: '無効なボタン',
  },
}

// インタラクション例
export const Loading: Story = {
  args: {
    isLoading: true,
    children: '読み込み中',
  },
}
```

### 条件分岐の網羅

```typescript
// コンポーネントに条件分岐がある場合、すべてのパターンをストーリー化
export const Success: Story = {
  args: { status: 'success', message: '成功しました' },
}

export const Error: Story = {
  args: { status: 'error', message: 'エラーが発生しました' },
}

export const Warning: Story = {
  args: { status: 'warning', message: '注意が必要です' },
}
```

## テストチェックリスト

- [ ] AAAパターンに従っている
- [ ] テストタイトルが日本語でわかりやすい
- [ ] エッジケース（空配列、null、undefined）をテスト
- [ ] エラーケースをテスト
- [ ] 非同期処理を適切にテスト（async/await）
- [ ] クリティカルパスは100%カバー

## Storybookチェックリスト

- [ ] 主要なpropsパターンをカバー
- [ ] 条件分岐ごとにストーリーを作成
- [ ] インタラクティブな状態（hover、focus、disabled）を網羅
- [ ] アクセシビリティチェック（autodocs活用）

## 注意事項

- テストは実装と同時に作成（TDD推奨）
- テストコードも品質を重視（重複排除、可読性）
- Storybookはドキュメントとしても機能する
