# テストコード生成

指定されたコードに対してVitestテストを生成します。

## テスト規約

### 必須ルール

1. **Vitestからの明示的インポート**
   ```typescript
   import { describe, expect, test, vi } from "vitest"
   ```

2. **日本語のテストタイトル**
   - フォーマット: `[条件]の場合、[期待される結果]こと`
   - 例: "商品が空の場合、0を返すこと"

3. **AAAパターン厳守**
   - Arrange: テストデータの準備
   - Act: テスト対象の実行
   - Assert: 結果の検証

4. **フラットなdescribe構造**
   - ネストした`describe`ブロックは禁止
   - 共有データはトップレベルに配置

5. **1テスト1アサーション**
   - オブジェクトとして複数プロパティを比較可能

## テンプレート

### ロジックテスト

```typescript
import { describe, expect, test } from "vitest"
import { calculateTotal } from "./calculateTotal"

describe("calculateTotal", () => {
  test("商品が1つの場合、その価格を返すこと", () => {
    // Arrange
    const items = [{ price: 100 }]
    const expected = 100

    // Act
    const actual = calculateTotal(items)

    // Assert
    expect(actual).toBe(expected)
  })

  test("商品が空の場合、0を返すこと", () => {
    // Arrange
    const items: Array<{ price: number }> = []
    const expected = 0

    // Act
    const actual = calculateTotal(items)

    // Assert
    expect(actual).toBe(expected)
  })
})
```

### コンポーネントテスト

```typescript
import { render, screen } from "@testing-library/react"
import { describe, expect, test, vi } from "vitest"
import { Button } from "./Button"

describe("Button", () => {
  test("children が表示されること", () => {
    // Arrange
    const expected = "クリック"

    // Act
    render(<Button>{expected}</Button>)
    const actual = screen.getByRole("button", { name: expected })

    // Assert
    expect(actual).toBeInTheDocument()
  })

  test("disabled の場合、クリックできないこと", () => {
    // Arrange
    const handleClick = vi.fn()

    // Act
    render(<Button disabled onClick={handleClick}>クリック</Button>)
    const button = screen.getByRole("button")

    // Assert
    expect(button).toBeDisabled()
  })
})
```

### 共有データの管理

```typescript
describe("formatUser", () => {
  // トップレベルで共有データを定義
  const baseUser = {
    id: 1,
    firstName: "太郎",
    lastName: "山田",
    email: "taro@example.com"
  }

  test("フルネームが正しくフォーマットされること", () => {
    // Arrange
    const user = baseUser
    const expected = "山田 太郎"

    // Act
    const actual = formatUser(user).fullName

    // Assert
    expect(actual).toBe(expected)
  })
})
```

## チェックリスト

テスト生成時に確認：

- [ ] Vitestから必要な関数をインポート
- [ ] すべての条件分岐にテストが存在
- [ ] AAAパターンに従っている
- [ ] 1テスト1アサーション
- [ ] describeはフラット構造
- [ ] テストタイトルは日本語で具体的
- [ ] 振る舞いを検証（実装の詳細に依存しない）

---

**質問**: テストを生成したいファイルまたは関数を教えてください。
