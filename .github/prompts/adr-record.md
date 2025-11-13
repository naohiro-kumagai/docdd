# ADR記録プロンプト

新しいアーキテクチャ決定記録（ADR）を作成します。

## 手順

1. `docs/adr/index.json`から次のADR番号を確認
2. 以下の情報を提供してください：
   - 決定のタイトル
   - 解決しようとしている問題
   - 検討した代替案
   - 決定の根拠
   - 影響を受けるファイル/コンポーネント

3. ADRを`docs/adr/decisions/{番号}-{タイトル}.json`に作成
4. `docs/adr/index.json`を更新

## ADRフォーマット

```json
{
  "id": "ADR-XXXX",
  "timestamp": "YYYY-MM-DDTHH:mm:ssZ",
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
