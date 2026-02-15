#!/bin/bash
# Module: homebrew.sh
# Description: Homebrew installation and verification
# Dependencies: colors.sh, core.sh, ui.sh
# Usage: Source this file after dependencies, then call install_homebrew

# Install Homebrew package manager
# Returns: Exits script (exit 1) if installation fails
install_homebrew() {
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
}
