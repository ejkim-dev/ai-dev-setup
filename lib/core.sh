#!/bin/bash
# Module: core.sh
# Description: Core utilities and global variables
# Dependencies: colors.sh
# Usage: Source this file after colors.sh

# Step counter
STEP=0
TOTAL=7

# Utility: Display step header
step() {
  STEP=$((STEP + 1))
  echo ""
  echo -e "${color_cyan}[$STEP/$TOTAL] $1${color_reset}"
}

# Utility: Display success message
done_msg() {
  echo -e "  ${color_green}✅ $MSG_DONE${color_reset}"
}

# Utility: Display skip message
skip_msg() {
  echo -e "  ${color_yellow}⏭  $MSG_SKIP${color_reset}"
}

# DEPRECATED: ask_yn() - Use select_menu instead
# This function is removed as part of UI consistency improvement
# Use: select_menu "Yes" "No" and check MENU_RESULT

# Utility: Expand ~ to $HOME
expand_path() {
  local path="$1"
  echo "${path/#\~/$HOME}"
}
