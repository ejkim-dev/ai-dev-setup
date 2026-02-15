# Terminal.app 프로파일 설치 문제 해결 과정

**날짜**: 2026-02-15
**문제**: Terminal.app의 Dev 프로파일을 설치할 때, 현재 실행 중인 터미널을 종료하지 않고 설정을 적용하는 방법 찾기

---

## 문제 배경

### 초기 상황
- `setup.sh`는 Terminal.app 프로파일(Dev.terminal)을 설치한 후 설정 적용을 위해 **Terminal.app을 강제 종료**했음
- 명령어: `osascript -e 'quit app "Terminal"'`

### 문제점
1. 사용자가 `setup.sh`를 실행 중인데 갑자기 터미널이 꺼짐
2. 설치 진행 상황을 볼 수 없음
3. 초보자에게 혼란스러운 UX
4. 스크립트 실행이 중단될 위험

### 목표
**새로운 소프트웨어 설치 없이**, 스크립트와 macOS 기본 명령어만으로:
- Terminal.app을 종료하지 않고
- Dev 프로파일을 임포트하고
- 기본 프로파일로 설정

---

## 시도한 방법들

### 방법 1: plist 직접 조작 + cfprefsd 재시작

**접근**:
```bash
# 1. plist 파일을 XML로 변환
plutil -convert xml1 ~/Library/Preferences/com.apple.Terminal.plist

# 2. PlistBuddy로 Dev 프로파일 추가
/usr/libexec/PlistBuddy -c "Add :Window\ Settings:Dev dict" "$PLIST"
/usr/libexec/PlistBuddy -c "Merge $DEV_TERMINAL :Window\ Settings:Dev" "$PLIST"

# 3. 기본값 설정
/usr/libexec/PlistBuddy -c "Set :Default\ Window\ Settings Dev" "$PLIST"

# 4. Binary로 변환
plutil -convert binary1 "$PLIST"

# 5. cfprefsd 재시작으로 설정 강제 동기화
killall cfprefsd

# 6. defaults read로 강제 로드
defaults read com.apple.Terminal >/dev/null
```

**결과**: ❌ **실패**

**문제점**:
- `killall cfprefsd` 실행 시 Terminal.app 프로세스가 종료됨
- `pgrep -x "Terminal"` 검증 시 프로세스가 감지되지 않음
- cfprefsd와 Terminal.app이 긴밀하게 연결되어 있어, cfprefsd 재시작이 Terminal.app에 영향을 줌

**테스트 파일**: `test-no-quit.sh`

---

### 방법 2: 조용한 설치 (cfprefsd 건드리지 않음)

**접근**:
```bash
# plist 파일만 수정하고 cfprefsd는 건드리지 않음
plutil -convert xml1 "$PLIST"
/usr/libexec/PlistBuddy -c "Add :Window\ Settings:Dev dict" "$PLIST"
/usr/libexec/PlistBuddy -c "Merge $DEV_TERMINAL :Window\ Settings:Dev" "$PLIST"
/usr/libexec/PlistBuddy -c "Set :Default\ Window\ Settings Dev" "$PLIST"
plutil -convert binary1 "$PLIST"

# cfprefsd 재시작 없음
# defaults read 강제 동기화 없음
```

**결과**: ❌ **부분 실패**

**검증 결과**:
- ✅ plist 파일 수정 성공
- ✅ `defaults read`로 확인하면 "Dev"로 설정됨
- ❌ Terminal.app UI에서 Dev 프로파일이 보이지 않음
- ❌ 새 창(⌘N)을 열어도 Dev 테마로 열리지 않음

**문제점**:
- Terminal.app이 **실행 중일 때는 plist 변경을 읽지 않음**
- Terminal.app은 시작할 때 plist를 읽고 메모리에 캐시
- 실행 중에는 plist 파일 변경을 감지하지 않음
- Terminal.app 재시작 후에만 적용됨 → 목표 달성 실패

**테스트 파일**: `test-silent-install.sh`

---

### 방법 3: open 명령 사용

**접근**:
```bash
open configs/mac/Dev.terminal
```

**결과**: ⚠️ **부분 성공**

**검증 결과**:
- ✅ Dev 프로파일이 Terminal.app Settings에 **즉시 나타남**
- ✅ Terminal.app이 실행 중이어도 프로파일 임포트 성공
- ❌ 기본 프로파일로는 설정되지 않음 (수동 클릭 필요)

**발견**:
- `open` 명령은 Terminal.app과 통신하여 프로파일을 동적으로 로드함
- macOS가 제공하는 공식 방법
- Terminal.app을 종료하지 않음

---

### 방법 4: open + defaults 조합 ✅ **최종 선택**

**접근**:
```bash
# 1. open으로 프로파일 임포트 (즉시 반영)
open configs/mac/Dev.terminal

# 2. defaults write로 기본값 설정 (plist 파일 변경)
defaults write com.apple.Terminal "Default Window Settings" -string "Dev"
defaults write com.apple.Terminal "Startup Window Settings" -string "Dev"
```

**결과**: ✅ **성공**

**검증 결과**:
1. **즉시 반영** (Terminal.app 실행 중):
   - ✅ Dev 프로파일이 Settings에 나타남
   - ✅ plist 파일에 기본값 설정됨
   - ❌ Settings UI에 "Default" 표시는 아직 안 나타남 (메모리 캐시 때문)
   - ❌ 새 창(⌘N)은 아직 이전 기본값으로 열림

2. **Terminal.app 재시작 후**:
   - ✅ Dev 테마로 자동 시작
   - ✅ Settings에서 Dev가 "Default"로 표시됨
   - ✅ 새 창(⌘N)이 Dev 테마로 열림

