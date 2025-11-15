#!/usr/bin/env bash
# DevToolsポートで動作するChromeを安全に終了
set -euo pipefail

PORT="${DEVTOOLS_PORT:-9222}"

# PID検出: --remote-debugging-port=PORT を含むプロセスを絞り込み
PIDS=$(pgrep -a chrome | awk -v p="${PORT}" '$0 ~ "--remote-debugging-port="p { print $1 }') || true

if [[ -z "${PIDS}" ]]; then
  # chromium名の可能性
  PIDS=$(pgrep -a chromium | awk -v p="${PORT}" '$0 ~ "--remote-debugging-port="p { print $1 }') || true
fi

if [[ -z "${PIDS}" ]]; then
  echo "[devtools] no chrome process found for port ${PORT}"
  exit 0
fi

echo "[devtools] stopping PIDs: ${PIDS}"
kill ${PIDS} || true

# 余裕があればSIGKILL
sleep 0.5
for pid in ${PIDS}; do
  if kill -0 "$pid" 2>/dev/null; then
    kill -9 "$pid" || true
  fi
done

echo "[devtools] stopped"
