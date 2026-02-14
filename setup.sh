#!/bin/bash
#
# ai-dev-setup: Set up macOS development environment
#
set -e

# Ensure interactive input (needed when run via curl | bash)
if [ ! -t 0 ]; then
  exec < /dev/tty
fi

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
STEP=0
TOTAL=6

# === Utilities ===
color_green="\033[0;32m"
color_yellow="\033[0;33m"
color_cyan="\033[0;36m"
color_gray="\033[0;90m"
color_reset="\033[0m"

step() {
  STEP=$((STEP + 1))
  echo ""
  echo -e "${color_cyan}[$STEP/$TOTAL] $1${color_reset}"
}

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

# Multi-select checkbox menu
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
        echo -e "  ${color_gray}▸ [$mark] ${options[$i]}${color_reset}"
      else
        echo -e "  ${color_cyan}▸ [$mark] ${options[$i]}${color_reset}"
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
      $'\n')
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
          echo -e "  ${color_gray}▸ [$mark] ${options[$i]}${color_reset}"
        else
          echo -e "  ${color_cyan}▸ [$mark] ${options[$i]}${color_reset}"
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

# === Language selection ===
echo ""
echo -e "🔧 ${color_cyan}ai-dev-setup${color_reset}"
echo ""
echo "  Select your language:"
echo ""
select_menu "English" "한국어" "日本語"

case "$MENU_RESULT" in
  1) USER_LANG="ko" ;;
  2) USER_LANG="ja" ;;
  *) USER_LANG="en" ;;
esac

# Load locale file
if [ -f "$SCRIPT_DIR/claude-code/locale/$USER_LANG.sh" ]; then
  source "$SCRIPT_DIR/claude-code/locale/$USER_LANG.sh"
else
  source "$SCRIPT_DIR/claude-code/locale/en.sh"
fi

echo ""
echo -e "🔧 $MSG_SETUP_WELCOME_MAC"
echo "   $MSG_SETUP_EACH_STEP"
echo ""

# --- 1. Xcode Command Line Tools ---
step "$MSG_STEP_XCODE"
if xcode-select -p &>/dev/null; then
  echo "  $MSG_ALREADY_INSTALLED"
else
  echo "  $MSG_XCODE_INSTALLING"
  xcode-select --install 2>/dev/null || true
  echo "  $MSG_XCODE_ENTER"
  read -r
fi
done_msg

# --- 2. Homebrew ---
step "$MSG_STEP_HOMEBREW"

# Check if Homebrew exists (in PATH or direct path)
if command -v brew &>/dev/null || [ -f "/opt/homebrew/bin/brew" ] || [ -f "/usr/local/bin/brew" ]; then
  # Homebrew exists - ensure it's in current PATH
  if ! command -v brew &>/dev/null; then
    if [ -f "/opt/homebrew/bin/brew" ]; then
      eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [ -f "/usr/local/bin/brew" ]; then
      eval "$(/usr/local/bin/brew shellenv)"
    fi
  fi
  echo "  $MSG_ALREADY_INSTALLED"
else
  # Homebrew not found - install
  echo "  $MSG_INSTALLING"

  # Check sudo permission first
  if ! sudo -v 2>/dev/null; then
    echo ""
    echo "❌ $MSG_NO_SUDO"
    echo ""
    echo "$MSG_BREW_NEEDS_SUDO"
    echo ""
    echo "$MSG_SUDO_HOW_TO_FIX"
    echo "  $MSG_SUDO_OPTION_1"
    echo "  $MSG_SUDO_OPTION_2"
    echo "  $MSG_SUDO_OPTION_3"
    echo "  $MSG_SUDO_OPTION_4"
    echo ""
    echo "$MSG_SUDO_OR"
    echo "  $MSG_SUDO_ADMIN_LOGIN"
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "$MSG_BREW_REQUIRED_FOR"
    echo "  $MSG_BREW_REQUIRED_NODE"
    echo "  $MSG_BREW_REQUIRED_TOOLS"
    echo ""
    echo "$MSG_BREW_MANUAL_ALTERNATIVE"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    exit 1
  fi

  # Attempt installation (sudo already verified)
  if /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; then
    # Success - add to PATH
    if [ -f "/opt/homebrew/bin/brew" ]; then
      eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [ -f "/usr/local/bin/brew" ]; then
      eval "$(/usr/local/bin/brew shellenv)"
    fi
  else
    # Failed - show manual install command and exit
    echo ""
    echo "❌ $MSG_BREW_FAILED"
    echo ""
    echo "$MSG_BREW_MANUAL_INSTALL"
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "$MSG_BREW_COPY_PASTE"
    echo ""
    echo "  /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "$MSG_BREW_AFTER_INSTALL"
    echo "  cd $SCRIPT_DIR && ./setup.sh"
    echo ""
    exit 1
  fi
