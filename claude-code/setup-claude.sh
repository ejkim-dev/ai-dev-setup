#!/bin/bash
#
# Claude Code Setup: workspace, agents, MCP servers, Obsidian
#
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
WORKSPACE="$HOME/claude-workspace"
CONFIG_FILE="$WORKSPACE/config.json"

color_green="\033[0;32m"
color_yellow="\033[0;33m"
color_cyan="\033[0;36m"
color_reset="\033[0m"

done_msg() {
  echo -e "  ${color_green}✅ $MSG_DONE${color_reset}"
}

skip_msg() {
  echo -e "  ${color_yellow}⏭  $MSG_SKIP${color_reset}"
}

ask_yn() {
  local prompt="$1"
  local default="${2:-Y}"
  if [ "$default" = "Y" ]; then
    read -p "  $prompt [Y/n]: " answer
    answer="${answer:-Y}"
  else
    read -p "  $prompt [y/N]: " answer
    answer="${answer:-N}"
  fi
  [[ "$answer" =~ ^[Yy] ]]
}

# Arrow key menu selector
# Usage: select_menu "Option 1" "Option 2" "Option 3"
# Result: MENU_RESULT (0-based index)
select_menu() {
  local options=("$@")
  local count=${#options[@]}
  local selected=0
  local key

  tput civis 2>/dev/null
  trap 'tput cnorm 2>/dev/null' EXIT

  for i in "${!options[@]}"; do
    if [ "$i" -eq $selected ]; then
      echo -e "  ${color_cyan}▸ ${options[$i]}${color_reset}"
    else
      echo -e "    ${options[$i]}"
    fi
  done

  while true; do
    IFS= read -rsn1 -d '' key
    case "$key" in
      $'\x1b')
        IFS= read -rsn2 -d '' key
        case "$key" in
          '[A')
            if [ $selected -gt 0 ]; then
              selected=$((selected - 1))
            fi
            ;;
          '[B')
            if [ $selected -lt $((count - 1)) ]; then
              selected=$((selected + 1))
            fi
            ;;
        esac
        ;;
      $'\n')
        break
        ;;
    esac

    tput cuu "$count" 2>/dev/null
    for i in "${!options[@]}"; do
      tput el 2>/dev/null
      if [ "$i" -eq $selected ]; then
        echo -e "  ${color_cyan}▸ ${options[$i]}${color_reset}"
      else
        echo -e "    ${options[$i]}"
      fi
    done
  done

  tput cnorm 2>/dev/null
  MENU_RESULT=$selected
}

echo ""
echo -e "🤖 ${color_cyan}Claude Code Setup${color_reset}"
echo ""

# === 0. Language selection (always in English) ===
echo "  Select your language:"
echo ""
select_menu "English" "한국어" "日本語" "Other"

case "$MENU_RESULT" in
  0)
    USER_LANG="en"
    LANG_NAME="English"
    LANG_INSTRUCTION="- Respond in English"
    ;;
  1)
    USER_LANG="ko"
    LANG_NAME="한국어"
    LANG_INSTRUCTION="- 한국어로 대답할 것
- 코드, 명령어, 기술 용어 등 필요한 경우에만 영어 사용"
    ;;
  2)
    USER_LANG="ja"
    LANG_NAME="日本語"
    LANG_INSTRUCTION="- 日本語で回答すること
- コード、コマンド、技術用語は英語のまま使用"
    ;;
  3)
    read -p "  Language code (e.g., zh, de, fr): " USER_LANG
    read -p "  Language name (e.g., 中文, Deutsch): " LANG_NAME
    read -p "  Instruction for Claude (e.g., Respond in Chinese): " custom_instr
    LANG_INSTRUCTION="- $custom_instr"
    ;;
esac

# Load locale file
if [ -f "$SCRIPT_DIR/locale/$USER_LANG.sh" ]; then
  source "$SCRIPT_DIR/locale/$USER_LANG.sh"
else
  source "$SCRIPT_DIR/locale/en.sh"
fi

echo ""
echo -e "  → $MSG_LANG_SET ${color_green}$LANG_NAME${color_reset}"

# Track installation options
OPT_WORKSPACE=false
OPT_OBSIDIAN=false
OPT_MCP_RAG=false
CONNECTED_PROJECTS="[]"

# --- Prerequisite checks ---
if ! command -v node &>/dev/null; then
  echo "  ⚠️  $MSG_NODE_NOT_INSTALLED"
  if command -v brew &>/dev/null; then
    if ask_yn "$MSG_NODE_INSTALL_ASK"; then
      brew install node || echo "  ⚠️  Installation failed."
      done_msg
    fi
  else
    echo "  → Node.js: https://nodejs.org/"
  fi
fi

