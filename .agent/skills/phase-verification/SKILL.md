---
name: "Phase-Verification-Skill"
description: "Phase 9: 検証フェーズのスキル"
version: "1.0.0"
---

# Phase Verification Skill

## 目的

実際の動作を確認します。

## 起動条件

- 品質チェック完了後
- 実際のブラウザでの動作確認が必要

## 使用リソース

- resources/verification_checklist.md

## Phase 9A: Runtime Verification【必須】

### Next.js Runtime MCP使用

```bash
npm run dev
```

**確認項目**:
1. ランタイムエラーチェック
2. すべてのルートが認識されているか
3. 主要ページが200 OKを返すか

## Phase 9B: Browser Verification【複雑なUI】

### 実行すべきケース
- 複雑なユーザーインタラクション
- パフォーマンス測定が必要
- レスポンシブデザインの検証

### 確認項目
1. ユーザーフローが正常に動作
2. Core Web Vitals（LCP < 2.5秒、FID < 100ms、CLS < 0.1）
3. アクセシビリティツリーが適切
4. レスポンシブデザインが正しく動作
5. ブラウザコンソールにエラーなし
