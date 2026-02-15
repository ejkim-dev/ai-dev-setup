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
TOTAL=5

# === Utilities ===
color_green="\033[0;32m"
color_yellow="\033[0;33m"
color_cyan="\033[0;36m"
color_gray="\033[0;90m"
color_bold="\033[1m"
color_bold_cyan="\033[1;36m"
color_bold_gray="\033[1;90m"
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
      echo -e "  ${color_bold_cyan}▸ ${options[$i]}${color_reset}"
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
      ''|$'\n'|$'\r')
        break
        ;;
    esac

    tput cuu "$count" 2>/dev/null
    for i in "${!options[@]}"; do
      tput el 2>/dev/null
      if [ "$i" -eq $selected ]; then
        echo -e "  ${color_bold_cyan}▸ ${options[$i]}${color_reset}"
      else
        echo -e "    ${options[$i]}"
      fi
    done
  done

  tput cnorm 2>/dev/null
  MENU_RESULT=$selected
}

# Import Terminal.app profile using PlistBuddy
# Usage: import_terminal_profile "/path/to/profile.terminal"
# Returns: 0 on success, 1 on failure
import_terminal_profile() {
  local dev_terminal="$1"
  local terminal_plist="$HOME/Library/Preferences/com.apple.Terminal.plist"

  # Backup
  cp "$terminal_plist" "${terminal_plist}.backup" 2>/dev/null || true

  # Convert to XML (PlistBuddy can read binary but safer to convert)
  plutil -convert xml1 "$terminal_plist" 2>/dev/null || true

  # Ensure Window Settings dictionary exists
  if ! /usr/libexec/PlistBuddy -c "Print :Window\ Settings" "$terminal_plist" >/dev/null 2>&1; then
    /usr/libexec/PlistBuddy -c "Add :Window\ Settings dict" "$terminal_plist" 2>/dev/null || true
  fi

  # Delete existing Dev profile if any
  /usr/libexec/PlistBuddy -c "Delete :Window\ Settings:Dev" "$terminal_plist" 2>/dev/null || true

  # Convert Dev.terminal to XML
  local temp_dev="/tmp/dev-profile-$$.xml"
  plutil -convert xml1 "$dev_terminal" -o "$temp_dev" 2>/dev/null

  if [ ! -f "$temp_dev" ]; then
    rm -f "$temp_dev"
    return 1
  fi

  # Add Dev profile and merge
  /usr/libexec/PlistBuddy -c "Add :Window\ Settings:Dev dict" "$terminal_plist" 2>/dev/null
  /usr/libexec/PlistBuddy -c "Merge $temp_dev :Window\ Settings:Dev" "$terminal_plist" 2>/dev/null

  # Set as default profile
  /usr/libexec/PlistBuddy -c "Set :Default\ Window\ Settings Dev" "$terminal_plist" 2>/dev/null || \
    /usr/libexec/PlistBuddy -c "Add :Default\ Window\ Settings string Dev" "$terminal_plist" 2>/dev/null

  /usr/libexec/PlistBuddy -c "Set :Startup\ Window\ Settings Dev" "$terminal_plist" 2>/dev/null || \
    /usr/libexec/PlistBuddy -c "Add :Startup\ Window\ Settings string Dev" "$terminal_plist" 2>/dev/null

  # Convert back to binary
  plutil -convert binary1 "$terminal_plist" 2>/dev/null

  # Restart cfprefsd to reload preferences
  killall cfprefsd 2>/dev/null || true

  # Force sync settings (reads plist and updates cache)
  defaults read com.apple.Terminal >/dev/null 2>&1

  # Cleanup
  rm -f "$temp_dev"

  # Verify: Check both profile exists AND is set as default
  sleep 2
  if /usr/libexec/PlistBuddy -c "Print :Window\ Settings:Dev" "$terminal_plist" >/dev/null 2>&1 && \
     defaults read com.apple.Terminal "Default Window Settings" 2>/dev/null | grep -q "Dev"; then
    return 0
  else
    return 1
  fi
}

