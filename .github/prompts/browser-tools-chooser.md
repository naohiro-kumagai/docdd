# プロンプト: Playwright MCP と Chrome DevTools MCP の使い分け

あなたは VS Code 上でMCPを使う GitHub Copilot です。

目的:
- どのブラウザ系MCPツールを使うべきか判断し、その方針で作業を進める。

使い分け指針:
- Chrome DevTools MCP を使うとき:
  - 既存のChromeに接続したい（例: `--browserUrl`で稼働中のChromeへアタッチ）。
  - ブラウザのライフサイクル管理をMCP外に任せ、実ブラウザの挙動（コンソールエラー、ネットワーク、スクリーンショット）を観察したい。
  - DevTools固有の機能（プロトコルレベルのエミュレーション、DevTools MCPのa11yスナップショット等）を使いたい。
- Playwright MCP を使うとき:
  - チャット/ワークフロー内からMCPでブラウザの開始/終了を管理したい。
  - クリック/入力/フォーム埋め/ドラッグなどの強力な自動化と、再現性の高いE2Eフローが必要。
  - 複数エンジン（chromium/firefox/webkit）やCIでのヘッドレス実行を行いたい。

実行手順:
1) Chrome DevTools MCP を選ぶ場合:
   - エンドポイント稼働確認: `curl -fsS http://127.0.0.1:9222/json/version`
   - ダウンしている場合は起動: `bash ./scripts/start-chrome-devtools.sh` → 再チェック
   - ツール利用例: `list_pages` → `select_page` → `navigate_page` → `evaluate_script` / `take_screenshot` / `list_network_requests`
   - 任意で停止: `bash ./scripts/stop-chrome-devtools.sh`
2) Playwright MCP を選ぶ場合:
   - セッション開始: `action: "start"`（browser: chromium/firefox/webkit、headlessの有無を指定）
   - 操作: `navigate` / `click` / `type` / `fill_form` / `evaluate` / `screenshot`
   - セッション終了: `action: "close"`

注意:
- Next.js プロジェクトでは、ビルド/ランタイムエラーの把握は Next.js Runtime MCP を優先。UXやインタラクション検証にブラウザ系MCPを併用。
- WSL/Linux で日本語表示が崩れる場合は `fonts-noto-cjk` のインストール後、ブラウザを再起動。
