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
color_gray="\033[0;90m"
color_bold="${color_bold}"
color_bold_cyan="${color_bold_cyan}"
color_bold_gray="${color_bold_gray}"
color_reset="${color_reset}"

done_msg() {
  echo -e "  ${color_green}✅ $MSG_DONE${color_reset}"
}

skip_msg() {
  echo -e "  ${color_yellow}⏭  $MSG_SKIP${color_reset}"
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

# Multi-select menu (Space to toggle, Enter to confirm)
# Usage: MULTI_DEFAULTS="0 2" DISABLED_ITEMS="3" select_multi "Option A" "Option B" "Option C" "Option D"
# Result: MULTI_RESULT array of selected indices (0-based)
select_multi() {
  local options=("$@")
  local count=${#options[@]}
  local selected=0
  local key
  local -a checked=()
  local -a disabled=()

  for i in "${!options[@]}"; do checked[$i]=0; done
  for idx in $MULTI_DEFAULTS; do checked[$idx]=1; done
  for i in "${!options[@]}"; do disabled[$i]=0; done
  for idx in $DISABLED_ITEMS; do disabled[$idx]=1; done

  tput civis 2>/dev/null
  trap 'tput cnorm 2>/dev/null' EXIT

  for i in "${!options[@]}"; do
    local mark=" "
    if [ "${disabled[$i]}" -eq 1 ]; then
      mark="-"
    elif [ "${checked[$i]}" -eq 1 ]; then
      mark="x"
    fi

    if [ "$i" -eq $selected ]; then
      if [ "${disabled[$i]}" -eq 1 ]; then
        echo -e "  ${color_bold_gray}▸ [$mark] ${options[$i]}${color_reset}"
      elif [ "${checked[$i]}" -eq 1 ]; then
        echo -e "  ${color_bold_cyan}▸ [$mark] ${options[$i]}${color_reset}"
      else
        echo -e "  ${color_bold}▸ [$mark] ${options[$i]}${color_reset}"
      fi
    else
      if [ "${disabled[$i]}" -eq 1 ]; then
        echo -e "  ${color_gray}  [$mark] ${options[$i]}${color_reset}"
      elif [ "${checked[$i]}" -eq 1 ]; then
        echo -e "    ${color_cyan}[$mark] ${options[$i]}${color_reset}"
      else
        echo -e "    [$mark] ${options[$i]}"
      fi
    fi
  done

  while true; do
    IFS= read -rsn1 key
    case "$key" in
      $'\x1b')
        IFS= read -rsn2 key
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
      ' ')
        # Ignore Space key for disabled items
        if [ "${disabled[$selected]}" -eq 1 ]; then
          :
        elif [ "${checked[$selected]}" -eq 1 ]; then
          checked[$selected]=0
        else
          checked[$selected]=1
        fi
        ;;
      ''|$'\n'|$'\r')
        break
        ;;
    esac

    tput cuu "$count" 2>/dev/null
    for i in "${!options[@]}"; do
      tput el 2>/dev/null
      local mark=" "
      if [ "${disabled[$i]}" -eq 1 ]; then
        mark="-"
      elif [ "${checked[$i]}" -eq 1 ]; then
        mark="x"
      fi

      if [ "$i" -eq $selected ]; then
        if [ "${disabled[$i]}" -eq 1 ]; then
          echo -e "  ${color_bold_gray}▸ [$mark] ${options[$i]}${color_reset}"
        elif [ "${checked[$i]}" -eq 1 ]; then
          echo -e "  ${color_bold_cyan}▸ [$mark] ${options[$i]}${color_reset}"
        else
          echo -e "  ${color_bold}▸ [$mark] ${options[$i]}${color_reset}"
        fi
      else
        if [ "${disabled[$i]}" -eq 1 ]; then
          echo -e "  ${color_gray}  [$mark] ${options[$i]}${color_reset}"
        elif [ "${checked[$i]}" -eq 1 ]; then
          echo -e "    ${color_cyan}[$mark] ${options[$i]}${color_reset}"
        else
          echo -e "    [$mark] ${options[$i]}"
        fi
      fi
    done
  done

  tput cnorm 2>/dev/null
  MULTI_RESULT=()
  for i in "${!options[@]}"; do
    if [ "${checked[$i]}" -eq 1 ]; then
      MULTI_RESULT+=("$i")
    fi
  done
}

