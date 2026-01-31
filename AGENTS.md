# AGENTS.md - Coding Agent Guidelines

このファイルは、Claude、Gemini、Cursor など、様々なコーディングエージェント向けの共通ガイダンスです。

## 📚 重要：詳細な実装指示の場所

エディタの種類に関わらず、**すべての詳細な実装指示は以下に統一されています**：

```
.github/instructions/
```

### 各フェーズの指示書

コーディング作業では、以下のフェーズごとの指示書に従ってください：

| フェーズ | ファイル | 説明 |
|---------|---------|------|
| **Phase 1** | `phase1-investigation.instructions.md` | 調査・リサーチ |
| **Phase 2** | `phase2-architecture.instructions.md` | アーキテクチャ設計 |
| **Phase 3** | `phase3-ui-design.instructions.md` | UI/UX 設計 |
| **Phase 4** | `phase4-planning.instructions.md` | 実装計画 |
| **Phase 5** | `phase5-implementation.instructions.md` | 実装（コーディング） |
| **Phase 6** | `phase6-testing.instructions.md` | テスト & Storybook |
| **Phase 7** | `phase7-code-review.instructions.md` | コードレビュー |
| **Phase 8** | `phase8-quality-checks.instructions.md` | 品質チェック |
| **Phase 9** | `phase9-verification.instructions.md` | 動作検証 |
| **Phase 10** | `phase10-git-commit.instructions.md` | Git コミット |
| **Phase 11** | `phase11-push.instructions.md` | Push |

### 言語・フレームワーク別ガイド

```
.github/instructions/
├── typescript.instructions.md     TypeScript 実装ガイド
├── react.instructions.md          React コンポーネントガイド
└── temporary-documents.instructions.md  一時ドキュメント管理
```

## 🚀 クイックスタート

1. **タスクが与えられたら、必ず Phase 1（Investigation）から開始**
   - 関連する `.github/instructions/phase1-investigation.instructions.md` を参照

2. **各タスクで必要なフェーズだけを実行**
   - 完全なワークフロー（全 11 フェーズ）が必要な場合もあれば、一部のフェーズだけの場合もあります
   - 各フェーズファイルに「スキップ可能なケース」の説明があります

3. **言語・フレームワーク固有のルールに従う**
   - TypeScript: `.github/instructions/typescript.instructions.md`
   - React/UI: `.github/instructions/react.instructions.md`

## 📖 主なプロジェクト向けドキュメント

- **`.github/copilot-instructions.md`** - コアのワークフロー定義（全エージェント共通）
- **`CLAUDE.md`** - Claude 専用の詳細ガイド
- **`GEMINI.md`** - Gemini 専用の詳細ガイド
- **`WINDSURF.md`** - Windsurf 専用の詳細ガイド
- **`README.md`** - プロジェクト概要

## ⚠️ 重要ルール

### 非交渉事項（必ず守る）

- ✅ ADR 一貫性：既存の ADR（`docs/adr/`）を確認し従う
- ✅ 型安全性：TypeScript で `any` を使用しない
- ✅ テスト：新しいロジックには必ずテストが必要
- ✅ 品質チェック：コミット前に全チェック（型、リント、テスト、ビルド）をパス
- ✅ ドキュメント：複雑なロジックは日本語のコメントで説明
- ✅ バレルインポート禁止：常に `@/` パスの明示的インポート

## 🔄 実装フロー（簡易版）

```
タスク受け取り
   ↓
Phase 1: Investigation
   ├─ 関連 ADR を確認
   ├─ Kiri MCP で既存コードを調査
   └─ 参照: phase1-investigation.instructions.md
   ↓
Phase 2-4: Design & Planning
   ├─ アーキテクチャ設計（必要に応じて）
   ├─ UI/UX 設計（UI 変更の場合）
   └─ 実装計画
   ↓
Phase 5: Implementation
   ├─ コーディング（言語別ガイドに従う）
   └─ 参照: typescript.instructions.md, react.instructions.md
   ↓
Phase 6-7: Testing & Review
   ├─ テスト作成
   └─ コードレビュー
   ↓
Phase 8-9: Quality & Verification
   ├─ 品質チェック（型、リント、テスト、ビルド）
   └─ 動作検証
   ↓
Phase 10-11: Commit & Push
   ├─ Git コミット（日本語メッセージ）
   └─ Push
```

