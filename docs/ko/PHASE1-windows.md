# Phase 1: 기본 개발 환경 (Windows)

Windows에서 필수 개발 도구와 터미널 환경을 설정합니다.

**macOS 사용자?** → [macOS 가이드 보기](PHASE1-macOS.md)

## 개요

**목표**: 패키지 관리자, 개발 도구, 터미널 테마, 쉘 커스터마이징 설치

**대상 사용자**:
- 터미널 초보자
- 새 Windows 세팅
- 일관된 개발 환경을 원하는 분

**소요 시간**: 15-30분 (인터넷 속도에 따라 다름)

---

## 설치되는 항목 (Windows)

| 도구 | 설명 | 설치 |
|------|------|:----:|
| **winget** | 패키지 관리자 (Windows 11) | ✅ |
| **Node.js** | JavaScript 런타임 (필수) | ✅ |
| **ripgrep** | 빠른 코드 검색 도구 | ✅ |
| **D2Coding 폰트** | 한글 지원 코딩 폰트 | ✅ |
| **Git** | 버전 관리 | ✅ |
| **Windows Terminal** | 모던 터미널 (선택) | ⚪ |
| **Oh My Posh** | PowerShell 프롬프트 테마 | ✅ |

---

## 설치 단계

### 시작하기 전에: PowerShell 열기

**방법 1: Windows 키 사용 (권장)**
1. `Win + X` 누르기
2. "Windows PowerShell (관리자)" 또는 "PowerShell (관리자)" 선택
   - **중요**: "(관리자)" 표시가 있는 것을 선택해야 합니다

**방법 2: 실행 대화상자 사용**
1. `Win + R` 누르기
2. `powershell` 입력
3. Enter 누르기
4. 창 제목 우클릭 → "관리자 권한으로 실행"

**방법 3: Windows Terminal 사용 (설치된 경우)**
1. `Win + X` 누르기
2. "Windows Terminal (관리자)" 선택
3. 드롭다운 화살표 클릭 → "PowerShell" 선택

⚠️ **중요**: PowerShell을 반드시 관리자 권한으로 실행해야 합니다. 창 제목의 **(관리자)** 표시를 확인하세요.

---

### PowerShell Execution Policy 에러 (만났을 경우)

**에러 메시지**:
```
이 시스템에서 스크립트를 실행할 수 없으므로 ... 파일을 로드할 수 없습니다.
자세한 내용은 about_Execution_Policies를 참조하십시오.
```

**왜 이런 에러가 나나요?**:
- Windows PowerShell은 보안상 기본적으로 스크립트 실행을 차단합니다
- 설치 스크립트가 인터넷에서 다운로드되므로 추가 확인이 필요합니다

**해결책** (둘 중 하나 선택):

**옵션 1: 영구적으로 변경 (권장)**
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
irm https://raw.githubusercontent.com/ejkim-dev/ai-dev-setup/main/install.ps1 | iex
```

**옵션 2: 한 줄로 우회 (임시)**
```powershell
powershell -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/ejkim-dev/ai-dev-setup/main/install.ps1 | iex"
```

**각 옵션의 의미**:
- `RemoteSigned`: 로컬 스크립트는 허용, 인터넷 다운로드 스크립트는 서명 필수
- `CurrentUser`: 현재 사용자만 영향 (다른 사용자는 영향 없음)
- `Bypass`: 이 명령에 대해서만 정책을 무시 (일시적)

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
- 선택한 언어는 `%USERPROFILE%\.dev-setup-lang`에 저장되어 다음 실행 시 사용됩니다

---

### Step 1: winget (패키지 관리자)

**역할**: 시스템에서 winget을 사용 가능한지 확인합니다

**자동 감지**: 사용 불가능하면 자동으로 건너뜁니다

**winget 정보**:
- Windows 11에 내장
- Windows 10 21H2 이상: Microsoft Store에서 설치 가능
- PowerShell을 통해 패키지 관리

**사용 불가능 시**:
```
❌ winget을 찾을 수 없습니다

winget은 Windows 11의 내장 패키지 관리자입니다.

Windows 10 (21H2+) 사용자:
  1. Microsoft Store 열기
  2. "App Installer" 검색
  3. 설치 클릭

초기 버전:
  Windows 10 21H2 이상 또는 Windows 11로 업그레이드하세요
```

---

### Step 2: 필수 패키지

winget으로 필수 개발 도구를 설치합니다:

```
[2/6] 필수 패키지

  패키지 설치 중...
  → Node.js
  → Git
  → ripgrep
  → D2Coding 폰트
```

**패키지 상세**:

#### Node.js (필수)
- JavaScript 런타임 환경
- Claude Code 및 기타 AI 도구 필수
- npm (패키지 관리자) 포함

#### Git
- 버전 관리 시스템
- Claude Code의 버전 관리 기능 권장
- 코드 변경 추적 및 커밋 생성

#### ripgrep
- Windows 검색보다 빠른 코드 검색 도구
- 최신 개발 도구에서 사용됨
- 대안: 퍼지 파일 검색을 위한 fzf

#### D2Coding 폰트
- 모노스페이스 코딩 폰트
- 한글 문자 지원 우수
- 가독성이 좋고 깔끔한 디자인

---

### Step 3: Windows Terminal 설정

Windows Terminal 테마와 폰트를 적용할지 선택합니다:

```
[3/6] Windows Terminal

  Windows Terminal은 현대적인 터미널 환경을 제공합니다.

  Windows Terminal 설치됨?
  
    ▸ 네 - Dev 테마 적용
      아니요 - 먼저 설치할까요?
      건너뛰기