echo ""
echo -e "🤖 ${color_cyan}Claude Code Setup${color_reset}"
echo ""

# === 0. Language selection (always in English) ===
# Check if language was already selected in Phase 1
if [ -f "$SCRIPT_DIR/.dev-setup-lang" ]; then
  USER_LANG=$(cat "$SCRIPT_DIR/.dev-setup-lang")
  case "$USER_LANG" in
    ko)
      LANG_NAME="한국어"
      LANG_INSTRUCTION="- 한국어로 대답할 것
- 코드, 명령어, 기술 용어 등 필요한 경우에만 영어 사용"
      ;;
    ja)
      LANG_NAME="日本語"
      LANG_INSTRUCTION="- 日本語で回答すること
- コード、コマンド、技術用語は英語のまま使用"
      ;;
    *)
      LANG_NAME="English"
      LANG_INSTRUCTION="- Respond in English"
      ;;
  esac
else
  # No saved language, ask user
  echo "  $MSG_LANG_SELECT"
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
      read -p "  $MSG_LANG_CUSTOM_CODE" USER_LANG
      read -p "  $MSG_LANG_CUSTOM_NAME" LANG_NAME
      read -p "  $MSG_LANG_CUSTOM_INSTRUCTION" custom_instr
      LANG_INSTRUCTION="- $custom_instr"
      ;;
  esac
fi

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
OPT_MCP_FILESYSTEM=false
OPT_MCP_SERENA=false
OPT_MCP_FETCH=false
OPT_MCP_PUPPETEER=false
CONNECTED_PROJECTS="[]"

# --- Prerequisite checks ---
if ! command -v node &>/dev/null; then
  echo "  ⚠️  $MSG_NODE_NOT_INSTALLED"
  if command -v brew &>/dev/null; then
    echo "  $MSG_NODE_INSTALL_ASK"
    echo ""
    select_menu "$MSG_YES" "$MSG_NO"
    if [ "$MENU_RESULT" -eq 0 ]; then
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
  echo "  $MSG_INSTALL_NOW"
  echo ""
  select_menu "$MSG_YES" "$MSG_NO"
  if [ "$MENU_RESULT" -eq 0 ]; then
    if npm install -g @anthropic-ai/claude-code; then
      # Verify installation succeeded
      if command -v claude &>/dev/null; then
        done_msg
      else
        echo ""
        echo "  ❌ $MSG_CLAUDE_NOT_IN_PATH"
        echo ""
        echo "  $MSG_CLAUDE_RESTART_TERMINAL"
        exit 1
      fi
    else
      echo ""
      echo "  ❌ $MSG_CLAUDE_INSTALL_FAILED"
      echo ""
      echo "  $MSG_CLAUDE_REQUIRED"
      echo "  $MSG_CLAUDE_CHECK_HEADER"
      echo "    $MSG_CLAUDE_CHECK_NPM"
      echo "    $MSG_CLAUDE_CHECK_INTERNET"
      echo "    $MSG_CLAUDE_CHECK_PERMISSIONS"
      echo ""
      echo "  $MSG_CLAUDE_TRY_MANUAL"
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
echo "  $MSG_WS_ASK"
echo ""
select_menu "$MSG_YES" "$MSG_NO"

if [ "$MENU_RESULT" -eq 0 ]; then
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
    echo "  $MSG_WS_BACKUP_ASK"
    echo ""
    select_menu "$MSG_YES" "$MSG_NO"
    if [ "$MENU_RESULT" -eq 0 ]; then
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

  while true; do
    echo "  $MSG_PROJ_ASK"
    echo ""
    select_menu "$MSG_YES" "$MSG_NO"
    [ "$MENU_RESULT" -ne 0 ] && break

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
echo "  $MSG_OBS_ASK"
echo ""
select_menu "$MSG_YES" "$MSG_NO"

