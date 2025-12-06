#!/bin/bash

# DocDDプロジェクトの設定ファイルを別プロジェクトに移行するスクリプト
# 対話モード対応版：AIエディター選択機能付き
# 使用方法: curl -fsSL https://raw.githubusercontent.com/naohiro-kumagai/docdd/main/migrate.sh | bash -s -- --interactive <ターゲットプロジェクトのパス>

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
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# 引数チェック
FORCE_OVERWRITE=false
INTERACTIVE_MODE=false
TARGET_DIR=""
SELECTED_EDITORS=()

# 引数を解析
while [[ $# -gt 0 ]]; do
    case $1 in
        --yes|-y|--force|-f)
            FORCE_OVERWRITE=true
            shift
            ;;
        --interactive|-i)
            INTERACTIVE_MODE=true
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
    echo ""
    echo "オプション:"
    echo "  --interactive, -i        対話モード（AIエディター選択）"
    echo "  --yes, -y, --force, -f   既存ファイルを確認せずに上書き"
    echo ""
    echo "例:"
    echo "  curl -fsSL https://raw.githubusercontent.com/${REPO_OWNER}/${REPO_NAME}/${BRANCH}/migrate.sh | bash -s -- /path/to/target-project"
    echo "  curl -fsSL https://raw.githubusercontent.com/${REPO_OWNER}/${REPO_NAME}/${BRANCH}/migrate.sh | bash -s -- --interactive /path/to/target-project"
    exit 1
fi

# ターゲットディレクトリの存在確認
if [ ! -d "$TARGET_DIR" ]; then
    echo -e "${RED}エラー: ターゲットディレクトリが存在しません: $TARGET_DIR${NC}"
    exit 1
fi

# 絶対パスに変換
TARGET_DIR="$(cd "$TARGET_DIR" && pwd)"

echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║         DocDD 設定ファイル移行ツール v2.0                 ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${BLUE}リポジトリ: https://github.com/${REPO_OWNER}/${REPO_NAME}${NC}"
echo -e "${BLUE}ブランチ: ${BRANCH}${NC}"
echo -e "${CYAN}ターゲット: ${TARGET_DIR}${NC}"
echo ""

