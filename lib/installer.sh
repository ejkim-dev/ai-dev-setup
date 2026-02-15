#!/bin/bash
# Module: installer.sh
# Description: Package installation wrappers
# Dependencies: colors.sh, ui.sh
# Usage: Source this file after colors.sh and ui.sh

# Install Homebrew package
# Usage: install_brew_package "package-name" "Display Name"
# Returns: 0 on success, 1 on failure
install_brew_package() {
  local package="$1"
  local display_name="${2:-$package}"

  if brew list "$package" &>/dev/null; then
    echo "  $display_name: $MSG_ALREADY_INSTALLED"
    return 0
  fi

  set +e  # Temporarily disable exit on error
  run_with_spinner "$MSG_INSTALLING $display_name..." "brew install $package"
  local result=$?
  set -e  # Re-enable exit on error

  if [ $result -eq 0 ]; then
    echo "  ✅ $display_name"
    return 0
  else
    echo "  ❌ $display_name installation failed"
    return 1
  fi
}

# Install Homebrew cask
# Usage: install_brew_cask "cask-name" "Display Name"
# Returns: 0 on success, 1 on failure
install_brew_cask() {
  local cask="$1"
  local display_name="${2:-$cask}"

  if brew list --cask "$cask" &>/dev/null; then
    echo "  $display_name: $MSG_ALREADY_INSTALLED"
    return 0
  fi

  set +e  # Temporarily disable exit on error
  run_with_spinner "$MSG_INSTALLING $display_name..." "brew install --cask $cask"
  local result=$?
  set -e  # Re-enable exit on error

  if [ $result -eq 0 ]; then
    echo "  ✅ $display_name"
    return 0
  else
    echo "  ❌ $display_name installation failed"
    return 1
  fi
}

# Install npm package globally
# Usage: install_npm_global "package-name" "Display Name"
# Returns: 0 on success, 1 on failure
install_npm_global() {
  local package="$1"
  local display_name="${2:-$package}"

  if npm list -g "$package" &>/dev/null; then
    echo "  $display_name: $MSG_ALREADY_INSTALLED"
    return 0
  fi

  set +e  # Temporarily disable exit on error
  run_with_spinner "$MSG_INSTALLING $display_name..." "npm install -g $package"
  local result=$?
  set -e  # Re-enable exit on error

  if [ $result -eq 0 ]; then
    echo "  ✅ $display_name"
    return 0
  else
    echo "  ❌ $display_name installation failed"
    return 1
  fi
}

# Check if command is installed
# Usage: check_installed "command-name"
# Returns: 0 if installed, 1 if not
check_installed() {
  local cmd="$1"
  command -v "$cmd" &>/dev/null
}