if [ "$MENU_RESULT" -eq 0 ]; then
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
echo "  $MSG_MCP_ASK"
echo ""
select_menu "$MSG_YES" "$MSG_NO"

if [ "$MENU_RESULT" -eq 0 ]; then
  echo ""
  echo "  $MSG_MCP_SELECT_PROMPT"
  echo ""
  echo "  $MSG_MCP_RECOMMENDED_HEADER"
  echo "  $MSG_MCP_RECOMMENDED_DESC_1"
  echo "  $MSG_MCP_RECOMMENDED_DESC_2"
  echo "  $MSG_MCP_RECOMMENDED_DESC_3"
  echo ""
  echo "  $MSG_MCP_ADDITIONAL_HEADER"
  echo "  $MSG_MCP_ADDITIONAL_DESC_1"
  echo "  $MSG_MCP_ADDITIONAL_DESC_2"
  echo ""
  echo "  $MSG_MCP_SELECT_HINT"
  echo ""

  # Build option labels with recommended status
  local opt_localrag="$MSG_MCP_SERVER_LOCALRAG $MSG_RECOMMENDED"
  local opt_filesystem="$MSG_MCP_SERVER_FILESYSTEM $MSG_RECOMMENDED"
  local opt_serena="$MSG_MCP_SERVER_SERENA $MSG_RECOMMENDED"
  local opt_fetch="$MSG_MCP_SERVER_FETCH"
  local opt_puppeteer="$MSG_MCP_SERVER_PUPPETEER"

  # Multi-select menu with recommended servers pre-checked
  MULTI_DEFAULTS="0 1 2" DISABLED_ITEMS="" select_multi \
    "$opt_localrag" \
    "$opt_filesystem" \
    "$opt_serena" \
    "$opt_fetch" \
    "$opt_puppeteer"

  # Process selected servers
  echo ""
  MCP_SERVERS=()
  for i in "${MULTI_RESULT[@]}"; do
    case $i in
      0)
        OPT_MCP_RAG=true
        MCP_SERVERS+=("local-rag")
        printf "  → $MSG_MCP_INSTALLING_PREFIX\n" "local-rag"
        ;;
      1)
        OPT_MCP_FILESYSTEM=true
        MCP_SERVERS+=("filesystem")
        printf "  → $MSG_MCP_INSTALLING_PREFIX\n" "filesystem"
        ;;
      2)
        OPT_MCP_SERENA=true
        MCP_SERVERS+=("serena")
        printf "  → $MSG_MCP_INSTALLING_PREFIX\n" "serena"
        ;;
      3)
        OPT_MCP_FETCH=true
        MCP_SERVERS+=("fetch")
        printf "  → $MSG_MCP_INSTALLING_PREFIX\n" "fetch"
        ;;
      4)
        OPT_MCP_PUPPETEER=true
        MCP_SERVERS+=("puppeteer")
        printf "  → $MSG_MCP_INSTALLING_PREFIX\n" "puppeteer"
        ;;
    esac
  done

  # Install selected MCP servers
  if [ ${#MCP_SERVERS[@]} -gt 0 ]; then
    echo ""
    printf "  $MSG_MCP_INSTALLING_COUNT\n" "${#MCP_SERVERS[@]}"

    # Ask for project path to configure .mcp.json
    echo ""
    read -p "  $MSG_MCP_PROJECT_PATH_PROMPT" mcp_project

    if [ -n "$mcp_project" ]; then
      mcp_project="${mcp_project/#\~/$HOME}"

      if [ -d "$mcp_project" ]; then
        mcp_file="$mcp_project/.mcp.json"

        if [ -f "$mcp_file" ]; then
          echo "  ⚠️  $MSG_MCP_FILE_EXISTS"
          echo "  → $MSG_MCP_SKIP_CREATION"
        else
          # Create .mcp.json with selected servers
          printf "  → $MSG_MCP_CREATING_FILE\n" "$mcp_file"

          cat > "$mcp_file" << 'EOF_MCP'
{
  "mcpServers": {
EOF_MCP

          # Add each selected server to .mcp.json
          local first=true
          for server in "${MCP_SERVERS[@]}"; do
            [ "$first" = false ] && echo "," >> "$mcp_file"
            first=false

            case $server in
              local-rag)
                rag_data_dir="$mcp_project/.claude-data"
                mkdir -p "$rag_data_dir"
                cat >> "$mcp_file" << EOF
    "local-rag": {
      "command": "npx",
      "args": ["-y", "@local-rag/mcp-server"],
      "env": {
        "DATA_PATH": "$rag_data_dir"
      }
    }
EOF
                ;;
              filesystem)
                cat >> "$mcp_file" << EOF
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "$mcp_project"]
    }
