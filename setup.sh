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
TOTAL=9

# === Utilities ===
color_green="\033[0;32m"
color_yellow="\033[0;33m"
color_cyan="\033[0;36m"
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
    read -rsn1 key
    case "$key" in
      $'\x1b')
        read -rsn2 key
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
      '')
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
# Usage: MULTI_DEFAULTS="0 2" select_multi "Option A" "Option B" "Option C"
# Result: MULTI_RESULT array of selected indices (0-based)
select_multi() {
  local options=("$@")
  local count=${#options[@]}
  local selected=0
  local key
  local -a checked=()

  for i in "${!options[@]}"; do checked[$i]=0; done
  for idx in $MULTI_DEFAULTS; do checked[$idx]=1; done

  tput civis 2>/dev/null
  trap 'tput cnorm 2>/dev/null' EXIT

  for i in "${!options[@]}"; do
    local mark=" "; if [ "${checked[$i]}" -eq 1 ]; then mark="x"; fi
    if [ "$i" -eq $selected ]; then
      echo -e "  ${color_cyan}▸ [$mark] ${options[$i]}${color_reset}"
    else
      echo -e "    [$mark] ${options[$i]}"
    fi
  done

  while true; do
    read -rsn1 key
    case "$key" in
      $'\x1b')
        read -rsn2 key
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
        if [ "${checked[$selected]}" -eq 1 ]; then
          checked[$selected]=0
        else
          checked[$selected]=1
        fi
        ;;
      '')
        break
        ;;
    esac

    tput cuu "$count" 2>/dev/null
    for i in "${!options[@]}"; do
      tput el 2>/dev/null
      local mark=" "; if [ "${checked[$i]}" -eq 1 ]; then mark="x"; fi
      if [ "$i" -eq $selected ]; then
        echo -e "  ${color_cyan}▸ [$mark] ${options[$i]}${color_reset}"
      else
        echo -e "    [$mark] ${options[$i]}"
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

# Cache sudo credentials upfront
sudo -v || echo "  ⚠️  sudo not available. Some steps may need manual installation."

# --- 1. Xcode Command Line Tools ---
step "$MSG_STEP_XCODE"
if xcode-select -p &>/dev/null; then
  echo "  $MSG_ALREADY_INSTALLED"
else
  echo "  $MSG_XCODE_INSTALLING"
  xcode-select --install
  echo "  $MSG_XCODE_ENTER"
  read -r
fi
done_msg

# --- 2. Homebrew ---
step "$MSG_STEP_HOMEBREW"
if command -v brew &>/dev/null; then
  echo "  $MSG_ALREADY_INSTALLED"
  echo "  $MSG_UPDATING"
  brew update || echo "  ⚠️  brew update failed, continuing..."
