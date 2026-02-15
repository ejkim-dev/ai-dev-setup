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

echo "Continue to Phase 2 now?"
select_menu "Yes, continue" "No, skip for now"

if [ "$MENU_RESULT" -eq 0 ]; then
  echo ""
  echo "  ⚠️  Terminal restart required for Phase 2"
  echo "     (to load updated PATH and shell config)"
  echo ""

  echo "Open new terminal and start Phase 2?"
  select_menu "Yes, open new terminal" "No, I'll run it manually later"

  if [ "$MENU_RESULT" -eq 0 ]; then
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
