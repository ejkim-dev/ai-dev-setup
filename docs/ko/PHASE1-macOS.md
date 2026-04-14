# Phase 1: 기본 개발 환경 (macOS)

macOS에서 필수 개발 도구와 터미널 환경을 설정합니다.

**Windows 사용자?** → [Windows 가이드 보기](PHASE1-windows.md)

## 개요

**목표**: 패키지 관리자, 개발 도구, 터미널 테마, 쉘 커스터마이징 설치

**대상 사용자**:
- 터미널 초보자
- 새 Mac 세팅
- 일관된 개발 환경을 원하는 분

**소요 시간**: 15-30분 (인터넷 속도에 따라 다름)

---

## 설치되는 항목 (macOS)

| 도구 | 설명 | 설치 |
|------|------|:----:|
| **Xcode Command Line Tools** | Git, make, gcc 등 개발 도구 | ✅ |
| **Homebrew** | 패키지 관리자 | ✅ |
| **Node.js** | JavaScript 런타임 (필수) | ✅ |
| **ripgrep** | 빠른 코드 검색 도구 | ✅ |
| **D2Coding 폰트** | 한글 지원 코딩 폰트 | ✅ |
| **zsh-autosuggestions** | 명령어 자동 완성 | ✅ |
| **zsh-syntax-highlighting** | 문법 강조 | ✅ |
| **Terminal.app 테마** | 다크 테마 프로필 | ✅ |
| **iTerm2** | 고급 터미널 (선택) | ⚪ |
| **Oh My Zsh** | 쉘 테마 + 플러그인 | ✅ |
| **tmux** | 터미널 멀티플렉서 | ✅ |

---

## 설치 단계

### 시작하기 전에: 터미널 열기

**방법 1: Spotlight 검색 (권장)**
1. `Cmd + Space` 누르기
2. `terminal` 입력
3. Enter 누르기

**방법 2: Finder 사용**
1. Finder 열기
2. 응용 프로그램 → 유틸리티로 이동
3. "Terminal" 더블클릭

**방법 3: LaunchPad 사용**
1. Dock의 LaunchPad 아이콘 클릭
2. "Terminal" 검색
3. "Terminal" 클릭

---

### Step 0: 언어 선택

시작 시 원하는 언어를 선택합니다:

```
Select your language:

  ▸ English
    한국어
    日本語
```

- 이동: ↑↓ 화살표 키
- 선택: Enter
- 선택한 언어는 `~/.dev-setup-lang`에 저장되어 다음 실행 시 사용됩니다

---

### Step 1: Xcode Command Line Tools

**역할**: Git, make, gcc 등 필수 개발 도구 설치

**자동 감지**: 이미 설치되어 있으면 자동으로 건너뜁니다

**미설치 시**:
```
[1/7] Xcode Command Line Tools

  Git, make 등 개발 도구에 필요합니다.

  ▸ Xcode Command Line Tools 설치
    건너뛰기 (설치 실패함)
```

**설치**: GUI 대화상자가 나타납니다. "설치"를 클릭하고 라이선스에 동의합니다.

**에러 처리**:
- 이미 설치 중: "설치 진행 중" 메시지 표시
- 설치 실패: 재시도 방법 안내

---

### Step 2: Homebrew (패키지 관리자)

**역할**: Homebrew 패키지 관리자 설치

**자동 감지**: 이미 설치되어 있으면 자동으로 건너뜁니다

**미설치 시**:
```
[2/7] Homebrew (패키지 관리자)

  개발 도구 설치에 필수입니다.
  공식 사이트: https://brew.sh

  ▸ Homebrew 설치
    건너뛰기 (패키지 설치 불가)
```

**역할**: 공식 스크립트에서 Homebrew를 다운로드하고 설치합니다

**설치 후**: Apple Silicon Mac의 경우 자동으로 Homebrew를 PATH에 추가합니다

---

### Step 3: 필수 패키지

**화살표 키 선택 메뉴**:

```
[3/7] 필수 패키지

  설치할 패키지를 선택하세요:

  ▸ [x] Node.js - JavaScript 런타임 (필수)
    [x] ripgrep - 빠른 코드 검색
    [x] D2Coding 폰트 - 한글 코딩 폰트
    [x] zsh-autosuggestions - 명령어 자동 완성
    [x] zsh-syntax-highlighting - 문법 강조

  ↑↓: 이동 | Space: 선택/해제 | Enter: 확인
```

**특징**:
- **필수 항목**: Node.js는 선택 해제 불가 (AI 도구 필수)
- **이미 설치됨**: "- 이미 설치됨" 표시되고 비활성화됨
- **기본 선택**: 모든 패키지가 기본으로 선택됨
- **설치**: 선택한 패키지들을 Homebrew로 설치합니다

