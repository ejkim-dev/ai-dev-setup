# Phase 1: 기본 개발 환경

macOS 또는 Windows에서 필수 개발 도구와 터미널 환경을 설정합니다.

## 개요

**목표**: 패키지 관리자, 개발 도구, 터미널 테마, 쉘 커스터마이징 설치

**대상 사용자**:
- 터미널 초보자
- 새 Mac/Windows 세팅
- 일관된 개발 환경을 원하는 분

**소요 시간**: 15-30분 (인터넷 속도에 따라 다름)

---

## 설치되는 항목

| 도구 | 설명 | macOS | Windows |
|------|------|:-----:|:-------:|
| **Xcode Command Line Tools** | Git, make, gcc 등 개발 도구 | ✅ | - |
| **패키지 관리자** | Homebrew (macOS) / winget (Windows) | ✅ | ✅ |
| **Node.js** | JavaScript 런타임 (필수) | ✅ | ✅ |
| **ripgrep** | 빠른 코드 검색 도구 | ✅ | ✅ |
| **D2Coding 폰트** | 한글 지원 코딩 폰트 | ✅ | ✅ |
| **zsh-autosuggestions** | 명령어 자동 완성 | ✅ | - |
| **zsh-syntax-highlighting** | 문법 강조 | ✅ | - |
| **Terminal.app 테마** | 다크 테마 프로필 | ✅ | - |
| **Windows Terminal** | 다크 테마 + 폰트 설정 | - | ✅ |
| **iTerm2** | 고급 터미널 (선택) | ✅ | - |
| **Oh My Zsh** | 쉘 테마 + 플러그인 | ✅ | - |
| **Oh My Posh** | PowerShell 프롬프트 테마 | - | ✅ |
| **tmux** | 터미널 멀티플렉서 | ✅ | - |

---

## 설치 단계

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

### Step 1: Xcode Command Line Tools (macOS만 해당)

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

### Step 2: 패키지 관리자

**macOS**: Homebrew 설치
**Windows**: winget 확인 (Windows 11에 기본 포함)

**자동 감지**: 이미 설치되어 있으면 자동으로 건너뜁니다

**미설치 시 (macOS)**:
```
[2/7] Homebrew (패키지 관리자)

  개발 도구를 설치하는 데 필요합니다.
  공식 사이트: https://brew.sh

  ▸ Homebrew 설치
    건너뛰기 (패키지 설치 불가)
```

**역할**: 공식 스크립트에서 Homebrew를 다운로드하고 설치

**설치 후**: Apple Silicon Mac에서는 자동으로 PATH에 Homebrew 추가

---

### Step 3: 필수 패키지

**화살표 키 탐색**을 사용하는 **다중 선택 메뉴**:

```
[3/7] 필수 패키지

  설치할 패키지를 선택하세요:

  ▸ [x] Node.js - JavaScript 런타임 (필수)
    [x] ripgrep - 빠른 코드 검색
    [x] D2Coding 폰트 - 한글 지원 코딩 폰트
    [x] zsh-autosuggestions - 명령어 제안
    [x] zsh-syntax-highlighting - 문법 강조

  ↑↓: 이동 | Space: 선택/해제 | Enter: 확인
```

**기능**:
- **필수 항목**: Node.js는 선택 해제 불가 (AI 도구에 필요)
- **이미 설치됨**: "- 이미 설치되어 있습니다" 표시 및 비활성화
- **기본 선택**: 모든 패키지가 기본으로 체크됨
- **설치**: 선택한 각 패키지를 Homebrew를 통해 설치

**패키지 상세 정보**:

#### Node.js (필수)
- JavaScript 런타임 환경
- Claude Code 및 기타 AI 도구에 필요
- 패키지 설치를 위한 npm 포함

#### ripgrep
- 빠른 코드 검색 도구 (grep보다 빠름)
- 많은 최신 개발 도구에서 사용

#### D2Coding 폰트
- 고정폭 코딩 폰트
- 뛰어난 한글 문자 지원
- 가독성 좋고 깔끔한 디자인

#### zsh-autosuggestions
- 명령 기록을 기반으로 제안 표시
- → 키를 눌러 제안 수락
- 터미널 작업 속도 향상

#### zsh-syntax-highlighting
- 유효한/유효하지 않은 명령어 강조
- 초록색 = 유효한 명령어
- 빨간색 = 유효하지 않은 명령어

