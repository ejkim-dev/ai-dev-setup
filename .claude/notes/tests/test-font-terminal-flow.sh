#!/bin/bash
# Test: Font → Terminal installation flow

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Colors
color_green="\033[0;32m"
color_yellow="\033[0;33m"
color_cyan="\033[0;36m"
color_bold="\033[1m"
color_bold_cyan="\033[1;36m"
color_reset="\033[0m"

# Load locale
source "$SCRIPT_DIR/claude-code/locale/ko.sh"

# === Utilities ===
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

# Multi-select checkbox menu (simplified)
select_multi() {
  local options=("$@")
  local count=${#options[@]}
  local selected=0
  local key
  local -a checked=()

  for i in "${!options[@]}"; do checked[$i]=0; done
  for idx in $MULTI_DEFAULTS; do checked[$idx]=1; done

  tput civis 2>/dev/null
  trap 'tput cnorm 2>/dev/null' EXIT

  for i in "${!options[@]}"; do
    local mark=" "
    if [ "${checked[$i]}" -eq 1 ]; then
      mark="x"
    fi

    if [ "$i" -eq $selected ]; then
      if [ "${checked[$i]}" -eq 1 ]; then
        echo -e "  ${color_bold_cyan}▸ [$mark] ${options[$i]}${color_reset}"
      else
        echo -e "  ${color_bold}▸ [$mark] ${options[$i]}${color_reset}"
      fi
    else
      if [ "${checked[$i]}" -eq 1 ]; then
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
        if [ "${checked[$selected]}" -eq 1 ]; then
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
      if [ "${checked[$i]}" -eq 1 ]; then
        mark="x"
      fi

      if [ "$i" -eq $selected ]; then
        if [ "${checked[$i]}" -eq 1 ]; then
          echo -e "  ${color_bold_cyan}▸ [$mark] ${options[$i]}${color_reset}"
        else
          echo -e "  ${color_bold}▸ [$mark] ${options[$i]}${color_reset}"
        fi
      else
        if [ "${checked[$i]}" -eq 1 ]; then
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

# Import Terminal profile (from setup.sh)
import_terminal_profile() {
  local dev_terminal="$1"

  # 1. Import profile using open (Terminal.app recognizes it immediately)
  if ! open "$dev_terminal" 2>/dev/null; then
    return 1
  fi

  # Wait for Terminal.app to process the import
  sleep 1

  # 2. Set as default profile using defaults write (applied after restart)
  defaults write com.apple.Terminal "Default Window Settings" -string "Dev" 2>/dev/null || return 1
  defaults write com.apple.Terminal "Startup Window Settings" -string "Dev" 2>/dev/null || return 1

  # 3. Verify settings were written to plist
  if defaults read com.apple.Terminal "Default Window Settings" 2>/dev/null | grep -q "Dev"; then
    return 0
  else
    return 1
  fi
}

echo ""
echo -e "${color_cyan}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${color_reset}"
echo -e "${color_cyan}폰트 + Terminal 설치 플로우 테스트${color_reset}"
echo -e "${color_cyan}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${color_reset}"
echo ""

# === 1. Font Selection ===
echo -e "${color_bold}[1/2] 폰트 선택 및 설치${color_reset}"
echo ""
echo "$MSG_FONT_ASK"
echo "  $MSG_FONT_HINT"
echo ""
MULTI_DEFAULTS="0" DISABLED_ITEMS="" select_multi "$MSG_FONT_OPT2" "$MSG_FONT_OPT1" "$MSG_FONT_OPT_SKIP"

SELECTED_FONT="none"
NERD_INSTALLED=false
D2CODING_INSTALLED=false

# Check what's actually installed
if command -v brew &>/dev/null; then
  if brew list font-d2coding-nerd-font &>/dev/null 2>&1; then
    NERD_INSTALLED=true
  fi
  if brew list font-d2coding &>/dev/null 2>&1; then
    D2CODING_INSTALLED=true
  fi
fi

echo ""
echo -e "  ${color_cyan}현재 설치된 폰트:${color_reset}"
echo "    D2Coding Nerd Font: $([ "$NERD_INSTALLED" = true ] && echo "✅ 설치됨" || echo "❌ 없음")"
echo "    D2Coding: $([ "$D2CODING_INSTALLED" = true ] && echo "✅ 설치됨" || echo "❌ 없음")"
echo ""

if [ ${#MULTI_RESULT[@]} -gt 0 ]; then
  echo "  $MSG_FONT_INSTALLING"
  for idx in "${MULTI_RESULT[@]}"; do
    case "$idx" in
      0)
        # D2Coding Nerd Font (priority 1)
        if [ "$NERD_INSTALLED" = true ]; then
          echo "  ✅ D2Coding Nerd Font (이미 설치됨)"
          SELECTED_FONT="nerd"
        else
          echo "  📦 D2Coding Nerd Font 설치 중..."
          if brew install font-d2coding-nerd-font 2>/dev/null; then
            echo "  ✅ D2Coding Nerd Font 설치 완료"
            SELECTED_FONT="nerd"
          else
            echo "  ❌ D2Coding Nerd Font 설치 실패"
          fi
        fi
        ;;
      1)
        # D2Coding (priority 2)
        if [ "$D2CODING_INSTALLED" = true ]; then
          echo "  ✅ D2Coding (이미 설치됨)"
          [ "$SELECTED_FONT" = "none" ] && SELECTED_FONT="d2coding"
        else
          echo "  📦 D2Coding 설치 중..."
          if brew install font-d2coding 2>/dev/null; then
            echo "  ✅ D2Coding 설치 완료"
            [ "$SELECTED_FONT" = "none" ] && SELECTED_FONT="d2coding"
          else
            echo "  ❌ D2Coding 설치 실패"
          fi
        fi
        ;;
      2)
        # Skip
        echo "  $MSG_FONT_SKIP"
        ;;
    esac
  done
  echo ""
  echo -e "  ${color_green}✅ 최종 선택된 폰트: $SELECTED_FONT${color_reset}"

  if [ "$SELECTED_FONT" = "none" ]; then
    echo -e "  ${color_yellow}⚠️  선택한 폰트가 설치되어 있지 않습니다.${color_reset}"
    echo "     → Dev-D2Coding.terminal (안전한 fallback) 사용됨"
  fi
else
  echo "  $MSG_FONT_SKIP"
fi

echo ""
echo -e "${color_bold}[2/2] Terminal 설치${color_reset}"
echo ""
echo "  폰트 선택 결과를 기반으로 Terminal 프로파일 선택:"
echo ""

# Select terminal file based on font choice (same logic as setup.sh)
if [ "$SELECTED_FONT" = "nerd" ]; then
  TERMINAL_FILE="$SCRIPT_DIR/configs/mac/Dev.terminal"
  echo "  → Dev.terminal (Nerd Font 버전)"
else
  # D2Coding or Skip: use D2Coding version (safer fallback)
  TERMINAL_FILE="$SCRIPT_DIR/configs/mac/Dev-D2Coding.terminal"
  echo "  → Dev-D2Coding.terminal (D2Coding 버전, 안전한 fallback)"
fi

echo ""
if ask_yn "Terminal.app에 Dev 프로파일 설치하시겠습니까?"; then
  if import_terminal_profile "$TERMINAL_FILE"; then
    echo ""
    echo "  ✅ $MSG_TERMINAL_APPLIED"
    echo "  💡 $MSG_TERMINAL_RESTART_HINT"
  else
    echo "  ⚠️  Terminal profile import failed"
  fi
else
  echo "  건너뛰기"
fi

echo ""
echo -e "${color_cyan}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${color_reset}"
echo -e "${color_green}✅ 테스트 완료!${color_reset}"
echo -e "${color_cyan}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${color_reset}"
echo ""
echo -e "${color_bold}📋 테마 적용 확인 방법:${color_reset}"
echo ""
echo -e "${color_yellow}[중요] Terminal.app을 완전히 종료해야 적용됩니다:${color_reset}"
echo "  1. Terminal.app 완전 종료: ⌘Q (Quit Terminal)"
echo "  2. Terminal.app 다시 실행"
echo "  3. 자동으로 Dev 테마(어두운 배경)로 시작되는지 확인"
echo ""
echo -e "${color_cyan}추가 확인:${color_reset}"
echo "  • Settings(⌘,) → Profiles → Dev가 'Default'로 표시되는지"
echo "  • 폰트 확인: $([ "$SELECTED_FONT" = "nerd" ] && echo "D2CodingLigature Nerd Font" || echo "D2Coding")"
echo ""
