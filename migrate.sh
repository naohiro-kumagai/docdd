#!/bin/bash

# DocDDプロジェクトの設定ファイルを別プロジェクトに移行するスクリプト
# 使用方法: curl -fsSL https://raw.githubusercontent.com/naohiro-kumagai/docdd/main/migrate.sh | bash -s -- <ターゲットプロジェクトのパス>
# または: bash <(curl -fsSL https://raw.githubusercontent.com/naohiro-kumagai/docdd/main/migrate.sh) <ターゲットプロジェクトのパス>

set -e

# GitHubリポジトリ情報
REPO_OWNER="naohiro-kumagai"
REPO_NAME="docdd"
BRANCH="main"
BASE_URL="https://raw.githubusercontent.com/${REPO_OWNER}/${REPO_NAME}/${BRANCH}"

# カラー出力用
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 引数チェック
FORCE_OVERWRITE=false
TARGET_DIR=""

# 引数を解析
while [[ $# -gt 0 ]]; do
    case $1 in
        --yes|-y|--force|-f)
            FORCE_OVERWRITE=true
            shift
            ;;
        *)
            if [ -z "$TARGET_DIR" ]; then
                TARGET_DIR="$1"
            fi
            shift
            ;;
    esac
done

if [ -z "$TARGET_DIR" ]; then
    echo -e "${RED}エラー: ターゲットプロジェクトのパスを指定してください${NC}"
    echo ""
    echo "使用方法:"
    echo "  curl -fsSL https://raw.githubusercontent.com/${REPO_OWNER}/${REPO_NAME}/${BRANCH}/migrate.sh | bash -s -- <ターゲットプロジェクトのパス>"
    echo "  または"
    echo "  bash <(curl -fsSL https://raw.githubusercontent.com/${REPO_OWNER}/${REPO_NAME}/${BRANCH}/migrate.sh) <ターゲットプロジェクトのパス>"
    echo ""
    echo "オプション:"
    echo "  --yes, -y, --force, -f  既存ファイルを確認せずに上書き"
    echo ""
    echo "例:"
    echo "  curl -fsSL https://raw.githubusercontent.com/${REPO_OWNER}/${REPO_NAME}/${BRANCH}/migrate.sh | bash -s -- /path/to/target-project"
    echo "  curl -fsSL https://raw.githubusercontent.com/${REPO_OWNER}/${REPO_NAME}/${BRANCH}/migrate.sh | bash -s -- --yes /path/to/target-project"
    exit 1
fi

# ターゲットディレクトリの存在確認
if [ ! -d "$TARGET_DIR" ]; then
    echo -e "${RED}エラー: ターゲットディレクトリが存在しません: $TARGET_DIR${NC}"
    exit 1
fi

# 絶対パスに変換
TARGET_DIR="$(cd "$TARGET_DIR" && pwd)"

echo -e "${BLUE}DocDD設定ファイルの移行を開始します${NC}"
echo -e "${BLUE}リポジトリ: https://github.com/${REPO_OWNER}/${REPO_NAME}${NC}"
echo -e "${BLUE}ターゲット: $TARGET_DIR${NC}"
echo ""

# 一時ディレクトリを作成
TEMP_DIR=$(mktemp -d)
trap "rm -rf $TEMP_DIR" EXIT

echo -e "${YELLOW}ファイルをダウンロード中...${NC}"

# ダウンロード関数
download_file() {
    local file_path="$1"
    local target_path="$2"
    local url="${BASE_URL}/${file_path}"

    echo -n "  ${file_path} ... "

    if curl -fsSL "$url" -o "$target_path" 2>/dev/null; then
        echo -e "${GREEN}✓${NC}"
        return 0
    else
        echo -e "${RED}✗${NC}"
        return 1
    fi
}

# ルートレベルのファイル
ROOT_FILES=(
    "CLAUDE.md"
    "MCP_REFERENCE.md"
    ".cursorrules"
    ".mcp.json"
    "GEMINI.md"
    "GEMINI_README.md"
    "GEMINI_CLI_SUMMARY.md"
    "MIGRATION_GUIDE.md"
    "gemini-extension.json"
    "ARCHITECTURE.md"
)

# .claude/agents/ のファイル
CLAUDE_AGENTS=(
    "adr-memory-manager.md"
    "app-code-specialist.md"
    "project-onboarding.md"
    "spec-document-creator.md"
    "storybook-story-creator.md"
    "test-guideline-enforcer.md"
    "ui-design-advisor.md"
)

