#!/bin/bash
# Terminal.app Dev 프로파일 설치 테스트 스크립트

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
echo -e "${color_cyan}Terminal.app Dev 프로파일 설치 테스트${color_reset}"
echo -e "${color_cyan}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${color_reset}"
echo ""

# Step 1: 현재 상태 확인
echo -e "${color_yellow}[1/5] 현재 상태 확인${color_reset}"
echo -n "  Default profile: "
defaults read com.apple.Terminal "Default Window Settings" 2>/dev/null || echo "(없음)"

echo -n "  Dev 프로파일 존재: "
if /usr/libexec/PlistBuddy -c "Print :Window\ Settings:Dev:name" "$TERMINAL_PLIST" >/dev/null 2>&1; then
  echo -e "${color_green}✅ 있음${color_reset}"
else
  echo -e "${color_yellow}❌ 없음${color_reset}"
fi
echo ""

# Step 2: 백업 생성
echo -e "${color_yellow}[2/5] plist 백업 생성${color_reset}"
cp "$TERMINAL_PLIST" "${TERMINAL_PLIST}.test-backup"
echo -e "  ${color_green}✅ 백업 완료: ${TERMINAL_PLIST}.test-backup${color_reset}"
echo ""

# Step 3: Dev 프로파일 제거 (클린 상태)
echo -e "${color_yellow}[3/5] Dev 프로파일 제거 (클린 테스트)${color_reset}"
plutil -convert xml1 "$TERMINAL_PLIST" 2>/dev/null || true
/usr/libexec/PlistBuddy -c "Delete :Window\ Settings:Dev" "$TERMINAL_PLIST" 2>/dev/null || echo "  (이미 없음)"
/usr/libexec/PlistBuddy -c "Delete :Default\ Window\ Settings" "$TERMINAL_PLIST" 2>/dev/null || true
plutil -convert binary1 "$TERMINAL_PLIST" 2>/dev/null || true
killall cfprefsd 2>/dev/null || true
sleep 1

echo -n "  제거 확인: "
if /usr/libexec/PlistBuddy -c "Print :Window\ Settings:Dev" "$TERMINAL_PLIST" >/dev/null 2>&1; then
  echo -e "${color_red}❌ 제거 실패${color_reset}"
  exit 1
else
  echo -e "${color_green}✅ 제거 완료${color_reset}"
fi
echo ""

# Step 4: import_terminal_profile 함수 정의 및 실행
echo -e "${color_yellow}[4/5] Dev 프로파일 설치 (import_terminal_profile 함수)${color_reset}"

# Extract and source the function from setup.sh
TEMP_FUNC="/tmp/import_terminal_profile_$$.sh"
sed -n '/^import_terminal_profile()/,/^}/p' "$SCRIPT_DIR/setup.sh" > "$TEMP_FUNC"
source "$TEMP_FUNC"
rm -f "$TEMP_FUNC"

# 실행
echo "  plist 수정 및 설정 동기화 중..."
if import_terminal_profile "$SCRIPT_DIR/configs/mac/Dev.terminal"; then
  echo -e "  ${color_green}✅ 설치 성공${color_reset}"
else
  echo -e "  ${color_red}❌ 설치 실패${color_reset}"
  echo ""
  echo "백업에서 복구하려면:"
  echo "  cp ${TERMINAL_PLIST}.test-backup $TERMINAL_PLIST"
  exit 1
fi
echo ""

# Step 5: 검증
echo -e "${color_yellow}[5/5] 설치 검증${color_reset}"

echo -n "  1. Dev 프로파일 존재: "
if /usr/libexec/PlistBuddy -c "Print :Window\ Settings:Dev:name" "$TERMINAL_PLIST" >/dev/null 2>&1; then
  PROFILE_NAME=$(/usr/libexec/PlistBuddy -c "Print :Window\ Settings:Dev:name" "$TERMINAL_PLIST" 2>&1)
  echo -e "${color_green}✅ $PROFILE_NAME${color_reset}"
else
  echo -e "${color_red}❌ 없음${color_reset}"
  exit 1
fi

echo -n "  2. Default 설정: "
DEFAULT_PROFILE=$(defaults read com.apple.Terminal "Default Window Settings" 2>&1)
if echo "$DEFAULT_PROFILE" | grep -q "Dev"; then
  echo -e "${color_green}✅ $DEFAULT_PROFILE${color_reset}"
else
  echo -e "${color_red}❌ $DEFAULT_PROFILE${color_reset}"
  exit 1
fi

echo -n "  3. Startup 설정: "
STARTUP_PROFILE=$(defaults read com.apple.Terminal "Startup Window Settings" 2>&1)
if echo "$STARTUP_PROFILE" | grep -q "Dev"; then
  echo -e "${color_green}✅ $STARTUP_PROFILE${color_reset}"
else
  echo -e "${color_yellow}⚠️  $STARTUP_PROFILE${color_reset}"
fi

echo -n "  4. 프로파일 필드 확인: "
FIELDS=0
/usr/libexec/PlistBuddy -c "Print :Window\ Settings:Dev:Font" "$TERMINAL_PLIST" >/dev/null 2>&1 && ((FIELDS++))
/usr/libexec/PlistBuddy -c "Print :Window\ Settings:Dev:BackgroundColor" "$TERMINAL_PLIST" >/dev/null 2>&1 && ((FIELDS++))
/usr/libexec/PlistBuddy -c "Print :Window\ Settings:Dev:CursorColor" "$TERMINAL_PLIST" >/dev/null 2>&1 && ((FIELDS++))

if [ $FIELDS -ge 3 ]; then
  echo -e "${color_green}✅ 필수 필드 존재 ($FIELDS개 확인)${color_reset}"
else
  echo -e "${color_red}❌ 필수 필드 부족 ($FIELDS개)${color_reset}"
  exit 1
fi

echo ""
echo -e "${color_green}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${color_reset}"
echo -e "${color_green}✅ 모든 테스트 통과!${color_reset}"
echo -e "${color_green}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${color_reset}"
echo ""
echo -e "${color_cyan}📋 확인 방법:${color_reset}"
echo "  새 Terminal 창(⌘N)을 열어서 Dev 테마가 적용되었는지 확인하세요"
echo "  (Terminal.app 재시작 불필요!)"
echo ""
echo -e "${color_cyan}🔄 원래 상태로 복구하려면:${color_reset}"
echo "  cp ${TERMINAL_PLIST}.test-backup $TERMINAL_PLIST"
echo "  killall cfprefsd"
echo ""