if ! command -v npm &>/dev/null; then
  echo "  ⚠️  $MSG_NPM_NOT_FOUND"
  echo "  → https://nodejs.org/"
  exit 1
fi

if ! command -v claude &>/dev/null; then
  echo "  $MSG_CLAUDE_NOT_INSTALLED"
  if ask_yn "$MSG_INSTALL_NOW"; then
    if npm install -g @anthropic-ai/claude-code; then
      # Verify installation succeeded
      if command -v claude &>/dev/null; then
        done_msg
      else
        echo ""
        echo "  ❌ Claude Code installed but not in PATH"
        echo ""
        echo "  Please restart your terminal and re-run this script."
        exit 1
      fi
    else
      echo ""
      echo "  ❌ Installation failed"
      echo ""
      echo "  Claude Code is required for this setup."
      echo "  Please check:"
      echo "    1. npm is working: npm --version"
      echo "    2. Internet connection"
      echo "    3. Permissions (may need sudo on some systems)"
      echo ""
      echo "  Try manually: npm install -g @anthropic-ai/claude-code"
      exit 1
    fi
  else
    echo "  $MSG_CLAUDE_REQUIRED"
    echo "$MSG_CLAUDE_INSTALL_CMD"
    exit 1
  fi
fi

# === 1. claude-workspace ===
echo ""
echo -e "${color_cyan}[1/4] $MSG_WS_TITLE${color_reset}"
echo ""
echo "  $MSG_WS_DESC_1"
echo "  $MSG_WS_DESC_2"
echo "  $MSG_WS_DESC_3"
echo ""
echo "  ~/claude-workspace/"
echo "  ├── global/agents/    ← $MSG_WS_TREE_AGENTS"
echo "  ├── projects/         ← $MSG_WS_TREE_PROJECTS"
echo "  └── templates/        ← $MSG_WS_TREE_TEMPLATES"
echo ""

if ask_yn "$MSG_WS_ASK"; then
  OPT_WORKSPACE=true

  mkdir -p "$WORKSPACE/global/agents"
  mkdir -p "$WORKSPACE/projects"
  mkdir -p "$WORKSPACE/templates"

  # Copy global agents
  cp "$SCRIPT_DIR/agents/workspace-manager.md" "$WORKSPACE/global/agents/"
  cp "$SCRIPT_DIR/agents/translate.md" "$WORKSPACE/global/agents/"
  cp "$SCRIPT_DIR/agents/doc-writer.md" "$WORKSPACE/global/agents/"
  echo "  → $MSG_WS_AGENTS_DONE"

  # Copy templates
  cp "$SCRIPT_DIR/templates/"* "$WORKSPACE/templates/" 2>/dev/null || true
  cp "$SCRIPT_DIR/examples/"* "$WORKSPACE/templates/" 2>/dev/null || true
  echo "  → $MSG_WS_TEMPLATES_DONE"

  # Inject language into CLAUDE.local.md (copy from template, substitute on the copy)
  if [ -f "$WORKSPACE/templates/CLAUDE.local.md" ]; then
    # Export so perl can read it via $ENV{}, then use perl for safe multiline replacement
    export LANG_INSTRUCTION
    perl -i -0pe 's/__LANGUAGE_INSTRUCTION__/$ENV{LANG_INSTRUCTION}/g' "$WORKSPACE/templates/CLAUDE.local.md"
  fi

  # Symlink ~/.claude/agents/
  if [ -L "$HOME/.claude/agents" ]; then
    echo "  $MSG_WS_SYMLINK_EXISTS"
  elif [ -d "$HOME/.claude/agents" ]; then
    echo "  ⚠️  $MSG_WS_FOLDER_EXISTS"
    if ask_yn "$MSG_WS_BACKUP_ASK"; then
      mv "$HOME/.claude/agents" "$HOME/.claude/agents.backup"
      ln -s "$WORKSPACE/global/agents" "$HOME/.claude/agents"
      echo "  → $MSG_WS_BACKUP_DONE"
      echo "  → $MSG_WS_SYMLINK_DONE"
    fi
  else
    mkdir -p "$HOME/.claude"
    ln -s "$WORKSPACE/global/agents" "$HOME/.claude/agents"
    echo "  → $MSG_WS_SYMLINK_DONE"
  fi

  done_msg

  # --- Project connection ---
  echo ""
  echo "  $MSG_PROJ_DESC_1"
  echo "  $MSG_PROJ_DESC_2"
  echo ""

  project_list=""

  while ask_yn "$MSG_PROJ_ASK"; do
    read -p "  $MSG_PROJ_PATH" project_path
    project_path="${project_path/#\~/$HOME}"
    project_name=$(basename "$project_path")

    if [ ! -d "$project_path" ]; then
      echo "  ❌ $MSG_PROJ_NOT_FOUND $project_path"
      continue
    fi

    # Handle name collision
    ws_project="$WORKSPACE/projects/$project_name"
    if [ -d "$ws_project" ]; then
      echo "  ⚠️  '$project_name' $MSG_PROJ_NAME_CONFLICT"
      read -p "  → " alt_name
      if [ -z "$alt_name" ]; then
        continue
      fi
      project_name="$alt_name"
      ws_project="$WORKSPACE/projects/$project_name"
    fi

    mkdir -p "$ws_project/.claude/agents"

    if [ ! -f "$ws_project/CLAUDE.md" ]; then
      cp "$WORKSPACE/templates/CLAUDE.md" "$ws_project/CLAUDE.md"
    fi

    if [ ! -f "$ws_project/CLAUDE.local.md" ]; then
      cp "$WORKSPACE/templates/CLAUDE.local.md" "$ws_project/CLAUDE.local.md"
    fi

    # .claude/
    if [ -e "$project_path/.claude" ]; then
      echo "  ⚠️  $project_path/.claude $MSG_PROJ_EXISTS"
    else
      ln -s "$ws_project/.claude" "$project_path/.claude"
      echo "  → $MSG_PROJ_LINK_CLAUDE"
    fi

    # CLAUDE.md
    if [ -e "$project_path/CLAUDE.md" ]; then
      echo "  ⚠️  $project_path/CLAUDE.md $MSG_PROJ_EXISTS"
    else
      ln -s "$ws_project/CLAUDE.md" "$project_path/CLAUDE.md"
      echo "  → $MSG_PROJ_LINK_CLAUDEMD"
    fi

    # CLAUDE.local.md
    if [ -e "$project_path/CLAUDE.local.md" ]; then
      echo "  ⚠️  $project_path/CLAUDE.local.md $MSG_PROJ_EXISTS"
    else
      ln -s "$ws_project/CLAUDE.local.md" "$project_path/CLAUDE.local.md"
      echo "  → $MSG_PROJ_LINK_LOCALMD"
    fi

    # .gitignore
    if [ -f "$project_path/.gitignore" ]; then
      for entry in ".claude/" "CLAUDE.local.md" ".claude-data/"; do
        if ! grep -q "$entry" "$project_path/.gitignore"; then
          echo "$entry" >> "$project_path/.gitignore"
        fi
      done
      echo "  → $MSG_PROJ_GITIGNORE"
    fi

    if [ -n "$project_list" ]; then
      project_list="$project_list, \"$project_name\""
    else
      project_list="\"$project_name\""
    fi

    echo -e "  ${color_green}✅ $project_name $MSG_PROJ_DONE${color_reset}"
    echo ""
  done

  CONNECTED_PROJECTS="[$project_list]"

