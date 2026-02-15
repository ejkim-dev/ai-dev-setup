#!/bin/bash
# Module: ui.sh
# Description: UI components (menus, spinners, prompts)
# Dependencies: colors.sh
# Usage: Source this file after colors.sh

# Spinner animation
# Usage: spinner "Installing..." & spinner_pid=$!; long_command; kill $spinner_pid 2>/dev/null; wait $spinner_pid 2>/dev/null
spinner() {
  local message="$1"
  local spinstr='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
  tput civis 2>/dev/null
  while true; do
    local temp=${spinstr#?}
    printf "\r  %s %s" "${spinstr:0:1}" "$message"
    spinstr=$temp${spinstr%"$temp"}
    sleep 0.1
  done
}

# Run command with spinner
# Usage: run_with_spinner "Installing..." "command to run"
# Note: Temporarily disables set -e to allow caller to handle errors
run_with_spinner() {
  local message="$1"
  local command="$2"

  spinner "$message" &
  local spinner_pid=$!

  # Temporarily disable exit on error for proper error handling
  set +e
  eval "$command" > /tmp/spinner_output_$$ 2>&1
  local result=$?
  set -e

  kill $spinner_pid 2>/dev/null || true
  wait $spinner_pid 2>/dev/null || true
  printf "\r\033[K"
  tput cnorm 2>/dev/null || true

  return $result
}

# Arrow key menu selector
# Usage: select_menu "Option 1" "Option 2" "Option 3"
# Result: MENU_RESULT (0-based index)
select_menu() {
  local options=("$@")
  local count=${#options[@]}
  local selected=0
  local key

  # Flush any buffered stdin (prevents auto-selection after brew install, etc.)
  while read -rsn1 -t 0.01 _discard 2>/dev/null; do :; done

  tput civis 2>/dev/null
  trap 'tput cnorm 2>/dev/null' EXIT

  for i in "${!options[@]}"; do
    if [ "$i" -eq $selected ]; then
      echo -e "  ${color_bold_cyan}▸ ${options[$i]}${color_reset}"
    else
      echo -e "    ${options[$i]}"
    fi
  done

  while true; do
    IFS= read -rsn1 key
    case "$key" in
      $'\x1b')
        IFS= read -rsn2 key
        case "$key" in
          '[A')
            if [ $selected -gt 0 ]; then
              selected=$((selected - 1))
            fi
            ;;
          '[B')
            if [ $selected -lt $((count - 1)) ]; then
              selected=$((selected + 1))
            fi
            ;;
        esac
        ;;
      ''|$'\n'|$'\r')
        break
        ;;
    esac

    tput cuu "$count" 2>/dev/null
    for i in "${!options[@]}"; do
      tput el 2>/dev/null
      if [ "$i" -eq $selected ]; then
        echo -e "  ${color_bold_cyan}▸ ${options[$i]}${color_reset}"
      else
        echo -e "    ${options[$i]}"
      fi
    done
  done

  tput cnorm 2>/dev/null
  MENU_RESULT=$selected
}

# Multi-select checkbox menu
# Usage: MULTI_DEFAULTS="0 2" DISABLED_ITEMS="3" select_multi "Option A" "Option B" "Option C" "Option D"
# Result: MULTI_RESULT array of selected indices (0-based)
select_multi() {
  local options=("$@")
  local count=${#options[@]}
  local selected=0
  local key
  local -a checked=()
  local -a disabled=()

  for i in "${!options[@]}"; do checked[$i]=0; done
  for idx in $MULTI_DEFAULTS; do checked[$idx]=1; done
  for i in "${!options[@]}"; do disabled[$i]=0; done
  for idx in $DISABLED_ITEMS; do disabled[$idx]=1; done

  tput civis 2>/dev/null
  trap 'tput cnorm 2>/dev/null' EXIT

  for i in "${!options[@]}"; do
    local mark=" "
    if [ "${disabled[$i]}" -eq 1 ]; then
      mark="-"
    elif [ "${checked[$i]}" -eq 1 ]; then
      mark="x"
    fi

    if [ "$i" -eq $selected ]; then
      if [ "${disabled[$i]}" -eq 1 ]; then
        echo -e "  ${color_bold_gray}▸ [$mark] ${options[$i]}${color_reset}"
      elif [ "${checked[$i]}" -eq 1 ]; then
        echo -e "  ${color_bold_cyan}▸ [$mark] ${options[$i]}${color_reset}"
      else
        echo -e "  ${color_bold}▸ [$mark] ${options[$i]}${color_reset}"
      fi
    else
      if [ "${disabled[$i]}" -eq 1 ]; then
        echo -e "  ${color_gray}  [$mark] ${options[$i]}${color_reset}"
      elif [ "${checked[$i]}" -eq 1 ]; then
        echo -e "    ${color_cyan}[$mark] ${options[$i]}${color_reset}"
      else
        echo -e "    [$mark] ${options[$i]}"
      fi
    fi
  done

  while true; do
    IFS= read -rsn1 key
    case "$key" in
      $'\x1b')
        IFS= read -rsn2 key
        case "$key" in
          '[A')
            if [ $selected -gt 0 ]; then
              selected=$((selected - 1))
            fi
            ;;
          '[B')
            if [ $selected -lt $((count - 1)) ]; then
              selected=$((selected + 1))
            fi
            ;;
        esac
        ;;
      ' ')
        # Ignore Space key for disabled items
        if [ "${disabled[$selected]}" -eq 1 ]; then
          :
        elif [ "${checked[$selected]}" -eq 1 ]; then
          checked[$selected]=0
        else
          checked[$selected]=1
        fi
        ;;
      ''|$'\n'|$'\r')
        break
        ;;
    esac

    tput cuu "$count" 2>/dev/null
    for i in "${!options[@]}"; do
      tput el 2>/dev/null
      local mark=" "
      if [ "${disabled[$i]}" -eq 1 ]; then
        mark="-"
      elif [ "${checked[$i]}" -eq 1 ]; then
        mark="x"
      fi

      if [ "$i" -eq $selected ]; then
        if [ "${disabled[$i]}" -eq 1 ]; then
          echo -e "  ${color_bold_gray}▸ [$mark] ${options[$i]}${color_reset}"
        elif [ "${checked[$i]}" -eq 1 ]; then
          echo -e "  ${color_bold_cyan}▸ [$mark] ${options[$i]}${color_reset}"
        else
          echo -e "  ${color_bold}▸ [$mark] ${options[$i]}${color_reset}"
        fi
      else
        if [ "${disabled[$i]}" -eq 1 ]; then
          echo -e "  ${color_gray}  [$mark] ${options[$i]}${color_reset}"
        elif [ "${checked[$i]}" -eq 1 ]; then
          echo -e "    ${color_cyan}[$mark] ${options[$i]}${color_reset}"
        else
          echo -e "    [$mark] ${options[$i]}"
        fi
      fi
    done
  done

  tput cnorm 2>/dev/null
  MULTI_RESULT=()
  for i in "${!options[@]}"; do
    if [ "${checked[$i]}" -eq 1 ]; then
      MULTI_RESULT+=("$i")
    fi
  done
}
