#!/bin/bash
# Test script for Step 3 package multi-select menu
# Usage: ./test-package-multiselect.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Source libraries
source "$SCRIPT_DIR/lib/colors.sh"
source "$SCRIPT_DIR/lib/core.sh"
source "$SCRIPT_DIR/lib/ui.sh"
source "$SCRIPT_DIR/lib/installer.sh"

# Load locale (default to Korean for testing)
if [ -f "$SCRIPT_DIR/claude-code/locale/ko.sh" ]; then
  source "$SCRIPT_DIR/claude-code/locale/ko.sh"
else
  echo "Locale file not found!"
  exit 1
fi

# Source packages module
source "$SCRIPT_DIR/modules/packages.sh"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🧪 Step 3 패키지 멀티 선택 테스트"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "현재 설치 상태:"
echo ""

# Show current installation status
command -v node >/dev/null 2>&1 && echo "  ✅ Node.js: $(node --version)" || echo "  ❌ Node.js: 미설치"
command -v rg >/dev/null 2>&1 && echo "  ✅ ripgrep: $(rg --version | head -1)" || echo "  ❌ ripgrep: 미설치"
if ls "$HOME/Library/Fonts/"*[Dd]2[Cc]oding*.ttc 2>/dev/null | grep -q . || \
   ls "/Library/Fonts/"*[Dd]2[Cc]oding*.ttc 2>/dev/null | grep -q .; then
  echo "  ✅ D2Coding 폰트: 설치됨"
else
  echo "  ❌ D2Coding 폰트: 미설치"
fi
brew list zsh-autosuggestions >/dev/null 2>&1 && echo "  ✅ zsh-autosuggestions: 설치됨" || echo "  ❌ zsh-autosuggestions: 미설치"
brew list zsh-syntax-highlighting >/dev/null 2>&1 && echo "  ✅ zsh-syntax-highlighting: 설치됨" || echo "  ❌ zsh-syntax-highlighting: 미설치"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "멀티 선택 메뉴 테스트를 시작합니다..."
echo ""
echo "💡 예상 동작:"
echo "   - Node.js: [-] 표시 (필수 또는 이미 설치)"
echo "   - 이미 설치된 패키지: [-] 표시 + '이미 설치됨' 텍스트"
echo "   - 미설치 패키지: [x] 표시 (선택 가능)"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Ask if user wants to proceed
read -p "계속하시겠습니까? (y/n): " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  echo "테스트 취소"
  exit 0
fi

# Run the actual package installation function
install_essential_packages

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🎉 테스트 완료!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "선택된 패키지 인덱스: ${MULTI_RESULT[@]}"
echo ""