fi

done_msg

# --- 3. Packages ---
step "$MSG_STEP_PACKAGES"
if command -v brew &>/dev/null; then
  echo ""

  # Install packages
  if brew bundle --file="$SCRIPT_DIR/Brewfile" --verbose; then
    echo ""
  else
    echo ""
    echo "  ⚠️  Some packages may have failed to install."
  fi

  # Verify Node.js (critical for AI tools)
  if ! command -v node &>/dev/null; then
    echo ""
    echo "❌ Node.js installation failed"
    echo ""
    echo "$MSG_NODE_REQUIRED"
    echo ""
    echo "$MSG_NODE_MANUAL_INSTALL"
    echo "  brew install node"
    echo ""
    echo "$MSG_NODE_VERIFY"
    echo "  node --version"
    echo ""
    exit 1
  fi

  done_msg
else
  echo "  ⚠️  Homebrew not available. Skipping package installation."
  skip_msg
fi

# --- 4. D2Coding font ---
step "$MSG_STEP_D2CODING"
# Check font directories
if ls ~/Library/Fonts/*D2Coding* /Library/Fonts/*D2Coding* 2>/dev/null | head -1 | grep -q .; then
  echo "  $MSG_ALREADY_INSTALLED"
else
  echo "  $MSG_STEP_FONT_D2CODING_BREW"
fi
done_msg

# --- 5. Terminal + Shell Setup ---
step "$MSG_STEP_TERMINAL"
select_menu "$MSG_TERMINAL_OPT1" "$MSG_TERMINAL_OPT2" "$MSG_TERMINAL_OPT3" "$MSG_TERMINAL_OPT4"

case "$MENU_RESULT" in
  0)
    # Terminal.app - import Dev theme and set as default
    open "$SCRIPT_DIR/configs/mac/Dev.terminal"
    sleep 2
    defaults write com.apple.Terminal "Default Window Settings" -string "Dev"
    defaults write com.apple.Terminal "Startup Window Settings" -string "Dev"
    killall cfprefsd 2>/dev/null || true
    echo "  $MSG_TERMINAL_APPLIED"
    echo "  💡 $MSG_TERMINAL_RESTART_HINT"
    ;;
  1)
    # iTerm2 only
    if [ -d "/Applications/iTerm.app" ]; then
      echo "  iTerm2: $MSG_ALREADY_INSTALLED"
    else
      if brew install --cask iterm2; then
        echo "  $MSG_ITERM2_INSTALLED"
      else
        echo "  ⚠️  $MSG_ITERM2_INSTALL_FAILED"
      fi
    fi
    # Apply Dev profile (only if iTerm2 exists)
    if [ -d "/Applications/iTerm.app" ]; then
      mkdir -p "$HOME/Library/Application Support/iTerm2/DynamicProfiles"
      cp "$SCRIPT_DIR/configs/mac/iterm2-dev-profile.json" "$HOME/Library/Application Support/iTerm2/DynamicProfiles/"
      echo "  $MSG_ITERM2_PROFILE_APPLIED"
      echo "  💡 $MSG_ITERM2_PROFILE_HINT"
    fi
    ;;
  2)
    # Both
    open "$SCRIPT_DIR/configs/mac/Dev.terminal"
    sleep 2
    defaults write com.apple.Terminal "Default Window Settings" -string "Dev"
    defaults write com.apple.Terminal "Startup Window Settings" -string "Dev"
    killall cfprefsd 2>/dev/null || true
    echo "  Terminal.app: $MSG_TERMINAL_APPLIED"

    if [ -d "/Applications/iTerm.app" ]; then
      echo "  iTerm2: $MSG_ALREADY_INSTALLED"
    else
      if brew install --cask iterm2; then
        echo "  $MSG_ITERM2_INSTALLED"
      else
        echo "  ⚠️  $MSG_ITERM2_INSTALL_FAILED"
      fi
    fi
    # Apply Dev profile to iTerm2 (only if iTerm2 exists)
    if [ -d "/Applications/iTerm.app" ]; then
      mkdir -p "$HOME/Library/Application Support/iTerm2/DynamicProfiles"
      cp "$SCRIPT_DIR/configs/mac/iterm2-dev-profile.json" "$HOME/Library/Application Support/iTerm2/DynamicProfiles/"
      echo "  iTerm2: $MSG_ITERM2_PROFILE_APPLIED"
      echo "  💡 $MSG_BOTH_TERMINAL_HINT"
    fi
    ;;
  3)
    skip_msg
    ;;
  *)
    skip_msg
    ;;
esac

# Oh My Zsh (if terminal was selected)
if [ "$MENU_RESULT" -ne 3 ]; then
  echo ""
  OMZ_INSTALLED=false
  if [ -d "$HOME/.oh-my-zsh" ]; then
    echo "  Oh My Zsh: $MSG_ALREADY_INSTALLED"
    OMZ_INSTALLED=true
  elif ask_yn "$MSG_OHMYZSH_INSTALL"; then
    if sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended; then
      OMZ_INSTALLED=true
    else
      echo "  ⚠️  Oh My Zsh installation failed."
      echo "     $MSG_OHMYZSH_INSTALL_HINT"
      echo "     $MSG_OHMYZSH_INSTALL_CMD"
    fi
  fi

  # zshrc customization
  if [ -f "$HOME/.zshrc" ] && grep -q "# === ai-dev-setup ===" "$HOME/.zshrc"; then
    echo "  .zshrc: $MSG_ALREADY_INSTALLED"
  else
    echo ""
    echo "  $MSG_ZSHRC_ASK"
    echo "  $MSG_ZSHRC_HINT"
    if [ "$OMZ_INSTALLED" = false ]; then
      echo ""
      echo "  ⚠️  $MSG_OHMYZSH_NOT_INSTALLED"
      echo "     $MSG_OHMYZSH_THEME_SKIP"
    fi
    echo ""
    MULTI_DEFAULTS="" select_multi "$MSG_ZSHRC_OPT_THEME" "$MSG_ZSHRC_OPT_PLUGINS" "$MSG_ZSHRC_OPT_ALIAS"

    if [ ${#MULTI_RESULT[@]} -gt 0 ]; then
      # Prepare .zshrc
      if [ -f "$HOME/.zshrc" ]; then
        echo "" >> "$HOME/.zshrc"
        echo "# === ai-dev-setup ===" >> "$HOME/.zshrc"
      else
        # Create new .zshrc with basic settings
        cat > "$HOME/.zshrc" << 'EOF'
# === Basic Settings ===
export LANG=en_US.UTF-8
export EDITOR=vim

# === History ===
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS

# === ai-dev-setup ===
EOF
      fi

      # Apply selected features
      for idx in "${MULTI_RESULT[@]}"; do
        case "$idx" in
          0) # agnoster theme + emoji prompt
            if [ "$OMZ_INSTALLED" = true ]; then
              # Set agnoster theme
              if grep -q "^ZSH_THEME=" "$HOME/.zshrc"; then
                sed -i '' 's/^ZSH_THEME=.*/ZSH_THEME="agnoster"/' "$HOME/.zshrc"
              else
                echo 'ZSH_THEME="agnoster"' >> "$HOME/.zshrc"
              fi
              # Add emoji prompt customization
              cat >> "$HOME/.zshrc" << 'EOF'

