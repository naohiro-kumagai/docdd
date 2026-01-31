# ADR（アーキテクチャ決定記録）作成

新しいアーキテクチャ決定記録（ADR）を作成します。

## ADRを記録すべきタイミング

- 重要なアーキテクチャ決定が行われたとき
- コードパターンが確立されたとき
- 技術選択が行われたとき
- デザインパターンが選択されたとき

## 手順

### 1. 次のADR番号を確認

```bash
# index.jsonから次の番号を確認
cat docs/adr/index.json
```

### 2. 必要な情報を収集

以下の情報を提供してください：

- **タイトル**: 決定の簡潔な説明
- **問題**: 解決しようとしている問題
- **コンテキスト**: 背景と制約
- **代替案**: 検討した他の選択肢
- **決定**: 採用した解決策
- **根拠**: なぜこの決定を下したか
- **影響**: この決定が影響を与えるファイル/コンポーネント

### 3. ADRファイルを作成

`docs/adr/decisions/{番号}-{タイトル}.json`に作成

## ADRフォーマット

```json
{
  "id": "ADR-XXXX",
  "timestamp": "2025-01-31T00:00:00Z",
  "title": "決定のタイトル",
  "status": "proposed",
  "context": {
    "problem": "解決しようとしている問題",
    "constraints": ["制約1", "制約2"],
    "requirements": ["要件1", "要件2"]
  },
  "decision": {
    "summary": "決定の要約",
    "details": "詳細な説明",
    "alternatives": [
      {
        "option": "代替案1",
        "pros": ["長所1"],
        "cons": ["短所1"],
        "rejected": true,
        "reason": "却下理由"
      }
    ],
    "rationale": "この決定を下した理由",
    "consequences": ["結果1", "結果2"]
  },
  "implementation": {
    "affected_files": ["path/to/file.ts"],
    "affected_components": ["Component1"],
    "code_patterns": ["pattern1"]
  },
  "metadata": {
    "tags": ["tag1", "tag2"],
    "related_adrs": []
  }
}
```

### 4. index.jsonを更新

```json
{
  "adrs": [
    {
      "id": "ADR-XXXX",
      "title": "タイトル",
      "status": "proposed",
      "file": "decisions/XXXX-title.json"
    }
  ]
}
```

## ステータス一覧

- `proposed`: 提案中
- `accepted`: 承認済み
- `deprecated`: 非推奨
- `superseded`: 置き換え済み

## 完了チェックリスト

- [ ] ADR番号を決定
- [ ] すべての必要情報を収集
- [ ] JSONファイルを作成
- [ ] index.jsonを更新
- [ ] JSON構文が有効であることを確認

---

**質問**: 記録したいアーキテクチャ決定の内容を教えてください。
