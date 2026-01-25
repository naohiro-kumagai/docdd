---
name: "TypeScript-Standards-Skill"
description: "TypeScript開発規約スキル"
version: "1.0.0"
---

# TypeScript Standards Skill

## 目的

TypeScriptのベストプラクティスと厳格な型安全性を維持します。

## 起動条件

- TypeScriptファイルの作成・修正
- 型定義が必要な場合

## 使用リソース

- resources/type_safety.md
- resources/naming_conventions.md
- resources/import_rules.md
- examples/type_examples.ts

## 基本ルール

### 型安全性（非交渉事項）

```typescript
// ❌ 禁止
const data: any = fetchData();
// @ts-ignore
someCode();

// ✅ 正しい
const data: UserData = fetchData();
```

### インポートルール

```typescript
// ❌ バレルインポート禁止
import { Button, Input } from '@/components';

// ✅ 明示的インポート
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
```

### 命名規約

- PascalCase: 型、インターフェース、クラス
- camelCase: 変数、関数、メソッド
- UPPER_SNAKE_CASE: 定数
