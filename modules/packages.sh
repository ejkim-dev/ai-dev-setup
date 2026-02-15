#!/bin/bash
# Module: packages.sh
# Description: Essential packages installation (Node.js, ripgrep, etc.)
# Dependencies: colors.sh, core.sh, ui.sh, installer.sh
# Usage: Source this file after dependencies, then call install_essential_packages

# Install essential packages via Brewfile
# Returns: Exits script (exit 1) if Node.js installation fails
install_essential_packages() {
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
}
