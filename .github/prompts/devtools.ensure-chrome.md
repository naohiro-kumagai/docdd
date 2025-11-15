# Prompt: Ensure Chrome DevTools is running (auto-start if needed)

You are GitHub Copilot working in VS Code with MCP.

Goal:
- Ensure a Chrome browser with the DevTools protocol is running at `http://127.0.0.1:9222`.
- If the endpoint is not reachable, start it via the repo script.
- After it is up, connect using the Chrome DevTools MCP and proceed with the requested actions.

Steps:
1) Check readiness:
   - Run: `curl -fsS http://127.0.0.1:9222/json/version`.
2) If the command fails (non‑zero exit):
   - Run: `bash ./scripts/start-chrome-devtools.sh`.
   - Re‑check: `curl -fsS http://127.0.0.1:9222/json/version`.
3) Confirm VS Code Copilot uses Chrome DevTools MCP with `--browserUrl http://127.0.0.1:9222`.
4) Continue with the user’s task (e.g., open a URL, list pages, select a tab, take screenshot).

Notes:
- To stop the managed browser later, run: `bash ./scripts/stop-chrome-devtools.sh`.
- Environment overrides: `DEVTOOLS_PORT` (default 9222), `DEVTOOLS_HOST` (default 127.0.0.1), `CHROME_BIN`.