# Install iTerm2 and apply Dev profile
# Returns: 0 on success, 1 on failure
install_and_setup_iterm2() {
  local profile_json="$1"
  local profile_dir="$HOME/Library/Application Support/iTerm2/DynamicProfiles"
  local profile_file="$profile_dir/iterm2-dev-profile.json"

  # Check if already installed
  if [ -d "/Applications/iTerm.app" ]; then
    echo "  iTerm2: $MSG_ALREADY_INSTALLED"
  else
    # Install iTerm2
    if brew install --cask iterm2; then
      sleep 2  # Wait for installation to complete
      if [ -d "/Applications/iTerm.app" ]; then
        echo "  ✅ $MSG_ITERM2_INSTALLED"
      else
        echo "  ⚠️  Installation succeeded but app not found in /Applications/"
        echo "      Check: brew --prefix --cask iterm2"
        return 1
      fi
    else
      echo "  ❌ $MSG_ITERM2_INSTALL_FAILED"
      echo "      Try: brew install --cask iterm2"
      return 1
    fi
  fi

  # Apply Dev profile (only if iTerm2 exists)
  if [ -d "/Applications/iTerm.app" ]; then
    mkdir -p "$profile_dir"

    if cp "$profile_json" "$profile_file"; then
      # Verify file was copied
      if [ -f "$profile_file" ]; then
        echo "  ✅ $MSG_ITERM2_PROFILE_APPLIED"
        echo "  💡 $MSG_ITERM2_PROFILE_HINT"
        return 0
      else
        echo "  ⚠️  Profile file copy failed"
        return 1
      fi
    else
      echo "  ⚠️  Failed to copy profile file"
      return 1
    fi
  else
    echo "  ⚠️  iTerm2 not found, skipping profile setup"
    return 1
  fi
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

# Save language selection for Phase 2 (Claude Code setup)
echo "$USER_LANG" > "$HOME/.dev-setup-lang"

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
    echo "❌ $MSG_NODE_INSTALL_FAILED"
    echo ""
    echo "$MSG_NODE_REQUIRED"
    echo ""
    echo "$MSG_NODE_MANUAL_INSTALL"
    echo "  $MSG_NPM_INSTALL_CMD"
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

# --- 4. Terminal + Shell Setup ---
step "$MSG_STEP_TERMINAL"
select_menu "$MSG_TERMINAL_OPT1" "$MSG_TERMINAL_OPT2" "$MSG_TERMINAL_OPT3" "$MSG_TERMINAL_OPT4"

case "$MENU_RESULT" in
  0)
    # Terminal.app - import Dev theme and set as default
    if import_terminal_profile "$SCRIPT_DIR/configs/mac/Dev.terminal"; then
      echo "  ✅ $MSG_TERMINAL_APPLIED"
      echo "  💡 $MSG_TERMINAL_RESTART_HINT"
    else
      echo "  ⚠️  Terminal profile import failed"
      echo "  📋 Please import manually:"
      echo "     Terminal > Settings (⌘,) > Profiles > Import..."
      echo "     Select: $SCRIPT_DIR/configs/mac/Dev.terminal"
    fi
    ;;
  1)
    # iTerm2 only
    install_and_setup_iterm2 "$SCRIPT_DIR/configs/mac/iterm2-dev-profile.json"
    ;;
  2)
    # Both
    if import_terminal_profile "$SCRIPT_DIR/configs/mac/Dev.terminal"; then
      echo "  ✅ Terminal.app: $MSG_TERMINAL_APPLIED"
    else
      echo "  ⚠️  Terminal.app: Profile import failed"
      echo "  📋 Please import manually: Terminal > Settings > Profiles > Import"
    fi

    install_and_setup_iterm2 "$SCRIPT_DIR/configs/mac/iterm2-dev-profile.json"
    ;;
  3)
    skip_msg
    ;;
  *)
    skip_msg
    ;;
esac

# Fonts (independent of terminal choice)
echo ""
echo "$MSG_FONT_ASK"
echo "  $MSG_FONT_HINT"
echo ""
MULTI_DEFAULTS="" DISABLED_ITEMS="" select_multi "$MSG_FONT_OPT1" "$MSG_FONT_OPT2"

