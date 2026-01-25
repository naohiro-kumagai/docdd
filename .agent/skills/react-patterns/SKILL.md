---
name: "React-Patterns-Skill"
description: "React/Next.js専用開発規約スキル"
version: "1.0.0"
---

# React Patterns Skill

## 目的

React/Next.jsのベストプラクティスとパターンを適用します。

## 起動条件

- Reactコンポーネントの作成・修正
- Next.jsの機能を使用する

## 使用リソース

- resources/component_patterns.md
- resources/server_client.md
- examples/server_component.tsx
- examples/client_component.tsx

## コンポーネント設計原則

### Server Components優先
- デフォルトはServer Component
- Client Componentは必要な場合のみ

### Presenterパターンの徹底
- ビジネスロジックと表示ロジックを分離
- すべての条件分岐はprops経由で制御

### React 19パターン
- useEffect最小化
- 直接計算を優先

## ファイル構成

```
components/
  ui/
    button/
      index.tsx
      button.presenter.tsx
      button.test.tsx
      button.stories.tsx
```
