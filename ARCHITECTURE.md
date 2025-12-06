# DocDD アーキテクチャ

## 概要

DocDD (Document-Driven Development) は、複数の AI エディター（Claude、Cursor、Windsurf、Gemini CLI、VS Code Copilot）に対応した、ドキュメント駆動の開発ワークフローシステムです。

## システムアーキテクチャ

### コアコンセプト

DocDD は以下の原則に基づいています：

1. **ドキュメント駆動開発**: すべてのアーキテクチャ決定を ADR (Architecture Decision Record) として文書化
2. **AI エディター統一**: Claude、Cursor、Windsurf、Gemini CLI、VS Code Copilot に統一されたワークフローを提供
3. **体系的な品質保証**: 11フェーズのワークフローで一貫性のある高品質な開発を実現

### マルチエディター対応

```
Claude         → .claude/agents/ + CLAUDE.md
Cursor         → .cursor/commands/ + .cursorrules
Windsurf       → .windsurf/rules/ + .windsurf/workflows/
Gemini CLI     → .gemini/commands/ + GEMINI.md
VS Code Copilot → .github/agents/ + .github/instructions/
```

### MCP (Model Context Protocol) 統合

DocDD は以下の MCP サーバーを統合しています：

- **Kiri**: セマンティックコード検索と依存関係分析
- **Serena**: シンボルベースのコード編集
- **Context7**: ライブラリドキュメント取得
- **Next.js Runtime**: ランタイムエラー検証（Next.js 16+）
- **Chrome DevTools**: ブラウザ検証

### 11フェーズワークフロー

1. **Phase 1**: 調査・研究（ADR確認、コードベース分析、ライブラリドキュメント確認）
2. **Phase 2**: アーキテクチャ設計（ファイル配置、状態管理、コンポーネント設計）
3. **Phase 3**: UI/UX デザイン（スタイルガイド確認、アクセシビリティ、レスポンシブ設計）
4. **Phase 4**: 計画（タスク分解、実装順序、依存関係確認）
5. **Phase 5**: 実装（コード作成、型安全性、コメント）
6. **Phase 6**: テスト・ストーリー（テスト作成、Storybook）
7. **Phase 7**: コードレビュー（SOLID原則、最適化、セキュリティ）
8. **Phase 8**: 品質チェック（型チェック、リント、テスト、ビルド）
9. **Phase 9**: 検証（ランタイム、ブラウザ）
10. **Phase 10**: コミット（Git commit）
11. **Phase 11**: プッシュ（Git push）

## ディレクトリ構造

```
docdd/
├── README.md                 # プロジェクト概要
├── ARCHITECTURE.md           # このファイル
├── CLAUDE.md                 # Claude ワークフロー
├── .cursorrules              # Cursor 設定
├── WINDSURF.md               # Windsurf ワークフロー
├── GEMINI.md                 # Gemini CLI ワークフロー
├── VSCODE_COPILOT_SETUP.md   # VS Code Copilot セットアップ
├── MCP_REFERENCE.md          # MCP コマンドリファレンス
├── adr/
│   ├── README.md             # ADR ガイド
│   └── decisions/            # 個別 ADR ファイル
├── .claude/agents/           # Claude エージェント
├── .cursor/commands/         # Cursor コマンド
├── .windsurf/
│   ├── rules/                # Windsurf ルール
│   └── workflows/            # Windsurf ワークフロー
├── .gemini/
│   ├── settings.json         # Gemini 設定
│   └── commands/             # Gemini カスタムコマンド
├── .github/
│   ├── agents/               # Copilot エージェント
│   ├── instructions/         # Copilot 指示ファイル
│   ├── prompts/              # Copilot プロンプト
│   └── copilot-instructions.md # Copilot メイン設定
└── .mcp.json                 # MCP 設定（共通）
```

## 開発原則

1. **ドキュメント第一**: アーキテクチャ決定は ADR で文書化し、実装前に確認
2. **品質第一**: 型安全性、テスト、コードレビューは非交渉事項
3. **体系的**: 11フェーズに従うことで一貫性と再現性を確保
4. **AI 支援**: AI エディターの MCP 統合で効率的な開発を実現
5. **保守性**: 明確なコメント、自己文書化コード、テストで長期保守性を確保

## エディター別セットアップ

### Claude
```bash
curl -fsSL https://raw.githubusercontent.com/naohiro-kumagai/docdd/main/migrate.sh | \
  bash -s -- --interactive /path/to/project
```

### Cursor
`.cursorrules` と `.cursor/commands/` が自動配置されます。

### Windsurf
`.windsurf/rules/` と `.windsurf/workflows/` が自動配置されます。

### Gemini CLI
```bash
cd /path/to/project && gemini extensions install --path=.
```

### VS Code Copilot
`.github/agents/` と `.github/instructions/` が自動配置されます。

## 品質基準

- **型安全性**: `any` 型は禁止、すべての TypeScript エラーを解決必須
- **テストカバレッジ**: 新しいロジックには 100% ブランチカバレッジ
- **コード品質**: SOLID 原則に従う、コードスメルをチェック
- **パフォーマンス**: Core Web Vitals（LCP < 2.5s、FID < 100ms、CLS < 0.1）
- **アクセシビリティ**: WCAG 2.1 AA 準拠、ARIA 属性適切、キーボードナビゲーション対応

## 参考ドキュメント

- [CLAUDE.md](./CLAUDE.md) - Claude 専用ワークフロー詳細
- [GEMINI.md](./GEMINI.md) - Gemini CLI 専用ワークフロー詳細
- [MCP_REFERENCE.md](./MCP_REFERENCE.md) - MCP コマンドリファレンス
- [adr/README.md](./adr/README.md) - アーキテクチャ決定記録ガイド
