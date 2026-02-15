# UI/UX & Code Quality Checklist

## Purpose
기획 변경 시 자동으로 체크해야 할 항목들. 일관성 있는 사용자 경험과 유지보수 가능한 코드를 위한 가이드라인.

---

## 1. UI/UX 통일성 체크

### 1.1 메뉴 패턴 통일
**규칙**: 모든 선택 메뉴는 동일한 포맷 사용

**올바른 패턴**:
```bash
# 단일 선택 (select_menu)
select_menu "Option 1" "Option 2" "Option 3"

# 다중 선택 (select_multi)
local opt_item="$MSG_ITEM - 설명"
[ $installed -eq 1 ] && opt_item="$opt_item - $MSG_ALREADY_INSTALLED"
[ $required -eq 1 ] && opt_item="$opt_item ($MSG_REQUIRED)"

MULTI_DEFAULTS="0 1" DISABLED_ITEMS="2" select_multi \
  "$opt_item1" \
  "$opt_item2" \
  "$opt_item3"
```

**체크 포인트**:
- [ ] 옵션 라벨 포맷: `"이름 - 설명 (상태)"`
- [ ] 상태 표시: `(필수)`, `(추천)`, `- 이미 설치됨`
- [ ] Locale 변수 사용: 하드코딩 금지
- [ ] 일관된 구분자: `-` (하이픈-공백)

**잘못된 예시**:
```bash
# ❌ 하드코딩
select_multi "local-rag    📚 Search your docs/code (recommended)"

# ❌ 불일치한 포맷
select_multi "Node.js (required)" "ripgrep - fast search"

# ❌ 이모지만 사용 (설명 없음)
select_multi "📚 local-rag" "📝 filesystem"
```

### 1.2 메시지 출력 패턴
**규칙**: echo 출력 시 일관된 들여쓰기 및 구조

**올바른 패턴**:
```bash
echo ""
echo -e "${color_cyan}[1/4] $MSG_SECTION_TITLE${color_reset}"
echo ""
echo "  $MSG_DESC_1"
echo "  $MSG_DESC_2"
echo ""
```

**체크 포인트**:
- [ ] 섹션 타이틀: `[n/N] $MSG_TITLE` 형식
- [ ] 설명: 2칸 들여쓰기
- [ ] 색상: cyan (섹션), green (성공), yellow (경고)
- [ ] 빈 줄: 섹션 전후로 한 줄씩

### 1.3 상태 메시지 통일
**규칙**: 성공/실패/건너뛰기 메시지 통일

**올바른 패턴**:
```bash
done_msg()  # ✅ Done / 완료
skip_msg()  # ⏭  Skipped / 건너뜀
# ❌ Failed 메시지는 구체적 에러 포함
```

**체크 포인트**:
- [ ] `done_msg` 사용 (직접 echo 금지)
- [ ] `skip_msg` 사용 (직접 echo 금지)
- [ ] 에러 메시지: 구체적 해결 방법 포함

---

## 2. 하드코딩 체크

### 2.1 텍스트 하드코딩
**규칙**: 사용자에게 보이는 모든 텍스트는 locale 파일 사용

**체크 포인트**:
- [ ] `echo` 안에 직접 한글/영어/일본어 없음
- [ ] 모든 메시지 `$MSG_*` 변수 사용
- [ ] 3개 언어 모두 locale 파일에 존재
  - `locale/en.sh`
  - `locale/ko.sh`
  - `locale/ja.sh`

**잘못된 예시**:
```bash
# ❌ 하드코딩
echo "설치를 시작합니다..."
echo "Install Node.js? [Y/n]"

# ✅ Locale 사용
echo "$MSG_INSTALL_START"
ask_yn "$MSG_INSTALL_NODE"
```

**자동 체크 명령어**:
```bash
# 하드코딩된 한글 찾기
grep -n "echo.*[가-힣]" setup.sh modules/*.sh

# 하드코딩된 영어 메시지 찾기 (MSG_ 없이)
grep -n 'echo.*"[A-Z]' setup.sh modules/*.sh | grep -v '\$MSG_'
```

### 2.2 경로 하드코딩
**규칙**: 절대 경로 하드코딩 금지, 변수 사용

**체크 포인트**:
- [ ] `$HOME` 사용 (✅)
- [ ] `$SCRIPT_DIR` 사용 (✅)
- [ ] `$WORKSPACE` 사용 (✅)
- [ ] `/Users/username` 직접 사용 (❌)

