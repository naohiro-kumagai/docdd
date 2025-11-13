# VS Code Copilot向けDocDDワークフロー設定ガイド

このドキュメントは、DocDDワークフローをVS Code GitHub Copilotで使用するための設定と使用方法を説明します。

## 📋 目次

- [必要な拡張機能](#必要な拡張機能)
- [設定ファイル概要](#設定ファイル概要)
- [セットアップ手順](#セットアップ手順)
- [使用方法](#使用方法)
- [トラブルシューティング](#トラブルシューティング)

## 必要な拡張機能

VS Codeに以下の拡張機能をインストールしてください：

1. **GitHub Copilot** (`GitHub.copilot`)
2. **GitHub Copilot Chat** (`GitHub.copilot-chat`)

```bash
# VS Code拡張機能のインストール
code --install-extension GitHub.copilot
code --install-extension GitHub.copilot-chat
```

## 設定ファイル概要

DocDDワークフローは以下のディレクトリ構造で構成されています：

```
your-project/
├── .github/
│   ├── copilot-instructions.md     # グローバルリポジトリ指示
│   ├── instructions/                # パス固有の指示
│   │   ├── phase1-investigation.instructions.md
│   │   ├── typescript.instructions.md
│   │   └── react.instructions.md
│   ├── agents/                      # カスタムエージェント定義
│   │   ├── adr-manager.md
│   │   ├── test-enforcer.md
│   │   └── ui-advisor.md
│   └── prompts/                     # 再利用可能なプロンプト（実験的）
│       ├── adr-record.md
│       ├── test-gen.md
│       └── ui-review.md
│
└── .vscode/
    ├── settings.json                # VS Code設定
    ├── mcp.json                     # MCP設定
    └── markdown.code-snippets       # Copilot用スニペット
```

### 各ファイルの役割

| ファイル | 役割 | スコープ |
|---------|------|---------|
| `.github/copilot-instructions.md` | グローバルな開発ルールとワークフロー定義 | リポジトリ全体 |
| `.github/instructions/*.instructions.md` | ファイルタイプ/パス固有のルール | 指定パス |
| `.github/agents/*.md` | 特化型AIエージェント（ADR、テスト、UI） | エージェントとして呼び出し |
| `.github/prompts/*.md` | 再利用可能なプロンプトテンプレート | チャットから直接実行 |
| `.vscode/settings.json` | Copilot機能の有効化設定 | ワークスペース |
| `.vscode/mcp.json` | MCPサーバー（Kiri、Serena等）設定 | ワークスペース |
| `.vscode/markdown.code-snippets` | チャット入力補助スニペット | ワークスペース |

## セットアップ手順

### 1. リポジトリへの設定追加

このリポジトリの設定ファイルを既存プロジェクトにコピー：

```bash
# DocDDリポジトリから設定をコピー
cp -r /path/to/docdd/.github your-project/
cp -r /path/to/docdd/.vscode your-project/

# または、migrate.shスクリプトを使用
curl -fsSL https://raw.githubusercontent.com/naohiro-kumagai/docdd/main/migrate.sh | bash -s -- /path/to/your-project
```

### 2. VS Code設定の確認

`.vscode/settings.json`が正しく配置されていることを確認：

```json
{
  "github.copilot.enable": {
    "*": true
  },
  "chat.mcp.enabled": true,
  "chat.promptFiles": true,
  "chat.useAgentsMdFile": true
}
```

### 3. MCP依存関係のインストール

Serena MCPには`uvx`が必要です：

```bash
# macOS/Linux
wget -qO- https://astral.sh/uv/install.sh | bash
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

### 4. VS Codeの再起動

設定を反映させるため、VS Codeを再起動してください。

## 使用方法

### 1. グローバルコンテキストの自動適用

`.github/copilot-instructions.md`の内容は、すべてのCopilot Chatセッションで自動的に参照されます。特別な操作は不要です。

### 2. エージェントの呼び出し

チャットで`@エージェント名`を使用：

```
@adr-manager 新しいアーキテクチャ決定を記録してください。
認証フローにJWT+RefreshTokenパターンを採用します。
```

**利用可能なエージェント:**
- `@adr-manager` - ADR記録、検索、管理
- `@test-enforcer` - Vitestテスト品質チェック
- `@ui-advisor` - UI/UX改善提案（実装前に承認必要）
- `@refactor-specialist` - コンポーネントリファクタリング
- `@story-creator` - Storybook作成（条件分岐のみ）
- `@spec-creator` - 仕様書作成（機能、API、アーキテクチャ、DB、統合）
- `@onboarding-specialist` - プロジェクト分析とADR記録

**注意:** エージェント機能は実験的です。代わりに下記のスニペット（安定版）の使用を推奨します。
@adr-manager 新しいServer Components使用の決定を記録して

@test-enforcer この関数にテストを生成して

@ui-advisor このボタンコンポーネントをレビューして
```

**注**: エージェント機能は現在進化中です。VS Codeバージョンによって動作が異なる場合があります。

### 3. プロンプトファイルの使用（実験的）

チャットビューから`.github/prompts/`内のプロンプトを直接実行できます。

**注**: この機能は実験的であり、将来変更される可能性があります。

### 4. スニペットを使った高速入力（推奨）

チャット入力欄で以下のプレフィックスを入力してTabキーを押す：

| プレフィックス | 展開内容 | 用途 |
|--------------|---------|------|
| `cadr` | ADR記録プロンプト | アーキテクチャ決定記録 |
| `ctest` | テスト生成プロンプト | Vitestテスト作成 |
| `cui` | UI/UXレビュープロンプト | UIコンポーネントレビュー |
| `creview` | コードレビュープロンプト | コード品質チェック |
| `crefactor` | リファクタリング提案 | コード改善 |
| `cp1` | Phase 1調査開始 | 実装前調査 |
| `cp2` | Phase 2設計開始 | アーキテクチャ設計 |
| `cp3` | Phase 3 UI/UX設計 | UIレビュー |
| `cp4` | Phase 4計画 | タスク分解・計画 |
| `cp5` | Phase 5実装 | コード実装 |
| `cp6` | Phase 6テスト | テスト・ストーリー作成 |
| `cp7` | Phase 7レビュー | コードレビュー |
| `cp8` | Phase 8品質チェック | lint・test・build実行 |
| `cp9a` | Phase 9Aランタイム検証 | Next.js開発サーバー検証 |
| `cp9b` | Phase 9Bブラウザ検証 | Chrome DevTools検証 |
| `cp10` | Phase 10コミット | Gitコミット |
| `cp11` | Phase 11プッシュ | Gitプッシュ |
| `csearch` | セマンティック検索 | 既存コード検索 |
| `cerr` | エラー解決依頼 | エラーデバッグ |

**使用例**:

1. Copilot Chatを開く
2. チャット入力欄で`cp1`と入力してTabキーを押す
3. プロンプトテンプレートが展開される
4. プレースホルダーを埋めてEnterキーを押す

### 5. MCPツールの使用

MCPツール（Kiri、Serena等）を使用するには、**エージェントモード**を有効にする必要があります：

#### Phase 1: Investigation（調査）

Kiri MCPでセマンティック検索：

```
エージェントモードで、Kiri MCPを使用してユーザー認証関連のコードを検索してください。

goal: 'user authentication, login flow, JWT validation'
limit: 10
compact: true
```

#### Phase 5: Implementation（実装）

Serena MCPでシンボル編集：

```
エージェントモードで、Serena MCPを使用してvalidateToken関数を置き換えてください。

name_path: 'UserAuth/validateToken'
relative_path: 'src/auth/user.ts'
```

### 6. ターミナルエージェント（@terminal）

VS Code内でターミナルコマンドを実行：

```
@terminal tests/ディレクトリ内のすべてのテストを実行して

@terminal npm run type-check && npm run lint

@terminal git status と git diff を実行して変更内容を確認
```

### 7. 11フェーズワークフローの実行

DocDDの11フェーズワークフローに従って開発：

```
Phase 1: Investigation & Research を実行してください。

タスク: ユーザープロフィール編集機能の追加

調査項目:
1. docs/adr/index.json の既存ADRを確認
2. Kiri MCPで関連コンポーネントを検索
3. 既存のフォームパターンを特定
4. 実装アプローチを推奨
```

## トラブルシューティング

### MCPサーバーが起動しない

**症状**: エージェントモードでMCPツールが使用できない

**解決策**:
1. `.vscode/mcp.json`が正しく配置されているか確認
2. `uvx`コマンドが利用可能か確認: `uvx --version`
3. VS Codeの出力パネルで「GitHub Copilot Chat」ログを確認
4. VS Codeを再起動

### エージェントが見つからない

**症状**: `@エージェント名`が認識されない

**解決策**:
1. `.github/agents/`ディレクトリが存在するか確認
2. VS Code設定で`chat.useAgentsMdFile`が有効か確認
3. VS Codeバージョンが最新か確認（古いバージョンではサポートされていない場合があります）
4. 代わりにスニペット（`cadr`、`ctest`等）を使用

### プロンプトファイルが表示されない

**症状**: `.github/prompts/`内のファイルがチャットビューに表示されない

**解決策**:
1. `.vscode/settings.json`で`chat.promptFiles: true`が設定されているか確認
2. この機能は実験的であり、安定したVS Codeバージョンでは利用できない場合があります
3. 代替として`.vscode/markdown.code-snippets`のスニペットを使用（推奨）

### スニペットが展開されない

**症状**: `ctest`等を入力してもスニペットが展開されない

**解決策**:
1. `.vscode/markdown.code-snippets`が正しく配置されているか確認
2. Copilot **Chat入力欄**でスニペットを入力（エディタではなく）
3. Tabキーで展開（Enterキーではない）
4. VS Codeを再起動

### パス固有の指示が適用されない

**症状**: `.github/instructions/typescript.instructions.md`等が機能しない

**解決策**:
1. ファイル名が`*.instructions.md`形式か確認
2. YAMLフロントマター（`applyTo`）が正しく記述されているか確認
3. `applyTo`のglobパターンが対象ファイルにマッチするか確認
4. VS Codeを再起動

## 機能の実験的ステータス

以下の機能は実験的であり、将来変更される可能性があります：

| 機能 | ステータス | 代替手段 |
|-----|----------|---------|
| `.github/prompts/`（プロンプトファイル） | 🧪 実験的 | ✅ `.vscode/markdown.code-snippets`（推奨） |
| `.github/agents/`（カスタムエージェント） | 🧪 進化中 | ✅ スニペット経由のプロンプト |
| `chat.useAgentsMdFile` | 🧪 実験的 | ✅ 直接プロンプト入力 |

**推奨**: 安定した本番環境では、スニペット（`.vscode/markdown.code-snippets`）を優先的に使用してください。

## さらに詳しく

- DocDD全体のワークフロー: [CLAUDE.md](../CLAUDE.md)
- MCPリファレンス: [MCP_REFERENCE.md](../MCP_REFERENCE.md)
- Gemini CLI移行ガイド: [MIGRATION_GUIDE.md](../MIGRATION_GUIDE.md)

---

**重要**: VS Code GitHub Copilotは急速に進化しており、新機能が継続的に追加されています。最新の機能については、[GitHub Copilot公式ドキュメント](https://docs.github.com/en/copilot)を参照してください。
