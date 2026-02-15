#!/bin/bash
# Complete Font + Terminal Installation Flow Test
# 목적: setup.sh의 폰트→Terminal 설치 플로우를 정확히 재현하고 검증

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Colors
color_green="\033[0;32m"
color_yellow="\033[0;33m"
color_cyan="\033[0;36m"
color_red="\033[0;31m"
color_bold="\033[1m"
color_bold_cyan="\033[1;36m"
color_reset="\033[0m"

# Load locale
source "$SCRIPT_DIR/claude-code/locale/ko.sh"

# === Utilities (from setup.sh) ===

# Spinner animation
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
run_with_spinner() {
  local message="$1"
  local command="$2"

  spinner "$message" &
  local spinner_pid=$!

  eval "$command" > /tmp/spinner_output_$$ 2>&1
  local result=$?

  kill $spinner_pid 2>/dev/null
  wait $spinner_pid 2>/dev/null
  printf "\r\033[K"
  tput cnorm 2>/dev/null

  return $result
}

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
    if [ "${checked[$i]}" -eq 1 ]; then mark="x"; fi

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
          '[A') [ $selected -gt 0 ] && selected=$((selected - 1)) ;;
          '[B') [ $selected -lt $((count - 1)) ] && selected=$((selected + 1)) ;;
        esac
        ;;
      ' ')
        if [ "${checked[$selected]}" -eq 1 ]; then
          checked[$selected]=0
        else
          checked[$selected]=1
        fi
        ;;
      ''|$'\n'|$'\r') break ;;
    esac

    tput cuu "$count" 2>/dev/null
    for i in "${!options[@]}"; do
      tput el 2>/dev/null
      local mark=" "
      if [ "${checked[$i]}" -eq 1 ]; then mark="x"; fi

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

# Verification function
verify_font_installed() {
  local font_type="$1"
  case "$font_type" in
    nerd)
      brew list font-d2coding-nerd-font &>/dev/null
      ;;
    d2coding)
      brew list font-d2coding &>/dev/null
      ;;
    *)
      return 1
      ;;
  esac
}

verify_terminal_profile_font() {
  local expected_font="$1"
  # This requires manual check in Terminal.app
  echo ""
  echo -e "${color_yellow}[수동 검증 필요]${color_reset}"
  echo "  Terminal.app Settings(⌘,) → Profiles → Dev → Font 탭에서 확인:"
  echo "  예상 폰트: $expected_font"
  echo ""
  echo -e "${color_cyan}💡 Tip: 폰트 선택 화면에서 'D2Coding'을 찾으세요${color_reset}"
  echo ""
  ask_yn "폰트가 '$expected_font'로 설정되어 있나요?"
  return $?
}

echo ""
echo -e "${color_cyan}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${color_reset}"
echo -e "${color_cyan}완전한 폰트 + Terminal 설치 플로우 테스트${color_reset}"
echo -e "${color_cyan}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${color_reset}"
echo ""

# === STEP 1: Font Selection & Installation ===
echo -e "${color_bold}[1/3] 폰트 선택 및 설치${color_reset}"
echo ""
echo "$MSG_FONT_ASK"
echo "  $MSG_FONT_HINT"
echo ""
MULTI_DEFAULTS="0" DISABLED_ITEMS="" select_multi "$MSG_FONT_OPT1" "$MSG_FONT_OPT_SKIP"

SELECTED_FONT="none"
if [ ${#MULTI_RESULT[@]} -gt 0 ]; then
  echo ""
  for idx in "${MULTI_RESULT[@]}"; do
    case "$idx" in
      0)
        # D2Coding
        set +e  # Temporarily disable exit on error
        run_with_spinner "Installing D2Coding..." "brew install font-d2coding"
        install_result=$?
        set -e  # Re-enable exit on error

        if [ $install_result -eq 0 ]; then
          echo "  ✅ D2Coding"
          SELECTED_FONT="d2coding"
        else
          echo "  ⚠️  D2Coding installation failed"
        fi
        ;;
      1)
        # Skip
        echo "  $MSG_FONT_SKIP"
        ;;
    esac
  done
else
  echo "  $MSG_FONT_SKIP"
fi

echo ""
echo -e "${color_cyan}[DEBUG] SELECTED_FONT=${SELECTED_FONT}${color_reset}"

# Show brew install output for debugging
SPINNER_OUT="/tmp/spinner_output_$$"
if [ -f "$SPINNER_OUT" ]; then
  echo -e "${color_cyan}[DEBUG] Brew output (last 5 lines):${color_reset}"
  tail -5 "$SPINNER_OUT" | sed 's/^/  /'
  rm -f "$SPINNER_OUT"
fi

# Verify font installation
echo ""
echo -e "${color_bold}[검증 1] 폰트 설치 확인${color_reset}"
if [ "$SELECTED_FONT" != "none" ]; then
  if verify_font_installed "$SELECTED_FONT"; then
    echo -e "  ${color_green}✅ 폰트가 시스템에 설치되어 있음${color_reset}"
  else
    echo -e "  ${color_red}❌ 폰트가 시스템에 없음!${color_reset}"
    exit 1
  fi
else
  echo "  ⏭️  폰트 설치 생략됨"
fi

# === STEP 2: Terminal Profile Selection ===
echo ""
echo -e "${color_bold}[2/3] Terminal 프로파일 선택${color_reset}"
echo ""

