# 技術スタック定義

## プロジェクト概要

DocDD（Document-Driven Development）は、AI支援開発ワークフローを実現するための体系的な開発手法です。

## 言語とランタイム

- **TypeScript**: 5.x以上（厳格な型チェック必須）
- **Node.js**: 18.x以上
- **パッケージマネージャー**: npm, yarn, bun, pnpm のいずれか

## フレームワーク・ライブラリ

### フロントエンド
- **React**: 19.x（Server Components優先）
- **Next.js**: 15.x以上（App Router使用）
- **UI Components**: shadcn/ui（Radix UI ベース）
- **スタイリング**: Tailwind CSS 3.x

### テスト
- **テストフレームワーク**: Vitest
- **E2Eテスト**: Playwright（Docker環境）
- **コンポーネントテスト**: React Testing Library

### ツール連携
- **MCP（Model Context Protocol）統合**:
  - Context7: ライブラリドキュメント取得
  - Kiri: セマンティックコード検索
  - Serena: シンボリック編集と記憶管理
  - Chrome DevTools: ブラウザ自動化（WSL/Linuxで動作確認済み）
  - Playwright: E2Eテスト自動化
  - Next.js Runtime: ビルド・ランタイムエラー監視

## 重要な制約

- **型安全性**: `any` 型の使用禁止、`@ts-ignore` 禁止
- **インポート形式**: バレルインポート禁止、明示的な `@/` パスインポートを使用
- **React パターン**: Client ComponentsよりServer Components優先
- **エラーハンドリング**: 非同期操作には `.then().catch()` を使用
- **コメント言語**: 日本語（コード自体は英語）

## 環境変数管理

- **機密情報**: `.env` ファイルで管理（リポジトリには含めない）
- **テンプレート**: `.env.example` で構造を共有
- **セキュリティ**: APIキーやパスワードのハードコード厳禁
