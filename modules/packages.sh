#!/bin/bash
# Module: packages.sh
# Description: Essential packages installation (Node.js, ripgrep, etc.)
# Dependencies: colors.sh, core.sh, ui.sh, installer.sh
# Usage: Source this file after dependencies, then call install_essential_packages

# Install essential packages with multi-select menu
# Returns: Exits script (exit 1) if Node.js installation fails
install_essential_packages() {
  step "$MSG_STEP_PACKAGES"
  if command -v brew &>/dev/null; then
    echo ""
    echo "  $MSG_PKG_SELECT_PROMPT"
    echo ""

    # Check installation status
    local node_installed=0
    local ripgrep_installed=0
    local font_installed=0
    local zsh_auto_installed=0
    local zsh_syntax_installed=0

    command -v node >/dev/null 2>&1 && node_installed=1
    command -v rg >/dev/null 2>&1 && ripgrep_installed=1
    if ls "$HOME/Library/Fonts/"*[Dd]2[Cc]oding*.ttc 2>/dev/null | grep -q . || \
       ls "/Library/Fonts/"*[Dd]2[Cc]oding*.ttc 2>/dev/null | grep -q .; then
      font_installed=1
    fi
    brew list zsh-autosuggestions >/dev/null 2>&1 && zsh_auto_installed=1
    brew list zsh-syntax-highlighting >/dev/null 2>&1 && zsh_syntax_installed=1

    # Build disabled items (required packages + already installed)
    local disabled="0"  # Node.js is always required
    [ $ripgrep_installed -eq 1 ] && disabled="$disabled 1"
    [ $font_installed -eq 1 ] && disabled="$disabled 2"
    [ $zsh_auto_installed -eq 1 ] && disabled="$disabled 3"
    [ $zsh_syntax_installed -eq 1 ] && disabled="$disabled 4"

    # Build option labels with status
    local opt_node="$MSG_PKG_NODE"
    local opt_ripgrep="$MSG_PKG_RIPGREP"
    local opt_font="$MSG_PKG_FONT"
    local opt_zsh_auto="$MSG_PKG_ZSH_AUTO"
    local opt_zsh_syntax="$MSG_PKG_ZSH_SYNTAX"

    [ $node_installed -eq 1 ] && opt_node="$opt_node - $MSG_ALREADY_INSTALLED" || opt_node="$opt_node ($MSG_REQUIRED)"
    [ $ripgrep_installed -eq 1 ] && opt_ripgrep="$opt_ripgrep - $MSG_ALREADY_INSTALLED"
    [ $font_installed -eq 1 ] && opt_font="$opt_font - $MSG_ALREADY_INSTALLED"
    [ $zsh_auto_installed -eq 1 ] && opt_zsh_auto="$opt_zsh_auto - $MSG_ALREADY_INSTALLED"
    [ $zsh_syntax_installed -eq 1 ] && opt_zsh_syntax="$opt_zsh_syntax - $MSG_ALREADY_INSTALLED"

    # Show multi-select menu (all checked by default)
    DISABLED_ITEMS="$disabled" MULTI_DEFAULTS="0 1 2 3 4" select_multi \
      "$opt_node" \
      "$opt_ripgrep" \
      "$opt_font" \
      "$opt_zsh_auto" \
      "$opt_zsh_syntax"

    # Install selected packages
    echo ""
    for i in "${MULTI_RESULT[@]}"; do
      case $i in
        0)
          if [ $node_installed -eq 0 ]; then
            install_brew_package "node" "Node.js" || {
              echo "  ⚠️  Node.js installation returned error, continuing..."
            }
          fi
          ;;
        1)
          if [ $ripgrep_installed -eq 0 ]; then
            install_brew_package "ripgrep" "ripgrep" || {
              echo "  ⚠️  ripgrep installation returned error, continuing..."
            }
          fi
          ;;
        2)
          if [ $font_installed -eq 0 ]; then
            install_brew_cask "font-d2coding" "D2Coding Font" || {
              echo "  ⚠️  font installation returned error, continuing..."
            }
          fi
          ;;
        3)
          if [ $zsh_auto_installed -eq 0 ]; then
            install_brew_package "zsh-autosuggestions" "zsh-autosuggestions" || {
              echo "  ⚠️  zsh-autosuggestions installation returned error, continuing..."
            }
          fi
          ;;
        4)
          if [ $zsh_syntax_installed -eq 0 ]; then
            install_brew_package "zsh-syntax-highlighting" "zsh-syntax-highlighting" || {
              echo "  ⚠️  zsh-syntax-highlighting installation returned error, continuing..."
            }
          fi
          ;;
      esac
    done

    echo ""
    echo "  [DEBUG] Verifying Node.js installation..."

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

    echo "  [DEBUG] Node.js verification passed: $(node --version)"

    done_msg
  else
    echo "  ⚠️  Homebrew not available. Skipping package installation."
    skip_msg
  fi
}
