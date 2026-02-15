#!/bin/bash
# Terminal.app 종료 없이 프로파일 설치 테스트

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TERMINAL_PLIST="$HOME/Library/Preferences/com.apple.Terminal.plist"

# Colors
color_cyan='\033[0;36m'
color_green='\033[0;32m'
color_yellow='\033[1;33m'
color_red='\033[0;31m'
color_reset='\033[0m'

echo -e "${color_cyan}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${color_reset}"
echo -e "${color_cyan}Terminal.app 종료 없이 프로파일 설치 테스트${color_reset}"
echo -e "${color_cyan}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${color_reset}"
echo ""

# 현재 터미널 확인
echo -e "${color_yellow}[확인] 현재 터미널${color_reset}"
echo "  TERM_PROGRAM: ${TERM_PROGRAM:-없음}"
if [ "$TERM_PROGRAM" = "Apple_Terminal" ]; then
  echo -e "  ${color_green}✅ Terminal.app에서 실행 중 (올바른 테스트 환경)${color_reset}"
else
  echo -e "  ${color_yellow}⚠️  Terminal.app이 아닙니다. Terminal.app에서 실행하세요.${color_reset}"
fi
echo ""

# Step 1: 백업
echo -e "${color_yellow}[1/6] plist 백업${color_reset}"
cp "$TERMINAL_PLIST" "${TERMINAL_PLIST}.no-quit-backup"
echo -e "  ${color_green}✅ 백업 완료${color_reset}"
echo ""

# Step 2: 현재 상태
echo -e "${color_yellow}[2/6] 현재 상태 확인${color_reset}"
echo -n "  Default profile: "
defaults read com.apple.Terminal "Default Window Settings" 2>/dev/null || echo "(없음)"
echo -n "  Dev 프로파일 존재: "
if /usr/libexec/PlistBuddy -c "Print :Window\ Settings:Dev:name" "$TERMINAL_PLIST" >/dev/null 2>&1; then
  echo -e "${color_green}✅ 있음${color_reset}"
  DEV_EXISTS_BEFORE=true
else
  echo -e "${color_yellow}❌ 없음${color_reset}"
  DEV_EXISTS_BEFORE=false
fi
echo ""

# Step 3: Dev 제거 (클린 테스트)
echo -e "${color_yellow}[3/6] Dev 프로파일 제거 (클린 상태)${color_reset}"
plutil -convert xml1 "$TERMINAL_PLIST" 2>/dev/null || true
/usr/libexec/PlistBuddy -c "Delete :Window\ Settings:Dev" "$TERMINAL_PLIST" 2>/dev/null && echo "  ✅ 삭제됨" || echo "  (이미 없음)"
/usr/libexec/PlistBuddy -c "Set :Default\ Window\ Settings Basic" "$TERMINAL_PLIST" 2>/dev/null || \
  /usr/libexec/PlistBuddy -c "Add :Default\ Window\ Settings string Basic" "$TERMINAL_PLIST" 2>/dev/null
plutil -convert binary1 "$TERMINAL_PLIST" 2>/dev/null || true
echo ""

# Step 4: Terminal.app 종료 없이 설치
echo -e "${color_yellow}[4/6] Terminal.app 종료 없이 Dev 프로파일 설치${color_reset}"
echo "  (Terminal.app은 계속 실행됩니다)"

# Convert to XML
plutil -convert xml1 "$TERMINAL_PLIST" 2>/dev/null || true

# Ensure Window Settings exists
if ! /usr/libexec/PlistBuddy -c "Print :Window\ Settings" "$TERMINAL_PLIST" >/dev/null 2>&1; then
  /usr/libexec/PlistBuddy -c "Add :Window\ Settings dict" "$TERMINAL_PLIST" 2>/dev/null || true
fi

# Convert Dev.terminal to XML and merge
TEMP_DEV="/tmp/dev-profile-$$.xml"
plutil -convert xml1 "$SCRIPT_DIR/configs/mac/Dev.terminal" -o "$TEMP_DEV" 2>/dev/null

if [ ! -f "$TEMP_DEV" ]; then
  echo -e "  ${color_red}❌ Dev.terminal 변환 실패${color_reset}"
  exit 1
fi

# Add and merge Dev profile
/usr/libexec/PlistBuddy -c "Add :Window\ Settings:Dev dict" "$TERMINAL_PLIST" 2>/dev/null
/usr/libexec/PlistBuddy -c "Merge $TEMP_DEV :Window\ Settings:Dev" "$TERMINAL_PLIST" 2>/dev/null