**장점**:
- Terminal.app을 강제 종료하지 않음
- setup.sh 실행 중에도 터미널이 유지됨
- 사용자가 설치 진행 상황을 계속 볼 수 있음
- 설치 완료 후 Terminal.app 재시작 시 자동 적용
- macOS 기본 명령어만 사용 (외부 의존성 없음)

**테스트 파일**: `test-open-defaults.sh`

---

## 최종 구현

### 코드
```bash
# Terminal.app Dev 프로파일 설치
if [ -f "$SCRIPT_DIR/configs/mac/Dev.terminal" ]; then
  echo "Installing Dev profile..."

  # 1. open으로 프로파일 임포트 (즉시 반영)
  open "$SCRIPT_DIR/configs/mac/Dev.terminal"

  # 2. defaults write로 기본값 설정 (재시작 후 적용)
  defaults write com.apple.Terminal "Default Window Settings" -string "Dev"
  defaults write com.apple.Terminal "Startup Window Settings" -string "Dev"

  echo "✅ Dev profile installed"
  echo ""
  echo "💡 Settings will be fully applied after restarting Terminal.app"
  echo "   (You can continue using the current terminal)"
fi
```

### 사용자 안내 메시지
```
✅ Dev 프로파일 설치 완료

💡 적용 방법:
   - 현재 터미널은 계속 사용 가능합니다
   - setup.sh 완료 후 Terminal.app을 재시작하면 Dev 테마가 기본값으로 적용됩니다

   또는 즉시 적용하려면:
   Settings(⌘,) → Profiles → Dev → "Default" 버튼 클릭
```

---

## 핵심 발견

### macOS Terminal.app 설정 메커니즘

1. **프로파일 임포트**:
   - `open *.terminal` → Terminal.app이 즉시 인식
   - Terminal.app의 공식 프로토콜 핸들러 사용
   - 실행 중에도 동적으로 프로파일 추가 가능

2. **기본값 설정**:
   - `defaults write` → plist 파일만 변경
   - Terminal.app은 **시작 시에만** plist를 읽음
   - 실행 중에는 메모리 캐시 사용
   - 재시작 후 적용

3. **cfprefsd의 역할**:
   - macOS 환경설정 데몬
   - plist 파일과 앱 간의 중개자
   - 재시작하면 Terminal.app에 영향을 줌 (권장하지 않음)

### Terminal.app이 실행 중일 때의 제약

| 작업 | plist 직접 수정 | cfprefsd 재시작 | open 명령 | defaults write |
|------|----------------|----------------|-----------|----------------|
| 프로파일 임포트 | ❌ (재시작 필요) | ⚠️ (Terminal 영향) | ✅ (즉시) | - |
| 기본값 설정 | ❌ (재시작 필요) | ⚠️ (Terminal 영향) | ❌ (불가능) | ⚠️ (재시작 필요) |
| Terminal 종료 위험 | ❌ (안전) | ⚠️ (위험) | ✅ (안전) | ✅ (안전) |

---

## 결론

**채택된 솔루션**: `open` + `defaults write` 조합

**이유**:
1. Terminal.app을 종료하지 않음 (핵심 요구사항)
2. 설치 진행 상황을 계속 볼 수 있음
3. macOS 기본 명령어만 사용 (외부 의존성 없음)
4. 재시작 후 완전히 적용됨 (사용자가 선택 가능)
5. AppleScript 불필요 (사용자 선호도 반영)

**트레이드오프**:
- 즉시 완전한 적용은 불가능 (재시작 필요)
- 하지만 setup.sh 실행 중 터미널 유지라는 핵심 목표 달성
- 사용자에게 명확한 안내 제공으로 UX 개선

---

## 참고 파일

테스트 스크립트 위치: `.claude/notes/tests/`

- `test-no-quit.sh` - 방법 1 테스트 (cfprefsd 재시작)
- `test-silent-install.sh` - 방법 2 테스트 (조용한 설치)
- `test-open-defaults.sh` - 방법 4 테스트 (최종 솔루션)

각 테스트를 실행해보고 싶다면:
```bash
cd /path/to/dev-setup
./.claude/notes/tests/test-open-defaults.sh  # 최종 솔루션 테스트
```

---

## 향후 개선 가능성

1. **AppleScript 활용** (현재는 사용 안 함):
   ```applescript
   tell application "Terminal"
       set default settings to settings set "Dev"
   end tell
   ```
   - 실행 중에도 기본값 즉시 설정 가능
   - 하지만 사용자가 AppleScript 사용을 선호하지 않음

2. **사용자 선택 옵션 제공**:
   ```bash
   echo "Apply Dev theme immediately?"
   echo "  Y) Yes (Terminal.app will restart)"
   echo "  N) No (apply on next restart)"
   ```

3. **iTerm2 지원** (별도 로직 필요):
   - iTerm2는 다른 설정 메커니즘 사용
   - plist 파일 위치 및 구조 다름

---

**작성자**: Claude Code
**검증 완료**: 2026-02-15
**macOS 버전**: Darwin 24.6.0

---

## Git Commit

**적용 커밋**: (다음 커밋)
```
feat: use open+defaults for Terminal.app profile installation

- Replace plist manipulation with 'open' command for profile import
- Remove cfprefsd restart to prevent Terminal.app interruption
- Users can see installation progress without terminal closing
- Settings fully applied after Terminal.app restart
- Update user messages in all locales (en, ko, ja)
```

**변경된 파일**:
- `setup.sh` - `import_terminal_profile()` 함수 교체 (62줄 → 27줄)
- `claude-code/locale/en.sh` - 영어 메시지
- `claude-code/locale/ko.sh` - 한국어 메시지
- `claude-code/locale/ja.sh` - 일본어 메시지
