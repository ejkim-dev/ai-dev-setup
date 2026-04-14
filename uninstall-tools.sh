#!/bin/bash
#
# Phase 1 tool uninstall script
# Warning: This script removes all items installed during Phase 1!
#

set -e

# Color codes
color_bold_cyan="\033[1;36m"
color_reset="\033[0m"

# Arrow key menu selector
# Usage: select_menu "Option 1" "Option 2" "Option 3"
# Result: MENU_RESULT (0-based index)
select_menu() {
  local options=("$@")
  local count=${#options[@]}
  local selected=${MENU_DEFAULT:-0}
  local key
  MENU_DEFAULT=""

  # Open /dev/tty for reading (allows interactive input when run via curl | bash)
  exec 3</dev/tty

  tput civis 2>/dev/null
  trap 'tput cnorm 2>/dev/null; exec 3<&-' EXIT

  for i in "${!options[@]}"; do
    if [ "$i" -eq $selected ]; then
      echo -e "  ${color_bold_cyan}▸ ${options[$i]}${color_reset}"
    else
      echo -e "    ${options[$i]}"
    fi
  done

  while true; do
    IFS= read -rsn1 key <&3
    case "$key" in
      $'\x1b')
        IFS= read -rsn2 key <&3
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

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🧹 Phase 1 설치 항목 정리"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "⚠️  경고: 다음 항목들이 제거됩니다:"
echo ""
echo "  1. Homebrew 패키지 (Node.js, ripgrep, D2Coding, zsh plugins)"
echo "  2. Oh My Zsh"
echo "  3. .zshrc 설정"
echo "  4. .tmux.conf"
echo "  5. Terminal.app Dev 프로필"
echo "  6. AI CLI 도구 (Claude Code, Gemini CLI 등)"
echo "  7. Phase 2 관련 파일 (~/claude-code-setup/, ~/claude-workspace/)"
echo "  8. Obsidian"
echo ""
echo "  ❌ Homebrew 자체는 제거하지 않습니다 (시스템에서 사용 중일 수 있음)"
echo "  ❌ Xcode Command Line Tools는 제거하지 않습니다"
echo ""

select_menu "진행" "취소"
if [ "$MENU_RESULT" -ne 0 ]; then
  echo "취소되었습니다."
  exit 0
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "정리 시작..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# 1. Remove AI CLI tools
echo "[1/8] AI CLI 도구 제거..."
if command -v npm &>/dev/null || command -v gh &>/dev/null; then
  echo "AI CLI 도구를 제거하시겠습니까?"
  select_menu "제거" "건너뛰기"
  if [ "$MENU_RESULT" -eq 0 ]; then
    if command -v npm &>/dev/null; then
      npm uninstall -g @anthropic-ai/claude-code 2>/dev/null || true
      npm uninstall -g @google/gemini-cli 2>/dev/null || true
      npm uninstall -g @openai/codex 2>/dev/null || true
    fi
    # Note: GitHub Copilot CLI is now integrated into gh CLI (as of 2026-01-14)
    # The separate gh-copilot extension is deprecated and no longer needs removal
    echo "  ✅ AI CLI 도구 제거 완료"
  else
    echo "  ⏭️  건너뜀"
  fi
else
  echo "  ⏭️  설치된 AI 도구 없음"
fi

echo ""

# 2. Remove Homebrew packages
echo "[2/8] Homebrew 패키지 제거..."
if command -v brew &>/dev/null; then
  echo "Homebrew 패키지를 제거하시겠습니까?"
  echo "(폰트, zsh plugins, tmux, ripgrep 등)"
  select_menu "제거" "건너뛰기"
  if [ "$MENU_RESULT" -eq 0 ]; then
    # Fonts
    brew uninstall --cask font-d2coding 2>/dev/null || true

    # Packages
    brew uninstall zsh-syntax-highlighting 2>/dev/null || true
    brew uninstall zsh-autosuggestions 2>/dev/null || true
    brew uninstall tmux 2>/dev/null || true
    brew uninstall ripgrep 2>/dev/null || true

    # Node.js is optional (may be used for other purposes)
    echo ""
    echo "  Node.js도 제거하시겠습니까?"
    select_menu "제거" "건너뛰기"
    if [ "$MENU_RESULT" -eq 0 ]; then
      brew uninstall node 2>/dev/null || true
      echo "  ✅ Node.js 제거됨"
    else
      echo "  ⏭️  Node.js 건너뜀"
    fi

    echo "  ✅ Homebrew 패키지 제거 완료"
  else
    echo "  ⏭️  건너뜀"
  fi
else
  echo "  ⏭️  Homebrew 없음, 건너뜀"
fi

echo ""

# 3. Remove Oh My Zsh
echo "[3/8] Oh My Zsh 제거..."
if [ -d "$HOME/.oh-my-zsh" ]; then
  echo "Oh My Zsh를 제거하시겠습니까?"
  select_menu "제거" "건너뛰기"
  if [ "$MENU_RESULT" -eq 0 ]; then
    # Direct removal (uninstall.sh may wait for input)
    rm -rf "$HOME/.oh-my-zsh"

    # Also remove custom folder
    rm -rf "$HOME/.oh-my-zsh.custom" 2>/dev/null || true

    echo "  ✅ Oh My Zsh 제거 완료"
  else
    echo "  ⏭️  건너뜀"
  fi
else
  echo "  ⏭️  Oh My Zsh 없음, 건너뜀"
fi

echo ""

# 4. Backup and restore .zshrc
echo "[4/8] .zshrc 정리..."
if [ -f "$HOME/.zshrc" ]; then
  # Remove ai-dev-setup section
  if grep -q "=== ai-dev-setup ===" "$HOME/.zshrc" 2>/dev/null; then
    # Backup (overwrites previous backup)
    cp "$HOME/.zshrc" "$HOME/.zshrc.backup"

    # Delete ai-dev-setup section
    sed -i.tmp '/# === ai-dev-setup ===/,/# === End ai-dev-setup ===/d' "$HOME/.zshrc" 2>/dev/null || true
    rm -f "$HOME/.zshrc.tmp"

    echo "  ✅ .zshrc에서 ai-dev-setup 설정 제거"
    echo "  📝 백업: ~/.zshrc.backup"
  else
    echo "  ℹ️  .zshrc에 ai-dev-setup 설정 없음"
  fi

  # Restore .zshrc.pre-oh-my-zsh
  if [ -f "$HOME/.zshrc.pre-oh-my-zsh" ]; then
    echo ""
    echo "  원래 .zshrc로 복원하시겠습니까?"
    select_menu "복원" "건너뛰기"
    if [ "$MENU_RESULT" -eq 0 ]; then
      mv "$HOME/.zshrc.pre-oh-my-zsh" "$HOME/.zshrc"
      echo "  ✅ 원래 .zshrc 복원 완료"
    fi
  fi
else
  echo "  ⏭️  .zshrc 없음"
fi

echo ""

# 5. Remove .tmux.conf
echo "[5/8] .tmux.conf 제거..."
if [ -f "$HOME/.tmux.conf" ]; then
  echo ".tmux.conf를 제거하시겠습니까?"
  select_menu "제거" "건너뛰기"
  if [ "$MENU_RESULT" -eq 0 ]; then
    # Backup (overwrites previous backup)
    cp "$HOME/.tmux.conf" "$HOME/.tmux.conf.backup"
    rm "$HOME/.tmux.conf"
    echo "  ✅ .tmux.conf 제거 완료"
    echo "  📝 백업: ~/.tmux.conf.backup"
  else
    echo "  ⏭️  건너뜀"
  fi
else
  echo "  ⏭️  .tmux.conf 없음"
fi

echo ""

# 6. Remove Terminal.app Dev profile
echo "[6/8] Terminal.app Dev 프로필 제거..."
if defaults read com.apple.Terminal "Window Settings" &>/dev/null; then
  if defaults read com.apple.Terminal "Window Settings" | grep -q "Dev" 2>/dev/null; then
    echo "Terminal.app Dev 프로필을 제거하시겠습니까?"
    select_menu "제거" "건너뛰기"
    if [ "$MENU_RESULT" -eq 0 ]; then
      # Remove Dev profile
      defaults delete com.apple.Terminal "Window Settings.Dev" 2>/dev/null || true

      # Reset default to Basic
      defaults write com.apple.Terminal "Default Window Settings" -string "Basic"
      defaults write com.apple.Terminal "Startup Window Settings" -string "Basic"

      echo "  ✅ Terminal.app Dev 프로필 제거 완료"
    else
      echo "  ⏭️  건너뜀"
    fi
  else
    echo "  ℹ️  Dev 프로필 없음"
  fi
else
  echo "  ⏭️  Terminal.app 설정 없음"
fi

echo ""

# 7. Remove Phase 2 files
echo "[7/8] Phase 2 관련 파일 제거..."
if [ -d "$HOME/claude-code-setup" ] || [ -d "$HOME/claude-workspace" ]; then
  echo "Phase 2 관련 파일을 제거하시겠습니까?"
  echo "(~/claude-code-setup/, ~/claude-workspace/)"
  select_menu "제거" "건너뛰기"
  if [ "$MENU_RESULT" -eq 0 ]; then
    rm -rf "$HOME/claude-code-setup" 2>/dev/null || true
    rm -rf "$HOME/claude-workspace" 2>/dev/null || true
    echo "  ✅ Phase 2 파일 제거 완료"
  else
    echo "  ⏭️  건너뜀"
  fi
else
  echo "  ⏭️  Phase 2 파일 없음"
fi

echo ""

# 8. Remove Obsidian
echo "[8/8] Obsidian 제거..."
if [ -d "/Applications/Obsidian.app" ]; then
  echo "Obsidian을 제거하시겠습니까?"
  select_menu "제거" "건너뛰기"
  if [ "$MENU_RESULT" -eq 0 ]; then
    brew uninstall --cask obsidian 2>/dev/null || true
    rm -rf "/Applications/Obsidian.app" 2>/dev/null || true
    echo "  ✅ Obsidian 제거 완료"
  else
    echo "  ⏭️  건너뜀"
  fi
else
  echo "  ⏭️  Obsidian 없음"
fi

echo ""

# Additional cleanup options
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "추가 정리 옵션"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "다음 항목들도 제거하시겠습니까?"
echo ""

# Remove iTerm2
if [ -d "/Applications/iTerm.app" ]; then
  echo "iTerm2를 제거하시겠습니까?"
  MENU_DEFAULT=1 select_menu "제거" "건너뛰기"
  if [ "$MENU_RESULT" -eq 0 ]; then
    brew uninstall --cask iterm2 2>/dev/null || true
    rm -rf "/Applications/iTerm.app" 2>/dev/null || true
    echo "  ✅ iTerm2 제거 완료"
  else
    echo "  ⏭️  iTerm2 건너뜀"
  fi
else
  echo "  ⏭️  iTerm2 없음"
fi

# Remove Homebrew
if command -v brew &>/dev/null; then
  echo ""
  echo "Homebrew를 완전히 제거하시겠습니까?"
  MENU_DEFAULT=1 select_menu "제거" "건너뛰기"
  if [ "$MENU_RESULT" -eq 0 ]; then
    echo "  Homebrew 제거 중... (시간이 걸릴 수 있습니다)"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)" -- --force

    # Completely remove Homebrew directories
    sudo rm -rf /opt/homebrew 2>/dev/null || true
    sudo rm -rf /usr/local/Homebrew 2>/dev/null || true

    # Remove Homebrew from PATH
    if [ -f "$HOME/.zprofile" ]; then
      sed -i.tmp '/homebrew/d' "$HOME/.zprofile" 2>/dev/null || true
      rm -f "$HOME/.zprofile.tmp"
    fi

    echo "  ✅ Homebrew 제거 완료"
  else
    echo "  ⏭️  Homebrew 건너뜀"
  fi