EOF
                ;;
              serena)
                cat >> "$mcp_file" << 'EOF'
    "serena": {
      "command": "npx",
      "args": ["-y", "@serena/mcp-server"]
    }
EOF
                ;;
              fetch)
                cat >> "$mcp_file" << 'EOF'
    "fetch": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-fetch"]
    }
EOF
                ;;
              puppeteer)
                cat >> "$mcp_file" << 'EOF'
    "puppeteer": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-puppeteer"]
    }
EOF
                ;;
            esac
          done

          cat >> "$mcp_file" << 'EOF'

  }
}
EOF

          printf "  ✅ $MSG_MCP_FILE_CREATED\n" "${#MCP_SERVERS[@]}"
        fi
      else
        echo "  ❌ $MSG_MCP_PROJECT_NOT_FOUND $mcp_project"
        echo "  → $MSG_MCP_PROJECT_MANUAL"
      fi
    else
      echo "  → $MSG_MCP_SKIP_CREATION"
    fi

    done_msg
  else
    echo "  $MSG_MCP_NO_SERVERS"
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
      "localRag": $OPT_MCP_RAG,
      "filesystem": $OPT_MCP_FILESYSTEM,
      "serena": $OPT_MCP_SERENA,
      "fetch": $OPT_MCP_FETCH,
      "puppeteer": $OPT_MCP_PUPPETEER
    }
  },
  "projects": $CONNECTED_PROJECTS
}
EOF
fi

# === 4. Git + SSH (Optional) ===
echo ""
echo -e "${color_cyan}[4/4] $MSG_GIT_TITLE${color_reset}"
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
  echo "  $MSG_GIT_INSTALL_ASK"
  echo ""
  select_menu "$MSG_YES" "$MSG_NO"
  if [ "$MENU_RESULT" -eq 0 ]; then
    echo "  $MSG_INSTALLING"
    if command -v brew &>/dev/null; then
      # macOS - use Homebrew
      if brew install git && brew install gh; then
        done_msg
      else
        echo "  ⚠️  $MSG_GIT_INSTALL_FAILED"
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
  echo ""
  echo "  $MSG_GIT_CONFIG_ASK"
  echo ""
  select_menu "$MSG_YES" "$MSG_NO"
  if [ "$MENU_RESULT" -eq 0 ]; then
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
    echo "  $MSG_SSH_REGISTER"
    echo ""
    select_menu "$MSG_YES" "$MSG_NO"
    if [ "$MENU_RESULT" -eq 0 ]; then
      cat "$HOME/.ssh/id_ed25519.pub" | pbcopy
      echo ""
      echo "  📋 $MSG_SSH_COPIED"
      echo "  $MSG_SSH_GITHUB_URL"
      echo ""
      read -p "  $MSG_SSH_ENTER "
    fi
  else
    echo ""
    echo "  $MSG_SSH_GENERATE"
    echo ""
    select_menu "$MSG_YES" "$MSG_NO"
    if [ "$MENU_RESULT" -eq 0 ]; then
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