```

**설정되는 항목**:
- **Dev 색상 스키마**: 커스텀 다크 테마
- **D2Coding 폰트**: 기본 폰트로 설정 (11pt)
- **투명도**: 95% 투명도
- **기본 프로필**: PowerShell

**요구사항**:
- Windows Terminal 필수 설치 (Windows 11에는 기본 포함)
- 또는 Windows 10에서 Microsoft Store에서 설치

**수동 설치 (필요 시)**:
```powershell
winget install --id Microsoft.WindowsTerminal
```

---

### Step 4: Oh My Posh

**역할**: PowerShell 프롬프트를 아름답게 만드는 Oh My Posh를 설치합니다

```
[4/6] Oh My Posh

  PowerShell 프롬프트를 테마로 커스터마이징합니다.

  ▸ Oh My Posh 설치
    건너뛰기
```

**설치 후**, PowerShell 프로필에 다음을 추가합니다:

```powershell
oh-my-posh init pwsh | Invoke-Expression
```

**설치 후 모습**:
- 현재 디렉토리 경로
- Git 브랜치 및 상태 (git 저장소 내에 있을 때)
- 멋진 아이콘과 색상
- 커스텀 프롬프트 테마

**프로필 위치**:
- 일반적으로: `%USERPROFILE%\Documents\PowerShell\profile.ps1`

---

### Step 5: 마무리

**실행 내용**:
1. 언어 선택 사항을 `%USERPROFILE%\.dev-setup-lang`에 저장
2. Phase 2 파일을 `%USERPROFILE%\claude-code-setup\`로 복사
3. 필요한 모든 파일이 복사되었는지 확인
4. 설치 디렉토리 삭제 (정리)

**Phase 2 제안**:

```
✨ Phase 1 완료!

  다음: Phase 2 - Claude Code 설정 (선택 사항)

  • 워크스페이스 관리 (중앙 설정)
  • 공유 에이전트 (workspace-manager, translate, doc-writer)
  • MCP 서버 (문서 검색)
  • Obsidian 연동

지금 Phase 2를 진행할까요?

  ▸ 네, 새 PowerShell 열기
    아니요, 나중에 수동으로 실행
```

**옵션 1: 네, 새 PowerShell 열기** (권장)
- 새 PowerShell 창 열기 (관리자 권한)
- 자동으로 Phase 2 설정 실행
- PATH 및 프로필 로드 보장

**옵션 2: 아니요, 나중에 수동으로 실행**
- 나중에 실행할 명령어 표시: `~\claude-code-setup\setup-claude.ps1`

---

## UI/UX 패턴

### 화살표 키 네비게이션

**모든 메뉴는 화살표 키 사용** - 타이핑 불필요:
- ↑↓ - 옵션 이동
- Space - 선택/해제 (다중 선택 메뉴)
- Enter - 선택 확인

### 시각적 표시

- `▸ 옵션` - 현재 선택됨 (청록색)
- `  옵션` - 선택 안 됨
- ✅ 완료 (초록색)
- ⏭️ 건너뜀 (노란색)
- ❌ 실패 (빨간색)

---

## 에러 처리

### winget 사용 불가능

**Windows 10에서 중요**:
- Windows 11: 내장, 정상 작동해야 함
- Windows 10 21H2+: Microsoft Store에서 "App Installer" 설치
- 초기 버전: Windows 업그레이드 필요

```
❌ winget을 사용할 수 없습니다

Microsoft Store에서 App Installer를 설치하세요:
  https://www.microsoft.com/store/productId/9NBLGGH4NNS1

그 후 이 스크립트를 다시 실행하세요.
```

### Node.js 설치 실패

**치명적 에러** - Node.js 없이 Phase 1 완료 불가:

```
❌ Node.js 설치 실패

AI 코딩 도구에 Node.js가 필수입니다.

수동으로 설치하세요:
  winget install --id OpenJS.NodeJS.LTS

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

### PATH가 새로고침되지 않음

설치한 도구를 즉시 찾을 수 없을 경우:

```
⚠️ 도구 설치됨, 하지만 PATH를 새로고침 필요

새 PowerShell 창을 닫고 열어주세요 (관리자 권한)
설정을 완료할 수 있습니다.
```

**해결책**: PowerShell을 닫고 새로 열기.

---

## 성공 기준

### 최소 요구사항 (Phase 1 완료)
- ✅ winget 확인 또는 구형 Windows에서 사용 불가
- ✅ Node.js 설치 및 작동
- ✅ Git 설치 (권장)
- ✅ Phase 2 파일이 `%USERPROFILE%\claude-code-setup\`에 복사됨
- ✅ 설치 디렉토리 정리됨

### 선택적 성공
- ⚪ Windows Terminal 테마 적용 (사용자 선택)
- ⚪ Oh My Posh 설치 (사용자 선택)

---

## 다음 단계

Phase 1 이후 할 수 있는 일:

1. **Phase 2로 진행** (Claude Code 사용자 권장)
   - Claude Code CLI 설치
   - 공유 에이전트 설치
   - MCP 서버 설정
   - Obsidian 연동

2. **Phase 2 건너뛰고 코딩 시작**
   - 완전한 개발 환경 구성 완료
   - 터미널 테마 및 플러그인 설정 완료

3. **Phase 2를 나중에 실행**
   - PowerShell (관리자 권한)을 열고 `~\claude-code-setup\setup-claude.ps1` 실행
   - 언어 선택사항이 저장됨

---

## 문제 해결

일반적인 문제 및 해결책은 [문제 해결](TROUBLESHOOTING.md) 문서를 참고하세요.

## FAQ

자주 묻는 질문은 [FAQ](FAQ.md) 문서를 참고하세요.
