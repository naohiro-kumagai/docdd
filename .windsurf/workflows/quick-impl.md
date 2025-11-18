# クイック実装ワークフロー

小規模な修正や既存パターンに従う実装用の簡略化ワークフロー。

## 実行方法
Windsurf Cascadeで `/quick-impl` と入力してください。

---

## 対象タスク

以下のような小規模変更に適しています：
- タイポ修正
- 小規模なバグ修正
- 既存パターンに完全に従う実装
- ドキュメントのみの更新
- スタイル調整

---

## Phase 1: Investigation（簡易版）

### Step 1: 関連コード確認
1. 変更対象のファイルとその周辺を確認
2. 既存のパターンを把握

---

## Phase 4: Planning（簡易版）

### Step 2: 変更内容の明確化
1. 何を変更するか簡潔に定義
2. 影響範囲を確認（1-3ファイル以内）

---

## Phase 5: Implementation

### Step 3: コード実装
1. 変更を実装
2. コーディング標準を遵守
   - 明示的な `@/` インポート
   - TypeScript型付け
   - 日本語コメント

---

## Phase 8: Quality Checks

### Step 4: 品質チェック実行
```bash
npm run type-check
npm run lint
npm run test
```

すべてのチェックがパスすることを確認。

---

## Phase 10: Git Commit

### Step 5: コミット
```bash
git add .
git commit -m "<type>: <description>"
```

**例**:
- `fix: ボタンのタイポを修正`
- `style: インデントを統一`
- `docs: READMEのセットアップ手順を更新`

---

## Phase 11: Push

### Step 6: プッシュ
```bash
git push
```

---

## 完了

クイック実装が完了しました！✅

**注意**: 以下の場合は `/full-workflow` を使用してください：
- 新機能追加
- アーキテクチャ変更
- 複数ファイルにわたる大規模リファクタリング
- 新しいパターンの導入