fi

# Remove Xcode Command Line Tools
if xcode-select -p &>/dev/null; then
  echo ""
  echo "Xcode Command Line Tools를 제거하시겠습니까?"
  MENU_DEFAULT=1 select_menu "제거" "건너뛰기"
  if [ "$MENU_RESULT" -eq 0 ]; then
    echo "  Xcode Command Line Tools 제거 중..."
    sudo rm -rf /Library/Developer/CommandLineTools
    echo "  ✅ Xcode Command Line Tools 제거 완료"
  else
    echo "  ⏭️  Xcode Command Line Tools 건너뜀"
  fi
fi

# Clean up backup files
backup_files=()
for f in "$HOME"/.zshrc.backup* "$HOME"/.tmux.conf.backup* "$HOME"/.zshrc.pre-oh-my-zsh; do
  [ -f "$f" ] && backup_files+=("$f")
done

if [ ${#backup_files[@]} -gt 0 ]; then
  echo ""
  echo "📝 백업 파일이 ${#backup_files[@]}개 있습니다:"
  for f in "${backup_files[@]}"; do
    echo "  - ${f/#$HOME/~}"
  done
  echo ""
  echo "백업 파일을 삭제하시겠습니까?"
  select_menu "삭제" "유지"
  if [ "$MENU_RESULT" -eq 0 ]; then
    for f in "${backup_files[@]}"; do
      rm -f "$f"
    done
    echo "  ✅ 백업 파일 삭제 완료"
  else
    echo "  ⏭️  백업 유지"
  fi
fi

# Done
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ 정리 완료!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "🔄 이제 ./setup.sh를 다시 실행하여 깨끗한 상태에서 테스트할 수 있습니다."
echo ""
