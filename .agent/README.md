# Antigravity Skills

このディレクトリは、Google Antigravity の Skills を定義するためのルートです。

## 目的

- 必要なときだけ読み込まれる「スキル」を明示的に管理する
- LLMの判断とスクリプト処理を分離し、品質と再現性を高める
- Gitで共有可能な知識ベースを構築する

## ディレクトリ構造

```
.agent/
└── skills/
    └── {skill-name}/
        ├── SKILL.md       # スキル定義（必須）
        ├── scripts/       # 自動化スクリプト（任意）
        ├── resources/     # 参照ドキュメント（任意）
        └── examples/      # 実装例（任意）
```

## 利用可能なスキル一覧

### 🔍 品質・レビュー系

| スキル | 説明 | 起動条件 |
|--------|------|----------|
| **code-reviewer** | コード品質・セキュリティレビュー | コードレビュー依頼時 |
| **refactor-specialist** | Reactリファクタリング | リファクタリング作業時 |

### 📋 ドキュメント管理系

| スキル | 説明 | 起動条件 |
|--------|------|----------|
| **adr-manager** | アーキテクチャ決定記録の管理 | ADR作成・更新時 |
| **spec-creator** | 仕様書・設計書の作成 | 仕様書作成依頼時 |
| **temp-docs** | 一時ドキュメント管理 | 分析・調査レポート作成時 |

### 🧪 テスト・ストーリー系

| スキル | 説明 | 起動条件 |
|--------|------|----------|
| **test-generator** | Vitest/RTLテスト生成 | テスト作成時 |
| **story-creator** | Storybookストーリー生成 | Storybook作成時 |

### 🎨 UI/UX系

| スキル | 説明 | 起動条件 |
|--------|------|----------|
| **ui-advisor** | UI/UXデザインレビュー | UI変更・レビュー時 |
| **react-patterns** | React/Next.jsパターン | Reactコンポーネント作成時 |

### ⚙️ 開発基盤系

| スキル | 説明 | 起動条件 |
|--------|------|----------|
| **typescript-standards** | TypeScript開発規約 | TypeScriptファイル作成時 |
| **browser-tools** | ブラウザツール選択 | E2Eテスト・検証時 |
| **onboarding-specialist** | プロジェクトオンボーディング | 新規参加者対応時 |

### 📦 フェーズ系（開発ワークフロー）

| スキル | 説明 | 起動条件 |
|--------|------|----------|
| **phase-investigation** | Phase 1: 調査・リサーチ | 新機能・変更の調査時 |
| **phase-architecture** | Phase 2: アーキテクチャ設計 | 設計作業時 |
| **phase-planning** | Phase 4: 実装計画 | 計画立案時 |
| **phase-implementation** | Phase 5: 実装 | コーディング時 |
| **phase-quality** | Phase 8: 品質チェック | コミット前 |
| **phase-verification** | Phase 9: 動作検証 | 実装後の検証時 |
| **phase-git** | Phase 10-11: Git操作 | コミット・プッシュ時 |

## 使用方法

### 手動起動

```
@skills/{skill-name} を使って{タスク内容}を実行してください
```

### 自動起動

エージェントは起動条件に基づいてスキルを自動的に選択します。

## スキル選択ガイド

| タスク | 推奨スキル |
|--------|-----------|
| 新機能追加 | phase-investigation → phase-architecture → phase-planning → phase-implementation → phase-quality → phase-verification → phase-git |
| バグ修正 | phase-investigation → phase-implementation → test-generator → phase-quality → phase-git |
| UI変更 | ui-advisor → react-patterns → phase-implementation → story-creator → phase-quality |
| リファクタリング | code-reviewer → refactor-specialist → phase-implementation → phase-quality |
| ドキュメント作成 | spec-creator or adr-manager or temp-docs |

## セキュリティ注意

外部由来のスキルには悪意のあるスクリプトが含まれる可能性があります。
導入前に必ず内容を確認し、必要に応じて実行を制限してください。

## 関連リソース

- [ADR記録](../docs/adr/) - アーキテクチャ決定記録
- [開発ガイド](../CLAUDE.md) - 開発ワークフロー詳細
- [プロジェクト概要](../README.md) - プロジェクト説明
