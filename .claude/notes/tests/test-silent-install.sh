#!/bin/bash
# Terminal.app을 건드리지 않고 조용히 프로파일 설치

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
echo -e "${color_cyan}방법 3: 조용한 설치 (cfprefsd 건드리지 않음)${color_reset}"
echo -e "${color_cyan}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${color_reset}"
echo ""

# Step 1: 백업
echo -e "${color_yellow}[1/5] plist 백업${color_reset}"
cp "$TERMINAL_PLIST" "${TERMINAL_PLIST}.silent-backup"
echo -e "  ${color_green}✅ 백업 완료${color_reset}"
echo ""

# Step 2: 현재 상태
echo -e "${color_yellow}[2/5] 설치 전 상태${color_reset}"
echo -n "  Default profile: "
defaults read com.apple.Terminal "Default Window Settings" 2>/dev/null || echo "(없음)"
echo -n "  Dev 프로파일 존재: "
if /usr/libexec/PlistBuddy -c "Print :Window\ Settings:Dev:name" "$TERMINAL_PLIST" >/dev/null 2>&1; then
  echo -e "${color_green}✅ 있음${color_reset}"
else
  echo -e "${color_yellow}❌ 없음${color_reset}"
fi
echo ""

# Step 3: 클린 상태 (Dev 제거)
echo -e "${color_yellow}[3/5] Dev 프로파일 제거 (클린 테스트)${color_reset}"
plutil -convert xml1 "$TERMINAL_PLIST" 2>/dev/null || true
/usr/libexec/PlistBuddy -c "Delete :Window\ Settings:Dev" "$TERMINAL_PLIST" 2>/dev/null && echo "  ✅ 삭제됨" || echo "  (이미 없음)"
/usr/libexec/PlistBuddy -c "Set :Default\ Window\ Settings Basic" "$TERMINAL_PLIST" 2>/dev/null || \
  /usr/libexec/PlistBuddy -c "Add :Default\ Window\ Settings string Basic" "$TERMINAL_PLIST" 2>/dev/null
plutil -convert binary1 "$TERMINAL_PLIST" 2>/dev/null || true
echo ""

# Step 4: 조용한 설치 (cfprefsd 건드리지 않음)
echo -e "${color_yellow}[4/5] 조용한 설치 (Terminal.app 건드리지 않음)${color_reset}"

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

# Cleanup
rm -f "$TEMP_DEV"

echo -e "  ${color_green}✅ plist 파일 수정 완료${color_reset}"
echo -e "  ${color_cyan}💡 cfprefsd를 건드리지 않았습니다${color_reset}"
echo ""

# Step 5: 검증 (파일만 확인)
echo -e "${color_yellow}[5/5] plist 파일 검증${color_reset}"

# XML로 변환해서 확인
plutil -convert xml1 "$TERMINAL_PLIST" 2>/dev/null || true

echo -n "  1. Dev 프로파일 존재: "
if /usr/libexec/PlistBuddy -c "Print :Window\ Settings:Dev:name" "$TERMINAL_PLIST" >/dev/null 2>&1; then
  PROFILE_NAME=$(/usr/libexec/PlistBuddy -c "Print :Window\ Settings:Dev:name" "$TERMINAL_PLIST" 2>&1)
  echo -e "${color_green}✅ $PROFILE_NAME${color_reset}"
  DEV_EXISTS=true
else
  echo -e "${color_red}❌ 없음${color_reset}"
  DEV_EXISTS=false
fi

echo -n "  2. Default 설정 (plist): "
DEFAULT_SETTING=$(/usr/libexec/PlistBuddy -c "Print :Default\ Window\ Settings" "$TERMINAL_PLIST" 2>&1)
if echo "$DEFAULT_SETTING" | grep -q "Dev"; then
  echo -e "${color_green}✅ $DEFAULT_SETTING${color_reset}"
  DEFAULT_OK=true
else
  echo -e "${color_red}❌ $DEFAULT_SETTING${color_reset}"
  DEFAULT_OK=false
fi

echo -n "  3. Terminal.app 실행 상태: "
if pgrep -x "Terminal" >/dev/null; then
  echo -e "${color_green}✅ 실행 중 (영향 없음)${color_reset}"
  TERMINAL_RUNNING=true
else
  echo -e "${color_yellow}⚠️  종료됨${color_reset}"
  TERMINAL_RUNNING=false
fi

# Binary로 다시 변환
plutil -convert binary1 "$TERMINAL_PLIST" 2>/dev/null || true

echo ""

# 결과
if [ "$DEV_EXISTS" = true ] && [ "$DEFAULT_OK" = true ]; then
  echo -e "${color_green}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${color_reset}"
  echo -e "${color_green}✅ 조용한 설치 성공!${color_reset}"
  echo -e "${color_green}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${color_reset}"
  echo ""
  echo -e "${color_cyan}📋 확인 방법 (3가지):${color_reset}"
  echo ""
  echo -e "${color_yellow}방법 1: 새 창 열기 (즉시 확인)${color_reset}"
  echo "  1. ⌘N으로 새 Terminal 창 열기"
  echo "  2. 어두운 Dev 테마로 열리는지 확인"
  echo ""
  echo -e "${color_yellow}방법 2: 설정에서 확인${color_reset}"
  echo "  1. ⌘, (Settings) 열기"
  echo "  2. Profiles 탭"
  echo "  3. Dev 프로파일이 기본값(Default)으로 표시되는지 확인"
  echo ""
  echo -e "${color_yellow}방법 3: Terminal.app 재시작 (완전한 적용)${color_reset}"
  echo "  1. Terminal.app 종료 (⌘Q)"
  echo "  2. Terminal.app 다시 실행"
  echo "  3. Dev 테마로 자동 시작"
  echo ""
  echo -e "${color_green}✅ Terminal.app을 건드리지 않고 설치 완료!${color_reset}"
else
  echo -e "${color_red}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${color_reset}"
  echo -e "${color_red}❌ 설치 실패${color_reset}"
  echo -e "${color_red}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${color_reset}"
  echo ""
  echo "실패 항목:"
  [ "$DEV_EXISTS" = false ] && echo "  ❌ Dev 프로파일이 설치되지 않음"
  [ "$DEFAULT_OK" = false ] && echo "  ❌ Default 설정이 Dev로 바뀌지 않음"
fi

echo ""
echo -e "${color_cyan}🔄 원래 상태로 복구하려면:${color_reset}"
echo "  cp ${TERMINAL_PLIST}.silent-backup $TERMINAL_PLIST"
echo ""
