#!/bin/bash
# Module: ai-tools.sh
# Description: AI CLI tools installation (Claude Code, Gemini CLI, etc.)
# Dependencies: colors.sh, core.sh, ui.sh, installer.sh
# Usage: Source this file after dependencies, then call install_ai_tools
# Returns: Sets INSTALLED_CLAUDE variable (true|false)

# Install AI coding tools
# Sets: INSTALLED_CLAUDE variable for Phase 2 transition
install_ai_tools() {
  step "$MSG_STEP_AI_TOOLS"
  echo ""

  # Show spinner while checking installation and updates
  check_ai_tools_status() {
    # Check installation status
    claude_installed=0
    gemini_installed=0
    codex_installed=0
    copilot_installed=0

    command -v claude >/dev/null 2>&1 && claude_installed=1
    command -v gemini >/dev/null 2>&1 && gemini_installed=1
    command -v codex >/dev/null 2>&1 && codex_installed=1
    gh extension list 2>/dev/null | grep -q "gh-copilot" && copilot_installed=1

    # Check for Claude Code updates (if installed)
    claude_update_available=0
    if [ $claude_installed -eq 1 ]; then
      # Use timeout to prevent hanging on network issues
      if timeout 5 npm outdated -g @anthropic-ai/claude-code 2>/dev/null | grep -q "@anthropic-ai/claude-code"; then
        claude_update_available=1
      fi
    fi
  }

  # Run checks with spinner
  run_with_spinner "$MSG_CHECKING_UPDATES" "check_ai_tools_status"

  echo "  $MSG_AI_TOOLS_HINT"
  echo ""

  # Build disabled items
  local disabled=""

  # Claude Code: disable only if installed AND no updates available
  if [ $claude_installed -eq 1 ] && [ $claude_update_available -eq 0 ]; then
    disabled="$disabled 0"
  fi

  # Other tools: disable if installed
  [ $gemini_installed -eq 1 ] && disabled="$disabled 1"
  [ $codex_installed -eq 1 ] && disabled="$disabled 2"

  # GitHub Copilot: disable if installed OR gh not available
  if [ $copilot_installed -eq 1 ] || ! command -v gh &>/dev/null; then
    disabled="$disabled 3"
  fi

  # Build option labels with status
  local opt_claude="Claude Code"
  local opt_gemini="Gemini CLI"
  local opt_codex="Codex CLI"
  local opt_copilot="GitHub Copilot CLI (requires gh)"

  if [ $claude_installed -eq 1 ]; then
    if [ $claude_update_available -eq 1 ]; then
      opt_claude="$opt_claude - $MSG_ALREADY_INSTALLED ($MSG_UPDATE_AVAILABLE)"
    else
      opt_claude="$opt_claude - $MSG_ALREADY_INSTALLED ($MSG_LATEST_VERSION)"
    fi
  fi

  [ $gemini_installed -eq 1 ] && opt_gemini="$opt_gemini - $MSG_ALREADY_INSTALLED"
  [ $codex_installed -eq 1 ] && opt_codex="$opt_codex - $MSG_ALREADY_INSTALLED"
  [ $copilot_installed -eq 1 ] && opt_copilot="$opt_copilot - $MSG_ALREADY_INSTALLED"

  # Show menu
  DISABLED_ITEMS="$disabled" MULTI_DEFAULTS="0" select_multi \
    "$opt_claude" \
    "$opt_gemini" \
    "$opt_codex" \
    "$opt_copilot"

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

        if [ $claude_installed -eq 0 ]; then
          # Not installed - install it
          echo "  $MSG_INSTALLING Claude Code..."
          npm install -g @anthropic-ai/claude-code || echo "  ⚠️  Installation failed."
        else
          # Already installed and user selected it - must be for update
          echo "  $MSG_UPDATING Claude Code..."
          npm update -g @anthropic-ai/claude-code || echo "  ⚠️  Update failed."
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

        # Only install if not already installed
        if [ $gemini_installed -eq 0 ]; then
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

        # Only install if not already installed
        if [ $codex_installed -eq 0 ]; then
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

        # Only install if not already installed
        if [ $copilot_installed -eq 0 ]; then
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
}