if [ ${#MULTI_RESULT[@]} -gt 0 ]; then
  echo ""
  echo "  $MSG_FONT_INSTALLING"
  for idx in "${MULTI_RESULT[@]}"; do
    case "$idx" in
      0)
        # D2Coding
        if brew install font-d2coding 2>/dev/null; then
          echo "  ✅ D2Coding"
        else
          echo "  ⚠️  D2Coding installation failed"
        fi
        ;;
      1)
        # D2Coding Nerd Font
        if brew install font-d2coding-nerd-font 2>/dev/null; then
          echo "  ✅ D2Coding Nerd Font"
        else
          echo "  ⚠️  D2Coding Nerd Font installation failed"
        fi
        ;;
    esac
  done
  echo "  $MSG_FONT_DONE"
else
  echo "  $MSG_FONT_SKIP"
fi

# Oh My Zsh (independent of terminal choice)
echo ""
OMZ_INSTALLED=false
if [ -d "$HOME/.oh-my-zsh" ]; then
  echo "  Oh My Zsh: $MSG_ALREADY_INSTALLED"
  OMZ_INSTALLED=true
else
  echo "  💡 $MSG_OHMYZSH_DESC"
  echo ""
  if ask_yn "$MSG_OHMYZSH_INSTALL"; then
    if sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended; then
      OMZ_INSTALLED=true
    else
      echo "  ⚠️  Oh My Zsh installation failed."
      echo "     $MSG_OHMYZSH_INSTALL_HINT"
      echo "     $MSG_OHMYZSH_INSTALL_CMD"
    fi
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
  RAND_EMOJI_N=$(( $RANDOM % ${#emojis[@]} ))
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
    else
      echo "  $MSG_ZSHRC_SKIP"
    fi
  fi

# tmux
echo ""
echo "  💡 $MSG_TMUX_DESC"
echo ""
if ask_yn "$MSG_TMUX_ASK"; then
  if [ -f "$HOME/.tmux.conf" ]; then
    cp "$HOME/.tmux.conf" "$HOME/.tmux.conf.backup"
  fi
  cp "$SCRIPT_DIR/configs/shared/.tmux.conf" "$HOME/.tmux.conf"
  echo "  $MSG_TMUX_DONE"
else
  echo "  $MSG_TMUX_SKIP"
fi

done_msg

# Terminal theme verification guide
if [ "$MENU_RESULT" -ne 3 ]; then
  echo ""
  echo "${color_cyan}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${color_reset}"
  echo "${color_bold_cyan}📋 $MSG_TERMINAL_VERIFY_HEADER${color_reset}"
  echo "${color_cyan}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${color_reset}"
  echo ""
  echo "  💡 $MSG_TERMINAL_VERIFY_DESC"
  echo ""
  echo "  $MSG_TERMINAL_MANUAL_SETUP"
  echo ""

  # Show relevant manual setup instructions
  if [ "$MENU_RESULT" -eq 0 ] || [ "$MENU_RESULT" -eq 2 ]; then
    echo "  ${color_yellow}Terminal.app:${color_reset}"
    echo "     $MSG_TERMINAL_MANUAL_TERMINAL"
    echo ""
  fi

  if [ "$MENU_RESULT" -eq 1 ] || [ "$MENU_RESULT" -eq 2 ]; then
    echo "  ${color_yellow}iTerm2:${color_reset}"
    echo "     $MSG_TERMINAL_MANUAL_ITERM2"
    echo ""
  fi

  echo "${color_cyan}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${color_reset}"
  echo ""
fi

# --- 5. AI Coding Tools ---
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
        echo "  ❌ Claude Code $MSG_AI_TOOL_NEEDS_NPM"
        echo "     $MSG_NPM_NOT_FOUND_INSTALL"
        echo "     $MSG_NPM_INSTALL_CMD"
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
        echo "  ❌ Gemini CLI $MSG_AI_TOOL_NEEDS_NPM"
        echo "     $MSG_NPM_NOT_FOUND_INSTALL"
        echo "     $MSG_NPM_INSTALL_CMD"
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
        echo "  ❌ Codex CLI $MSG_AI_TOOL_NEEDS_NPM"
        echo "     $MSG_NPM_NOT_FOUND_INSTALL"
        echo "     $MSG_NPM_INSTALL_CMD"
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
        echo "  ❌ GitHub Copilot CLI $MSG_AI_TOOL_NEEDS_GH"
        echo "     $MSG_GH_NOT_FOUND_INSTALL"
        echo "     $MSG_GH_INSTALL_CMD"
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