**패키지 상세**:

#### Node.js (필수)
- JavaScript 런타임 환경
- Claude Code 및 기타 AI 도구 필수
- npm (패키지 관리자) 포함

#### ripgrep
- grep보다 빠른 코드 검색 도구
- 최신 개발 도구에서 사용됨

#### D2Coding 폰트
- 모노스페이스 코딩 폰트
- 한글 문자 지원 우수
- 가독성이 좋고 깔끔한 디자인

#### zsh-autosuggestions
- 명령어 히스토리 기반 자동 완성 제안
- → 키를 눌러 제안 수용
- 터미널 작업 속도 향상

#### zsh-syntax-highlighting
- 유효/무효한 명령어 강조 표시
- 초록색 = 유효한 명령어
- 빨간색 = 무효한 명령어

---

### Step 4: 터미널 설정

사용할 터미널 애플리케이션을 선택합니다:

```
[4/7] 터미널 설정

  터미널 애플리케이션 선택:

  ▸ Terminal.app만 (Dev 테마 적용)
    iTerm2만
    Terminal.app + iTerm2 둘 다
    건너뛰기
```

**옵션 1: Terminal.app만**
- Dev 다크 테마 프로필 적용
- D2Coding 폰트 설정 (11pt)
- 커스텀 색상 스키마 적용
- 기본 프로필로 설정

**옵션 2: iTerm2만**
- Homebrew로 iTerm2 설치
- Dev 프로필 적용
- D2Coding 폰트 설정

**옵션 3: 둘 다**
- Terminal.app과 iTerm2 모두 설정
- 필요에 따라 언제든지 전환 가능

**옵션 4: 건너뛰기**
- 터미널 설정 없음
- 기존 설정 유지

**폰트 확인**: D2Coding 폰트가 설치되지 않았으면 테마 적용 전 설치 제안

---

### Step 5: 쉘 커스터마이징

#### 부분 1: Oh My Zsh 설치

아직 설치되지 않았으면:

```
[5/7] 쉘 설정

  Oh My Zsh는 zsh을 위한 멋진 테마와 플러그인을 제공합니다.

  ▸ Oh My Zsh 설치
    건너뛰기
```

**역할**: zsh용 Oh My Zsh 프레임워크를 다운로드하고 설치합니다

#### 부분 2: .zshrc 커스터마이징

**쉘 기능 선택 메뉴**:

```
  .zshrc 커스터마이징

  ▸ [x] agnoster 테마 + 랜덤 이모지
    [x] 명령어 자동 완성 설정
    [x] 문법 강조 설정
    [ ] 유용한 별칭 (ll, gs, gl)

  ↑↓: 이동 | Space: 선택/해제 | Enter: 확인
```

**자동 연결 기능**:
- Step 3에서 zsh-autosuggestions 설치했으면 자동 선택
- Step 3에서 zsh-syntax-highlighting 설치했으면 자동 선택
- 미설치 시 "설치되지 않음" 표시되고 비활성화됨

**커스터마이징 상세**:

#### agnoster 테마 + 이모지
- 현재 디렉토리 및 Git 브랜치 표시
- 프롬프트에 랜덤 이모지 (매 세션마다 변경)
- 색상으로 Git 상태 표시

#### 명령어 자동 완성
- Homebrew 위치에서 zsh-autosuggestions 적용
- Step 3에서 설치했을 때만 사용 가능

#### 문법 강조
- Homebrew 위치에서 zsh-syntax-highlighting 적용
- Step 3에서 설치했을 때만 사용 가능

#### 유용한 별칭
- `ll` → `ls -la` (상세 파일 목록)
- `gs` → `git status`
- `gl` → `git log --oneline -20`

**적용 방식**: 선택한 설정이 `~/.zshrc`에 다음과 같이 추가됩니다:
```bash
# === ai-dev-setup ===
[커스터마이징 설정]
# === End ai-dev-setup ===
```

---

### Step 6: tmux (터미널 멀티플렉서)

창 분할 및 세션 관리용 터미널 멀티플렉서입니다.

```
[6/7] tmux (터미널 멀티플렉서)

  터미널 창을 분할하고 세션을 관리합니다.

  ▸ tmux 설치
    건너뛰기
```

**역할**:
- Homebrew로 tmux 설치
- `.tmux.conf` 설정 파일을 홈 디렉토리에 복사
- 창 분할, 세션 관리 등 사용 가능

**기본 tmux 명령어** (설치 후):
- `tmux` - 새 세션 시작
- `Ctrl+b %` - 세로 분할
- `Ctrl+b "` - 가로 분할
- `Ctrl+b 화살표` - 창 이동

