---
name: "Browser-Tools-Skill"
description: "Playwright MCPとChrome DevTools MCPの使い分けスキル"
version: "1.0.0"
---

# Browser Tools Skill

## 目的

ブラウザ系MCPツール（Playwright MCP、Chrome DevTools MCP）を状況に応じて使い分けます。

## 起動条件

- ブラウザでの動作確認が必要
- E2Eテストやスクリーンショット取得が必要
- コンソールエラーやネットワーク監視が必要

## 使用リソース

- resources/tool_selection.md
- scripts/ensure_chrome.sh

## Chrome DevTools MCPを使うとき

- 既存のChromeに接続したい
- ブラウザのライフサイクル管理をMCP外に任せる
- DevTools固有の機能（a11yスナップショット等）を使いたい

### 手順
1. エンドポイント確認: `curl -fsS http://127.0.0.1:9222/json/version`
2. 起動: `bash ./scripts/start-chrome-devtools.sh`
3. ツール利用: `list_pages` → `select_page` → `navigate_page`

## Playwright MCPを使うとき

- MCP内からブラウザの開始/終了を管理したい
- クリック/入力/フォーム埋めなどの自動化が必要
- 複数エンジン（chromium/firefox/webkit）やCIでのヘッドレス実行

### 手順
1. セッション開始: `action: "start"`
2. 操作: `navigate` / `click` / `type` / `fill_form`
3. セッション終了: `action: "close"`
