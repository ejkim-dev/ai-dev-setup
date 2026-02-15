#!/bin/bash
# Module: shell.sh
# Description: Oh My Zsh and shell customization
# Dependencies: colors.sh, core.sh, ui.sh
# Usage: Source this file after dependencies, then call setup_shell
# Returns: Sets OMZ_INSTALLED variable (true|false)

# Set up Oh My Zsh and .zshrc customization
# Sets: OMZ_INSTALLED variable for other modules to check
setup_shell() {
  echo ""
  OMZ_INSTALLED=false
  if [ -d "$HOME/.oh-my-zsh" ]; then
    echo "  Oh My Zsh: $MSG_ALREADY_INSTALLED"
    OMZ_INSTALLED=true
  else
    echo "  💡 $MSG_OHMYZSH_DESC"
    echo ""
    echo "$MSG_OHMYZSH_ASK"
    echo ""
    select_menu "$MSG_OHMYZSH_OPT_INSTALL" "$MSG_OHMYZSH_OPT_SKIP"

    if [ "$MENU_RESULT" -eq 0 ]; then
      echo ""
      run_with_spinner "$MSG_OHMYZSH_INSTALLING" "sh -c \"\$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)\" \"\" --unattended"
      if [ $? -eq 0 ]; then
        echo "  ✅ $MSG_OHMYZSH_DONE"
        OMZ_INSTALLED=true
      else
        echo "  ⚠️  Oh My Zsh installation failed."
        echo "     $MSG_OHMYZSH_INSTALL_HINT"
        echo "     $MSG_OHMYZSH_INSTALL_CMD"
      fi
    else
      echo "  $MSG_OHMYZSH_SKIP"
    fi
  fi

  # zshrc customization
  if [ -f "$HOME/.zshrc" ] && grep -q "# === ai-dev-setup ===" "$HOME/.zshrc"; then
    echo "  .zshrc: $MSG_ALREADY_INSTALLED"
  else
    echo ""
    echo "  $MSG_ZSHRC_ASK"
    echo "  $MSG_ZSHRC_HINT"
    if [ "$OMZ_INSTALLED" = false ]; then
      echo ""
      echo "  ⚠️  $MSG_OHMYZSH_NOT_INSTALLED"
      echo "     $MSG_OHMYZSH_THEME_SKIP"
    fi
    echo ""
    MULTI_DEFAULTS="0 1" select_multi "$MSG_ZSHRC_OPT_THEME" "$MSG_ZSHRC_OPT_PLUGINS" "$MSG_ZSHRC_OPT_ALIAS"

    if [ ${#MULTI_RESULT[@]} -gt 0 ]; then
      # Prepare .zshrc
      if [ -f "$HOME/.zshrc" ]; then
        echo "" >> "$HOME/.zshrc"
        echo "# === ai-dev-setup ===" >> "$HOME/.zshrc"
      else
        # Create new .zshrc with basic settings
        cat > "$HOME/.zshrc" << 'EOF'
# === Basic Settings ===
export LANG=en_US.UTF-8
export EDITOR=vim

# === History ===
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS

# === ai-dev-setup ===
EOF
      fi

      # Apply selected features
      for idx in "${MULTI_RESULT[@]}"; do
        case "$idx" in
          0) # agnoster theme + emoji prompt
            if [ "$OMZ_INSTALLED" = true ]; then
              # Set agnoster theme
              if grep -q "^ZSH_THEME=" "$HOME/.zshrc"; then
                sed -i '' 's/^ZSH_THEME=.*/ZSH_THEME="agnoster"/' "$HOME/.zshrc"
              else
                echo 'ZSH_THEME="agnoster"' >> "$HOME/.zshrc"
              fi
              # Add emoji prompt customization
              cat >> "$HOME/.zshrc" << 'EOF'

# === agnoster emoji prompt ===
prompt_context() {
  emojis=("🔥" "👑" "😎" "🍺" "🐵" "🦄" "🌈" "🚀" "🐧" "🎉" "🐱" "🐶" "🦋" "🔅")
  RAND_EMOJI_N=$(( $RANDOM % ${#emojis[@]} ))
  prompt_segment black default "%(!.%{%F{yellow}%}.) $USER ${emojis[$RAND_EMOJI_N]} "
}
EOF
            else
              echo "  ⚠️  agnoster theme requires Oh My Zsh (skipped)"
            fi
            ;;
          1) # plugins
            cat >> "$HOME/.zshrc" << 'EOF'

# === zsh plugins ===
if [ -f "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
  source "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi
if [ -f "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]; then
  source "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi
EOF
            ;;
          2) # alias
            cat >> "$HOME/.zshrc" << 'EOF'

# === Useful aliases ===
alias ll="ls -la"
alias gs="git status"
alias gl="git log --oneline -20"
EOF
            ;;
        esac
      done

      # Add end marker for cleanup script
      echo "" >> "$HOME/.zshrc"
      echo "# === End ai-dev-setup ===" >> "$HOME/.zshrc"

      echo "  $MSG_ZSHRC_DONE"
    else
      echo "  $MSG_ZSHRC_SKIP"
    fi
  fi
}
