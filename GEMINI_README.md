# DocDD for Gemini CLI - 使用ガイド

Gemini CLI 用の DocDD (Document-Driven Development) ワークフローへようこそ！

## 📋 目次

- [クイックスタート](#クイックスタート)
- [基本的な使い方](#基本的な使い方)
- [利用可能なコマンド](#利用可能なコマンド)
- [11フェーズワークフロー](#11フェーズワークフロー)
- [MCPサーバー](#mcpサーバー)
- [VS Code統合](#vs-code統合)
- [トラブルシューティング](#トラブルシューティング)

## クイックスタート

### インストール

```bash
# Gemini CLI のインストール
npm install -g @google/gemini-cli

# DocDD エクステンションのインストール
gemini extensions install https://github.com/naohiro-kumagai/docdd

# プロジェクトディレクトリに移動
cd your-project/

# 起動
gemini
```

### 初回起動後

```bash
# ツール一覧を確認
/tools

# MCPサーバーの状態を確認
/mcp

# 利用可能なカスタムコマンドを確認
/adr:<Tab>    # ADR関連コマンド
/test:<Tab>   # テスト関連コマンド
/ui:<Tab>     # UI関連コマンド
```

## 基本的な使い方

### 対話モード（推奨）

```bash
gemini

# セッション内で
> 新しいログイン機能を実装してください

# コマンドを使用
/adr:record
/test:gen
/git:commit
```

### ワンショットモード

```bash
# 1つの質問を投げて終了
gemini "この関数を最適化してください"

# ファイルを参照
gemini "auth.tsのセキュリティをレビューしてください"
```

## 利用可能なコマンド

### ADR（アーキテクチャ決定記録）

| コマンド | 説明 | 使用例 |
|---------|------|--------|
| `/adr:record` | 新しいADRを記録 | アーキテクチャ決定の文書化 |
| `/adr:search` | 既存のADRを検索 | 過去の決定を確認 |

### テスト

| コマンド | 説明 | 使用例 |
|---------|------|--------|
| `/test:gen` | ユニットテストを生成 | AAAパターンでテストコード作成 |

### UI/UX

| コマンド | 説明 | 使用例 |
|---------|------|--------|
| `/ui:review` | UIデザインをレビュー | アクセシビリティチェック |
| `/ui:propose` | UI改善案を提案 | デザイン改善の提案 |

### リファクタリング

| コマンド | 説明 | 使用例 |
|---------|------|--------|
| `/refactor:review` | コード品質をレビュー | SOLID原則準拠チェック |

### ドキュメント

| コマンド | 説明 | 使用例 |
|---------|------|--------|
| `/doc:add` | JSDoc/TSDocを追加 | 関数・クラスのドキュメント化 |

### Lint

| コマンド | 説明 | 使用例 |
|---------|------|--------|
| `/lint:fix` | Lintエラーを修正 | ESLint/Prettierの自動修正 |

### Git

| コマンド | 説明 | 使用例 |
|---------|------|--------|
| `/git:commit` | コミットメッセージを生成 | Conventional Commits形式 |

### アーキテクチャ

| コマンド | 説明 | 使用例 |
|---------|------|--------|
| `/arch:design` | システム設計を支援 | アーキテクチャの設計 |

### Storybook

| コマンド | 説明 | 使用例 |
|---------|------|--------|
| `/story:create` | Storybookストーリーを作成 | コンポーネントのストーリー作成 |

## 11フェーズワークフロー

DocDD は体系的な開発プロセスを11のフェーズに分割しています:

### フェーズ選択ガイド

| 変更タイプ | 推奨フェーズ | 推定時間 |
|----------|------------|---------|
| **新機能** | 1-11（すべて） | 60-120分 |
| **中規模バグ修正** | 1,4,5,6,8,9A,10,11 | 30-60分 |
| **UI調整** | 1,3,4,5,8,9A,10,11 | 20-40分 |
| **小規模リファクタリング** | 1,4,5,8,10,11 | 15-30分 |
| **タイポ修正** | 5,8,10,11 | 5分 |
| **ドキュメント更新** | 5,10,11 | 5-10分 |

### 各フェーズの詳細

#### フェーズ1: 調査・研究 [必須]

**使用ツール**: Kiri MCP, Context7 MCP, `/grep`, `/search`

```bash
> ユーザー認証機能について調査してください
```

AIが自動的に:
- Kiri MCPでコードベースを検索
- Context7で関連ドキュメントを取得
- 既存のADRをチェック
- 実装アプローチを提案

#### フェーズ2: アーキテクチャ設計 [推奨: 新機能/大規模変更]

```bash
/arch:design
```

- ファイル配置とディレクトリ構造を設計
- 状態管理アプローチを定義
- コンポーネント階層とデータフローを設計

#### フェーズ3: UI/UXデザイン [推奨: UI変更]

```bash
/ui:review
```

- スタイルガイドに対してデザインをレビュー
- アクセシビリティ準拠を確認
- レスポンシブデザインを検証

#### フェーズ4: 計画 [必須]

```bash
/memory add "計画: タスク1, タスク2, タスク3"
```

- 作業を細かいタスクに分解
- 実装順序を定義
- 依存関係を特定

#### フェーズ5: 実装 [必須]

```bash
> ログイン機能を実装してください
```

AIが自動的に:
- Serena MCPでシンボルベースの編集
- 厳格なTypeScript型付け
- 意図を日本語コメントで文書化

#### フェーズ6: テスト [推奨: ロジック変更]

```bash
/test:gen
```

- AAAパターン（Arrange-Act-Assert）のテスト生成
- 日本語のテストタイトル
- 重要パスの100%ブランチカバレッジ

#### フェーズ7: コードレビュー [推奨: リファクタリング]

```bash
/refactor:review
```

- SOLID原則準拠チェック
- コードスメルの確認
- パフォーマンス検討

#### フェーズ8: 品質チェック [必須]

```bash
> すべての品質チェックを実行してください
```

AIが実行:
```bash
npm run type-check
npm run lint
npm run test
npm run build
```

#### フェーズ9A: ランタイム検証 [必須]

Next.js Runtime MCP（該当する場合）:
- 開発サーバー起動
- ランタイムエラーなしを確認
- すべてのルートが認識されることを確認

#### フェーズ9B: ブラウザ検証 [オプション: 複雑なUI]

Chrome DevTools MCP:
- ユーザーフローをテスト
- Core Web Vitalsを測定
- アクセシビリティツリーを確認

#### フェーズ10: Gitコミット [必須]

```bash
/git:commit
```

Conventional Commits形式のメッセージを生成:
```
feat: ユーザー認証フローを追加
```

#### フェーズ11: プッシュ [必須]

```bash
> 変更をプッシュしてください
```

## MCPサーバー

DocDD は5つのMCPサーバーを統合しています:

### Kiri（自動有効）

**機能**: セマンティックコード検索と依存関係分析

```bash
> "認証ロジック"に関連するコードを見つけてください
```

Kiriが自動的に:
- セマンティック検索で関連コードを発見
- 依存関係ツリーを分析
- 影響範囲を特定

### Serena（自動有効）

**機能**: シンボルベースのコード編集

```bash
> LoginButton関数を更新してください
```

Serenaが自動的に:
- シンボル定義を検索
- プロジェクト全体で正確に編集
- 参照を自動更新

### Context7（自動有効）

**機能**: ライブラリドキュメント取得

```bash
> React HooksのベストプラクティスとuseEffectの使い方を教えてください
```

Context7が自動的に:
- 最新のライブラリドキュメントを取得
- APIの使用パターンを確認
- 破壊的変更をチェック

### Next.js Runtime（手動有効）

**機能**: ランタイムエラー検証

```bash
/mcp enable next-devtools
```

フェーズ9Aで使用:
- 開発サーバー監視
- ランタイムエラー検出
- ルーティング検証

### Chrome DevTools（手動有効）

**機能**: ブラウザ検証

```bash
/mcp enable chrome-devtools
```

フェーズ9Bで使用:
- DOMインスペクション
- パフォーマンス測定
- アクセシビリティ監査

## VS Code統合

Gemini CLI を VS Code の統合ターミナルで使用できます:

### セットアップ

```bash
# VS Code でターミナルを開く（Ctrl+`）
gemini

# IDEブリッジをインストール
/ide install

# 統合を有効化
/ide enable
```

### 機能

- **ファイル参照**: `@src/components/Button.tsx`
- **検索結果参照**: `@search "認証パターン"`
- **複数ファイル**: `@src/auth/jwt.ts と @src/auth/session.ts を比較`
- **シームレスな編集**: VS Codeエディタと同期

## トラブルシューティング

### MCPサーバーが起動しない

```bash
# MCPサーバーの状態を確認
/mcp

# 特定のサーバーを再起動
/mcp restart kiri

# ログを確認
/debug
```

### コマンドが見つからない

```bash
# エクステンションがインストールされているか確認
gemini extensions list

# 再インストール
gemini extensions install https://github.com/naohiro-kumagai/docdd
```

### コンテキストが読み込まれない

```bash
# GEMINI.mdが存在するか確認
ls -la GEMINI.md

# 手動でコンテキストを読み込み
> GEMINI.mdの内容を要約してください
```

### Serenaが起動しない（uvxエラー）

```bash
# uvをインストール
wget -qO- https://astral.sh/uv/install.sh | bash

# PATHに追加
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

# 確認
uvx --version
```

## 高度な使い方

### 階層的コンテキスト

```
~/.gemini/GEMINI.md              # 個人のデフォルト
└── project/
    ├── GEMINI.md                # プロジェクトルール
    ├── frontend/
    │   └── GEMINI.md            # React固有ルール
    └── backend/
        └── GEMINI.md            # API固有ルール
```

各ディレクトリに`GEMINI.md`を配置して、コンテキストを細かく制御できます。

### セッションメモリ

```bash
# 決定を保存
/memory add "決定: 状態管理にZustandを使用"

# 保存された内容を一覧表示
/memory list

# 検索
/memory search "状態管理"
```

### カスタムコマンドの追加

`.gemini/commands/` に新しい `.toml` ファイルを作成:

```toml
# .gemini/commands/deploy/staging.toml
name = "deploy:staging"
description = "Deploy to staging environment"
prompt = """
ステージング環境にデプロイしてください:
1. ビルドを実行
2. テストを実行
3. ステージングサーバーにデプロイ
4. ヘルスチェックを確認
"""
```

## ベストプラクティス

### 1. ADRを一貫して使用

```bash
# 重要な決定の前に
/adr:search "認証"

# 決定後
/adr:record
```

### 2. セッションメモリでコンテキストを維持

```bash
# セッション開始時
/memory add "今日のタスク: ログイン機能の実装"

# 進行中
/memory add "完了: バックエンドAPI"
/memory add "次: フロントエンドUI"
```

### 3. MCPツールを活用

```bash
# コード変更前に影響範囲をチェック
> この関数を変更すると何に影響しますか？（Kiri使用）

# ライブラリの使い方を確認
> Next.js 15の新機能を教えてください（Context7使用）
```

### 4. 段階的に進める

大きなタスクを小さなステップに分割:
```bash
> タスク1: データモデルを作成
> タスク2: APIエンドポイントを追加
> タスク3: フロントエンドコンポーネントを実装
> タスク4: テストを追加
```

## さらに詳しく

- [GEMINI.md](./GEMINI.md) - AI向け戦略的コンテキスト
- [ARCHITECTURE.md](./ARCHITECTURE.md) - システムアーキテクチャ
- [MIGRATION_GUIDE.md](./MIGRATION_GUIDE.md) - Claude/Cursorからの移行
- [GEMINI_CLI_SUMMARY.md](./GEMINI_CLI_SUMMARY.md) - 実装概要

---

**ハッピーコーディング！** 🐟
