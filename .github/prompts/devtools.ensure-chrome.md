```markdown
# プロンプト: Chrome DevTools の起動確認（必要に応じて自動起動）

あなたは VS Code 上で MCP を使う GitHub Copilot です。

目的:
- Chrome ブラウザが DevTools プロトコルで `http://127.0.0.1:9222` で起動していることを確認する。
- エンドポイントに到達できない場合は、リポジトリのスクリプトで起動する。
- 起動後、Chrome DevTools MCP に接続して、要求されたアクションを実行する。

手順:
1) 稼働確認:
   - 実行: `curl -fsS http://127.0.0.1:9222/json/version`
2) コマンドが失敗した場合（終了コードが非ゼロ）:
   - 実行: `bash ./scripts/start-chrome-devtools.sh`
   - 再確認: `curl -fsS http://127.0.0.1:9222/json/version`
3) VS Code Copilot が Chrome DevTools MCP を `--browserUrl http://127.0.0.1:9222` で使用していることを確認。
4) ユーザーのタスクを続行（例: URL を開く、ページをリスト、タブを選択、スクリーンショット）。

注意:
- 後でブラウザを停止する場合: `bash ./scripts/stop-chrome-devtools.sh` を実行。
- 環境変数で上書き可能: `DEVTOOLS_PORT`（デフォルト 9222）、`DEVTOOLS_HOST`（デフォルト 127.0.0.1）、`CHROME_BIN`。

```
