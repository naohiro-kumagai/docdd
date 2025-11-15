---
applyTo: "**/*"
---

# Phase 8: Quality Checks（品質チェックフェーズ）専用指示

このフェーズでは、**すべての品質チェックを実行**します。

## 必須チェック

コミット前に以下をすべて実行し、すべてパスする必要があります。

### 1. 型チェック

```bash
npm run type-check
# または
bun run type-check
# または
yarn type-check
```

**期待する結果**: エラーなし

### 2. リントチェック

```bash
npm run lint
# または
bun run lint
# または
yarn lint
```

**期待する結果**: エラーなし（警告は要確認）

### 3. テスト実行

```bash
npm run test
# または
bun test
# または
yarn test
```

**期待する結果**: すべてのテストがパス

### 4. ビルドチェック

```bash
npm run build
# または
bun run build
# または
yarn build
```

**期待する結果**: ビルド成功

## エラー対応

### 型エラー

```typescript
// エラー例: Type 'string' is not assignable to type 'number'
const age: number = "25" // ❌

// 修正: 型を合わせる
const age: number = 25 // ✅
```

### リントエラー

```typescript
// エラー例: 'React' must be in scope when using JSX
function MyComponent() {
  return <div>Hello</div> // ❌
}

// 修正: Reactをインポート（React 17未満の場合）
import React from 'react'

function MyComponent() {
  return <div>Hello</div> // ✅
}

// または: React 17+では不要だが、設定を確認
```

### テスト失敗

```typescript
// 失敗例: Expected 5 but received 4
it('合計を計算する', () => {
  expect(sum(2, 2)).toBe(5) // ❌
})

// 修正: 期待値を正しく設定
it('合計を計算する', () => {
  expect(sum(2, 2)).toBe(4) // ✅
})
```

### ビルドエラー

```bash
# エラー例: Module not found
Error: Cannot find module '@/components/Button'

# 修正手順:
1. ファイルパスを確認
2. tsconfig.jsonのpathsを確認
3. 必要に応じてファイルを作成またはインポートパスを修正
```

## チェックリスト

実行前:
- [ ] すべての変更をステージング (`git add`)
- [ ] 不要なconsole.logを削除
- [ ] コメントアウトされたコードを削除
- [ ] TODOコメントを確認（重要なものは Issue化）

実行結果:
- [ ] `type-check`: エラーなし
- [ ] `lint`: エラーなし
- [ ] `test`: すべてパス
- [ ] `build`: 成功

すべてパス後:
- [ ] 変更内容を再確認
- [ ] コミットメッセージを準備

## 自動修正

可能な場合は自動修正を活用:

```bash
# リントエラーの自動修正
npm run lint -- --fix

# フォーマット自動修正
npm run format
# または
npx prettier --write "src/**/*.{ts,tsx}"
```

## 注意事項

- **すべてのチェックがパス必須**: 1つでも失敗したら次のフェーズに進めない
- エラーを無視しない（`@ts-ignore`、`eslint-disable`は禁止）
- 修正が難しい場合は設計を見直す
- CI/CDでも同じチェックが実行されることを意識