else
  echo "  $MSG_INSTALLING"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  # Apple Silicon path
  if [ -f "/opt/homebrew/bin/brew" ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
fi
done_msg

# --- 3. Packages ---
step "$MSG_STEP_PACKAGES"
brew bundle --file="$SCRIPT_DIR/Brewfile" || echo "  ⚠️  Some packages may have failed to install."
done_msg

# --- 4. D2Coding font ---
step "$MSG_STEP_D2CODING"
# Check font directories
if ls ~/Library/Fonts/*D2Coding* /Library/Fonts/*D2Coding* 2>/dev/null | head -1 | grep -q .; then
  echo "  $MSG_ALREADY_INSTALLED"
else
  echo "  $MSG_STEP_FONT_D2CODING_BREW"
fi
done_msg

# --- 5. SSH key ---
step "$MSG_STEP_SSH"
if [ -f "$HOME/.ssh/id_ed25519" ]; then
  echo "  $MSG_SSH_EXISTS"
  if ask_yn "$MSG_SSH_REGISTER"; then
    cat "$HOME/.ssh/id_ed25519.pub" | pbcopy
    echo ""
    echo "  📋 $MSG_SSH_COPIED"
    echo "  $MSG_SSH_GITHUB_URL"
    echo ""
    read -p "  $MSG_SSH_ENTER "
  fi
  done_msg
elif ask_yn "$MSG_SSH_GENERATE"; then
  read -p "  $MSG_SSH_EMAIL" ssh_email
  ssh-keygen -t ed25519 -C "$ssh_email" -f "$HOME/.ssh/id_ed25519"
  eval "$(ssh-agent -s)" &>/dev/null
  ssh-add "$HOME/.ssh/id_ed25519" 2>/dev/null
  cat "$HOME/.ssh/id_ed25519.pub" | pbcopy
  echo ""
  echo "  📋 $MSG_SSH_COPIED"
  echo "  $MSG_SSH_GITHUB_URL"
  echo ""
  read -p "  $MSG_SSH_ENTER "
  done_msg
else
  skip_msg
fi

# --- 6. macOS developer settings ---
step "$MSG_STEP_MACOS_SETTINGS"
if ask_yn "$MSG_MACOS_APPLY"; then
  echo ""
  if ask_yn "$MSG_MACOS_HIDDEN"; then
    defaults write com.apple.finder AppleShowAllFiles -bool true
    echo "    $MSG_APPLIED"
  fi
  if ask_yn "$MSG_MACOS_KEYBOARD"; then
    defaults write NSGlobalDomain KeyRepeat -int 2
    defaults write NSGlobalDomain InitialKeyRepeat -int 15
    defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
    echo "    $MSG_APPLIED"
  fi
  if ask_yn "$MSG_MACOS_SCREENSHOT"; then
    mkdir -p "$HOME/Screenshots"
    defaults write com.apple.screencapture location "$HOME/Screenshots"
    echo "    $MSG_APPLIED"
  fi
  killall Finder 2>/dev/null || true
  done_msg
else
  skip_msg
fi

# --- 7. Terminal settings ---
step "$MSG_STEP_TERMINAL"
select_menu "$MSG_TERMINAL_OPT1" "$MSG_TERMINAL_OPT2" "$MSG_TERMINAL_OPT3" "$MSG_TERMINAL_OPT4"

case "$MENU_RESULT" in
  0)
    open "$SCRIPT_DIR/configs/mac/Dev.terminal"
    sleep 1
    defaults write com.apple.Terminal "Default Window Settings" -string "Dev"
    defaults write com.apple.Terminal "Startup Window Settings" -string "Dev"
    echo "  $MSG_TERMINAL_APPLIED"
    done_msg
    ;;
  1)
    if [ -d "/Applications/iTerm.app" ]; then
      echo "  iTerm2: $MSG_ALREADY_INSTALLED"
    else
      brew install --cask iterm2
    fi
    open -a iTerm 2>/dev/null || true
    done_msg
    ;;
  2)
    open "$SCRIPT_DIR/configs/mac/Dev.terminal"
    sleep 1
    defaults write com.apple.Terminal "Default Window Settings" -string "Dev"
    defaults write com.apple.Terminal "Startup Window Settings" -string "Dev"
    echo "  $MSG_TERMINAL_APPLIED"
    if [ -d "/Applications/iTerm.app" ]; then
      echo "  iTerm2: $MSG_ALREADY_INSTALLED"
    else
      brew install --cask iterm2
    fi
    open -a iTerm 2>/dev/null || true
    done_msg
    ;;
  3)
    skip_msg
    ;;
  *)
    skip_msg
    ;;
esac

# --- 8. Oh My Zsh ---
step "$MSG_STEP_OHMYZSH"
if [ -d "$HOME/.oh-my-zsh" ]; then
  echo "  $MSG_ALREADY_INSTALLED"
  done_msg
elif ask_yn "$MSG_OHMYZSH_INSTALL"; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  done_msg
else
  skip_msg
fi

# zshrc
if [ -f "$HOME/.zshrc" ] && grep -q "# === ai-dev-setup ===" "$HOME/.zshrc"; then
  echo "  .zshrc: $MSG_ALREADY_INSTALLED"
elif ask_yn "$MSG_ZSHRC_ASK"; then
  if [ -f "$HOME/.zshrc" ]; then
    echo "" >> "$HOME/.zshrc"
    echo "# === ai-dev-setup ===" >> "$HOME/.zshrc"
    cat "$SCRIPT_DIR/configs/shared/.zshrc" >> "$HOME/.zshrc"
  else
    cp "$SCRIPT_DIR/configs/shared/.zshrc" "$HOME/.zshrc"
  fi
  echo "  $MSG_ZSHRC_DONE"
fi

# tmux
if ask_yn "$MSG_TMUX_ASK"; then
  if [ -f "$HOME/.tmux.conf" ]; then
    cp "$HOME/.tmux.conf" "$HOME/.tmux.conf.backup"
  fi
  cp "$SCRIPT_DIR/configs/shared/.tmux.conf" "$HOME/.tmux.conf"
  echo "  $MSG_TMUX_DONE"
fi

# --- 9. AI Coding Tools ---
step "$MSG_STEP_AI_TOOLS"
echo "  $MSG_AI_TOOLS_HINT"
echo ""
MULTI_DEFAULTS="0" select_multi "Claude Code" "Gemini CLI" "GitHub Copilot CLI"

INSTALLED_CLAUDE=false
for idx in "${MULTI_RESULT[@]}"; do
  case "$idx" in
    0) # Claude Code
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
      if command -v gemini &>/dev/null; then
        echo "  Gemini CLI: $MSG_ALREADY_INSTALLED"
      else
        echo "  $MSG_INSTALLING Gemini CLI..."
        npm install -g @google/gemini-cli || echo "  ⚠️  Installation failed."
      fi
      ;;
    2) # GitHub Copilot CLI
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
echo -e "✨ ${color_green}$MSG_SETUP_COMPLETE${color_reset}"
echo ""
echo "  $MSG_OPEN_NEW_TERMINAL"
echo ""
echo "  💡 $MSG_CLAUDE_EXTRA_SETUP"
echo "     ~/claude-code-setup/setup-claude.sh"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