# === agnoster emoji prompt ===
prompt_context() {
  emojis=("🔥" "👑" "😎" "🍺" "🐵" "🦄" "🌈" "🚀" "🐧" "🎉" "🐱" "🐶" "🦋" "🔅")
  RAND_EMOJI_N=$(( $RANDOM % ${#emojis[@]} + 1))
  prompt_segment black default "%(!.%{%F{yellow}%}.) $USER ${emojis[$RAND_EMOJI_N]} "
}
EOF
            else
              echo "  ⚠️  agnoster theme requires Oh My Zsh (skipped)"
            fi
            ;;
          1) # plugins
            cat >> "$HOME/.zshrc" << 'EOF'

# === zsh plugins ===
if [ -f "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
  source "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi
if [ -f "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]; then
  source "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi
EOF
            ;;
          2) # alias
            cat >> "$HOME/.zshrc" << 'EOF'

# === Useful aliases ===
alias ll="ls -la"
alias gs="git status"
alias gl="git log --oneline -20"
EOF
            ;;
        esac
      done

      echo "  $MSG_ZSHRC_DONE"
    fi
  fi

  # tmux
  if ask_yn "$MSG_TMUX_ASK"; then
    if [ -f "$HOME/.tmux.conf" ]; then
      cp "$HOME/.tmux.conf" "$HOME/.tmux.conf.backup"
    fi
    cp "$SCRIPT_DIR/configs/shared/.tmux.conf" "$HOME/.tmux.conf"
    echo "  $MSG_TMUX_DONE"
  fi
fi

done_msg

# --- 6. AI Coding Tools ---
step "$MSG_STEP_AI_TOOLS"
echo "  $MSG_AI_TOOLS_HINT"
echo ""

# Check if gh CLI is available for GitHub Copilot CLI
DISABLED_ITEMS=""
if ! command -v gh &>/dev/null; then
  DISABLED_ITEMS="3"  # Disable GitHub Copilot CLI (index 3)
fi

MULTI_DEFAULTS="0" select_multi "Claude Code" "Gemini CLI" "Codex CLI" "GitHub Copilot CLI (requires gh)"

INSTALLED_CLAUDE=false
for idx in "${MULTI_RESULT[@]}"; do
  case "$idx" in
    0) # Claude Code
      # Check npm prerequisite
      if ! command -v npm &>/dev/null; then
        echo "  ❌ Claude Code requires Node.js/npm"
        echo "     npm not found. Please install Node.js first:"
        echo "     brew install node"
        continue
      fi

      INSTALLED_CLAUDE=true
      if command -v claude &>/dev/null; then
        echo "  Claude Code: $MSG_ALREADY_INSTALLED"
        if ask_yn "$MSG_CLAUDE_UPDATE_ASK"; then
          echo "  $MSG_UPDATING"
          npm update -g @anthropic-ai/claude-code || echo "  ⚠️  Update failed."
        fi
      else
        echo "  $MSG_INSTALLING Claude Code..."
        npm install -g @anthropic-ai/claude-code || echo "  ⚠️  Installation failed."
      fi
      ;;
    1) # Gemini CLI
      # Check npm prerequisite
      if ! command -v npm &>/dev/null; then
        echo "  ❌ Gemini CLI requires Node.js/npm"
        echo "     npm not found. Please install Node.js first:"
        echo "     brew install node"
        continue
      fi

      if command -v gemini &>/dev/null; then
        echo "  Gemini CLI: $MSG_ALREADY_INSTALLED"
      else
        echo "  $MSG_INSTALLING Gemini CLI..."
        npm install -g @google/gemini-cli || echo "  ⚠️  Installation failed."
      fi
      ;;
    2) # Codex CLI
      # Check npm prerequisite
      if ! command -v npm &>/dev/null; then
        echo "  ❌ Codex CLI requires Node.js/npm"
        echo "     npm not found. Please install Node.js first:"
        echo "     brew install node"
        continue
      fi

      if command -v codex &>/dev/null; then
        echo "  Codex CLI: $MSG_ALREADY_INSTALLED"
      else
        echo "  $MSG_INSTALLING Codex CLI..."
        npm install -g @openai/codex || echo "  ⚠️  Installation failed."
      fi
      ;;
    3) # GitHub Copilot CLI
      # Check gh prerequisite
      if ! command -v gh &>/dev/null; then
        echo "  ❌ GitHub Copilot CLI requires GitHub CLI (gh)"
        echo "     gh not found. Please install it first:"
        echo "     brew install gh"
        continue
      fi

      if gh extension list 2>/dev/null | grep -q "gh-copilot"; then
        echo "  GitHub Copilot CLI: $MSG_ALREADY_INSTALLED"
      else
        echo "  $MSG_INSTALLING GitHub Copilot CLI..."
        gh extension install github/gh-copilot || echo "  ⚠️  Installation failed."
      fi
      ;;
  esac