**올바른 예시**:
```bash
# ✅ 변수 사용
WORKSPACE="$HOME/claude-workspace"
CONFIG_FILE="$WORKSPACE/config.json"

# ❌ 하드코딩
CONFIG_FILE="/Users/ejkim/claude-workspace/config.json"
```

### 2.3 명령어 하드코딩
**규칙**: 반복되는 명령어는 함수화

**체크 포인트**:
- [ ] `brew install` → `install_brew_package()` 사용
- [ ] `npm install -g` → `install_npm_global()` 사용
- [ ] 3번 이상 반복되는 패턴은 함수화

---

## 3. 코드 역할 분리

### 3.1 단일 책임 원칙
**규칙**: 함수는 한 가지 일만 함

**체크 포인트**:
- [ ] 함수 이름이 동작을 명확히 설명
- [ ] 함수 길이 < 50 줄 (권장)
- [ ] 함수가 여러 작업을 하면 분리

**잘못된 예시**:
```bash
# ❌ 너무 많은 역할
install_and_configure_everything() {
  install_homebrew
  install_packages
  setup_terminal
  setup_shell
  setup_git
  create_config_file
}

# ✅ 역할 분리
install_homebrew() { ... }
install_packages() { ... }
setup_terminal() { ... }
# 각각 독립적으로 호출
```

### 3.2 모듈 분리
**규칙**: 기능별로 파일 분리

**현재 구조** (✅ 잘 분리됨):
```
lib/
├── colors.sh      # 색상 정의만
├── core.sh        # 핵심 유틸리티만
├── ui.sh          # UI 함수만
└── installer.sh   # 설치 래퍼만

modules/
├── xcode.sh       # Xcode 관련만
├── homebrew.sh    # Homebrew 관련만
├── packages.sh    # 패키지 설치만
├── terminal.sh    # 터미널 설정만
├── shell.sh       # 쉘 설정만
└── ai-tools.sh    # AI 도구만
```

**체크 포인트**:
- [ ] 한 파일이 여러 도메인 담당하지 않음
- [ ] 의존성 순서 명확 (`source` 순서)
- [ ] 순환 의존성 없음

### 3.3 변수 스코프
**규칙**: 전역 변수 최소화, local 사용

**올바른 예시**:
```bash
# ✅ 함수 내 local 사용
install_package() {
  local package="$1"
  local display_name="${2:-$package}"
  local result=0
  ...
}

# ❌ 전역 변수 남용
package="$1"
display_name="${2:-$package}"
```

**체크 포인트**:
- [ ] 함수 내 변수는 `local` 선언
- [ ] 전역 변수: 대문자 (예: `WORKSPACE`, `CONFIG_FILE`)
- [ ] 지역 변수: 소문자 (예: `package`, `result`)

---

## 4. 자동 체크 스크립트

### 4.1 하드코딩 체크
```bash
#!/bin/bash
# .claude/tools/check-hardcoding.sh

echo "🔍 Checking for hardcoded strings..."

# 한글 하드코딩
echo "1. Korean hardcoding:"
grep -n "echo.*[가-힣]" setup.sh modules/*.sh claude-code/setup-claude.sh 2>/dev/null | grep -v '\$MSG_' || echo "  ✅ None found"

# 영어 하드코딩 (MSG_ 없이)
echo "2. English hardcoding:"
grep -n 'echo "' setup.sh modules/*.sh claude-code/setup-claude.sh 2>/dev/null | grep -v '\$MSG_' | grep -v '━' | grep -v '^[[:space:]]*#' || echo "  ✅ None found"

# 경로 하드코딩
echo "3. Path hardcoding:"
grep -n '"/Users/' setup.sh modules/*.sh claude-code/setup-claude.sh 2>/dev/null | grep -v '\$HOME' || echo "  ✅ None found"
```

### 4.2 패턴 통일 체크
```bash
#!/bin/bash
# .claude/tools/check-patterns.sh

echo "🎨 Checking UI/UX patterns..."

# select_multi 사용 체크
echo "1. select_multi usage:"
grep -A 5 "select_multi" setup.sh modules/*.sh claude-code/setup-claude.sh 2>/dev/null | grep -v "local opt_" && echo "  ⚠️  Hardcoded options found" || echo "  ✅ All use variables"

# 섹션 타이틀 포맷 체크
echo "2. Section title format:"
grep -n '\[.*\]' setup.sh modules/*.sh claude-code/setup-claude.sh 2>/dev/null | grep -v '\$MSG_' && echo "  ⚠️  Hardcoded titles found" || echo "  ✅ All use MSG_ variables"
```

