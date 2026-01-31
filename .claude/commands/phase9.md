# Phase 9: Runtime Verification（動作確認フェーズ）

このフェーズでは、**ランタイムエラーの確認とブラウザ動作検証**を行います。

## Phase 9A: Runtime Verification【必須】

### 1. 開発サーバー起動

```bash
bun run dev
```

### 2. Next.js MCP でエラー確認

```javascript
// サーバー検出
mcp__next-devtools__nextjs_index()

// エラー確認（ポートを指定）
mcp__next-devtools__nextjs_call({
  port: '3000',
  toolName: 'get_errors'
})

// ログ確認
mcp__next-devtools__nextjs_call({
  port: '3000',
  toolName: 'get_logs'
})
```

### 3. 基本チェック

- [ ] Next.js MCPツールでサーバー検出成功
- [ ] `get_errors`でエラー確認
- [ ] ビルド・ランタイムエラーがゼロ
- [ ] 開発サーバーログにエラーなし

---

## Phase 9B: Browser Verification【任意】

**実行すべきケース:**
- 複雑なUIインタラクション
- パフォーマンス測定が必要
- レスポンシブデザインの詳細確認

### Chrome DevTools MCP の使用

```javascript
// ページ一覧取得
mcp__chrome-devtools__list_pages()

// ページ選択
mcp__chrome-devtools__select_page({ pageId: 0 })

// ナビゲーション
mcp__chrome-devtools__navigate_page({ url: 'http://localhost:3000' })

// スナップショット取得
mcp__chrome-devtools__take_snapshot()

// スクリーンショット
mcp__chrome-devtools__take_screenshot()

// コンソールメッセージ確認
mcp__chrome-devtools__list_console_messages()

// ネットワークリクエスト確認
mcp__chrome-devtools__list_network_requests()
```

### パフォーマンス測定

```javascript
// トレース開始
mcp__chrome-devtools__performance_start_trace({
  reload: true,
  autoStop: true
})

// Core Web Vitals確認
// LCP, FID, CLSの値をチェック
```

### レスポンシブテスト

```javascript
// モバイル（375px）
mcp__chrome-devtools__resize_page({ width: 375, height: 667 })

// タブレット（768px）
mcp__chrome-devtools__resize_page({ width: 768, height: 1024 })

// デスクトップ（1920px）
mcp__chrome-devtools__resize_page({ width: 1920, height: 1080 })
```

## 完了チェックリスト

### Phase 9A（必須）
- [ ] Next.js MCPでサーバー検出成功
- [ ] ランタイムエラーがゼロ
- [ ] HTTPレスポンスが正常（200 OK）

### Phase 9B（任意）
- [ ] ネットワークリクエストが正常
- [ ] Core Web Vitalsが良好
- [ ] レスポンシブデザインが正常
- [ ] コンソールエラーがゼロ

## 次のステップ

すべての確認がパスしたら、Phase 10（コミット）に進みます。

```
/phase10 を実行
```

---

**質問**: Phase 9Aのみ実行しますか、それともPhase 9Bも含めて実行しますか？
