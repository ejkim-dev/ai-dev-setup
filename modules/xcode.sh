#!/bin/bash
# Module: xcode.sh
# Description: Xcode Command Line Tools installation
# Dependencies: colors.sh, core.sh, ui.sh
# Usage: Source this file after dependencies, then call install_xcode_tools

# Install Xcode Command Line Tools
# Returns: Always returns 0 (user must confirm installation manually)
install_xcode_tools() {
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
}
