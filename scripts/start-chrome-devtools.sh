#!/usr/bin/env bash
# 起動していなければChrome(DevTools)を立ち上げ、起動していれば何もしない
set -euo pipefail

# 設定可能な環境変数
PORT="${DEVTOOLS_PORT:-9222}"
HOST="${DEVTOOLS_HOST:-127.0.0.1}"
USER_DIR="${DEVTOOLS_USER_DIR:-/tmp/chrome-mcp}" # WSLでも使える一時ディレクトリ

ENDPOINT="http://${HOST}:${PORT}/json/version"

has_cmd() { command -v "$1" >/dev/null 2>&1; }

pick_chrome() {
  if [[ -n "${CHROME_BIN:-}" && -x "${CHROME_BIN}" ]]; then
    echo "$CHROME_BIN"; return 0
  fi
  for c in google-chrome-stable google-chrome chromium chromium-browser; do
    if has_cmd "$c"; then echo "$c"; return 0; fi
  done
  echo ""; return 1
}

is_up() {
  curl -fsS "${ENDPOINT}" >/dev/null 2>&1
}

if is_up; then
  echo "[devtools] already running at ${ENDPOINT}"
  curl -fsS "${ENDPOINT}" || true
  exit 0
fi

CHROME_BIN=$(pick_chrome) || {
  echo "[devtools] Chrome/Chromium が見つかりません。CHROME_BIN を指定してください。" >&2
  exit 1
}

mkdir -p "${USER_DIR}"

echo "[devtools] starting ${CHROME_BIN} on ${HOST}:${PORT} ..."
"${CHROME_BIN}" \
  --remote-debugging-port="${PORT}" \
  --user-data-dir="${USER_DIR}" \
  --no-first-run \
  --no-default-browser-check \
  about:blank \
  >/dev/null 2>&1 &

# 起動待ち
for i in {1..40}; do
  if is_up; then
    echo "[devtools] ready: ${ENDPOINT}"
    curl -fsS "${ENDPOINT}" || true
    exit 0
  fi
  sleep 0.25
done

echo "[devtools] timeout: DevTools endpoint not responding at ${ENDPOINT}" >&2
exit 2