### 4.3 locale 완성도 체크
```bash
#!/bin/bash
# .claude/tools/check-locale.sh

echo "🌐 Checking locale completeness..."

# en.sh의 MSG_ 변수 추출
EN_VARS=$(grep "^MSG_" claude-code/locale/en.sh | cut -d'=' -f1 | sort)

# ko.sh와 비교
echo "1. Korean (ko.sh):"
KO_VARS=$(grep "^MSG_" claude-code/locale/ko.sh | cut -d'=' -f1 | sort)
diff <(echo "$EN_VARS") <(echo "$KO_VARS") && echo "  ✅ Complete" || echo "  ⚠️  Missing messages"

# ja.sh와 비교
echo "2. Japanese (ja.sh):"
JA_VARS=$(grep "^MSG_" claude-code/locale/ja.sh | cut -d'=' -f1 | sort)
diff <(echo "$EN_VARS") <(echo "$JA_VARS") && echo "  ✅ Complete" || echo "  ⚠️  Missing messages"
```

---

## 5. 기획 변경 시 체크리스트

새로운 기능 추가 또는 UI 변경 시:

### Phase 1: 설계
- [ ] 기존 패턴 확인 (이 문서 참조)
- [ ] 비슷한 기능이 있는지 확인
- [ ] 재사용 가능한 함수 확인

### Phase 2: 구현
- [ ] Locale 메시지 먼저 추가 (en, ko, ja)
- [ ] 함수는 50줄 이하로 유지
- [ ] 반복 코드는 함수화
- [ ] select_multi 사용 시 변수로 옵션 구성

### Phase 3: 검토
- [ ] 하드코딩 체크 스크립트 실행
- [ ] 패턴 통일 체크 스크립트 실행
- [ ] locale 완성도 체크 스크립트 실행
- [ ] 3개 언어 모두 테스트

### Phase 4: 커밋 전
- [ ] `bash -n script.sh` (문법 체크)
- [ ] 관련 있는 변경은 한 커밋에
- [ ] 커밋 메시지에 패턴 변경 명시

---

## 6. 자주하는 실수

### 실수 1: 하드코딩 후 locale 추가
**문제**: 코드 먼저 작성 → 나중에 locale로 옮기기
**해결**: locale 메시지 먼저 추가 → 코드에서 사용

### 실수 2: 일부 언어만 업데이트
**문제**: en.sh만 수정, ko.sh/ja.sh는 빠뜨림
**해결**: 3개 파일 동시에 편집, check-locale.sh 실행

### 실수 3: 패턴 불일치
**문제**: packages.sh는 "이름 - 설명", ai-tools.sh는 "이름 (설명)"
**해결**: 기존 코드 패턴 먼저 확인, 동일하게 적용

### 실수 4: 너무 긴 함수
**문제**: 100줄+ 함수에 모든 로직
**해결**: 기능별로 함수 분리, 메인 함수는 orchestration만

---

## 7. 자동화 통합

### Git Hook (pre-commit)
```bash
#!/bin/bash
# .git/hooks/pre-commit

# 체크 스크립트 실행
.claude/tools/check-hardcoding.sh
.claude/tools/check-patterns.sh
.claude/tools/check-locale.sh

# 실패 시 커밋 중단
if [ $? -ne 0 ]; then
  echo "❌ Quality checks failed. Please fix issues before committing."
  exit 1
fi
```

### Claude Code 사용 시
CLAUDE.md에 이 체크리스트 참조 추가:
```markdown
## Code Quality

Before making changes, review:
- `.claude/notes/ui-ux-checklist.md` - UI/UX patterns and quality checks
```

---

## 8. 빠른 참조

### 메뉴 옵션 포맷
```
"이름 - 설명 (상태)"
 ↑    ↑ ↑     ↑
 |    | |     └─ (필수), (추천), - 이미 설치됨
 |    | └─────── 공백
 |    └─────────── 하이픈
 └──────────────── locale 변수
```

### 색상 사용
```
cyan    → 섹션 타이틀
green   → 성공
yellow  → 경고/건너뜀
red     → 에러
```

### 함수 이름 규칙
```
동사_명사()          예: install_package, setup_terminal
check_상태()         예: check_installed
ask_질문()           예: ask_yn
```
