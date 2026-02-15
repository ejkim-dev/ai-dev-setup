#!/bin/bash
# open + defaults 조합 테스트

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
echo -e "${color_cyan}최종 테스트: open + defaults 조합${color_reset}"
echo -e "${color_cyan}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${color_reset}"
echo ""

# Step 1: 백업
echo -e "${color_yellow}[1/5] plist 백업${color_reset}"
cp "$TERMINAL_PLIST" "${TERMINAL_PLIST}.open-defaults-backup"
echo -e "  ${color_green}✅ 백업 완료${color_reset}"
echo ""

# Step 2: 현재 상태
echo -e "${color_yellow}[2/5] 설치 전 상태${color_reset}"
echo -n "  Default profile: "
defaults read com.apple.Terminal "Default Window Settings" 2>/dev/null || echo "(없음)"
echo ""

# Step 3: Dev 제거 (클린 테스트)
echo -e "${color_yellow}[3/5] Dev 프로파일 제거 (클린 상태)${color_reset}"
plutil -convert xml1 "$TERMINAL_PLIST" 2>/dev/null || true
/usr/libexec/PlistBuddy -c "Delete :Window\ Settings:Dev" "$TERMINAL_PLIST" 2>/dev/null && echo "  ✅ plist에서 삭제됨" || echo "  (이미 없음)"
plutil -convert binary1 "$TERMINAL_PLIST" 2>/dev/null || true
echo -e "  ${color_cyan}💡 Terminal.app Settings에서 Dev가 보이면 수동으로 삭제해주세요${color_reset}"
echo ""

# Step 4: open + defaults 조합
echo -e "${color_yellow}[4/5] open + defaults 조합 설치${color_reset}"

echo "  [4-1] open 명령으로 Dev 프로파일 임포트..."
open "$SCRIPT_DIR/configs/mac/Dev.terminal"
sleep 1
echo -e "  ${color_green}✅ open 완료${color_reset}"

echo "  [4-2] defaults write로 기본값 설정..."
defaults write com.apple.Terminal "Default Window Settings" -string "Dev"
defaults write com.apple.Terminal "Startup Window Settings" -string "Dev"
echo -e "  ${color_green}✅ defaults write 완료${color_reset}"
echo ""

# Step 5: 검증
echo -e "${color_yellow}[5/5] 검증${color_reset}"

echo -n "  1. plist 파일 확인: "
PLIST_DEFAULT=$(defaults read com.apple.Terminal "Default Window Settings" 2>&1)
if echo "$PLIST_DEFAULT" | grep -q "Dev"; then
  echo -e "${color_green}✅ $PLIST_DEFAULT${color_reset}"
  PLIST_OK=true
else
  echo -e "${color_red}❌ $PLIST_DEFAULT${color_reset}"
  PLIST_OK=false
fi

echo ""
echo -e "${color_cyan}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${color_reset}"
echo -e "${color_cyan}📋 Terminal.app에서 확인하세요${color_reset}"
echo -e "${color_cyan}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${color_reset}"
echo ""
echo -e "${color_yellow}Step 1: Terminal.app 실행 중 확인${color_reset}"
echo "  1. Terminal.app으로 전환 (없으면 실행)"
echo "  2. Settings(⌘,) → Profiles"
echo "  3. Dev 프로파일이 보이나요? (임포트 확인)"
echo "  4. Dev 옆에 'Default' 표시가 있나요? (아마 없을 것)"
echo ""
echo -e "${color_yellow}Step 2: Terminal.app 재시작 후 확인${color_reset}"
echo "  1. Terminal.app 완전 종료 (⌘Q)"
echo "  2. Terminal.app 다시 실행"
echo "  3. 자동으로 Dev 테마(어두운 배경)로 시작되나요?"
echo "  4. Settings(⌘,) → Profiles → Dev가 'Default'로 표시되나요?"
echo ""

if [ "$PLIST_OK" = true ]; then
  echo -e "${color_green}✅ plist 설정 완료!${color_reset}"
  echo -e "${color_cyan}💡 Terminal.app 재시작 후 완전히 적용됩니다${color_reset}"
else
  echo -e "${color_red}❌ plist 설정 실패${color_reset}"
fi

echo ""
echo -e "${color_cyan}🔄 원래 상태로 복구하려면:${color_reset}"
echo "  cp ${TERMINAL_PLIST}.open-defaults-backup $TERMINAL_PLIST"
echo ""
