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

# Source libraries (order matters!)
source "$SCRIPT_DIR/lib/colors.sh"
source "$SCRIPT_DIR/lib/core.sh"
source "$SCRIPT_DIR/lib/ui.sh"
source "$SCRIPT_DIR/lib/installer.sh"

# Source modules
source "$SCRIPT_DIR/modules/xcode.sh"
source "$SCRIPT_DIR/modules/homebrew.sh"
source "$SCRIPT_DIR/modules/packages.sh"
source "$SCRIPT_DIR/modules/terminal.sh"
source "$SCRIPT_DIR/modules/shell.sh"
source "$SCRIPT_DIR/modules/tmux.sh"
source "$SCRIPT_DIR/modules/ai-tools.sh"

# === Language selection ===
echo ""
echo -e "🔧 ${color_cyan}ai-dev-setup${color_reset}"
echo ""
echo "  Select your language:"
echo ""
select_menu "English" "한국어" "日本語"

case "$MENU_RESULT" in
  0) USER_LANG="en" ;;
  1) USER_LANG="ko" ;;
  2) USER_LANG="ja" ;;
esac

# Create Phase 2 directory early to save language setting
CLAUDE_CODE_DIR="$HOME/claude-code-setup"
mkdir -p "$CLAUDE_CODE_DIR"

# Save language selection for Phase 2 (Claude Code setup)
echo "$USER_LANG" > "$CLAUDE_CODE_DIR/.dev-setup-lang"

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
install_xcode_tools

# --- 2. Homebrew ---
install_homebrew

# --- 3. Packages ---
install_essential_packages

# --- 4. Terminal App ---
step "$MSG_STEP_TERMINAL_APP"
SELECTED_FONT="d2coding"
setup_terminal "$SELECTED_FONT"
TERMINAL_MENU_CHOICE=$MENU_RESULT
done_msg

# Terminal theme verification guide
if [ "$TERMINAL_MENU_CHOICE" -ne 3 ]; then
  echo ""
  echo "${color_cyan}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${color_reset}"
  echo "${color_bold_cyan}📋 $MSG_TERMINAL_VERIFY_HEADER${color_reset}"
  echo "${color_cyan}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${color_reset}"
  echo ""
  echo "  💡 $MSG_TERMINAL_VERIFY_DESC"
  echo ""
  echo "  $MSG_TERMINAL_MANUAL_SETUP"
  echo ""

  if [ "$TERMINAL_MENU_CHOICE" -eq 0 ] || [ "$TERMINAL_MENU_CHOICE" -eq 2 ]; then
    echo "  ${color_yellow}Terminal.app:${color_reset}"
    echo "     $MSG_TERMINAL_MANUAL_TERMINAL"
    echo ""
  fi

  if [ "$TERMINAL_MENU_CHOICE" -eq 1 ] || [ "$TERMINAL_MENU_CHOICE" -eq 2 ]; then
    echo "  ${color_yellow}iTerm2:${color_reset}"
    echo "     $MSG_TERMINAL_MANUAL_ITERM2"
    echo ""
  fi

  echo "${color_cyan}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${color_reset}"
  echo ""
fi

# --- 5. Shell Setup ---
step "$MSG_STEP_SHELL"
setup_shell
done_msg

# --- 6. tmux ---
step "$MSG_STEP_TMUX"
setup_tmux
done_msg

# --- 7. AI Coding Tools ---
install_ai_tools

# === Cleanup ===
# Copy claude-code/ for later setup, then remove entire install directory
# This handles both ZIP download (install.sh) and git clone cases cleanly
# Note: $CLAUDE_CODE_DIR already exists (created during language selection)
if [ -d "$SCRIPT_DIR/claude-code" ]; then
  cp "$SCRIPT_DIR/claude-code/setup-claude.sh" "$CLAUDE_CODE_DIR/"
  cp "$SCRIPT_DIR/claude-code/README.md" "$CLAUDE_CODE_DIR/" 2>/dev/null || true
  cp -r "$SCRIPT_DIR/claude-code/agents" "$CLAUDE_CODE_DIR/"
  cp -r "$SCRIPT_DIR/claude-code/templates" "$CLAUDE_CODE_DIR/"
  cp -r "$SCRIPT_DIR/claude-code/examples" "$CLAUDE_CODE_DIR/"
  cp -r "$SCRIPT_DIR/claude-code/locale" "$CLAUDE_CODE_DIR/"
  chmod +x "$CLAUDE_CODE_DIR/setup-claude.sh"

  # Verify critical Phase 2 files were copied successfully
  if [ ! -f "$CLAUDE_CODE_DIR/setup-claude.sh" ] || \
     [ ! -d "$CLAUDE_CODE_DIR/agents" ] || \
     [ ! -d "$CLAUDE_CODE_DIR/templates" ] || \
     [ ! -d "$CLAUDE_CODE_DIR/locale" ]; then
    echo ""
    echo "❌ Failed to copy Phase 2 files to ~/claude-code-setup/"
    echo "   Please check disk space and permissions."
    echo "   Installation directory preserved: $SCRIPT_DIR"
    echo ""
    exit 1
  fi
fi

# Safety check: Prevent accidental deletion of critical directories
if [[ -z "$SCRIPT_DIR" ]] || \
   [[ "$SCRIPT_DIR" == "/" ]] || \
   [[ "$SCRIPT_DIR" == "$HOME" ]] || \
   [[ "$SCRIPT_DIR" == "/Users" ]] || \
   [[ "$SCRIPT_DIR" == "/System" ]]; then
  echo ""
  echo "❌ Safety check failed: Invalid directory for deletion: '$SCRIPT_DIR'"
  echo "   This should never happen. Please report this issue."
  echo "   Installation directory preserved for safety."
  echo ""
  exit 1
fi

# Remove entire install directory (including .git if cloned)
cd "$HOME"
rm -rf "$SCRIPT_DIR"

# === Done ===
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "✨ ${color_green}$MSG_PHASE1_COMPLETE${color_reset}"
echo ""
echo "  $MSG_PHASE2_NEXT"
echo ""
echo "  $MSG_PHASE2_DESC_1"
echo "  $MSG_PHASE2_DESC_2"
echo "  $MSG_PHASE2_DESC_3"
echo "  $MSG_PHASE2_DESC_4"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

echo "  $MSG_PHASE2_RESTART_WARN"
echo "$MSG_PHASE2_RESTART_REASON"
echo ""

echo "$MSG_PHASE2_OPEN_TERM_ASK"
select_menu "$MSG_PHASE2_OPEN_OPT_YES" "$MSG_PHASE2_OPEN_OPT_NO"

if [ "$MENU_RESULT" -eq 0 ]; then
  echo ""
  echo "  $MSG_PHASE2_OPENING"
  echo ""

  # Open new terminal with setup-claude.sh (use Dev profile if available)
  osascript <<EOF
tell application "Terminal"
    activate
    do script "cd ~ && ~/claude-code-setup/setup-claude.sh"
    try
        set current settings of selected tab of front window to settings set "Dev"
    end try
end tell
EOF

  echo "  $MSG_PHASE2_OPENED"
  echo "  $MSG_PHASE2_CLOSE_INFO"
else
  echo ""
  echo "  $MSG_PHASE2_MANUAL_LATER"
  echo "     ~/claude-code-setup/setup-claude.sh"
fi

echo ""