else
  skip_msg
fi

# === 2. Obsidian ===
echo ""
echo -e "${color_cyan}[2/4] $MSG_OBS_TITLE${color_reset}"
echo ""
echo "  $MSG_OBS_DESC_1"
echo "  $MSG_OBS_DESC_2"
echo ""

if ask_yn "$MSG_OBS_ASK"; then
  OPT_OBSIDIAN=true
  if command -v brew &>/dev/null; then
    brew install --cask obsidian || echo "  ⚠️  Installation failed."
  else
    echo "  → $MSG_BREW_NOT_FOUND_OBSIDIAN"
  fi
  done_msg
else
  skip_msg
fi

# === 3. MCP Servers ===
echo ""
echo -e "${color_cyan}[3/4] $MSG_MCP_TITLE${color_reset}"
echo ""
echo "  $MSG_MCP_DESC_1"
echo "  $MSG_MCP_DESC_2"
echo "  $MSG_MCP_DESC_3"
echo ""

if ask_yn "$MSG_MCP_ASK"; then

  # --- local-rag ---
  echo ""
  echo -e "  ${color_cyan}📚 $MSG_RAG_TITLE${color_reset}"
  echo "  $MSG_RAG_DESC"
  echo ""

  if ask_yn "$MSG_RAG_ASK"; then
    OPT_MCP_RAG=true
    read -p "  $MSG_RAG_PATH" rag_project
    rag_project="${rag_project/#\~/$HOME}"

    if [ -d "$rag_project" ]; then
      rag_data_dir="$rag_project/.claude-data"
      mkdir -p "$rag_data_dir"

      mcp_file="$rag_project/.mcp.json"
      if [ -f "$mcp_file" ]; then
        echo "  ⚠️  $MSG_MCP_FILE_EXISTS"
        echo "  → $MSG_MCP_FILE_REF $SCRIPT_DIR/templates/mcp-local-rag.json"
      else
        # Use perl for safe substitution (handles special chars in paths)
        BASE_DIR="$rag_data_dir" perl -pe 's|__BASE_DIR__|$ENV{BASE_DIR}|g' "$SCRIPT_DIR/templates/mcp-local-rag.json" > "$mcp_file"
        echo "  → $mcp_file $MSG_MCP_FILE_DONE"
      fi
      done_msg
    else
      echo "  ❌ $MSG_PROJ_NOT_FOUND $rag_project"
    fi
  else
    skip_msg
  fi

