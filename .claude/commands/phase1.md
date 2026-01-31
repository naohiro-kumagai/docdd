# Phase 1: Investigation & Research（調査フェーズ）

このフェーズでは、**既存コードの理解とADRの確認が最優先**です。

## 実行手順

### 1. ADR確認（最優先）

まず `docs/adr/index.json` を確認し、関連するADRファイルを読みます。

```
読むべきファイル:
- docs/adr/index.json
- docs/adr/decisions/*.json（関連するもの）
```

### 2. コードベース調査（Kiri MCP）

タスクに関連するコードを検索します。

**コンテキスト自動取得:**
```javascript
mcp__kiri__context_bundle({
  goal: '[タスクに関連するキーワード]',
  limit: 10,
  compact: true
})
```

**依存関係の調査:**
```javascript
mcp__kiri__deps_closure({
  path: '[対象ファイル]',
  direction: 'inbound',
  max_depth: 3
})
```

### 3. ライブラリドキュメント確認（Context7 MCP）

使用するライブラリの最新ドキュメントを確認します。

```javascript
mcp__context7__resolve-library-id({ libraryName: '[ライブラリ名]' })
mcp__context7__query-docs({ libraryId: '[取得したID]', query: '[質問]' })
```

## 出力フォーマット

調査結果は以下の構造でまとめてください：

```markdown
## 調査結果サマリー

### ADR確認
- 確認したADR: ADR-XXXX, ADR-YYYY
- 関連する決定: [要約]
- 一貫性: ✅/⚠️

### コードベース分析
- 関連ファイル: [リスト]
- 既存パターン: [説明]
- 依存関係: [重要な依存]

### 推奨アプローチ
[実装方針]
```

## 完了チェックリスト

- [ ] ADRを確認し、既存決定を理解
- [ ] Kiri MCPで関連コードを特定
- [ ] 必要なライブラリのドキュメントを確認
- [ ] 既存パターンと依存関係を把握
- [ ] 実装がADRの決定と一致していることを確認

---

**質問**: 調査対象のタスクや機能を教えてください。