## 🎯 意思決定フロー

不明点や判断が必要な場合：

1. **実装パターンが不明** → `.github/instructions/` を確認
2. **型の扱いが不明** → `typescript.instructions.md` を確認
3. **React コンポーネント設計が不明** → `react.instructions.md` を確認
4. **アーキテクチャ決定が不明** → `docs/adr/index.json` と関連 ADR を確認
5. **それでも不明** → ユーザーに質問

## 📝 エージェント別ガイド

このプロジェクトに統合されている各エージェント用の詳細指示：

- `claude` → `CLAUDE.md`（+ `.github/copilot-instructions.md`）
- `gemini` → `GEMINI.md`（+ `.github/copilot-instructions.md`）
- `windsurf` → `WINDSURF.md`（+ `.github/copilot-instructions.md`）

**注意**: 各エージェント用ファイルは、本ファイル（AGENTS.md）と `.github/instructions/` の内容に追加する形で、補足情報を提供しています。

---

## 🤖 Claude Code 専用ガイド

Claude Code（CLI）を使用する場合は、以下の機能を活用してください。

### 利用可能なスキル（`/コマンド`）

| スキル | 説明 | 使用タイミング |
|--------|------|---------------|
| `/workflow` | ワークフロー選択ヘルパー | タスク開始時 |
| `/phase1` | 調査フェーズ | ADR確認、コード調査 |
| `/phase4` | 計画フェーズ | タスク分解、順序決定 |
| `/phase5` | 実装フェーズ | コーディング |
| `/phase8` | 品質チェック | 型チェック、リント、テスト |
| `/phase9` | 動作確認 | ランタイム検証 |
| `/phase10` | コミット | Git操作 |
| `/ui-review` | UIレビュー | デザイン改善提案 |
| `/adr-record` | ADR作成 | アーキテクチャ決定記録 |
| `/test-gen` | テスト生成 | Vitestテスト作成 |

### 利用可能なエージェント（Task tool）

| エージェント | 説明 |
|-------------|------|
| `component-refactoring-specialist` | Reactコンポーネントのリファクタリング |
| `test-guideline-enforcer` | テストコードの品質チェック |
| `storybook-story-creator` | Storybookストーリー作成 |
| `ui-design-advisor` | UI/UXデザインレビュー |
| `spec-document-creator` | 仕様書作成 |
| `adr-memory-manager` | ADR管理 |
| `project-onboarding` | プロジェクトオンボーディング |

### MCP統合

このプロジェクトでは以下のMCPサーバーが利用可能です：

| MCP | 用途 | 主な機能 |
|-----|------|---------|
| **Kiri** | コード調査 | セマンティック検索、依存関係分析 |
| **Serena** | コード編集 | シンボルベース編集、リネーム |
| **Context7** | ドキュメント | ライブラリドキュメント取得 |
| **Chrome DevTools** | ブラウザ検証 | スクリーンショット、パフォーマンス |
| **Next.js DevTools** | Next.js検証 | ランタイムエラー確認 |

### Claude Code ワークフロー例

```bash
# 1. ワークフロー選択
/workflow

# 2. 調査開始
/phase1

# 3. 計画立案
/phase4

# 4. 実装
/phase5

# 5. 品質チェック
/phase8

# 6. 動作確認
/phase9

# 7. コミット
/phase10
```

### タスク管理

Claude Codeでは`TaskCreate`/`TaskUpdate`/`TaskList`ツールでタスク管理が可能です：

```
# タスク作成例
TaskCreate:
  subject: "UserCardコンポーネントを作成"
  description: "ユーザー情報を表示するカードコンポーネント"
  activeForm: "UserCardコンポーネントを作成中"
```

## 🔗 外部参考

- **AGENTS.md フォーマット仕様** → https://github.com/agentsmd/agents.md
- **プロジェクト ADR** → `docs/adr/`

---

**このファイルは、すべてのコーディングエージェントの入口です。詳細は `.github/instructions/` を参照してください。**