# .cursor/commands/ のファイル
CURSOR_COMMANDS=(
    "adr-memory-manager.md"
    "app-code-specialist.md"
    "project-onboarding.md"
    "spec-document-creator.md"
    "storybook-story-creator.md"
    "test-guideline-enforcer.md"
    "ui-design-advisor.md"
)

# .gemini/commands/ のファイル
GEMINI_COMMANDS=(
    "adr/record.toml"
    "adr/search.toml"
    "api/design.toml"
    "api/test.toml"
    "arch/design.toml"
    "doc/add.toml"
    "git/commit.toml"
    "lint/fix.toml"
    "react/component.toml"
    "react/hook.toml"
    "refactor/review.toml"
    "story/create.toml"
    "test/gen.toml"
    "ui/propose.toml"
    "ui/review.toml"
)

# プレースホルダー置換関数
replace_placeholders() {
    local file="$1"
    if [ -f "$file" ]; then
        # macOSとLinuxの両方で動作するsedコマンド
        if [[ "$OSTYPE" == "darwin"* ]]; then
            sed -i '' "s|{{PROJECT_PATH}}|$TARGET_DIR|g" "$file"
        else
            sed -i "s|{{PROJECT_PATH}}|$TARGET_DIR|g" "$file"
        fi
    fi
}

# 既存ファイルの上書き確認関数
should_overwrite() {
    local file_path="$1"
    if [ "$FORCE_OVERWRITE" = true ]; then
        return 0  # 上書きする
    fi

    # 対話的に確認（/dev/ttyを使用して端末から直接入力を受け取る）
    echo -e "    ${YELLOW}警告: $file_path は既に存在します。上書きしますか？ (y/N)${NC}" >&2
    read -r response < /dev/tty
    if [[ "$response" =~ ^[Yy]$ ]]; then
        return 0  # 上書きする
    else
        return 1  # スキップする
    fi
}

# ルートレベルのファイルをダウンロード
echo -e "${YELLOW}ルートレベルのファイル:${NC}"
for file in "${ROOT_FILES[@]}"; do
    temp_file="$TEMP_DIR/$file"
    if download_file "$file" "$temp_file"; then
        # 既存ファイルの確認
        target_file="$TARGET_DIR/$file"
        if [ -f "$target_file" ]; then
            if [ "$FORCE_OVERWRITE" = true ]; then
                echo -e "    ${YELLOW}既存ファイルを上書き: $file${NC}"
            else
                if ! should_overwrite "$file"; then
                    echo "    スキップ: $file"
                    continue
                fi
            fi
        fi

        # ディレクトリが存在しない場合は作成
        target_dir=$(dirname "$target_file")
        mkdir -p "$target_dir"

        cp "$temp_file" "$target_file"
        # プレースホルダーを置換（.mcp.jsonの場合）
        if [ "$file" = ".mcp.json" ]; then
            replace_placeholders "$target_file"
        fi
        echo -e "    ${GREEN}コピー完了: $file${NC}"
    fi
done

# .claude/agents/ のファイルをダウンロード
echo ""
echo -e "${YELLOW}.claude/agents/ のファイル:${NC}"
mkdir -p "$TARGET_DIR/.claude/agents"
for file in "${CLAUDE_AGENTS[@]}"; do
    temp_file="$TEMP_DIR/$file"
    if download_file ".claude/agents/$file" "$temp_file"; then
        target_file="$TARGET_DIR/.claude/agents/$file"

        if [ -f "$target_file" ]; then
            if [ "$FORCE_OVERWRITE" = true ]; then
                echo -e "    ${YELLOW}既存ファイルを上書き: .claude/agents/$file${NC}"
            else
                if ! should_overwrite ".claude/agents/$file"; then
                    echo "    スキップ: .claude/agents/$file"
                    continue
                fi
            fi
        fi

        cp "$temp_file" "$target_file"
        echo -e "    ${GREEN}コピー完了: .claude/agents/$file${NC}"
    fi
done

