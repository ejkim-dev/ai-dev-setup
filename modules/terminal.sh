#!/bin/bash
# Module: terminal.sh
# Description: Terminal.app and iTerm2 configuration
# Dependencies: colors.sh, core.sh, ui.sh, installer.sh
# Usage: Source this file after dependencies, then call setup_terminal

# Import Terminal.app profile using open + defaults
# Usage: import_terminal_profile "/path/to/profile.terminal"
# Returns: 0 on success, 1 on failure
#
# Implementation note:
# - Uses 'open' command to import profile (immediate reflection)
# - Uses 'defaults write' to set as default (applied after restart)
# - Does NOT quit Terminal.app (user can see installation progress)
# - See .claude/notes/terminal-profile-installation-investigation.md for details
import_terminal_profile() {
  local dev_terminal="$1"

  # Import profile using open
  if ! open "$dev_terminal" 2>/dev/null; then
    return 1
  fi

  sleep 2

  # Set as default profile
  defaults write com.apple.Terminal "Default Window Settings" -string "Dev" 2>/dev/null || return 1
  defaults write com.apple.Terminal "Startup Window Settings" -string "Dev" 2>/dev/null || return 1

  # Verify
  if defaults read com.apple.Terminal "Default Window Settings" 2>/dev/null | grep -q "Dev"; then
    return 0
  else
    return 1
  fi
}

# Install iTerm2 and apply Dev profile
# Usage: install_and_setup_iterm2 <profile_json>
# Returns: 0 on success, 1 on failure
install_and_setup_iterm2() {
  local profile_json="$1"
  local profile_dir="$HOME/Library/Application Support/iTerm2/DynamicProfiles"
  local profile_file="$profile_dir/iterm2-dev-profile.json"

  # Check if already installed
  if [ -d "/Applications/iTerm.app" ]; then
    echo "  iTerm2: $MSG_ALREADY_INSTALLED"
  else
    # Install iTerm2
    if brew install --cask iterm2; then
      sleep 2  # Wait for installation to complete
      if [ -d "/Applications/iTerm.app" ]; then
        echo "  ✅ $MSG_ITERM2_INSTALLED"
      else
        echo "  ⚠️  Installation succeeded but app not found in /Applications/"
        echo "      Check: brew --prefix --cask iterm2"
        return 1
      fi
    else
      echo "  ❌ $MSG_ITERM2_INSTALL_FAILED"
      echo "      Try: brew install --cask iterm2"
      return 1
    fi
  fi

  # Apply Dev profile (only if iTerm2 exists)
  if [ -d "/Applications/iTerm.app" ]; then
    mkdir -p "$profile_dir"

    if cp "$profile_json" "$profile_file"; then
      # Verify file was copied
      if [ -f "$profile_file" ]; then
        echo "  ✅ $MSG_ITERM2_PROFILE_APPLIED"
        echo "  💡 $MSG_ITERM2_PROFILE_HINT"
        return 0
      else
        echo "  ⚠️  Profile file copy failed"
        return 1
      fi
    else
      echo "  ⚠️  Failed to copy profile file"
      return 1
    fi
  else
    echo "  ⚠️  iTerm2 not found, skipping profile setup"
    return 1
  fi
}

# Set up terminal applications (Terminal.app and/or iTerm2)
# Note: D2Coding font should be installed in Step 3 (packages)
setup_terminal() {
  local font_name="${1:-d2coding}"

  # Check if font is installed (use brew instead of filesystem check for reliability)
  local font_installed=0
  if command -v brew &>/dev/null && brew list --cask font-d2coding &>/dev/null; then
    font_installed=1
  fi

  if [ $font_installed -eq 0 ]; then
    echo ""
    echo "  ⚠️  $MSG_FONT_NOT_INSTALLED"
    echo "  💡 $MSG_FONT_REQUIRED"
    echo ""
    echo "$MSG_FONT_INSTALL_ASK"
    select_menu "$MSG_FONT_INSTALL_OPT" "$MSG_FONT_SKIP_OPT"

    if [ "$MENU_RESULT" -eq 0 ]; then
      if command -v brew &>/dev/null; then
        echo ""
        run_with_spinner "$MSG_INSTALLING D2Coding..." "brew install --cask font-d2coding"
        if [ $? -eq 0 ]; then
          echo "  ✅ $MSG_FONT_INSTALLED"
          font_installed=1
        else
          echo "  ❌ $MSG_FONT_INSTALL_FAILED"
          echo "     $MSG_FONT_MANUAL_INSTALL"
          return 1
        fi
      else
        echo "  ❌ $MSG_FONT_NO_BREW"
        return 1
      fi
    else
      echo "  ⏭️  $MSG_TERMINAL_THEME_SKIP"
      return 0
    fi
  fi

  echo ""
  select_menu "$MSG_TERMINAL_OPT1" "$MSG_TERMINAL_OPT2" "$MSG_TERMINAL_OPT3" "$MSG_TERMINAL_OPT4"

  case "$MENU_RESULT" in
    0)
      # Terminal.app - import Dev theme and set as default
      TERMINAL_FILE="$SCRIPT_DIR/configs/mac/Dev.terminal"

      if import_terminal_profile "$TERMINAL_FILE"; then
        echo "  ✅ $MSG_TERMINAL_APPLIED"
        echo "  💡 $MSG_TERMINAL_RESTART_HINT"
      else
        echo "  ⚠️  Terminal profile import failed"
        echo "  📋 Please import manually:"
        echo "     Terminal > Settings (⌘,) > Profiles > Import..."
        echo "     Select: $TERMINAL_FILE"
      fi
      ;;
    1)
      # iTerm2 only
      install_and_setup_iterm2 "$SCRIPT_DIR/configs/mac/iterm2-dev-profile.json"
      ;;
    2)
      # Both
      TERMINAL_FILE="$SCRIPT_DIR/configs/mac/Dev.terminal"

      if import_terminal_profile "$TERMINAL_FILE"; then
        echo "  ✅ Terminal.app: $MSG_TERMINAL_APPLIED"
      else
        echo "  ⚠️  Terminal.app: Profile import failed"
        echo "  📋 Please import manually: Terminal > Settings > Profiles > Import"
      fi

      install_and_setup_iterm2 "$SCRIPT_DIR/configs/mac/iterm2-dev-profile.json"
      ;;
    3)
      skip_msg
      ;;
    *)
      skip_msg
      ;;
  esac
}