---

### Step 7: 마무리

**실행 내용**:
1. 언어 선택 사항을 `~/.dev-setup-lang`에 저장
2. Phase 2 파일을 `~/claude-code-setup/`로 복사
3. 필요한 모든 파일이 복사되었는지 확인
4. 설치 디렉토리 삭제 (정리)

**Phase 2 제안**:

```
✨ Phase 1 완료!

  다음: Phase 2 - Claude Code 설정 (선택 사항)

  • 워크스페이스 관리 (중앙 설정)
  • 공유 에이전트 (workspace-manager, translate, doc-writer)
  • MCP 서버 (문서 검색)
  • Git + GitHub (Claude 기능 사용 권장)

지금 Phase 2를 진행할까요?

  ▸ 네, 새 터미널 열기
    아니요, 나중에 수동으로 실행
```

**옵션 1: 네, 새 터미널 열기** (권장)
- 새 Terminal.app 창 열기
- 자동으로 Phase 2 설정 실행
- 새 PATH와 쉘 설정 로드 보장

**옵션 2: 아니요, 나중에 수동으로 실행**
- 나중에 실행할 명령어 표시: `~/claude-code-setup/setup-claude.sh`

---

## UI/UX 패턴

### 화살표 키 네비게이션

**모든 메뉴는 화살표 키 사용** - 타이핑 불필요:
- ↑↓ - 옵션 이동
- Space - 선택/해제 (다중 선택 메뉴)
- Enter - 선택 확인

### 다중 선택 메뉴

시각적 표시:
- `[x]` - 선택됨
- `[ ]` - 선택 안 됨
- `[-]` - 비활성화 (변경 불가)
- `▸` - 현재 커서 위치

색상 코딩:
- 청록색 - 선택된 항목
- 회색 - 비활성화 항목
- 굵은 글씨 - 현재 항목

### 상태 메시지

- ✅ `완료` - 초록색, 성공
- ⏭️ `건너뜀` - 노란색, 의도적으로 건너뜀
- ❌ `실패` - 빨간색, 에러 발생 (해결책 포함)

---

## 에러 처리

### Node.js 설치 실패

**치명적 에러** - Node.js 없이 Phase 1 완료 불가:

```
❌ Node.js 설치 실패

AI 코딩 도구에 Node.js가 필수입니다.

수동으로 설치하세요:
  brew install node

설치 확인:
  node --version
```

스크립트 종료 및 수동 설치 방법 제시.

### 패키지 설치 실패

**비치명적** - Phase 1 계속 진행:

```
⚠️ ripgrep 설치 에러 발생, 계속합니다...
```

경고 표시하지만 설치 프로세스는 계속됩니다.

### 터미널 프로필 임포트 실패

**복구 가능** - 수동 방법 제시:

```
⚠️ 터미널 프로필 임포트 실패

📋 수동으로 임포트하세요:
   Terminal > 설정 (⌘,) > 프로필 > 임포트...
   선택: /path/to/Dev.terminal
```

### Homebrew 미설치

**치명적 (macOS)** - 패키지 관리자 필수:

```
❌ Homebrew를 찾을 수 없습니다

먼저 Homebrew를 설치하세요:
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

그 후 이 스크립트를 다시 실행하세요.
```

---

## 성공 기준

### 최소 요구사항 (Phase 1 완료)
- ✅ Xcode Command Line Tools 설치
- ✅ Homebrew 설치 및 작동
- ✅ Node.js 설치 및 작동
- ✅ Phase 2 파일이 `~/claude-code-setup/`에 복사됨
- ✅ 설치 디렉토리 정리됨

### 선택적 성공
- ⚪ 터미널 테마 적용 (사용자 선택)
- ⚪ Oh My Zsh 설치 (사용자 선택)
- ⚪ tmux 설치 (사용자 선택)

---

## 다음 단계

Phase 1 이후 할 수 있는 일:

1. **Phase 2로 진행** (Claude Code 사용자 권장)
   - Claude Code CLI 설치
   - 공유 에이전트 설치
   - MCP 서버 설정

2. **Phase 2 건너뛰고 코딩 시작**
   - 완전한 개발 환경 구성 완료
   - 터미널 테마 및 플러그인 설정 완료
   - 쉘 별칭 준비 완료

3. **Phase 2를 나중에 실행**
   - 언제든지: `~/claude-code-setup/setup-claude.sh`
   - 언어 선택사항이 저장됨

---

## 문제 해결

일반적인 문제 및 해결책은 [문제 해결](TROUBLESHOOTING.md) 문서를 참고하세요.

## FAQ

자주 묻는 질문은 [FAQ](FAQ.md) 문서를 참고하세요.
