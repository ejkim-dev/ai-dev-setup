#!/bin/bash
# Module: tmux.sh
# Description: tmux installation and configuration
# Dependencies: colors.sh, core.sh, ui.sh
# Usage: Source this file after dependencies, then call setup_tmux

# Set up tmux configuration
setup_tmux() {
  echo ""
  echo "  💡 $MSG_TMUX_DESC"
  echo ""
  echo "$MSG_TMUX_ASK"
  echo ""
  select_menu "$MSG_TMUX_OPT_INSTALL" "$MSG_TMUX_OPT_SKIP"

  if [ "$MENU_RESULT" -eq 0 ]; then
    echo ""
    spinner "$MSG_TMUX_INSTALLING" &
    spinner_pid=$!

    if [ -f "$HOME/.tmux.conf" ]; then
      cp "$HOME/.tmux.conf" "$HOME/.tmux.conf.backup" 2>/dev/null
    fi
    cp "$SCRIPT_DIR/configs/shared/.tmux.conf" "$HOME/.tmux.conf" 2>/dev/null
    sleep 0.5

    kill $spinner_pid 2>/dev/null
    wait $spinner_pid 2>/dev/null
    printf "\r\033[K"
    tput cnorm 2>/dev/null

    echo "  ✅ $MSG_TMUX_DONE"
  else
    echo "  $MSG_TMUX_SKIP"
  fi
}