---

### Step 4: 터미널 설정

설정할 터미널 애플리케이션 선택:

```
[4/7] 터미널 설정

  터미널 애플리케이션 선택:

  ▸ Terminal.app만 (Dev 테마 포함)
    iTerm2만
    Terminal.app + iTerm2 둘 다
    건너뛰기
```

**옵션 1: Terminal.app만**
- Dev 다크 테마 프로필 가져오기
- D2Coding 폰트 설정 (11pt)
- 사용자 정의 색상 체계 적용
- 기본 프로필로 설정

**옵션 2: iTerm2만**
- Homebrew를 통해 iTerm2 설치
- Dev 프로필 적용
- D2Coding 폰트 설정

**옵션 3: 둘 다**
- Terminal.app과 iTerm2 모두 설정
- 언제든지 둘 사이 전환 가능

**옵션 4: 건너뛰기**
- 터미널 설정 안 함
- 현재 설정 유지

**폰트 체크**: D2Coding 폰트가 설치되지 않은 경우 테마 적용 전에 설치할지 묻습니다

---

### Step 5: 쉘 커스터마이징

#### 1부: Oh My Zsh 설치

이미 설치되지 않은 경우:

```
[5/7] 쉘 설정

  Oh My Zsh는 zsh를 위한 아름다운 테마와 플러그인을 제공합니다.

  ▸ Oh My Zsh 설치
    건너뛰기
```

**역할**: zsh를 위한 Oh My Zsh 프레임워크 다운로드 및 설치

#### 2부: .zshrc 커스터마이징

쉘 기능을 위한 **다중 선택 메뉴**:

```
  .zshrc 커스터마이징

  ▸ [x] agnoster 테마 + 랜덤 이모지
    [x] 명령어 자동 제안 설정
    [x] 문법 강조 설정
    [ ] 유용한 별칭 (ll, gs, gl)

  ↑↓: 이동 | Space: 선택/해제 | Enter: 확인
```

**자동 링크 기능**:
- Step 3에서 zsh-autosuggestions를 설치했다면 여기서 자동 선택됨
- Step 3에서 zsh-syntax-highlighting을 설치했다면 여기서 자동 선택됨
- 설치되지 않은 경우 "설치되지 않음" 표시 및 비활성화

**커스터마이징 상세**:

#### agnoster 테마 + 이모지
- 현재 디렉토리와 Git 브랜치 표시
- 프롬프트에 랜덤 이모지 (세션마다 변경)
- Git 상태에 따른 색상 코딩

#### 명령어 자동 제안
- Homebrew 위치에서 zsh-autosuggestions 소스
- Step 3에서 설치한 경우에만 사용 가능

#### 문법 강조
- Homebrew 위치에서 zsh-syntax-highlighting 소스
- Step 3에서 설치한 경우에만 사용 가능

#### 유용한 별칭
- `ll` → `ls -la` (상세 파일 목록)
- `gs` → `git status`
- `gl` → `git log --oneline -20`

**적용**: 선택한 설정이 `~/.zshrc`에 마커 사이에 추가됩니다:
```bash
# === ai-dev-setup ===
[설정 내용]
# === End ai-dev-setup ===
```

---

### Step 6: tmux (macOS만 해당)

분할 창과 세션 관리를 위한 터미널 멀티플렉서.

```
[6/7] tmux (터미널 멀티플렉서)

  터미널 창 분할 및 세션 관리.

  ▸ tmux 설치
    건너뛰기
```

**역할**:
- Homebrew를 통해 tmux 설치
- `.tmux.conf` 설정 파일을 홈 디렉토리에 복사
- 분할 창, 세션 관리 등 활성화

**기본 tmux 명령어** (설치 후):
- `tmux` - 새 세션 시작
- `Ctrl+b %` - 세로 분할
- `Ctrl+b "` - 가로 분할
- `Ctrl+b 화살표` - 창 이동

---

### Step 7: 마무리

**수행 작업**:
1. 언어 선택을 `~/claude-code-setup/.dev-setup-lang`에 저장
2. Phase 2 파일을 `~/claude-code-setup/`로 복사
3. 필요한 모든 파일이 복사되었는지 확인
4. 설치 디렉토리 삭제 (정리)