# Set as default
/usr/libexec/PlistBuddy -c "Set :Default\ Window\ Settings Dev" "$TERMINAL_PLIST" 2>/dev/null || \
  /usr/libexec/PlistBuddy -c "Add :Default\ Window\ Settings string Dev" "$TERMINAL_PLIST" 2>/dev/null

/usr/libexec/PlistBuddy -c "Set :Startup\ Window\ Settings Dev" "$TERMINAL_PLIST" 2>/dev/null || \
  /usr/libexec/PlistBuddy -c "Add :Startup\ Window\ Settings string Dev" "$TERMINAL_PLIST" 2>/dev/null

# Convert back to binary
plutil -convert binary1 "$TERMINAL_PLIST" 2>/dev/null || true

# Restart cfprefsd
echo "  cfprefsd 재시작 중..."
killall cfprefsd 2>/dev/null || true

# Force sync
echo "  설정 강제 동기화 중..."
defaults read com.apple.Terminal >/dev/null 2>&1

# Cleanup
rm -f "$TEMP_DEV"

sleep 2

echo -e "  ${color_green}✅ 설치 완료${color_reset}"
echo ""

# Step 5: 검증
echo -e "${color_yellow}[5/6] 검증${color_reset}"

echo -n "  1. Dev 프로파일 존재: "
if /usr/libexec/PlistBuddy -c "Print :Window\ Settings:Dev:name" "$TERMINAL_PLIST" >/dev/null 2>&1; then
  PROFILE_NAME=$(/usr/libexec/PlistBuddy -c "Print :Window\ Settings:Dev:name" "$TERMINAL_PLIST" 2>&1)
  echo -e "${color_green}✅ $PROFILE_NAME${color_reset}"
  DEV_EXISTS=true
else
  echo -e "${color_red}❌ 없음${color_reset}"
  DEV_EXISTS=false
fi

echo -n "  2. Default 설정: "
DEFAULT_PROFILE=$(defaults read com.apple.Terminal "Default Window Settings" 2>&1)
if echo "$DEFAULT_PROFILE" | grep -q "Dev"; then
  echo -e "${color_green}✅ $DEFAULT_PROFILE${color_reset}"
  DEFAULT_OK=true
else
  echo -e "${color_red}❌ $DEFAULT_PROFILE${color_reset}"
  DEFAULT_OK=false
fi

echo -n "  3. Terminal.app 실행 상태: "
if pgrep -x "Terminal" >/dev/null; then
  echo -e "${color_green}✅ 실행 중 (종료 안 됨)${color_reset}"
  TERMINAL_RUNNING=true
else
  echo -e "${color_red}❌ 종료됨${color_reset}"
  TERMINAL_RUNNING=false
fi

echo ""

# Step 6: 결과
echo -e "${color_yellow}[6/6] 테스트 결과${color_reset}"
echo ""

if [ "$DEV_EXISTS" = true ] && [ "$DEFAULT_OK" = true ] && [ "$TERMINAL_RUNNING" = true ]; then
  echo -e "${color_green}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${color_reset}"
  echo -e "${color_green}✅ 모든 테스트 통과!${color_reset}"
  echo -e "${color_green}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${color_reset}"
  echo ""
  echo -e "${color_cyan}📋 확인 방법:${color_reset}"
  echo "  1. 새 Terminal 창(⌘N) 열기"
  echo "  2. Dev 테마(어두운 배경) 확인"
  echo "  3. Settings(⌘,) → Profiles에서 Dev 프로파일 확인"
  echo ""
  echo -e "${color_green}✅ Terminal.app을 종료하지 않고 설치 성공!${color_reset}"
else
  echo -e "${color_red}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${color_reset}"
  echo -e "${color_red}❌ 테스트 실패${color_reset}"
  echo -e "${color_red}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${color_reset}"
  echo ""
  echo "실패 항목:"
  [ "$DEV_EXISTS" = false ] && echo "  ❌ Dev 프로파일이 설치되지 않음"
  [ "$DEFAULT_OK" = false ] && echo "  ❌ Default 설정이 Dev로 바뀌지 않음"
  [ "$TERMINAL_RUNNING" = false ] && echo "  ❌ Terminal.app이 종료됨"
  echo ""
  echo -e "${color_yellow}💡 Terminal.app이 실행 중일 때는 plist 변경이 반영되지 않을 수 있습니다.${color_reset}"
  echo -e "${color_yellow}   새 창을 열었을 때 적용되는지 확인해보세요.${color_reset}"
fi

echo ""
echo -e "${color_cyan}🔄 원래 상태로 복구하려면:${color_reset}"
echo "  cp ${TERMINAL_PLIST}.no-quit-backup $TERMINAL_PLIST"
echo "  killall cfprefsd"
echo ""