done

if [ ${#MULTI_RESULT[@]} -eq 0 ]; then
  skip_msg
else
  done_msg
fi

if [ "$INSTALLED_CLAUDE" = true ]; then
  echo ""
  echo -e "  💡 $MSG_CLAUDE_EXTRA"
  echo -e "     ${color_cyan}~/claude-code-setup/setup-claude.sh${color_reset}"
fi

# === Cleanup ===
# Copy claude-code/ for later setup, then remove entire install directory
# This handles both ZIP download (install.sh) and git clone cases cleanly
CLAUDE_CODE_DIR="$HOME/claude-code-setup"
if [ -d "$SCRIPT_DIR/claude-code" ]; then
  mkdir -p "$CLAUDE_CODE_DIR"
  cp "$SCRIPT_DIR/claude-code/setup-claude.sh" "$CLAUDE_CODE_DIR/"
  cp "$SCRIPT_DIR/claude-code/README.md" "$CLAUDE_CODE_DIR/" 2>/dev/null || true
  cp -r "$SCRIPT_DIR/claude-code/agents" "$CLAUDE_CODE_DIR/"
  cp -r "$SCRIPT_DIR/claude-code/templates" "$CLAUDE_CODE_DIR/"
  cp -r "$SCRIPT_DIR/claude-code/examples" "$CLAUDE_CODE_DIR/"
  cp -r "$SCRIPT_DIR/claude-code/locale" "$CLAUDE_CODE_DIR/"
  chmod +x "$CLAUDE_CODE_DIR/setup-claude.sh"
fi
# Remove entire install directory (including .git if cloned)
cd "$HOME"
rm -rf "$SCRIPT_DIR"

# === Done ===
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "✨ ${color_green}Phase 1 Complete!${color_reset}"
echo ""
echo "  Next: Phase 2 - Claude Code Setup (optional)"
echo ""
echo "  • Workspace management (central config)"
echo "  • Global agents (workspace-manager, translate, doc-writer)"
echo "  • MCP servers (document search)"
echo "  • Git + GitHub (recommended for Claude features)"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

if ask_yn "Continue to Phase 2 now?"; then
  echo ""
  echo "  ⚠️  Terminal restart required for Phase 2"
  echo "     (to load updated PATH and shell config)"
  echo ""

  if ask_yn "Open new terminal and start Phase 2?"; then
    echo ""
    echo "  🚀 Opening new terminal..."
    echo ""

    # Open new terminal with setup-claude.sh
    osascript <<EOF
tell application "Terminal"
    activate
    do script "cd ~ && ~/claude-code-setup/setup-claude.sh"
end tell
EOF

    echo "  ✅ New terminal opened with Phase 2 setup"
    echo "  ℹ️  You can close this window after Phase 2 starts"
  else
    echo ""
    echo "  💡 Run Phase 2 later in a new terminal:"
    echo "     ~/claude-code-setup/setup-claude.sh"
  fi
else
  echo ""
  echo "  💡 You can run Phase 2 anytime:"
  echo "     ~/claude-code-setup/setup-claude.sh"
fi

echo ""