# .claude/settings.json をダウンロード
echo ""
echo -e "${YELLOW}.claude/settings.json:${NC}"
temp_file="$TEMP_DIR/.claude-settings.json"
if download_file ".claude/settings.json" "$temp_file"; then
    target_file="$TARGET_DIR/.claude/settings.json"

    if [ -f "$target_file" ]; then
        if [ "$FORCE_OVERWRITE" = true ]; then
            echo -e "    ${YELLOW}既存ファイルを上書き: .claude/settings.json${NC}"
            mkdir -p "$(dirname "$target_file")"
            cp "$temp_file" "$target_file"
            echo -e "    ${GREEN}コピー完了: .claude/settings.json${NC}"
        else
            if should_overwrite ".claude/settings.json"; then
                mkdir -p "$(dirname "$target_file")"
                cp "$temp_file" "$target_file"
                echo -e "    ${GREEN}コピー完了: .claude/settings.json${NC}"
            else
                echo "    スキップ: .claude/settings.json"
            fi
        fi
    else
        mkdir -p "$(dirname "$target_file")"
        cp "$temp_file" "$target_file"
        echo -e "    ${GREEN}コピー完了: .claude/settings.json${NC}"
    fi
fi

# .cursor/commands/ のファイルをダウンロード
echo ""
echo -e "${YELLOW}.cursor/commands/ のファイル:${NC}"
mkdir -p "$TARGET_DIR/.cursor/commands"
for file in "${CURSOR_COMMANDS[@]}"; do
    temp_file="$TEMP_DIR/$file"
    if download_file ".cursor/commands/$file" "$temp_file"; then
        target_file="$TARGET_DIR/.cursor/commands/$file"

        if [ -f "$target_file" ]; then
            if [ "$FORCE_OVERWRITE" = true ]; then
                echo -e "    ${YELLOW}既存ファイルを上書き: .cursor/commands/$file${NC}"
            else
                if ! should_overwrite ".cursor/commands/$file"; then
                    echo "    スキップ: .cursor/commands/$file"
                    continue
                fi
            fi
        fi

        cp "$temp_file" "$target_file"
        echo -e "    ${GREEN}コピー完了: .cursor/commands/$file${NC}"
    fi
done

# .cursor/mcp.json をダウンロード
echo ""
echo -e "${YELLOW}.cursor/mcp.json:${NC}"
temp_file="$TEMP_DIR/.cursor-mcp.json"
if download_file ".cursor/mcp.json" "$temp_file"; then
    target_file="$TARGET_DIR/.cursor/mcp.json"

    if [ -f "$target_file" ]; then
        if [ "$FORCE_OVERWRITE" = true ]; then
            echo -e "    ${YELLOW}既存ファイルを上書き: .cursor/mcp.json${NC}"
            mkdir -p "$(dirname "$target_file")"
            cp "$temp_file" "$target_file"
            # プレースホルダーを置換
            replace_placeholders "$target_file"
            echo -e "    ${GREEN}コピー完了: .cursor/mcp.json${NC}"
        else
            if should_overwrite ".cursor/mcp.json"; then
                mkdir -p "$(dirname "$target_file")"
                cp "$temp_file" "$target_file"
                # プレースホルダーを置換
                replace_placeholders "$target_file"
                echo -e "    ${GREEN}コピー完了: .cursor/mcp.json${NC}"
            else
                echo "    スキップ: .cursor/mcp.json"
            fi
        fi
    else
        mkdir -p "$(dirname "$target_file")"
        cp "$temp_file" "$target_file"
        # プレースホルダーを置換
        replace_placeholders "$target_file"
        echo -e "    ${GREEN}コピー完了: .cursor/mcp.json${NC}"
    fi
fi

# .cursor/settings.json をダウンロード
echo ""
echo -e "${YELLOW}.cursor/settings.json:${NC}"
temp_file="$TEMP_DIR/.cursor-settings.json"
if download_file ".cursor/settings.json" "$temp_file"; then
    target_file="$TARGET_DIR/.cursor/settings.json"

    if [ -f "$target_file" ]; then
        if [ "$FORCE_OVERWRITE" = true ]; then
            echo -e "    ${YELLOW}既存ファイルを上書き: .cursor/settings.json${NC}"
            mkdir -p "$(dirname "$target_file")"
            cp "$temp_file" "$target_file"
            echo -e "    ${GREEN}コピー完了: .cursor/settings.json${NC}"
        else
            if should_overwrite ".cursor/settings.json"; then
                mkdir -p "$(dirname "$target_file")"
                cp "$temp_file" "$target_file"
                echo -e "    ${GREEN}コピー完了: .cursor/settings.json${NC}"
            else
                echo "    スキップ: .cursor/settings.json"
            fi
        fi
    else
        mkdir -p "$(dirname "$target_file")"
        cp "$temp_file" "$target_file"
        echo -e "    ${GREEN}コピー完了: .cursor/settings.json${NC}"
    fi
