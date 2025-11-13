# テスト生成プロンプト

指定されたコードに対してVitestテストを生成します。

## 要件

- Vitest / React Testing Library を使用
- AAAパターン（Arrange-Act-Assert）に従う
- 日本語のテストタイトル
- すべての条件分岐をカバー

## テストタイトルフォーマット

`[条件]の場合、[期待される結果]こと`

例:
- "商品が空の場合、0を返すこと"
- "disabled の場合、クリックできないこと"

## テンプレート

```typescript
import { describe, expect, test } from "vitest";
import { 対象関数 } from "./対象ファイル";

describe("対象関数", () => {
  test("条件の場合、結果こと", () => {
    // Arrange
    const input = /* テストデータ */;
    const expected = /* 期待値 */;

    // Act
    const actual = 対象関数(input);

    // Assert
    expect(actual).toBe(expected);
  });
});
```

## チェックリスト

テスト生成時に以下を確認：

- [ ] Vitestから必要な関数をインポート
- [ ] すべての条件分岐にテストが存在
- [ ] AAAパターンに従っている
- [ ] 1テスト1アサーション
- [ ] describeはフラット構造
- [ ] テストタイトルは日本語で具体的
