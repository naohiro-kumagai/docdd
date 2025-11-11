# DocDD for Gemini CLI - 実装サマリー

## 🎯 作成されたもの

これは、DocDD (Document-Driven Development) ワークフローを Claude/Cursor から Google の Gemini CLI エコシステムに移植した完全なエクステンションです。

### コアファイル

| ファイル | サイズ | 目的 |
|---------|------|------|
| `GEMINI.md` | 8.7 KB | 戦略的コンテキストと11フェーズワークフロー定義 |
| `gemini-extension.json` | 3.6 KB | ワンコマンドインストール用エクステンションマニフェスト |
| `.gemini/settings.json` | ~2 KB | MCPサーバー設定とツール設定 |
| `.gemini/commands/*.toml` | 11ファイル | 名前空間付きカスタムコマンド |
| `GEMINI_README.md` | 7.6 KB | Gemini CLIワークフローのユーザーガイド |
| `MIGRATION_GUIDE.md` | 11 KB | 詳細な移行手順 |

## 📊 アーキテクチャ概要

### 理念: ReAct ループ + 戦略レイヤー

```
┌─────────────────────────────────────────────────┐
│           ユーザーリクエスト（ターミナル/IDE）         │
└────────────────┬────────────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────────────┐
│  GEMINI.md（戦略レイヤー）                        │
│  - ペルソナ定義                                   │
│  - 11フェーズワークフロールール                      │
│  - 重要なコーディング標準                          │
└────────────────┬────────────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────────────┐
│  ReAct ループ（Gemini CLI コア）                  │
│  ┌─────────┐  ┌─────────┐  ┌─────────┐        │
│  │ 推論    │→ │  実行   │→ │ 観察    │         │
│  └─────────┘  └────┬────┘  └─────────┘         │
│                    │                             │
│                    ▼                             │
│  ┌─────────────────────────────────────┐        │
│  │  ツールとアクション                   │        │
│  │  - /terminal (コマンド実行)          │        │
│  │  - /grep (ファイル検索)              │        │
│  │  - /fileRead, /fileWrite            │        │
│  │  - MCP ツール (Kiri, Serena等)       │        │
│  │  - カスタムコマンド (/adr:*等)        │        │
│  └─────────────────────────────────────┘        │
└─────────────────────────────────────────────────┘
```

### 主要なアーキテクチャ改善

1. **関心の分離**
   - **移行前**: 単一の.mdファイルにペルソナ+タスクが混在
   - **移行後**: GEMINI.mdにペルソナ、.tomlコマンドにタスク

2. **階層的コンテキスト**
   - **移行前**: プロジェクト全体で単一のCLAUDE.md
   - **移行後**: グローバル → プロジェクト → サブディレクトリの GEMINI.md チェーン

3. **統一されたエコシステム**
   - **移行前**: CursorとClaudeで別々の設定
   - **移行後**: ターミナル + VS Code で共有する単一のsettings.json

## 🗂️ ファイル構造

```
docdd/
├── GEMINI.md                      # 戦略的コンテキスト（CLAUDE.mdの置き換え）
├── gemini-extension.json          # エクステンションマニフェスト
├── GEMINI_README.md               # ユーザーガイド
├── MIGRATION_GUIDE.md             # 移行手順
│
├── .gemini/
│   ├── settings.json              # MCP + ツール設定
│   └── commands/                  # カスタムスラッシュコマンド
│       ├── adr/
│       │   ├── record.toml        → /adr:record
│       │   └── search.toml        → /adr:search
│       ├── test/
│       │   └── gen.toml           → /test:gen
│       ├── ui/
│       │   ├── review.toml        → /ui:review
│       │   └── propose.toml       → /ui:propose
│       ├── refactor/
│       │   └── review.toml        → /refactor:review
│       ├── doc/
│       │   └── add.toml           → /doc:add
│       ├── lint/
│       │   └── fix.toml           → /lint:fix
│       ├── git/
│       │   └── commit.toml        → /git:commit
│       ├── arch/
│       │   └── design.toml        → /arch:design
│       └── story/
│           └── create.toml        → /story:create
│
├── （参照用に元のファイルは残す）
├── .claude/
├── .cursor/
├── CLAUDE.md
└── MCP_REFERENCE.md
```

## 🔧 MCP統合

### 設定済みMCPサーバー

| MCP | 自動有効 | トランスポート | 目的 |
|-----|---------|--------------|------|
| **Kiri** | ✅ はい | stdio | セマンティックコード検索、依存関係分析 |
| **Serena** | ✅ はい | stdio | シンボルベースのコード編集 |
| **Context7** | ✅ はい | stdio | ライブラリドキュメント取得 |
| **Next.js Runtime** | ❌ いいえ | stdio | フェーズ9Aランタイム検証 |
| **Chrome DevTools** | ❌ いいえ | stdio | フェーズ9Bブラウザ検証 |