fi

# .gemini/commands/ のファイルをダウンロード
echo ""
echo -e "${YELLOW}.gemini/commands/ のファイル:${NC}"
mkdir -p "$TARGET_DIR/.gemini/commands"
for file in "${GEMINI_COMMANDS[@]}"; do
    temp_file="$TEMP_DIR/gemini-cmd-${file//\//-}"
    if download_file ".gemini/commands/$file" "$temp_file"; then
        target_file="$TARGET_DIR/.gemini/commands/$file"

        if [ -f "$target_file" ]; then
            if [ "$FORCE_OVERWRITE" = true ]; then
                echo -e "    ${YELLOW}既存ファイルを上書き: .gemini/commands/$file${NC}"
            else
                if ! should_overwrite ".gemini/commands/$file"; then
                    echo "    スキップ: .gemini/commands/$file"
                    continue
                fi
            fi
        fi

        # サブディレクトリも作成
        mkdir -p "$(dirname "$target_file")"
        cp "$temp_file" "$target_file"
        echo -e "    ${GREEN}コピー完了: .gemini/commands/$file${NC}"
    fi
done

# .gemini/settings.json をダウンロード
echo ""
echo -e "${YELLOW}.gemini/settings.json:${NC}"
temp_file="$TEMP_DIR/.gemini-settings.json"
if download_file ".gemini/settings.json" "$temp_file"; then
    target_file="$TARGET_DIR/.gemini/settings.json"

    if [ -f "$target_file" ]; then
        if [ "$FORCE_OVERWRITE" = true ]; then
            echo -e "    ${YELLOW}既存ファイルを上書き: .gemini/settings.json${NC}"
            mkdir -p "$(dirname "$target_file")"
            cp "$temp_file" "$target_file"
            # プレースホルダーを置換
            replace_placeholders "$target_file"
            echo -e "    ${GREEN}コピー完了: .gemini/settings.json${NC}"
        else
            if should_overwrite ".gemini/settings.json"; then
                mkdir -p "$(dirname "$target_file")"
                cp "$temp_file" "$target_file"
                # プレースホルダーを置換
                replace_placeholders "$target_file"
                echo -e "    ${GREEN}コピー完了: .gemini/settings.json${NC}"
            else
                echo "    スキップ: .gemini/settings.json"
            fi
        fi
    else
        mkdir -p "$(dirname "$target_file")"
        cp "$temp_file" "$target_file"
        # プレースホルダーを置換
        replace_placeholders "$target_file"
        echo -e "    ${GREEN}コピー完了: .gemini/settings.json${NC}"
    fi
fi

echo ""
echo -e "${GREEN}移行が完了しました！${NC}"
echo ""
echo "移行されたファイル:"
echo "  - CLAUDE.md (開発ワークフロー定義)"
echo "  - MCP_REFERENCE.md (MCPコマンドリファレンス)"
echo "  - .cursorrules (Cursor設定)"
echo "  - .mcp.json (MCP設定)"
echo "  - .claude/agents/*.md (Claudeエージェント定義)"
echo "  - .claude/settings.json (Claude設定)"
echo "  - .cursor/commands/*.md (Cursorコマンド定義)"
echo "  - .cursor/mcp.json (Cursor MCP設定)"
echo "  - .cursor/settings.json (Cursor設定)"
echo "  - GEMINI.md (Gemini CLI戦略的コンテキスト)"
echo "  - GEMINI_README.md (Gemini CLI使用ガイド)"
echo "  - GEMINI_CLI_SUMMARY.md (Gemini CLI実装サマリー)"
echo "  - MIGRATION_GUIDE.md (Gemini CLI移行ガイド)"
echo "  - gemini-extension.json (Gemini CLI拡張マニフェスト)"
echo "  - .gemini/settings.json (Gemini CLI設定)"
echo "  - .gemini/commands/*.toml (Gemini CLIカスタムコマンド 15個)"
echo ""
echo "次のステップ:"
echo "  1. ターゲットプロジェクトで設定を確認してください"
echo "  2. 必要に応じて設定をカスタマイズしてください"
echo "  3. .claude/settings.local.json は個人設定なので、各自で設定してください"
echo "  4. Gemini CLIを使用する場合は、拡張機能をインストールしてください:"
echo "     cd <ターゲットプロジェクト> && gemini extensions install --path=."
