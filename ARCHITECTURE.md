# DocDD アーキテクチャ

## 概要

DocDD (Document-Driven Development) は、Gemini CLI で使用するために設計された AI 駆動の開発ワークフローシステムです。

## システムアーキテクチャ

### コアコンポーネント

1. **GEMINI.md**: 戦略的コンテキストとワークフロー定義
2. **.gemini/settings.json**: MCP サーバー設定
3. **.gemini/commands/**: カスタムスラッシュコマンド（TOML形式）
4. **gemini-extension.json**: エクステンションマニフェスト

### MCP統合

DocDD は 5つの Model Context Protocol (MCP) サーバーを統合しています:

- **Kiri**: セマンティックコード検索と依存関係分析
- **Serena**: シンボルベースのコード編集
- **Context7**: ライブラリドキュメント取得
- **Next.js Runtime**: ランタイムエラー検証
- **Chrome DevTools**: ブラウザ検証

### ワークフローシステム

DocDD は体系的な11フェーズの開発ワークフローを実装しています:

1. 調査・研究
2. アーキテクチャ設計
3. UI/UX デザイン
4. 実装計画
5. コード実装
6. テスト
7. コードレビュー
8. 品質チェック
9. 検証（ランタイム & ブラウザ）
10. バージョン管理
11. デプロイ

## ディレクトリ構造

```
docdd/
├── GEMINI.md                 # 戦略的コンテキスト
├── ARCHITECTURE.md           # このファイル
├── docs/
│   └── adr/                  # アーキテクチャ決定記録
├── .gemini/
│   ├── settings.json         # 設定
│   └── commands/             # カスタムコマンド
└── gemini-extension.json     # エクステンションマニフェスト
```

## 開発原則

1. **ドキュメント第一**: すべてのアーキテクチャ決定は ADR 形式で文書化
2. **品質第一**: 型安全性、テスト、コードレビューは必須
3. **体系的**: 一貫した結果を得るために11フェーズのワークフローに従う

## エクステンションシステム

DocDD は Gemini CLI エクステンションとしてインストールできます:

```bash
gemini extensions install https://github.com/naohiro-kumagai/docdd
```

使用方法の詳細は [GEMINI_README.md](./GEMINI_README.md) を参照してください。