**Phase 2 프롬프트**:

```
✨ Phase 1 완료!

  다음: Phase 2 - Claude Code 설정 (선택 사항)

  • Workspace 관리 (중앙 설정)
  • Global agents (workspace-manager, translate, doc-writer)
  • MCP 서버 (문서 검색)
  • Git + GitHub (Claude 기능에 권장)

Phase 2를 지금 진행하시겠습니까?

  ▸ 예, 새 터미널 열기
    예, 현재 터미널에서 계속
    아니오, 나중에 수동 실행
```

**옵션 1: 예, 새 터미널 열기** (권장)
- 새 Terminal.app 창을 엽니다
- 자동으로 Phase 2 설정을 실행합니다
- 새로운 PATH와 쉘 설정이 로드됩니다

**옵션 2: 예, 현재 터미널에서 계속**
- 즉시 Phase 2를 실행합니다
- ⚠️ 경고: 설정 변경을 위해 터미널 재시작 권장

**옵션 3: 아니오, 나중에 수동 실행**
- 나중에 실행할 명령어 표시: `~/claude-code-setup/setup-claude.sh`

---

## UI/UX 패턴

### 화살표 키 탐색

**모든 메뉴가 화살표 키 사용** - 타이핑 불필요:
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
- 회색 - 비활성화된 항목
- 굵게 - 현재 항목

### 상태 메시지

- ✅ `완료` - 초록색, 성공적으로 완료
- ⏭️ `건너뜀` - 노란색, 의도적으로 건너뜀
- ❌ `실패` - 빨간색, 오류 발생 (해결책 포함)

---

## 에러 처리

### Node.js 설치 실패

**치명적 에러** - Node.js 없이는 Phase 1 완료 불가:

```
❌ Node.js 설치 실패

Node.js는 AI 코딩 도구에 필요합니다.

수동 설치:
  brew install node

확인:
  node --version
```

스크립트가 종료되고 수동 설치 방법을 안내합니다.

### 패키지 설치 실패

**치명적이지 않음** - Phase 1 계속 진행:

```
⚠️ ripgrep 설치가 에러를 반환했지만 계속 진행합니다...
```

경고를 로그하지만 설치 프로세스를 중단하지 않습니다.

### 터미널 프로필 가져오기 실패

**복구 가능** - 수동 방법 안내:

```
⚠️ 터미널 프로필 가져오기 실패

📋 수동으로 가져오기:
   Terminal > 설정 (⌘,) > 프로파일 > 가져오기...
   선택: /path/to/Dev.terminal
```

### Homebrew를 사용할 수 없음

**macOS에서 치명적** - 패키지 관리자 없이 진행 불가:

```
❌ Homebrew를 사용할 수 없습니다

먼저 Homebrew를 설치하세요:
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

그런 다음 이 스크립트를 다시 실행하세요.
```

---

## 성공 기준

### 최소 요구 사항 (Phase 1 완료)
- ✅ 패키지 관리자 설치됨 (Homebrew/winget)
- ✅ Node.js 설치되고 작동 중
- ✅ Phase 2 파일이 `~/claude-code-setup/`에 복사됨
- ✅ 설치 디렉토리 정리 완료

### 선택적 성공
- ⚪ 터미널 테마 적용 (사용자 선택)
- ⚪ Oh My Zsh 설치 (사용자 선택)
- ⚪ tmux 설치 (사용자 선택)

---

## 다음 단계

Phase 1 이후 다음을 수행할 수 있습니다:

1. **Phase 2로 진행** (Claude Code 사용자에게 권장)
   - Git + GitHub 설정
   - Claude Code CLI 설치
   - Global agents 설치
   - MCP 서버 설정

2. **Phase 2를 건너뛰고 코딩 시작**
   - 완전한 개발 환경 준비 완료
   - 터미널이 테마와 플러그인으로 설정됨
   - 쉘 별칭 사용 준비 완료

3. **나중에 Phase 2 실행**
   - 언제든지: `~/claude-code-setup/setup-claude.sh`
   - 언어 기본 설정이 저장되어 있음

---

## 문제 해결

일반적인 문제와 해결책은 [TROUBLESHOOTING.md](TROUBLESHOOTING.md)를 참조하세요.

## FAQ

자주 묻는 질문은 [FAQ.md](FAQ.md)를 참조하세요.
