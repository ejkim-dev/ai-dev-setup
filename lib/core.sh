#!/bin/bash
# Module: core.sh
# Description: Core utilities and global variables
# Dependencies: colors.sh
# Usage: Source this file after colors.sh

# Step counter
STEP=0
TOTAL=5

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

# Utility: Ask Y/n question
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

# Utility: Expand ~ to $HOME
expand_path() {
  local path="$1"
  echo "${path/#\~/$HOME}"
}
