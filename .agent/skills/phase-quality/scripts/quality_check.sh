#!/bin/bash
# 品質チェックスクリプト

set -e

echo "🔍 品質チェックを開始します..."

# 型チェック
echo "📝 型チェック..."
if npm run type-check 2>/dev/null || bun run type-check 2>/dev/null || yarn type-check 2>/dev/null; then
  echo "✅ 型チェック: パス"
else
  echo "❌ 型チェック: 失敗"
  exit 1
fi

# リントチェック
echo "🧹 リントチェック..."
if npm run lint 2>/dev/null || bun run lint 2>/dev/null || yarn lint 2>/dev/null; then
  echo "✅ リントチェック: パス"
else
  echo "❌ リントチェック: 失敗"
  exit 1
fi

# テスト実行
echo "🧪 テスト実行..."
if npm run test 2>/dev/null || bun test 2>/dev/null || yarn test 2>/dev/null; then
  echo "✅ テスト: パス"
else
  echo "❌ テスト: 失敗"
  exit 1
fi

# ビルドチェック
echo "🏗️ ビルドチェック..."
if npm run build 2>/dev/null || bun run build 2>/dev/null || yarn build 2>/dev/null; then
  echo "✅ ビルド: 成功"
else
  echo "❌ ビルド: 失敗"
  exit 1
fi

echo "🎉 すべての品質チェックがパスしました！"