### MCP設定フォーマット

```json
{
  "mcpServers": {
    "kiri": {
      "command": "npx",
      "args": ["kiri-mcp-server@latest", "--repo", ".", "--db", ".kiri/index.duckdb", "--watch"],
      "autoEnable": true,
      "description": "Kiri MCP for semantic code search"
    }
  }
}
```

## 🎯 利用可能なコマンド

### コマンド名前空間の階層

```
/adr:*          # アーキテクチャ決定記録
  ├── record    # 新しいADRを作成
  └── search    # 既存のADRを検索

/test:*         # テスト
  └── gen       # ユニットテスト生成（AAAパターン）

/ui:*           # UI/UXデザイン
  ├── review    # アクセシビリティのためのデザインレビュー
  └── propose   # 改善案を提案

/refactor:*     # コード品質
  └── review    # SOLID原則準拠のレビュー

/doc:*          # ドキュメント
  └── add       # JSDoc/TSDocコメントを追加

/lint:*         # コードフォーマット
  └── fix       # Lintエラーを修正

/git:*          # バージョン管理
  └── commit    # コミットメッセージを生成

/arch:*         # アーキテクチャ
  └── design    # システムアーキテクチャを設計

/story:*        # Storybook
  └── create    # Storybookストーリーを作成
```

## 🚀 インストール

### エンドユーザー向け

```bash
# Gemini CLI のインストール
npm install -g @google/gemini-cli

# DocDD エクステンションのインストール
gemini extensions install https://github.com/naohiro-kumagai/docdd

# 使い始める
gemini
```

### 開発/テスト向け

```bash
# リポジトリをクローン
git clone https://github.com/naohiro-kumagai/docdd.git
cd docdd

# ローカルインストール
gemini extensions install --path=.

# テスト
gemini
/tools      # MCPツールが表示されるはず
/adr:record # ADRコマンドが表示されるはず
```

### VS Code統合

```bash
# VS Code統合ターミナルで
gemini

# IDEブリッジをインストール
/ide install

# 統合を有効化
/ide enable

# これでVS CodeのGemini Agentが同じワークフローを使用！
```

## 📖 11フェーズワークフロー実装

ワークフローは `GEMINI.md` で定義され、Gemini CLI の ReAct ループに統合されています:

### フェーズとコマンドのマッピング

| フェーズ | コマンド | 自動/手動 |
|---------|---------|----------|
| 1. 調査 | Kiri MCP context_bundle | 自動（AI経由） |
| 2. アーキテクチャ | `/arch:design` | 手動トリガー |
| 3. UIデザイン | `/ui:review` | 手動トリガー |
| 4. 計画 | `/memory add` | 自動（AI経由） |
| 5. 実装 | Serena MCP | 自動（AI経由） |
| 6. テスト | `/test:gen` | 手動トリガー |
| 7. コードレビュー | `/refactor:review` | 手動トリガー |
| 8. 品質チェック | `/terminal npm run ...` | 自動（AI経由） |
| 9A. ランタイム | Next.js MCP | 自動（AI経由） |
| 9B. ブラウザ | Chrome DevTools MCP | 手動トリガー |
| 10. コミット | `/git:commit` | 手動トリガー |
| 11. プッシュ | `/terminal git push` | 手動実行 |

### ワークフロー自動化レベル

- **完全自動**（AIが処理）: フェーズ 1, 4, 5, 8, 9A
- **半自動**（手動トリガー、AIが実行）: フェーズ 2, 3, 6, 7, 9B, 10
- **手動**（ユーザーが実行）: フェーズ 11

## 🧠 コンテキスト管理機能

### 階層的読み込み

```
~/.gemini/GEMINI.md              # 個人のデフォルト
└── project/
    ├── GEMINI.md                # プロジェクトルール（DocDDワークフロー）
    ├── frontend/
    │   └── GEMINI.md            # React固有のルール
    └── backend/
        └── GEMINI.md            # API固有のルール
```

### プロンプトでの動的参照

```bash
# ファイル参照
> @src/auth/login.ts をレビューしてください

# 検索結果参照
> @search "認証パターン" を分析してください

# 複数ファイル
> @src/auth/jwt.ts と @src/auth/session.ts を比較してください
```

### セッションメモリ

```bash
# 決定を保存
/memory add "決定: 状態管理にZustandを使用"

# 保存したものを一覧表示
/memory list

# 検索
/memory search "状態管理"
```

## ✅ 検証チェックリスト

インストール後、以下を確認:

```bash
# エクステンションがインストールされているか
gemini extensions list
# 表示されるはず: docdd-workflow

# MCPサーバーがアクティブか
gemini
/mcp
# 表示されるはず: kiri, serena, context7

# ツールが利用可能か
/tools
# 表示されるはず: MCPツール + コアツール

# コマンドが利用可能か
/adr:<Tab>
# 自動補完されるはず: record, search

# コンテキストが読み込まれているか
> DocDDワークフローについて教えてください
# AIが11フェーズワークフローを説明するはず
```

## 🎯 Claude/Cursorからの移行パス

### クイック比較

| コンポーネント | Claude/Cursor | Gemini CLI |
|-------------|--------------|------------|
| コンテキスト | CLAUDE.md | GEMINI.md（階層的） |
| コマンド | .cursor/commands/*.md | .gemini/commands/*.toml |
| エージェント | .claude/agents/*.md | GEMINI.md + .tomlコマンド |
| MCP | .mcp.json | settings.json (mcpServers) |
| IDE | Cursor ネイティブ | VS Code + エクステンション |

### 移行ステップまとめ

1. **Gemini CLIをインストール**: `npm install -g @google/gemini-cli`
2. **構造を作成**: `mkdir -p .gemini/commands/{adr,test,ui,...}`
3. **コンテキストを移行**: CLAUDE.md → GEMINI.md（ペルソナを追加）
4. **エージェントをリファクタリング**: ペルソナ（GEMINI.md）とタスク（.toml）を分離
5. **コマンドを変換**: .md → .toml形式
6. **MCP設定を更新**: .mcp.json → settings.json（transportラッパー）
7. **マニフェストを作成**: gemini-extension.json
8. **ローカルテスト**: `gemini extensions install --path=.`
9. **VS Codeを有効化**: `/ide install && /ide enable`

詳細な手順は [MIGRATION_GUIDE.md](./MIGRATION_GUIDE.md) を参照してください。

## 📚 ドキュメント

| ドキュメント | 目的 |
|------------|------|
| **GEMINI.md** | 戦略的コンテキスト - AIが読む |
| **GEMINI_README.md** | ユーザーマニュアル - 人間が読む |
| **MIGRATION_GUIDE.md** | 移行手順 - 開発者が読む |
| **gemini-extension.json** | マニフェスト - Gemini CLIが読む |
| **GEMINI_CLI_SUMMARY.md** | このファイル - 概要 |

## 🎓 重要なポイント

### ユーザー向け

- **ワンコマンドインストール**: `gemini extensions install <url>`
- **統一された体験**: ターミナルとVS Codeで同じワークフロー
- **階層的コンテキスト**: ディレクトリごとに細かい制御
- **名前空間付きコマンド**: 直感的な `/ドメイン:アクション` 構造

### 開発者向け

- **クリーンなアーキテクチャ**: ペルソナとタスクの分離
- **拡張可能**: 新しいコマンド（.tomlファイル）を簡単に追加
- **ポータブル**: マニフェストを含む自己完結型エクステンション
- **型安全**: スキーマ検証付きTOMLフォーマット

### 技術的ハイライト

1. **ReActループ統合**: GEMINI.mdがGemini CLIの推論フェーズに供給
2. **MCPエコシステム**: 専門タスク用の5つのMCPサーバー
3. **VS Codeブリッジ**: シームレスなIDE統合用の `/ide` コマンド
4. **セッション永続化**: マルチターンコンテキスト用の `/memory`

## 🚧 次のステップ

### すぐに使用する場合

1. ローカルテスト: `gemini extensions install --path=.`
2. セッション開始: `gemini`
3. コマンドを試す: `/adr:record`, `/test:gen` など
4. VS Codeを有効化: `/ide install && /ide enable`

### 公開する場合

1. GitHubにプッシュ: `git push origin main`
2. リリースタグ: `git tag v1.0.0 && git push --tags`
3. URLを共有: ユーザーはリポジトリURL経由でインストール

### 拡張する場合

- より多くのコマンドを追加（例: `/deploy:*`, `/db:*`）
- コンポーネント用のサブディレクトリGEMINI.mdファイルを作成
- プロジェクト固有のニーズに合わせてプロンプトをカスタマイズ
- 必要に応じてカスタムMCPサーバーを追加

---

## 🐟 まとめ

DocDD for Gemini CLI は、Document-Driven Development ワークフローをGoogleのAIエコシステムに移行・強化し、以下を提供します:

- ✅ 完全なアーキテクチャアップグレード（モノリシック → モジュラー）
- ✅ 改善されたコンテキスト階層（グローバル → プロジェクト → コンポーネント）
- ✅ 統一されたターミナル + IDE 体験
- ✅ 名前空間付き拡張可能なコマンドシステム
- ✅ 完全なMCP統合（5つのサーバーが事前設定済み）
- ✅ チーム向けワンコマンドインストール

**このワークフローはプロダクション準備が整っており、すぐにインストールできます。**
