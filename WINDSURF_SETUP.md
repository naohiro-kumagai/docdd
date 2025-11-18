# Windsurf IDE 設定ガイド完全版

**DocDD × Windsurf: エージェンティック開発環境のセットアップと運用戦略**

このドキュメントは、Windsurf IDEの設定ファイル体系と、DocDDの11フェーズワークフローを最大限に活用するための完全ガイドです。

> **注意**: ワークフローの実行手順については [WINDSURF.md](./WINDSURF.md) を参照してください。このドキュメントは設定に特化しています。

---

## 目次

1. [Windsurf設定ファイル体系](#windsurf設定ファイル体系)
2. [ルールファイル詳細](#ルールファイル詳細)
3. [ワークフローファイル詳細](#ワークフローファイル詳細)
4. [除外設定戦略](#除外設定戦略)
5. [MCP統合設定](#mcp統合設定)
6. [グローバル設定](#グローバル設定)
7. [セットアップ手順](#セットアップ手順)

---

## Windsurf設定ファイル体系

### プロジェクトレベル設定

```
docdd-kumagai/
├── .windsurf/                          # Windsurf IDE設定（Wave 8+）
│   ├── rules/                         # AI振る舞いルール
│   │   ├── tech-stack.md             # 技術スタック・制約定義
│   │   ├── coding-standards.md       # コーディング規約
│   │   ├── architecture.md           # アーキテクチャ原則
│   │   └── testing.md                # テスト戦略
│   ├── workflows/                     # 自動化ワークフロー
│   │   ├── full-workflow.md          # 11フェーズ完全実行
│   │   ├── quick-impl.md             # 簡易実装フロー
│   │   └── fix-bug.md                # バグ修正専用フロー
│   └── mcp_config.template.json       # MCP設定テンプレート
└── .codeiumignore                     # AI除外ファイル定義
```

### グローバル設定（ユーザーホーム）

```
~/.codeium/windsurf/
├── mcp_config.json                    # MCPサーバー設定（実運用）
├── memories/                          # Cascade記憶領域
│   ├── global_rules.md               # グローバルルール
│   └── *.pb                          # 自動学習データ（Protocol Buffers）
└── User/
    └── settings.json                 # Windsurf設定
```

**macOS/Linux パス**:
- `~/.codeium/windsurf/`

**Windows パス**:
- `%APPDATA%\Codeium\Windsurf\`

---

## ルールファイル詳細

### 概要

Wave 8で導入された `.windsurf/rules/` ディレクトリは、単一ファイル形式（`.windsurfrules`）の後継として、モジュール化されたルール管理を実現します。

**主な利点**:
- **モジュール性**: 技術スタック、コーディング規約、アーキテクチャ等をファイル分割
- **メンテナンス性**: テーマごとに独立して更新可能
- **コンテキスト最適化**: Cascadeが関連性の高いルールのみを動的に読み込み

### tech-stack.md

**目的**: プロジェクトで使用する技術、バージョン、必須ライブラリを定義

**記述内容**:
```markdown
# 技術スタック定義

## 言語とランタイム
- TypeScript: 5.x以上（厳格な型チェック必須）
- Node.js: 18.x以上

## フレームワーク
- React: 19.x（Server Components優先）
- Next.js: 15.x以上（App Router）

## 重要な制約
- `any` 型の使用禁止
- バレルインポート禁止（明示的な `@/` パス使用）
- Server Components優先、必要時のみClient Components

## MCP統合
- Context7: ライブラリドキュメント取得
- Kiri: セマンティックコード検索
- Serena: シンボリック編集
- Chrome DevTools: ブラウザ自動化（WSL/Linux動作確認済み）
```

**AIへの影響**:
- Cascadeは指定されたバージョンのAPIのみを提案
- 禁止事項（`any`型、バレルインポート等）を自動的に回避

### coding-standards.md

**目的**: 命名規則、エラーハンドリング、コメント方針を統一

**記述内容**:
```markdown
# コーディング規約

## 命名規則
- 変数・関数: キャメルケース（`camelCase`）
- 定数: 大文字スネークケース（`UPPER_SNAKE_CASE`）
- 型・クラス: パスカルケース（`PascalCase`）

## エラーハンドリング
- 非同期処理: `.then().catch()` パターン
- 同期処理: `try-catch` を予約

## コメント（日本語必須）
```typescript
// ✅ 良い例: 意図を明確に
/**
 * ユーザー認証トークンを検証し、有効期限をチェック
 * @param token - JWTトークン文字列
 * @returns 有効な場合はtrue
 */
function validateToken(token: string): boolean {
  // トークンのフォーマット検証
  if (!token.startsWith('Bearer ')) return false
  
  // 有効期限チェック（24時間以内）
  const expiresAt = parseTokenExpiry(token)
  return Date.now() < expiresAt
}
```

## インポート規則
```typescript
// ✅ 明示的パス
import { Button } from '@/components/ui/button'
import { formatDate } from '@/lib/utils/date'

// ❌ バレルインポート禁止
import { Button, formatDate } from '@/lib'
```
```

**AIへの影響**:
- 生成されるコードが自動的に規約に準拠
- Good/Bad例を参照して適切なパターンを選択

### architecture.md

**目的**: ディレクトリ構造、SOLID原則、状態管理戦略を定義

**記述内容**:
```markdown
# アーキテクチャ原則

## ディレクトリ構造
```
src/
├── components/     # UIコンポーネント
├── lib/           # ユーティリティ
├── services/      # ビジネスロジック
└── types/         # 型定義
```

## SOLID原則の遵守

### 単一責任の原則（SRP）
```typescript
// ✅ 良い例
class UserValidator {
  validate(user: User): ValidationResult { /* ... */ }
}

class UserRepository {
  async save(user: User): Promise<void> { /* ... */ }
}

// ❌ 悪い例
class UserManager {
  validate(user: User) { /* ... */ }
  save(user: User) { /* ... */ }
  sendEmail(user: User) { /* ... */ }
}
```

## React/Next.jsパターン
- Server Components優先
- Presenterパターンでロジック分離
- 最小限の`useEffect`

## ADR管理
- 重要な決定は `docs/adr/` に記録必須
- 実装前に既存ADRを確認
```

**AIへの影響**:
- コンポーネント設計時にSOLID原則を自動適用
- ADR確認を実装前に促す

### testing.md

**目的**: テストフレームワーク、記述形式、カバレッジ要件を定義

**記述内容**:
```markdown
# テスト戦略

## テストフレームワーク
- 単体・統合: Vitest
- コンポーネント: React Testing Library
- E2E: Playwright

## AAAパターン（必須）
```typescript
test('商品が空の場合、0を返すこと', () => {
  // Arrange: テストデータ準備
  const items = []
  const expected = 0

  // Act: 実行
  const actual = calculateTotal(items)

  // Assert: 検証
  expect(actual).toBe(expected)
})
```

## テストタイトル形式（日本語）
**フォーマット**: `[条件]の場合、[期待される結果]こと`

例:
- `ユーザーがログイン済みの場合、ダッシュボードを表示すること`
- `入力値が空の場合、バリデーションエラーを返すこと`

## カバレッジ要件
- ビジネスロジック: 100%ブランチカバレッジ
- ユーティリティ関数: 90%以上
- UIコンポーネント: 主要な条件分岐
```

**AIへの影響**:
- テスト生成時にAAAパターンを自動適用
- 日本語タイトルで可読性向上

---

## ワークフローファイル詳細

### 概要

`.windsurf/workflows/` 内のMarkdownファイルは、スラッシュコマンドとして呼び出し可能な自動化手順を定義します。

**呼び出し方法**:
- ファイル名 `full-workflow.md` → コマンド `/full-workflow`

### full-workflow.md

**目的**: DocDDの11フェーズすべてを順次実行

**構造**:
```markdown
# DocDD 完全開発フロー

## Phase 1: Investigation & Research
### Step 1-1: ADR確認
1. `docs/adr/index.json` を確認
2. 関連ADRを読み取る
3. 既存決定との整合性を検証

### Step 1-2: コードベース調査
[具体的な手順]

## Phase 2: Architecture Design
[設計手順]

...

## Phase 11: Push
[プッシュ手順]
```

**使用タイミング**:
- 新機能追加
- 大規模リファクタリング
- アーキテクチャ変更

### quick-impl.md

**目的**: 小規模修正用の簡略版フロー

**スキップされるフェーズ**:
- Phase 2 (Architecture)
- Phase 3 (UI Design)
- Phase 6 (Testing)
- Phase 7 (Code Review)
- Phase 9B (Browser Verification)

**実行フロー**:
```
Phase 1 → Phase 4 → Phase 5 → Phase 8 → Phase 10 → Phase 11
```

**使用タイミング**:
- タイポ修正
- 小規模バグ修正（既存パターン踏襲）
- スタイル調整

### fix-bug.md

**目的**: バグ修正専用のTDD的アプローチ

**特徴**:
1. バグ再現テストを先に作成
2. テストが失敗することを確認
3. 修正を実装
4. テストがパスすることを確認
5. 追加テストで再発防止

**フロー**:
```
バグ再現 → 原因特定 → 再現テスト作成 → 修正 → 検証 → コミット
```

---

## 除外設定戦略

### .codeiumignore の役割

**目的**: AIに読ませたくないファイルを定義（`.gitignore` 構文互換）

**除外理由**:
1. **機密情報**: `.env.local`, `*.pem`, 認証トークン
2. **ノイズファイル**: `node_modules/`, ロックファイル、ログ
3. **廃止コード**: `deprecated/`, `legacy/`（学習されると悪影響）
4. **大規模データ**: データベースファイル、バイナリ

**プロジェクトレベル** (リポジトリルート):
```gitignore
# 機密情報
.env.local
.env.*.local
*.pem
*.key

# ノイズ
node_modules/
package-lock.json
*.log

# 廃止コード
deprecated/
legacy/
```

**グローバルレベル** (`~/.codeium/.codeiumignore`):
```gitignore
# OS生成ファイル
.DS_Store
Thumbs.db

# 個人メモ
*.scratch
notes/
```

### .gitignore との関係

- **デフォルト**: Windsurfは `.gitignore` を尊重
- **例外設定**: 設定で "Cascade Gitignore Access" を有効化すると、`.gitignore` 除外ファイルもAIが読み取り可能
- **優先順位**: `.gitignore` > `.codeiumignore`（`.gitignore` で除外されたファイルは `.codeiumignore` で復活不可）

---

## MCP統合設定

### mcp_config.json

**配置場所**: `~/.codeium/windsurf/mcp_config.json`（グローバル）

**注意**: 現在Windsurfはプロジェクトローカルな `mcp_config.json` を完全にはサポートしていません。グローバル設定を使用し、WindsurfのGUIから個別に有効化/無効化します。

**基本構造**:
```json
{
  "mcpServers": {
    "server-name": {
      "command": "npx",
      "args": ["-y", "@package/name"],
      "env": {
        "API_KEY": "your_key"
      }
    }
  }
}
```

### DocDD推奨MCPサーバー

#### 1. Context7（ドキュメント取得）
```json
"context7": {
  "command": "npx",
  "args": ["-y", "@context7/mcp-server"]
}
```

**機能**: 最新のライブラリドキュメントを取得

**使用例**:
```
"Next.js 15のApp Routerでユーザー認証を実装"
→ Context7が最新ドキュメントを参照して適切な実装を提案
```

#### 2. Kiri（セマンティック検索）
```json
"kiri": {
  "command": "npx",
  "args": ["-y", "@kiri/mcp-server", "/path/to/project"]
}
```

**機能**: コードベース全体のセマンティック検索、依存関係分析

**使用例**:
```
"認証トークンの検証ロジックはどこ?"
→ Kiriが類似コードをプロジェクト全体から検索
```

#### 3. Serena（シンボリック編集）
```json
"serena": {
  "command": "npx",
  "args": ["-y", "@serena/mcp-server", "/path/to/project"]
}
```

**機能**: 関数/クラス単位での安全な編集

**使用例**:
```
"UserServiceクラスのcreateUserメソッドをリファクタリング"
→ Serenaがシンボル境界を認識して編集
```

#### 4. GitHub（Issue・PR管理）
```json
"github": {
  "command": "npx",
  "args": ["-y", "@modelcontextprotocol/server-github"],
  "env": {
    "GITHUB_PERSONAL_ACCESS_TOKEN": "<YOUR_TOKEN>"
  }
}
```

**機能**: Issue作成、PR管理、リポジトリ情報取得

#### 5. Chrome DevTools（WSL/Linux対応）
```json
"chrome-devtools": {
  "command": "npx",
  "args": [
    "-y",
    "@modelcontextprotocol/server-chrome-devtools",
    "--browserUrl",
    "http://127.0.0.1:9222"
  ]
}
```

**事前準備**:
```bash
bash scripts/start-chrome-devtools.sh
```

**機能**: ブラウザのコンソールエラー取得、スクリーンショット、ネットワーク監視

#### 6. Playwright（E2Eテスト）
```json
"playwright": {
  "serverUrl": "http://localhost:3000/sse"
}
```

**注意**: Docker環境で `playwright-mcp` サーバーを事前起動

**機能**: ブラウザ自動化、E2Eテスト実行

---

## グローバル設定

### global_rules.md

**配置場所**: `~/.codeium/windsurf/memories/global_rules.md`

**目的**: すべてのプロジェクトに共通して適用される基本姿勢

**推奨内容**:
```markdown
# グローバルルール

## コミュニケーション
- すべての回答は日本語で行う
- 技術用語は英語のまま使用（例: "React", "TypeScript"）

## セキュリティ
- APIキーやパスワードのハードコード禁止
- 環境変数を必ず使用する
- ログ出力時は機密情報をマスキング

## 作業フロー
- コードを書く前に変更計画を提示し、承認を得る
- 大規模な変更は段階的に実装する
- 不明点があれば即座に質問する

## 品質保証
- 型安全性を最優先（`any` 型禁止）
- すべてのコミット前に品質チェックを実行
- テストがない変更はコミットしない
```

### settings.json（Windsurf固有設定）

**配置場所**: 
- macOS: `~/Library/Application Support/Windsurf/User/settings.json`
- Linux: `~/.config/Windsurf/User/settings.json`
- Windows: `%APPDATA%\Windsurf\User\settings.json`

**重要な設定キー**:

```json
{
  "windsurf.cascadeCommandsAllowList": [
    "ls", "cat", "grep", "git status", "npm test"
  ],
  "windsurf.cascadeCommandsDenyList": [
    "rm -rf /", "shutdown", "format"
  ],
  "windsurf.enableTurboMode": false,
  "telemetry.telemetryLevel": "off"
}
```

**説明**:
- `cascadeCommandsAllowList`: 自動実行を許可するコマンド（読み取り系）
- `cascadeCommandsDenyList`: 絶対に実行させないコマンド（破壊的）
- `enableTurboMode`: `true` で自律的にコマンド連続実行（要監視）
- `telemetryLevel`: `off` でテレメトリ無効化

---

## セットアップ手順

### ステップ1: プロジェクトへのルール配置

```bash
# DocDDリポジトリから設定をコピー
cd /path/to/your-project

# Windsurfディレクトリをコピー
cp -r /path/to/docdd-kumagai/.windsurf ./

# 除外設定をコピー
cp /path/to/docdd-kumagai/.codeiumignore ./

# Gitに追加
git add .windsurf/ .codeiumignore
git commit -m "feat: Windsurf IDE設定を追加"
```

### ステップ2: グローバルMCP設定

```bash
# 設定ディレクトリ作成
mkdir -p ~/.codeium/windsurf

# テンプレートをコピー
cp .windsurf/mcp_config.template.json ~/.codeium/windsurf/mcp_config.json

# プロジェクトパスを置換（macOS/BSD sed）
sed -i '' 's|{{PROJECT_PATH}}|'$(pwd)'|g' ~/.codeium/windsurf/mcp_config.json

# Linux（GNU sed）の場合
sed -i 's|{{PROJECT_PATH}}|'$(pwd)'|g' ~/.codeium/windsurf/mcp_config.json

# GitHubトークンを設定
sed -i '' 's|<YOUR_GITHUB_TOKEN>|ghp_your_actual_token|g' ~/.codeium/windsurf/mcp_config.json
```

### ステップ3: グローバルルール作成（任意）

```bash
# memoriesディレクトリ作成
mkdir -p ~/.codeium/windsurf/memories

# グローバルルールを作成
cat > ~/.codeium/windsurf/memories/global_rules.md << 'EOF'
# グローバルルール

## 言語設定
- すべての回答は日本語で行う

## セキュリティ
- 機密情報のハードコード禁止

## 作業フロー
- 変更前に計画を提示し承認を得る
EOF
```

### ステップ4: Windsurf再起動

1. Windsurfを完全に終了
2. 再起動してMCP設定を読み込み
3. Cascadeパネル（サイドバー）を開く
4. "Plugins" または "MCP Servers" タブで接続状態を確認

### ステップ5: 動作確認

Cascadeチャットで以下を実行：

```
/full-workflow
```

ワークフローのステップが表示されれば成功です。

---

## まとめ

Windsurf IDEでDocDDを実現するための設定ファイル：

### 必須設定（プロジェクト）
1. ✅ `.windsurf/rules/` - AI振る舞いルール（4ファイル）
2. ✅ `.windsurf/workflows/` - 自動化ワークフロー（3ファイル以上）
3. ✅ `.codeiumignore` - AI除外設定

### 推奨設定（グローバル）
4. ✅ `~/.codeium/windsurf/mcp_config.json` - MCP統合
5. ✅ `~/.codeium/windsurf/memories/global_rules.md` - グローバルルール
6. ✅ `~/.codeium/windsurf/User/settings.json` - Windsurf設定

### 運用のポイント
- **ルールは生きたドキュメント**: プロジェクトの成長に合わせて更新
- **ワークフローは資産**: チーム内で共有し、ベストプラクティスを蓄積
- **MCPは必要に応じて**: すべてのサーバーを有効にする必要はない
- **Cascade Memoriesを定期レビュー**: AIが学習した内容を確認・削除

---

## 参考資料

- **ワークフロー実行手順**: [WINDSURF.md](./WINDSURF.md)
- **DocDD 11フェーズ**: [CLAUDE.md](./CLAUDE.md)
- **MCP統合**: [MCP_REFERENCE.md](./MCP_REFERENCE.md)
- **VS Code Copilot**: [VSCODE_COPILOT_SETUP.md](./VSCODE_COPILOT_SETUP.md)