else
  skip_msg
fi

# === 4. Save config.json + summary ===
if [ "$OPT_WORKSPACE" = true ]; then
  mkdir -p "$WORKSPACE"
  cat > "$CONFIG_FILE" << EOF
{
  "language": "$USER_LANG",
  "languageName": "$LANG_NAME",
  "os": "darwin",
  "installedAt": "$(date +%Y-%m-%d)",
  "options": {
    "workspace": $OPT_WORKSPACE,
    "obsidian": $OPT_OBSIDIAN,
    "mcp": {
      "localRag": $OPT_MCP_RAG
    }
  },
  "projects": $CONNECTED_PROJECTS
}
EOF
fi

# === 5. Git + SSH (Optional) ===
echo ""
echo -e "${color_cyan}[5/5] $MSG_GIT_TITLE${color_reset}"
echo ""
echo "  $MSG_GIT_DESC_1"
echo "  $MSG_GIT_DESC_2"
echo "  $MSG_GIT_DESC_3"
echo "  $MSG_GIT_DESC_4"
echo "  $MSG_GIT_DESC_5"
echo ""
echo "  $MSG_GIT_DESC_NOTE"
echo ""

if command -v git &>/dev/null; then
  echo "  $MSG_ALREADY_INSTALLED"
  done_msg
else
  if ask_yn "$MSG_GIT_INSTALL_ASK"; then
    echo "  $MSG_INSTALLING"
    if command -v brew &>/dev/null; then
      # macOS - use Homebrew
      if brew install git && brew install gh; then
        done_msg
      else
        echo "  ⚠️  Installation failed. Install manually: brew install git gh"
        skip_msg
      fi
    else
      echo "  ⚠️  Homebrew not found. Install Git manually: https://git-scm.com"
      skip_msg
    fi
  else
    skip_msg
  fi
fi

# Git config (if Git is available)
if command -v git &>/dev/null; then
  if ask_yn "$MSG_GIT_CONFIG_ASK"; then
    read -p "  $MSG_GIT_NAME" git_name
    read -p "  $MSG_GIT_EMAIL" git_email
    git config --global user.name "$git_name"
    git config --global user.email "$git_email"
    echo "  $MSG_GIT_CONFIG_DONE"
    done_msg
  fi

  # SSH key (if Git is configured)
  if [ -f "$HOME/.ssh/id_ed25519" ]; then
    echo ""
    echo "  $MSG_SSH_EXISTS"
    if ask_yn "$MSG_SSH_REGISTER"; then
      cat "$HOME/.ssh/id_ed25519.pub" | pbcopy
      echo ""
      echo "  📋 $MSG_SSH_COPIED"
      echo "  $MSG_SSH_GITHUB_URL"
      echo ""
      read -p "  $MSG_SSH_ENTER "
    fi
  elif ask_yn "$MSG_SSH_GENERATE"; then
    read -p "  $MSG_SSH_EMAIL" ssh_email
    if ssh-keygen -t ed25519 -C "$ssh_email" -f "$HOME/.ssh/id_ed25519"; then
      eval "$(ssh-agent -s)" &>/dev/null || true
      ssh-add "$HOME/.ssh/id_ed25519" 2>/dev/null || true
      cat "$HOME/.ssh/id_ed25519.pub" | pbcopy
      echo ""
      echo "  📋 $MSG_SSH_COPIED"
      echo "  $MSG_SSH_GITHUB_URL"
      echo ""
      read -p "  $MSG_SSH_ENTER "
    else
      echo "  ⚠️  SSH key generation cancelled."
    fi
  fi
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "✨ ${color_green}$MSG_COMPLETE${color_reset}"
echo ""
echo "  $MSG_USAGE"
echo ""
if [ "$OPT_WORKSPACE" = true ] && [ -d "$WORKSPACE" ]; then
  echo "  📁 $MSG_INFO_WORKSPACE ~/claude-workspace/"
  echo "  🤖 $MSG_INFO_AGENTS"
  echo "  🌐 $MSG_INFO_LANGUAGE $LANG_NAME"
  echo "  ⚙️  $MSG_INFO_CONFIG ~/claude-workspace/config.json"
  echo ""
  echo "  💡 $MSG_TIP_ADD_PROJECT"
  echo "     $MSG_TIP_ADD_CMD"
fi
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