# Always use Dev.terminal (with D2Coding)
TERMINAL_FILE="$SCRIPT_DIR/configs/mac/Dev.terminal"
EXPECTED_FONT="D2Coding 11"
echo "  → Dev.terminal (D2Coding 고정)"
echo "  예상 폰트: $EXPECTED_FONT"
echo -e "${color_cyan}[DEBUG] TERMINAL_FILE=${TERMINAL_FILE}${color_reset}"

# Verify terminal file exists and show its actual font
if [ -f "$TERMINAL_FILE" ]; then
  ACTUAL_FONT=$(python3 -c "
import plistlib
with open('$TERMINAL_FILE', 'rb') as f:
    p = plistlib.load(f)
    font_data = p['Font']
    font_archive = plistlib.loads(font_data)
    objs = font_archive['\$objects']
    if len(objs) > 1 and 'NSName' in objs[1]:
        name = objs[1]['NSName']
        size = objs[1]['NSSize']
        print(f'{name} {size}')
" 2>/dev/null)
  echo -e "${color_cyan}[DEBUG] Terminal 파일의 실제 폰트: ${ACTUAL_FONT}${color_reset}"
else
  echo -e "${color_red}[DEBUG] ERROR: Terminal 파일 없음: ${TERMINAL_FILE}${color_reset}"
fi

# === STEP 3: Terminal Installation ===
echo ""
echo -e "${color_bold}[3/3] Terminal 프로파일 설치${color_reset}"
echo ""
echo "  → 자동으로 설치 진행 (테스트 모드)"
echo ""

echo -e "${color_cyan}[DEBUG] Running: import_terminal_profile \"$TERMINAL_FILE\"${color_reset}"

set +e  # Temporarily disable exit on error
import_terminal_profile "$TERMINAL_FILE"
import_result=$?
set -e  # Re-enable exit on error

if [ $import_result -eq 0 ]; then
  echo ""
  echo "  ✅ $MSG_TERMINAL_APPLIED"
  echo "  💡 $MSG_TERMINAL_RESTART_HINT"
  echo -e "${color_cyan}[DEBUG] import_terminal_profile 성공${color_reset}"
else
  echo ""
  echo -e "${color_red}[DEBUG] import_terminal_profile 실패 (return code: $import_result)${color_reset}"
  echo "  ⚠️  Terminal profile import failed"

  # Check if Dev profile exists in Terminal.app
  if defaults read com.apple.Terminal 2>/dev/null | grep -q "Dev ="; then
    echo -e "${color_yellow}[DEBUG] Dev 프로파일은 존재하지만 기본값 설정 실패${color_reset}"
  else
    echo -e "${color_yellow}[DEBUG] Dev 프로파일이 Terminal.app에 없음${color_reset}"
  fi
  exit 1
fi

# === VERIFICATION ===
echo ""
echo -e "${color_cyan}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${color_reset}"
echo -e "${color_bold}검증 단계${color_reset}"
echo -e "${color_cyan}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${color_reset}"

# Verify defaults
echo ""
echo -e "${color_bold}[검증 2] defaults 설정 확인${color_reset}"
DEFAULT_PROFILE=$(defaults read com.apple.Terminal "Default Window Settings" 2>/dev/null)
if [ "$DEFAULT_PROFILE" = "Dev" ]; then
  echo -e "  ${color_green}✅ Default Window Settings = Dev${color_reset}"
else
  echo -e "  ${color_red}❌ Default Window Settings = $DEFAULT_PROFILE (예상: Dev)${color_reset}"
fi

# Verify Terminal profile font (manual)
echo ""
echo -e "${color_bold}[검증 3] Terminal 프로파일 폰트 확인${color_reset}"
if verify_terminal_profile_font "$EXPECTED_FONT"; then
  echo -e "  ${color_green}✅ 폰트 설정 정상${color_reset}"
else
  echo -e "  ${color_red}❌ 폰트 설정 문제 발견!${color_reset}"
  echo -e "  ${color_yellow}문제: Terminal.app에서 폰트가 '$EXPECTED_FONT'가 아님${color_reset}"
  echo ""
  echo "  가능한 원인:"
  echo "    1. Dev.terminal 파일에 폰트가 제대로 설정되지 않음"
  echo "    2. Terminal.app이 plist를 아직 읽지 않음 (⌘Q 재시작 필요)"
  echo ""
  exit 1
fi

echo ""
echo -e "${color_cyan}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${color_reset}"
echo -e "${color_green}✅ 모든 검증 통과!${color_reset}"
echo -e "${color_cyan}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${color_reset}"
echo ""
echo -e "${color_bold}[최종 요약]${color_reset}"
echo "  SELECTED_FONT: $SELECTED_FONT"
echo "  TERMINAL_FILE: $(basename "$TERMINAL_FILE")"
echo "  EXPECTED_FONT: $EXPECTED_FONT"
if [ -n "$ACTUAL_FONT" ]; then
  echo "  ACTUAL_FONT: $ACTUAL_FONT"
fi
echo ""
echo -e "${color_bold}📋 최종 확인 방법:${color_reset}"
echo ""
echo -e "${color_yellow}[필수] Terminal.app 완전 종료 및 재시작:${color_reset}"
echo "  1. ⌘Q (Quit Terminal) - 완전 종료"
echo "  2. Terminal.app 다시 실행"
echo "  3. 자동으로 Dev 테마(어두운 배경)로 시작"
echo "  4. Settings(⌘,) → Profiles → Dev가 'Default'로 표시"
echo ""
echo -e "${color_cyan}추가 확인:${color_reset}"
echo "  • 폰트: $EXPECTED_FONT"
echo "  • 배경: 어두운 배경"
echo "  • 새 창(⌘N)도 Dev 테마로 열림"
echo ""
