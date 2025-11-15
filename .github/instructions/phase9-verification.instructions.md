---
applyTo: "**/*"
---

# Phase 9A/9B: Verification（検証フェーズ）専用指示

このフェーズでは、**実際の動作を確認**します。

## Phase 9A: Runtime Verification【必須】

### Next.js Runtime MCP使用

```bash
# 開発サーバー起動
npm run dev
```

**確認項目**:

1. **ランタイムエラーチェック**
   - Next.js Runtime MCPで`list_tools`を実行
   - エラーログを確認
   - コンパイルエラーがないことを確認

2. **ルート認識**
   - すべてのルートが認識されているか
   - 動的ルートが正しく設定されているか

3. **HTTPレスポンス**
   - 主要ルートが200 OKを返すか
   - エラーページが適切に表示されるか

### 確認コマンド例

```bash
# ランタイム情報取得
# VS Code Copilot ChatでMCPツールを使用
# - nextjs_runtime: action='list_tools'
# - nextjs_runtime: action='call_tool' toolName='get_errors'
# - nextjs_runtime: action='call_tool' toolName='get_routes'
```

## Phase 9B: Browser Verification【推奨：複雑なUI】

### Chrome DevTools MCP使用

**実行すべきケース**:
- 複雑なユーザーインタラクション
- パフォーマンス測定が必要
- レスポンシブデザインの検証

### 確認手順

1. **Chrome起動**
   ```bash
   bash scripts/start-chrome-devtools.sh
   ```

2. **ページオープン**
   - DevTools MCPで対象URLを開く
   - ページが正しく読み込まれることを確認

3. **ユーザーフロー検証**
   - 主要な操作フローを実行
   - ボタンクリック、フォーム入力、ナビゲーション等
   - エラーが発生しないことを確認

4. **Core Web Vitals測定**
   - LCP (Largest Contentful Paint): 2.5秒以内
   - FID (First Input Delay): 100ms以内
   - CLS (Cumulative Layout Shift): 0.1以内

5. **アクセシビリティツリー検証**
   - 適切なARIA属性が設定されているか
   - キーボードナビゲーションが機能するか

6. **レスポンシブテスト**
   ```typescript
   // DevTools MCPでビューポートサイズ変更
   // resize_page: width=375, height=667  (Mobile)
   // resize_page: width=768, height=1024 (Tablet)
   // resize_page: width=1920, height=1080 (Desktop)
   ```

### スクリーンショット取得

```typescript
// フルページスクリーンショット
// take_screenshot: fullPage=true

// 特定要素のスクリーンショット
// take_screenshot: uid='element-id'
```

### コンソールエラー確認

```typescript
// ブラウザコンソールメッセージ取得
// console_messages: errorsOnly=true
```

## 検証チェックリスト

### Phase 9A（必須）
- [ ] 開発サーバーが起動する
- [ ] ランタイムエラーがない
- [ ] すべてのルートが認識されている
- [ ] 主要ページが200 OKを返す

### Phase 9B（複雑なUIの場合）
- [ ] ユーザーフローが正常に動作
- [ ] Core Web Vitalsが基準内
- [ ] アクセシビリティツリーが適切
- [ ] レスポンシブデザインが正しく動作
- [ ] ブラウザコンソールにエラーなし

## トラブルシューティング

### ランタイムエラーが出る場合
1. エラーメッセージを確認
2. スタックトレースで原因ファイルを特定
3. Phase 5（実装）に戻って修正

### パフォーマンスが悪い場合
1. Chrome DevToolsでプロファイリング
2. 重い処理を特定
3. Phase 7（コードレビュー）で最適化

### レスポンシブが崩れる場合
1. 各ブレークポイントでスクリーンショット
2. CSSを確認
3. Phase 3（UI設計）に戻って修正

## 注意事項

- 実際のブラウザでの動作確認は重要
- パフォーマンス測定は本番環境に近い状態で
- アクセシビリティは実装時から意識
