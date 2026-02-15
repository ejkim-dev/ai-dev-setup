#!/bin/bash
# Module: fonts.sh
# Description: Font installation (D2Coding, D2Coding Nerd Font)
# Dependencies: colors.sh, core.sh, ui.sh, installer.sh
# Usage: Source this file after dependencies, then call install_fonts
# Returns: Sets SELECTED_FONT variable (d2coding|nerd|none)

# Install coding fonts
# Sets: SELECTED_FONT variable for terminal configuration
install_fonts() {
  echo ""
  echo "$MSG_FONT_ASK"
  echo "  $MSG_FONT_HINT"
  echo ""
  MULTI_DEFAULTS="0" DISABLED_ITEMS="" select_multi "$MSG_FONT_OPT1" "$MSG_FONT_OPT_SKIP"

  SELECTED_FONT="none"
  if [ ${#MULTI_RESULT[@]} -gt 0 ]; then
    echo ""
    for idx in "${MULTI_RESULT[@]}"; do
      case "$idx" in
        0)
          # D2Coding
          run_with_spinner "Installing D2Coding..." "brew install font-d2coding"
          local result=$?

          if [ $result -eq 0 ]; then
            echo "  ✅ D2Coding"
            SELECTED_FONT="d2coding"
          else
            echo "  ⚠️  D2Coding installation failed"
            echo "     Try manually: brew install font-d2coding"
          fi
          ;;
        1)
          # Skip
          echo "  $MSG_FONT_SKIP"
          ;;
      esac
    done
  else
    echo "  $MSG_FONT_SKIP"
  fi
}
