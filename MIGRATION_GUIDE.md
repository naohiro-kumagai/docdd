# Claude/Cursor から Gemini CLI への移行ガイド

このガイドでは、既存の DocDD ワークフローを Claude Code/Cursor から Gemini CLI に移行する手順を説明します。

## 📋 目次

- [移行の理念](#移行の理念)
- [移行前の準備](#移行前の準備)
- [ステップバイステップの移行](#ステップバイステップの移行)
- [ファイルマッピング](#ファイルマッピング)
- [設定の変換](#設定の変換)
- [よくある落とし穴](#よくある落とし穴)
- [検証チェックリスト](#検証チェックリスト)

## 移行の理念

### これは1:1の翻訳ではありません

Claude/Cursor から Gemini CLI への移行は、単なるファイルの名前変更ではありません。アーキテクチャのアップグレードです:

| 側面 | Claude/Cursor | Gemini CLI |
|------|--------------|------------|
| **アーキテクチャ** | モノリシック | モジュラー |
| **コンテキスト** | 単一ファイル | 階層的 |
| **コマンド** | エージェント指向 | タスク指向 |
| **エコシステム** | IDE固有 | 統合（ターミナル + IDE） |
| **拡張性** | 限定的 | エクステンションシステム |

### 主要な哲学的変化

#### 1. ペルソナとタスクの分離

**Before (Claude/Cursor):**
```markdown
<!-- CLAUDE.md -->
# あなたの役割
あなたは上級開発者です...

## タスク1: 実装
[タスクの詳細]

## タスク2: テスト
[タスクの詳細]
```

**After (Gemini CLI):**
```markdown
<!-- GEMINI.md - ペルソナのみ -->
# あなたの役割
あなたは上級開発者です...
## 原則
## ワークフロー

<!-- .gemini/commands/task1.toml - タスク定義 -->
name = "task1"
prompt = "[タスクの詳細]"
```

**なぜ**: ペルソナ（あなたは誰か）とタスク（あなたは何をするか）の分離により、再利用性と保守性が向上します。

#### 2. 階層的コンテキストの読み込み

**Before (Claude/Cursor):**
```
project/
└── CLAUDE.md  (すべてが1つのファイルに)
```

**After (Gemini CLI):**
```
~/.gemini/GEMINI.md          # グローバルデフォルト
└── project/
    ├── GEMINI.md            # プロジェクトルール
    ├── frontend/
    │   └── GEMINI.md        # フロントエンド固有
    └── backend/
        └── GEMINI.md        # バックエンド固有
```

**なぜ**: 細かい制御により、コンテキストの過負荷を防ぎ、関連性を向上させます。

#### 3. 構造化されたコマンドフォーマット

**Before (Claude/Cursor):**
```markdown
<!-- .claude/agents/adr-manager.md -->
自由形式のMarkdown指示...
```

**After (Gemini CLI):**
```toml
# .gemini/commands/adr/record.toml
name = "adr:record"
description = "新しいADRを記録"
prompt = """
構造化された指示...
"""
```

**なぜ**: TOMLフォーマットにより型安全性とスキーマ検証が可能になります。

## 移行前の準備

### 1. 環境のセットアップ

```bash
# Gemini CLI のインストール
npm install -g @google/gemini-cli

# Python uv のインストール (Serena MCP用)
wget -qO- https://astral.sh/uv/install.sh | bash
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

# 確認
gemini --version
uvx --version
```

### 2. バックアップ

```bash
# 既存の設定をバックアップ
cd your-project
tar -czf docdd-claude-backup-$(date +%Y%m%d).tar.gz \
  CLAUDE.md \
  .claude/ \
  .cursor/ \
  .mcp.json
```

### 3. 既存の構造を把握

```bash
# 何があるか確認
tree -L 2 -a .claude/ .cursor/
cat CLAUDE.md | grep "^#" | head -20
```

## ステップバイステップの移行

### フェーズ1: ディレクトリ構造の作成

```bash
# 新しいディレクトリを作成
mkdir -p .gemini/commands/{adr,test,ui,refactor,doc,lint,git,arch,story}

# 確認
tree -L 2 .gemini/
```

### フェーズ2: コンテキストの移行

#### CLAUDE.md → GEMINI.md

```bash
# テンプレートをコピー
cp CLAUDE.md GEMINI.md
```

次に `GEMINI.md` を編集:

1. **ペルソナセクションを抽出**:
   - 「あなたの役割」
   - 「コア原則」
   - 「開発原則」

2. **タスク固有のセクションを削除**:
   - 個別のエージェント指示
   - タスク固有のプロンプト
   - これらは後で .toml ファイルに移動

3. **@参照を更新**:
   ```markdown
   <!-- Before -->
   @README.md, @ARCHITECTURE.md
   
   <!-- After -->
   README.md, ARCHITECTURE.md (@ プレフィックスなし)
   ```

4. **ワークフローセクションを追加**:
   ```markdown
   ## 11フェーズ開発ワークフロー
   
   ### フェーズ選択ガイド
   [フェーズマッピングテーブルを追加]
   ```

### フェーズ3: エージェントのリファクタリング

#### .claude/agents/*.md → .gemini/commands/*.toml

各エージェントファイルを変換:

**例: ADR Manager**

**Before (.claude/agents/adr-manager.md):**
```markdown
# ADR Manager Agent

あなたはアーキテクチャ決定を管理する専門エージェントです。

## タスク

新しいADRを作成する際:
1. docs/adr/ディレクトリの既存ADRを確認
2. 次の番号を決定
3. テンプレートに従って作成
...
```

**After (.gemini/commands/adr/record.toml):**
```toml
name = "adr:record"
description = "新しいアーキテクチャ決定記録を作成"

prompt = """
新しいADRを作成してください:

1. docs/adr/ディレクトリの既存ADRを確認
2. 次の番号を決定 (ADR-XXXX)
3. 以下のテンプレートを使用:

\`\`\`markdown
# ADR-XXXX: [タイトル]

日付: YYYY-MM-DD
ステータス: 提案中

## 背景
[問題の説明]

## 決定
[決定内容]

## 結果
[影響]

## 代替案
[検討した他の選択肢]
\`\`\`

4. docs/adr/README.mdにエントリを追加
"""
```

**変換パターン**:
- エージェントの紹介 → `description`フィールド
- タスクセクション → `prompt`フィールド
- 複数ステップ → 番号付きリスト形式
- コード例 → トリプルバッククォートでエスケープ

### フェーズ4: コマンドの変換

**すべてのエージェント**:
- adr-manager.md → `adr/record.toml` + `adr/search.toml`
- test-enforcer.md → `test/gen.toml`
- ui-ux-advisor.md → `ui/review.toml` + `ui/propose.toml`
- refactoring-specialist.md → `refactor/review.toml`
- documentation-writer.md → `doc/add.toml`
- code-quality-guardian.md → `lint/fix.toml`
- git-commit-assistant.md → `git/commit.toml`

**名前空間設計**:
```
/domain:action
例:
/adr:record      (新しいADRを記録)
/adr:search      (既存のADRを検索)
/test:gen        (テストを生成)
/ui:review       (UIをレビュー)
```

### フェーズ5: MCP設定の更新

#### .mcp.json → .gemini/settings.json

**Before (.mcp.json):**
```json
{
  "mcpServers": {
    "kiri": {
      "command": "npx",
      "args": ["kiri-mcp-server@latest", "--repo", ".", "--db", ".kiri/index.duckdb"]
    }
  }
}
```

**After (.gemini/settings.json):**
```json
{
  "coreTools": ["fileRead", "fileWrite", "grep", "terminal", "webSearch"],
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

**変更点**:
1. `coreTools`配列を追加
2. 各MCPサーバーに`autoEnable`を追加
3. 各MCPサーバーに`description`を追加
4. トランスポートオブジェクトは不要（直接commandとargsを使用）

### フェーズ6: エクステンションマニフェストの作成

`gemini-extension.json` を作成:

```json
{
  "name": "docdd-workflow",
  "version": "1.0.0",
  "description": "Document-Driven Development workflow for Gemini CLI",
  "repository": "https://github.com/naohiro-kumagai/docdd",
  "config": {
    "mcpServers": {
      "kiri": { "autoEnable": true },
      "serena": { "autoEnable": true },
      "context7": { "autoEnable": true }
    },
    "coreTools": ["fileRead", "fileWrite", "grep", "terminal", "webSearch"]
  },
  "postInstall": [
    "echo 'DocDD ワークフローがインストールされました!'",
    "echo '使用方法: gemini'",
    "echo 'コマンド一覧: /adr:record, /test:gen, /ui:review など'"
  ],
  "commands": [
    "adr:record", "adr:search",
    "test:gen",
    "ui:review", "ui:propose",
    "refactor:review",
    "doc:add",
    "lint:fix",
    "git:commit",
    "arch:design",
    "story:create"
  ],
  "keywords": ["docdd", "adr", "mcp", "workflow", "automation"]
}
```

### フェーズ7: ドキュメントの作成

3つの主要ドキュメントを作成:

1. **ARCHITECTURE.md** - システム概要
2. **GEMINI_README.md** - ユーザーガイド
3. **このファイル** - 移行ガイド

### フェーズ8: ローカルテスト

```bash
# エクステンションをローカルインストール
gemini extensions install --path=.

# 起動
gemini

# テスト
/tools        # すべてのツールが表示されるはず
/mcp          # MCPサーバーがアクティブなはず
/adr:record   # カスタムコマンドが動作するはず
```

### フェーズ9: VS Code統合の有効化

```bash
# VS Code内
gemini
/ide install
/ide enable

# テスト
> GEMINI.mdの内容を要約してください
```

### フェーズ10: GitHubへの公開

```bash
# コミット
git add .gemini/ GEMINI.md gemini-extension.json ARCHITECTURE.md
git commit -m "feat: Gemini CLI エクステンションを追加"

# プッシュ
git push origin main

# タグ
git tag v1.0.0
git push --tags
```

## ファイルマッピング

| Claude/Cursor | Gemini CLI | 注記 |
|--------------|------------|------|
| `CLAUDE.md` | `GEMINI.md` | ペルソナのみを保持 |
| `.claude/agents/adr-manager.md` | `.gemini/commands/adr/record.toml` | タスクをコマンドに変換 |
| `.claude/agents/test-enforcer.md` | `.gemini/commands/test/gen.toml` | 同上 |
| `.claude/settings.json` | `.gemini/settings.json` | coreToolsを追加 |
| `.mcp.json` | `.gemini/settings.json` | settings.jsonにマージ |
| `.cursor/commands/*.md` | `.gemini/commands/*.toml` | MDからTOMLへ変換 |
| なし | `gemini-extension.json` | 新規: エクステンションマニフェスト |
| なし | `ARCHITECTURE.md` | 新規: システムドキュメント |

## 設定の変換

### MCPサーバー設定

**変換ルール**:

1. **Transportオブジェクトを削除**:
   ```json
   // Before
   "transport": {
     "type": "stdio",
     "command": "npx",
     "args": [...]
   }
   
   // After
   "command": "npx",
   "args": [...]
   ```

2. **autoEnableを追加**:
   ```json
   "autoEnable": true  // 自動起動用
   ```

3. **descriptionを追加**:
   ```json
   "description": "Kiri MCP for semantic code search"
   ```

### コマンド変換

**Markdownからのテンプレート**:

```toml
name = "namespace:action"
description = "1行の説明"

prompt = """
複数行の指示がここに入ります。

トリプルクォートでMarkdownをエスケープ:
\`\`\`typescript
// コード例
\`\`\`

番号付きリストの使用:
1. ステップ1
2. ステップ2
3. ステップ3
"""
```

## よくある落とし穴

### 1. @参照構文

❌ **間違い**: `@ARCHITECTURE.md` を GEMINI.md に残す
✅ **正しい**: `ARCHITECTURE.md` (プレフィックスなし)

### 2. Transport設定

❌ **間違い**: settings.jsonに`transport`オブジェクトを含める
✅ **正しい**: `command`と`args`を直接使用

### 3. coreToolsフォーマット

❌ **間違い**:
```json
"tools": {
  "core": {
    "fileRead": { "enabled": true }
  }
}
```

✅ **正しい**:
```json
"coreTools": ["fileRead", "fileWrite", "grep", "terminal", "webSearch"]
```

### 4. コマンド名前空間

❌ **間違い**: `record_adr.toml` (フラットな命名)
✅ **正しい**: `adr/record.toml` (階層的)

### 5. プロンプトのエスケープ

❌ **間違い**:
```toml
prompt = """
コード例:
```typescript  <- これで壊れます
```

✅ **正しい**:
```toml
prompt = """
コード例:
\`\`\`typescript  <- バッククォートをエスケープ
\`\`\`
"""
```

## 検証チェックリスト

### インストール後

- [ ] `gemini extensions list` に docdd-workflow が表示される
- [ ] `gemini` がエラーなしで起動する
- [ ] `/tools` がコアツールとMCPツールを表示する
- [ ] `/mcp` が自動有効化されたサーバーを表示する

### コマンドのテスト

- [ ] `/adr:record` が動作する
- [ ] `/test:gen` が動作する
- [ ] `/ui:review` が動作する
- [ ] `/git:commit` が動作する
- [ ] タブ補完が `/adr:<Tab>` で動作する

### MCPサーバー

- [ ] Kiri が自動起動する
- [ ] Serena が自動起動する（uvxがインストールされている場合）
- [ ] Context7 が自動起動する
- [ ] `/mcp` ですべてのサーバーが緑色（アクティブ）で表示される

### コンテキストの読み込み

- [ ] `> DocDDワークフローについて教えてください` に正しく応答する
- [ ] AIが11フェーズワークフローを理解している
- [ ] AIがプロジェクト固有のルールに従う

### VS Code統合

- [ ] `/ide install` がエラーなしで実行される
- [ ] `/ide enable` が統合を有効化する
- [ ] VS Code の Gemini Agent が同じワークフローを使用する

## トラブルシューティング

### uvx が見つからない

```bash
wget -qO- https://astral.sh/uv/install.sh | bash
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

### MCPサーバーが起動しない

```bash
# ログを確認
/debug

# 手動で再起動
/mcp restart kiri

# 無効化/有効化
/mcp disable kiri
/mcp enable kiri
```

### コマンドが見つからない

```bash
# .gemini/commands/ の構造を確認
find .gemini/commands -name "*.toml"

# 再インストール
gemini extensions uninstall docdd-workflow
gemini extensions install --path=.
```

## 次のステップ

移行が完了したら:

1. **チームに共有**:
   ```bash
   git push origin main
   git tag v1.0.0
   git push --tags
   ```

2. **ドキュメントを更新**:
   - README.mdにGemini CLIの指示を追加
   - 寄稿ガイドラインを更新

3. **チームをトレーニング**:
   - Gemini CLIのデモセッションを実施
   - 11フェーズワークフローについてドキュメントを共有

4. **継続的改善**:
   - より多くのカスタムコマンドを追加
   - コンポーネント固有の GEMINI.md ファイルを作成
   - ワークフローをプロジェクトのニーズに合わせて調整

---

移行に成功しました！🎉 それでは、次のステップに進みましょう!🐟
