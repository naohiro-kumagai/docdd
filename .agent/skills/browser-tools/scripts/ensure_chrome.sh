#!/bin/bash
# Chrome DevToolsの起動確認と自動起動

DEVTOOLS_HOST="${DEVTOOLS_HOST:-127.0.0.1}"
DEVTOOLS_PORT="${DEVTOOLS_PORT:-9222}"
ENDPOINT="http://${DEVTOOLS_HOST}:${DEVTOOLS_PORT}/json/version"

echo "Chrome DevToolsエンドポイントを確認中: ${ENDPOINT}"

if curl -fsS "${ENDPOINT}" > /dev/null 2>&1; then
  echo "✅ Chrome DevToolsは既に起動しています"
  curl -fsS "${ENDPOINT}"
else
  echo "⚠️ Chrome DevToolsが起動していません"
  echo "起動を試みます..."
  
  SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
  if [ -f "${SCRIPT_DIR}/../../scripts/start-chrome-devtools.sh" ]; then
    bash "${SCRIPT_DIR}/../../scripts/start-chrome-devtools.sh"
    sleep 2
    
    if curl -fsS "${ENDPOINT}" > /dev/null 2>&1; then
      echo "✅ Chrome DevToolsの起動に成功しました"
    else
      echo "❌ Chrome DevToolsの起動に失敗しました"
      exit 1
    fi
  else
    echo "❌ 起動スクリプトが見つかりません"
    exit 1
  fi
fi
