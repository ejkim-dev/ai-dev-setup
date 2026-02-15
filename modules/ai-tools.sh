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
}
