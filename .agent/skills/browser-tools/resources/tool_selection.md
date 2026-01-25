# ブラウザツール選択ガイド

## 選択フローチャート

```
ブラウザ操作が必要
  │
  ├─ 既存Chromeに接続？ → Chrome DevTools MCP
  │
  ├─ E2E自動化が必要？ → Playwright MCP
  │
  ├─ 複数ブラウザエンジン？ → Playwright MCP
  │
  ├─ DevTools固有機能？ → Chrome DevTools MCP
  │
  └─ それ以外 → Playwright MCP（汎用性が高い）
```

## Chrome DevTools MCP

### 長所
- 実ブラウザの挙動をそのまま観察
- プロトコルレベルのエミュレーション
- a11yスナップショット

### 短所
- ブラウザのライフサイクル管理が必要
- 環境依存が強い

## Playwright MCP

### 長所
- MCP内でブラウザ管理が完結
- 複数エンジン対応
- 再現性の高いE2Eフロー
- CIでのヘッドレス実行

### 短所
- DevTools固有機能には非対応

## 注意事項
- Next.jsプロジェクトでは、ビルド/ランタイムエラーの把握はNext.js Runtime MCPを優先
- WSL/Linuxで日本語表示が崩れる場合は`fonts-noto-cjk`をインストール