# AIエディター選択関数
select_editors() {
    # パイプ実行で標準入力がスクリプトに消費されるのを防ぐ
    # /dev/tty が読めない環境では自動で「すべて選択」にフォールバック
    if [ ! -t 0 ] && [ ! -r /dev/tty ]; then
        echo -e "${YELLOW}/dev/tty を読み取れないため、デフォルトで全てのエディターを選択します${NC}"
        SELECTED_EDITORS=("claude" "cursor" "windsurf" "gemini" "copilot" "common")
        echo ""
        return
    fi
    echo -e "${YELLOW}┌─ AIエディター選択 ─────────────────────────────────────┐${NC}"
    echo ""
    echo -e "${CYAN}1${NC})${GREEN} Claude${NC}        - .claude/ + Claude設定"
    echo -e "${CYAN}2${NC})${GREEN} Cursor${NC}        - .cursor/ + Cursor設定"
    echo -e "${CYAN}3${NC})${GREEN} Windsurf${NC}      - .windsurf/ + Windsurf設定"
    echo -e "${CYAN}4${NC})${GREEN} Gemini CLI${NC}    - .gemini/ + Gemini関連ファイル"
    echo -e "${CYAN}5${NC})${GREEN} VS Code Copilot${NC} - .github/ + VS Code Copilot設定"
    echo -e "${CYAN}6${NC})${GREEN} 共通設定のみ${NC}    - MCP、Architecture等"
    echo -e "${CYAN}7${NC})${GREEN} すべてインストール（推奨）${NC}"
    echo ""
    echo -e "${YELLOW}└─────────────────────────────────────────────────────────┘${NC}"
    echo ""
    echo "複数選択可能です (例: 1 2 3 で Claude, Cursor, Windsurf を選択)"
    echo "スペース区切りで入力、または 7 で全て選択してください:"
    selections=""
    if ! read -r -p "> " selections < /dev/tty; then
        echo -e "${YELLOW}入力を受け取れませんでした。デフォルトですべてを選択します${NC}"
        selections="7"
    fi

    # 入力内容に応じてエディターを設定
    if [[ "$selections" == "7" ]]; then
        SELECTED_EDITORS=("claude" "cursor" "windsurf" "gemini" "copilot" "common")
        echo ""
        echo -e "${GREEN}✓ すべてのエディター設定を選択しました${NC}"
    else
        for num in $selections; do
            case $num in
                1) SELECTED_EDITORS+=("claude"); echo -e "${GREEN}✓ Claude を選択${NC}" ;;
                2) SELECTED_EDITORS+=("cursor"); echo -e "${GREEN}✓ Cursor を選択${NC}" ;;
                3) SELECTED_EDITORS+=("windsurf"); echo -e "${GREEN}✓ Windsurf を選択${NC}" ;;
                4) SELECTED_EDITORS+=("gemini"); echo -e "${GREEN}✓ Gemini CLI を選択${NC}" ;;
                5) SELECTED_EDITORS+=("copilot"); echo -e "${GREEN}✓ VS Code Copilot を選択${NC}" ;;
                6) SELECTED_EDITORS+=("common"); echo -e "${GREEN}✓ 共通設定 を選択${NC}" ;;
                *)
                    echo -e "${YELLOW}⚠ 無効な選択: $num${NC}"
                    ;;
            esac
        done

        # 共通設定がない場合は自動追加
        if [ ${#SELECTED_EDITORS[@]} -gt 0 ]; then
            if [[ ! " ${SELECTED_EDITORS[@]} " =~ " common " ]]; then
                SELECTED_EDITORS+=("common")
            fi
        fi
    fi

    if [ ${#SELECTED_EDITORS[@]} -eq 0 ]; then
        echo -e "${YELLOW}入力が空でした。デフォルトで全てのエディターを選択します${NC}"
        SELECTED_EDITORS=("claude" "cursor" "windsurf" "gemini" "copilot" "common")
    fi

    echo ""
}

# エディターが選択されているかチェック
is_editor_selected() {
    local editor="$1"
    for selected in "${SELECTED_EDITORS[@]}"; do
        if [ "$selected" = "$editor" ]; then
            return 0
        fi
    done
    return 1
}

# 対話モード実行
if [ "$INTERACTIVE_MODE" = true ]; then
    select_editors
else
    # 非対話モード時はすべてをダウンロード
    SELECTED_EDITORS=("claude" "cursor" "windsurf" "gemini" "copilot" "common")
fi

# 一時ディレクトリを作成
TEMP_DIR=$(mktemp -d)
trap "rm -rf $TEMP_DIR" EXIT

echo -e "${YELLOW}ファイルをダウンロード中...${NC}"
echo ""

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

# プレースホルダー置換関数
replace_placeholders() {
    local file="$1"
    if [ -f "$file" ]; then
        if [[ "$OSTYPE" == "darwin"* ]]; then
            sed -i '' "s|{{PROJECT_PATH}}|$TARGET_DIR|g" "$file"
        else
            sed -i "s|{{PROJECT_PATH}}|$TARGET_DIR|g" "$file"
        fi
    fi
}

# ファイルリスト定義
COMMON_ROOT_FILES=(
    "README.md"
    "ARCHITECTURE.md"
    "MCP_REFERENCE.md"
    ".mcp.json"
)

CLAUDE_ROOT_FILES=(
    "CLAUDE.md"
)

CURSOR_ROOT_FILES=(
    ".cursorrules"
)

WINDSURF_ROOT_FILES=(
    "WINDSURF.md"
    "WINDSURF_SETUP.md"
    ".codeiumignore"
)

GEMINI_ROOT_FILES=(
    "GEMINI.md"
    "GEMINI_README.md"
    "GEMINI_CLI_SUMMARY.md"
    "MIGRATION_GUIDE.md"
    "gemini-extension.json"
)

COPILOT_ROOT_FILES=(
    "VSCODE_COPILOT_SETUP.md"
)

CLAUDE_AGENTS=(
    "adr-memory-manager.md"
    "app-code-specialist.md"
    "project-onboarding.md"
    "spec-document-creator.md"
    "storybook-story-creator.md"
    "test-guideline-enforcer.md"
    "ui-design-advisor.md"
)

CURSOR_COMMANDS=(
    "adr-memory-manager.md"
    "app-code-specialist.md"
    "project-onboarding.md"
    "spec-document-creator.md"
    "storybook-story-creator.md"
    "test-guideline-enforcer.md"
    "ui-design-advisor.md"
)

WINDSURF_RULES=(
    "tech-stack.md"
    "coding-standards.md"
    "architecture.md"
    "testing.md"
)

WINDSURF_WORKFLOWS=(
    "full-workflow.md"
    "quick-impl.md"
    "fix-bug.md"
)

WINDSURF_FILES=(
    "mcp_config.template.json"
)

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

GITHUB_AGENTS=(
    "adr-manager.md"
    "onboarding-specialist.md"
    "refactor-specialist.md"
    "spec-creator.md"
    "story-creator.md"
    "test-enforcer.md"
    "ui-advisor.md"
)

GITHUB_INSTRUCTIONS=(
    "phase1-investigation.instructions.md"
    "phase2-architecture.instructions.md"
    "phase3-ui-design.instructions.md"
    "phase4-planning.instructions.md"
    "phase5-implementation.instructions.md"
    "phase6-testing.instructions.md"
    "phase7-code-review.instructions.md"
    "phase8-quality-checks.instructions.md"
    "phase9-verification.instructions.md"
    "phase10-git-commit.instructions.md"
    "phase11-push.instructions.md"
    "react.instructions.md"
    "typescript.instructions.md"
)

GITHUB_PROMPTS=(
    "adr-record.md"
    "browser-tools-chooser.md"
    "devtools.ensure-chrome.md"
    "test-gen.md"
    "ui-review.md"
)

# 共通設定ファイルをダウンロード
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}共通設定（すべてのエディター対応）${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

for file in "${COMMON_ROOT_FILES[@]}"; do
    temp_file="$TEMP_DIR/$file"
    if download_file "$file" "$temp_file"; then
        target_file="$TARGET_DIR/$file"
        mkdir -p "$(dirname "$target_file")"
        cp "$temp_file" "$target_file"
        if [ "$file" = ".mcp.json" ]; then
            replace_placeholders "$target_file"
        fi
    fi
done

# Claude設定
if is_editor_selected "claude"; then
    echo ""
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}Claude 設定${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

    for file in "${CLAUDE_ROOT_FILES[@]}"; do
        temp_file="$TEMP_DIR/$file"
        download_file "$file" "$temp_file" && cp "$temp_file" "$TARGET_DIR/$file"
    done

    echo -e "${YELLOW}.claude/agents/:${NC}"
    mkdir -p "$TARGET_DIR/.claude/agents"
    for file in "${CLAUDE_AGENTS[@]}"; do
        temp_file="$TEMP_DIR/claude-agent-$file"
        if download_file ".claude/agents/$file" "$temp_file"; then
            cp "$temp_file" "$TARGET_DIR/.claude/agents/$file"
        fi
    done

    echo -e "${YELLOW}.claude/settings.json:${NC}"
    temp_file="$TEMP_DIR/.claude-settings.json"
    download_file ".claude/settings.json" "$temp_file" && {
        mkdir -p "$TARGET_DIR/.claude"
        cp "$temp_file" "$TARGET_DIR/.claude/settings.json"
    }
fi

# Cursor設定
if is_editor_selected "cursor"; then
    echo ""
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}Cursor 設定${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

    for file in "${CURSOR_ROOT_FILES[@]}"; do
        temp_file="$TEMP_DIR/$file"
        download_file "$file" "$temp_file" && cp "$temp_file" "$TARGET_DIR/$file"
    done

    echo -e "${YELLOW}.cursor/commands/:${NC}"
    mkdir -p "$TARGET_DIR/.cursor/commands"
    for file in "${CURSOR_COMMANDS[@]}"; do
        temp_file="$TEMP_DIR/cursor-cmd-$file"
        if download_file ".cursor/commands/$file" "$temp_file"; then
            cp "$temp_file" "$TARGET_DIR/.cursor/commands/$file"
        fi
    done

    echo -e "${YELLOW}.cursor/ MCP設定:${NC}"
    for conf in "mcp.json" "settings.json"; do
        temp_file="$TEMP_DIR/.cursor-$conf"
        if download_file ".cursor/$conf" "$temp_file"; then
            mkdir -p "$TARGET_DIR/.cursor"
            cp "$temp_file" "$TARGET_DIR/.cursor/$conf"
            [ "$conf" = "mcp.json" ] && replace_placeholders "$TARGET_DIR/.cursor/$conf"
        fi
    done
fi

# Windsurf設定
if is_editor_selected "windsurf"; then
    echo ""
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}Windsurf 設定${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

    for file in "${WINDSURF_ROOT_FILES[@]}"; do
        temp_file="$TEMP_DIR/$file"
        download_file "$file" "$temp_file" && cp "$temp_file" "$TARGET_DIR/$file"
    done

    echo -e "${YELLOW}.windsurf/rules/:${NC}"
    mkdir -p "$TARGET_DIR/.windsurf/rules"
    for file in "${WINDSURF_RULES[@]}"; do
        temp_file="$TEMP_DIR/windsurf-rule-$file"
        if download_file ".windsurf/rules/$file" "$temp_file"; then
            cp "$temp_file" "$TARGET_DIR/.windsurf/rules/$file"
        fi
    done

    echo -e "${YELLOW}.windsurf/workflows/:${NC}"
    mkdir -p "$TARGET_DIR/.windsurf/workflows"
    for file in "${WINDSURF_WORKFLOWS[@]}"; do
        temp_file="$TEMP_DIR/windsurf-workflow-$file"
        if download_file ".windsurf/workflows/$file" "$temp_file"; then
            cp "$temp_file" "$TARGET_DIR/.windsurf/workflows/$file"
        fi
    done
fi

# Gemini CLI設定
if is_editor_selected "gemini"; then
    echo ""
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}Gemini CLI 設定${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

    for file in "${GEMINI_ROOT_FILES[@]}"; do
        temp_file="$TEMP_DIR/$file"
        download_file "$file" "$temp_file" && cp "$temp_file" "$TARGET_DIR/$file"
    done

    echo -e "${YELLOW}.gemini/commands/:${NC}"
    mkdir -p "$TARGET_DIR/.gemini/commands"
    for file in "${GEMINI_COMMANDS[@]}"; do
        temp_file="$TEMP_DIR/gemini-cmd-${file//\//-}"
        if download_file ".gemini/commands/$file" "$temp_file"; then
            mkdir -p "$(dirname "$TARGET_DIR/.gemini/commands/$file")"
            cp "$temp_file" "$TARGET_DIR/.gemini/commands/$file"
        fi
    done

    echo -e "${YELLOW}.gemini/settings.json:${NC}"
    temp_file="$TEMP_DIR/.gemini-settings.json"
    if download_file ".gemini/settings.json" "$temp_file"; then
        mkdir -p "$TARGET_DIR/.gemini"
        cp "$temp_file" "$TARGET_DIR/.gemini/settings.json"
        replace_placeholders "$TARGET_DIR/.gemini/settings.json"
    fi
fi

# VS Code Copilot設定
if is_editor_selected "copilot"; then
    echo ""
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}VS Code Copilot 設定${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

    for file in "${COPILOT_ROOT_FILES[@]}"; do
        temp_file="$TEMP_DIR/$file"
        download_file "$file" "$temp_file" && cp "$temp_file" "$TARGET_DIR/$file"
    done

    echo -e "${YELLOW}.github/agents/:${NC}"
    mkdir -p "$TARGET_DIR/.github/agents"
    for file in "${GITHUB_AGENTS[@]}"; do
        temp_file="$TEMP_DIR/github-agent-$file"
        if download_file ".github/agents/$file" "$temp_file"; then
            cp "$temp_file" "$TARGET_DIR/.github/agents/$file"
        fi
    done

    echo -e "${YELLOW}.github/instructions/:${NC}"
    mkdir -p "$TARGET_DIR/.github/instructions"
    for file in "${GITHUB_INSTRUCTIONS[@]}"; do
        temp_file="$TEMP_DIR/github-instr-${file//\//-}"
        if download_file ".github/instructions/$file" "$temp_file"; then
            cp "$temp_file" "$TARGET_DIR/.github/instructions/$file"
        fi
    done

    echo -e "${YELLOW}.github/prompts/:${NC}"
    mkdir -p "$TARGET_DIR/.github/prompts"
    for file in "${GITHUB_PROMPTS[@]}"; do
        temp_file="$TEMP_DIR/github-prompt-$file"
        if download_file ".github/prompts/$file" "$temp_file"; then
            cp "$temp_file" "$TARGET_DIR/.github/prompts/$file"
        fi
    done

    echo -e "${YELLOW}.github/copilot-instructions.md:${NC}"
    temp_file="$TEMP_DIR/github-copilot-instructions.md"
    download_file ".github/copilot-instructions.md" "$temp_file" && {
        mkdir -p "$TARGET_DIR/.github"
        cp "$temp_file" "$TARGET_DIR/.github/copilot-instructions.md"
    }
fi

# 完了メッセージ
echo ""
echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║           移行が完了しました！ ✓                        ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${GREEN}インストール済みコンポーネント:${NC}"
echo "  - 共通設定（MCP、Architecture等）"
if is_editor_selected "claude"; then
    echo "  - ${CYAN}Claude${NC} 設定（.claude/ + Agents）"
fi
if is_editor_selected "cursor"; then
    echo "  - ${CYAN}Cursor${NC} 設定（.cursor/ + Commands）"
fi
if is_editor_selected "windsurf"; then
    echo "  - ${CYAN}Windsurf${NC} 設定（.windsurf/rules/ + workflows/）"
fi
if is_editor_selected "gemini"; then
    echo "  - ${CYAN}Gemini CLI${NC} 設定（.gemini/ + Commands）"
fi
if is_editor_selected "copilot"; then
    echo "  - ${CYAN}VS Code Copilot${NC} 設定（.github/ + Instructions）"
fi
echo ""
echo -e "${YELLOW}次のステップ:${NC}"
echo "  1. エディターを開く"
echo "  2. 設定ファイルが正しく配置されたか確認"
echo "  3. MCPサーバーの設定を確認"
echo ""
