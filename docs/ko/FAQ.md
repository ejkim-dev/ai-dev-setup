# 자주 묻는 질문 (FAQ)

ai-dev-setup 설치 및 사용에 대한 일반적인 질문들입니다.

## 일반 질문

### ai-dev-setup이란 무엇인가요?

ai-dev-setup은 macOS 및 Windows에서 개발 환경을 한 줄로 설치하는 프로그램입니다. 다음을 설정합니다:
- 패키지 관리자 (Homebrew/winget)
- 필수 개발 도구 (Node.js, Git 등)
- 터미널 테마 및 셸 커스터마이징
- 선택사항: 워크스페이스 관리 기능이 있는 Claude Code

**대상 사용자**: 터미널 초보자, 새 컴퓨터 설정, 일관된 AI 지원 개발 환경을 원하는 분들.

---

### 설치하는 데 Git이 필요한가요?

**아니오, Git은 설치에 필요하지 않습니다.**

**Phase 1** (기본 환경):
- `curl`을 사용하여 다운로드 (macOS) 또는 `irm` (Windows)
- Git이 전혀 필요하지 않음

**Phase 2** (Claude Code 설정):
- Git이 아직 설치되지 않은 경우 설치
- Claude Code 버전 관리 기능에만 필요

---

### Phase 1과 Phase 2의 차이점은 무엇인가요?

**Phase 1: 기본 개발 환경**
- 패키지 관리자 (Homebrew/winget)
- Node.js, ripgrep, 개발 도구
- 터미널 테마 (Terminal.app, Windows Terminal, iTerm2)
- 셸 커스터마이징 (Oh My Zsh/Oh My Posh)
- 소요 시간: 약 15-30분

**Phase 2: Claude Code 설정** (선택사항)
- Claude Code 설치
- 공유 에이전트 (workspace-manager, translate, doc-writer)
- MCP 서버 (local-rag, filesystem, serena 등)
- 워크스페이스 관리 구조
- 소요 시간: 약 10-20분

**Phase 2 없이 Phase 1만 실행할 수 있지만**, Phase 2는 Phase 1 도구 (Node.js 등)가 필요합니다.

---

### 특정 단계를 건너뛸 수 있나요?

**예! 모든 단계가 선택사항입니다** (필수 요구 사항 제외).

**필수 단계**:
- Homebrew (macOS) - 다른 모든 설치에 필요
- Node.js - Claude Code 및 AI 도구에 필요

**선택 단계**:
- 터미널 테마
- 셸 커스터마이징
- tmux
- 특정 패키지 (ripgrep, 폰트 등)
- AI 도구
- MCP 서버

설치 프로그램이 각 단계마다 물어봅니다. 화살표 키로 이동하여 원하는 것을 선택하세요.

---

### [Y/n] 대신 화살표 키를 사용하는 이유는?

**그렇지 않습니다!** 모든 프롬프트가 **화살표 키 탐색**을 사용합니다.

**이전 버전**은 `[Y/n]`과 같은 텍스트 입력을 사용했습니다. **현재 버전**은 대화형 메뉴를 사용합니다:

```
  ▸ 설치
    건너뛰기
```

↑↓로 이동, Enter로 선택. 타이핑 불필요.

`[Y/n]` 프롬프트가 보인다면 구버전을 사용 중입니다. 최신 버전으로 업데이트하세요:
```bash
curl -fsSL https://raw.githubusercontent.com/ejkim-dev/ai-dev-setup/v1.0.0/install.sh | bash
```

---

### 설치 후 언어를 변경하려면?

언어는 `~/.dev-setup-lang`에 저장됩니다. 변경하려면:

**방법 1: 삭제 후 재실행**
```bash
rm ~/.dev-setup-lang
~/claude-code-setup/setup-claude.sh
```
언어 선택 프롬프트가 다시 표시됩니다.

**방법 2: 직접 편집**
```bash
echo "ko" > ~/.dev-setup-lang  # 한국어
echo "en" > ~/.dev-setup-lang  # 영어
echo "ja" > ~/.dev-setup-lang  # 일본어
```

---

### 재설치하거나 정리하려면?

정리 방법은 **[제거 가이드](UNINSTALL.md)**를 참조하세요. 정리 후 재설치:

```bash
curl -fsSL https://raw.githubusercontent.com/ejkim-dev/ai-dev-setup/v1.0.0/install.sh | bash
```

---

## 설치 질문

### 이미 Homebrew가 있다면?

설치 프로그램이 기존 Homebrew를 **자동으로 감지**하고 설치를 건너뜁니다:

```
[2/7] Homebrew

  ✅ 이미 설치되어 있습니다
  ⏭️ 건너뛰었습니다
```

충돌 없음, 재설치 없음.

---

### 이미 Node.js가 있다면?

Homebrew와 동일 - **자동으로 감지하고 건너뜁니다**:

```
[3/7] 필수 패키지

  ▸ [x] Node.js - JavaScript 런타임 - 이미 설치되어 있습니다
```

체크박스가 "이미 설치되어 있습니다"로 표시되고 비활성화됩니다 (선택 해제 불가).

다른 Node.js 버전 (nvm 등)이 있는 경우 설치 프로그램이 감지하고 Homebrew 설치를 건너뜁니다.

---

### 여러 컴퓨터에서 사용할 수 있나요?

**예!** 일반적인 사용 사례입니다.

**모든 컴퓨터에서 동일한 설정**:
```bash
# 컴퓨터 1
curl -fsSL https://raw.githubusercontent.com/ejkim-dev/ai-dev-setup/v1.0.0/install.sh | bash

# 컴퓨터 2
curl -fsSL https://raw.githubusercontent.com/ejkim-dev/ai-dev-setup/v1.0.0/install.sh | bash

# 컴퓨터 3
curl -fsSL https://raw.githubusercontent.com/ejkim-dev/ai-dev-setup/v1.0.0/install.sh | bash
```

각 설치는 독립적이지만 동일한 설정 패턴을 따릅니다.

**컴퓨터 간 워크스페이스 동기화**:
```bash
# 워크스페이스에 Dropbox/iCloud 사용
ln -s ~/Dropbox/claude-workspace ~/claude-workspace
```

또는 Git을 사용하여 동기화:
```bash
cd ~/claude-workspace
git init
git remote add origin <your-repo>
git push
```

---

### Apple Silicon (M1/M2/M3)에서 작동하나요?

**예!** Apple Silicon에서 완전히 테스트되었습니다.

**자동 조정**:
- Homebrew는 `/opt/homebrew/`에 설치 (Apple Silicon 표준)
- PATH가 ARM 아키텍처에 맞게 자동으로 구성됨
- 모든 패키지가 가능한 경우 네이티브 ARM 버전 사용

수동 설정 불필요.

---

### Intel Mac에서 작동하나요?

**예!** Intel과 Apple Silicon 모두에서 작동합니다.

**차이점**:
- Homebrew 위치: `/usr/local/` (Intel) vs `/opt/homebrew/` (ARM)
- 스크립트가 자동으로 감지하고 처리

---

### 인터넷 없이 실행할 수 있나요?

**아니오.** 다음을 위해 인터넷 연결이 필요합니다:
- 설치 프로그램 스크립트 다운로드
- Homebrew 다운로드
- brew/winget을 통한 패키지 설치
- npm 패키지 설치 (Claude Code, MCP 서버)

**오프라인 대안**:
인터넷이 있는 컴퓨터에서 저장소를 클론한 다음 전송:
```bash
# 온라인 컴퓨터
git clone https://github.com/ejkim-dev/ai-dev-setup.git
tar -czf ai-dev-setup.tar.gz ai-dev-setup/

# 오프라인 컴퓨터로 전송 (USB 등)

# 오프라인 컴퓨터
tar -xzf ai-dev-setup.tar.gz
cd ai-dev-setup
./setup.sh
```

주의: 인터넷 없이는 패키지 다운로드가 여전히 실패합니다.

---

## 사용 질문

### 자동 링크 기능이란?

**자동 링크**는 패키지 설치 (Step 3)와 셸 설정 (Step 5)을 연결합니다.

**예시**:

**Step 3: 패키지 설치**
```
  ▸ [x] zsh-autosuggestions - 명령어 제안
    [x] zsh-syntax-highlighting - 문법 강조
```

**Step 5: 셸 설정** (Step 3에 따라 자동 선택됨)
```
  ▸ [x] 명령어 자동 제안 설정  ← 자동 선택됨!
    [x] 문법 강조 설정         ← 자동 선택됨!
```

**Step 3에서 설치하지 않은 경우**:
```
  ▸ [-] 명령어 자동 제안 설정 - 설치되지 않음  ← 비활성화됨
    [-] 문법 강조 설정 - 설치되지 않음         ← 비활성화됨
```

**이점**:
- 수동 설정 불필요
- 오류 방지 (설치되지 않은 것은 설정할 수 없음)
- 논리적 워크플로우 (설치 → 설정)

---

### 비활성화된 옵션이란?

**비활성화된 옵션**은 `[-]` 표시와 함께 회색으로 표시됩니다:

```
  ▸ [x] Node.js - JavaScript 런타임 (필수)
    [-] ripgrep - 빠른 코드 검색 - 이미 설치되어 있습니다
```

**비활성화 이유**:
1. **필수 항목**: Node.js는 선택 해제 불가
2. **이미 설치됨**: 재설치 불필요
3. **종속성 미충족**: 플러그인 없이 zsh 플러그인

**시각적 표시**:
- `[-]` - 비활성화된 체크박스
- 회색 텍스트 - 선택 불가
- Space 키 작동 안 함 - 토글 불가

---

### 설치된 도구를 업데이트하려면?

**Homebrew 패키지 업데이트**:
```bash
brew update           # 패키지 목록 업데이트
brew upgrade          # 모든 패키지 업그레이드
brew upgrade node     # 특정 패키지 업그레이드
```

**npm 전역 패키지 업데이트**:
```bash
npm update -g                           # 모든 전역 패키지 업데이트
npm update -g @anthropic-ai/claude-code # 특정 패키지 업데이트
```

**Claude Code 업데이트**:
```bash
npm update -g @anthropic-ai/claude-code
```

**MCP 서버 업데이트**:
```bash
npm update -g @anthropic-ai/local-rag-mcp
npm update -g @anthropic-ai/filesystem-mcp
```

**Oh My Zsh 업데이트**:
```bash
omz update
```

---

## Claude Code 질문

### Phase 1을 사용하는 데 Claude Code가 필요한가요?

**아니오.** Phase 1은 독립적인 개발 환경 설정입니다.

**Claude Code 없이** 얻을 수 있는 것:
- 아름다운 테마의 터미널
- 자동 제안 기능이 있는 빠른 셸
- 개발 도구 (Node.js, Git, ripgrep)
- 구성된 셸 (.zshrc)

**Claude Code 포함** (Phase 2)하면 추가로:
- AI 코딩 어시스턴트
- 워크스페이스 관리
- 공유 에이전트
- MCP 서버

Phase 1은 Claude Code 사용자뿐만 아니라 누구에게나 유용합니다.

---

### claude-workspace란?

`claude-workspace`는 Claude Code 리소스를 위한 **중앙 집중식 관리 구조**입니다.

**위치**: `~/claude-workspace/`

**목적**:
- 공유 에이전트 저장 (모든 프로젝트에서 사용 가능)
- 프로젝트 템플릿 관리 (CLAUDE.md, .mcp.json)
- 프로젝트별 설정 백업
- 문서 정리

**이점**:
- **단일 진실 공급원**: 한 번 업데이트하면 모든 곳에 적용
- **일관성**: 프로젝트 간 동일한 에이전트
- **쉬운 백업**: 한 디렉토리만 백업
- **중복 없음**: 복사 대신 심볼릭 링크

자세한 내용은 [WORKSPACE.md](WORKSPACE.md)를 참조하세요.

---

### 공유 에이전트란?

**공유 에이전트**는 모든 프로젝트에서 사용할 수 있는 재사용 가능한 AI 어시스턴트입니다.

**포함된 에이전트**:

1. **workspace-manager**
   - 프로젝트 연결/연결 해제
   - 심볼릭 링크 및 .gitignore 관리
   - 워크스페이스 상태 확인

2. **translate**
   - 다국어 번역 (en/ko/ja)
   - 마크다운 형식 유지
   - 일괄 번역

3. **doc-writer**
   - 코드에서 README 생성
   - CLAUDE.md 생성
   - API 문서 작성

**사용법**:
```
/workspace-manager connect ~/projects/my-app
/translate README.md en ko
/doc-writer create-readme
```

**위치**: `~/claude-workspace/shared/agents/`

---

### MCP 서버란?

**MCP (Model Context Protocol)** 서버는 Claude Code의 기능을 확장합니다.

**기본 기능** (MCP 없이):
- 파일 읽기/쓰기
- 터미널 명령어 실행
- 코드 분석

**MCP 서버 포함**:
- **local-rag**: 문서 및 코드 검색
- **filesystem**: 고급 파일 작업
- **serena**: 웹 검색
- **fetch**: HTTP 요청
- **puppeteer**: 브라우저 자동화

**예시**:
```
"프로젝트 문서에서 인증 흐름 검색"
→ local-rag가 모든 마크다운/PDF 파일 검색
→ 관련 섹션 반환
```

**설정**: `~/.claude/.mcp.json`

서버 세부 정보는 [PHASE2.md](PHASE2.md)를 참조하세요.

---

### Git 없이 Claude Code를 사용할 수 있나요?

**예**, 하지만 버전 관리 기능을 사용할 수 없습니다.

**Git 없이** Claude Code가 할 수 있는 것:
- ✅ 파일 읽기/쓰기
- ✅ 터미널 명령어 실행
- ✅ 코드 생성
- ✅ MCP 서버 사용
- ✅ 채팅 인터페이스

**Git 없이** Claude Code가 할 수 없는 것:
- ❌ 변경 사항 추적 (`git status`, `git diff`)
- ❌ AI가 작성한 메시지로 커밋 생성
- ❌ 풀 리퀘스트 생성 (`gh pr create`)
- ❌ 브랜치 관리
- ❌ GitHub 통합

**권장사항**: 전체 Claude Code 경험을 위해 Git 설치 (Phase 2가 자동으로 수행).

---

## 기술 질문

### 어떤 셸을 사용하나요?

**macOS**: zsh (macOS Catalina 이후 기본)
**Windows**: PowerShell

**커스터마이징**:
- **macOS**: Oh My Zsh + agnoster 테마
- **Windows**: Oh My Posh

**왜 zsh인가요?**: 더 나은 자동 완성, 테마, 플러그인 생태계를 갖춘 현대적인 셸.

---

### 설정 파일이 어디에 저장되나요?

**셸 설정**:
- `~/.zshrc` - zsh 설정 (macOS)
- `~/.tmux.conf` - tmux 설정 (macOS)
- PowerShell 프로필 (Windows)

**터미널 설정**:
- `~/Library/Preferences/com.apple.Terminal.plist` - Terminal.app (macOS)
- `~/Library/Application Support/iTerm2/DynamicProfiles/` - iTerm2
- `%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_*\LocalState\settings.json` (Windows)

**Claude Code 설정**:
- `~/.claude/` - Claude Code 설정
- `~/.claude/.mcp.json` - MCP 서버 설정
- `~/claude-workspace/` - 워크스페이스 관리

**언어 기본 설정**:
- `~/.dev-setup-lang` - 저장된 언어 선택

---

### .zshrc 파일에 무엇이 있나요?

ai-dev-setup 후 `.zshrc`에는 다음이 포함됩니다:

```bash
# === ai-dev-setup ===

# Oh My Zsh
ZSH_THEME="agnoster"
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
source $ZSH/oh-my-zsh.sh

# agnoster 이모지 프롬프트
prompt_context() {
  emojis=("🔥" "👑" "😎" "🍺" "🐵" "🦄" "🌈" "🚀" "🐧" "🎉")
  RAND_EMOJI_N=$(( $RANDOM % ${#emojis[@]} ))
  prompt_segment black default "%(!.%{%F{yellow}%}.) $USER ${emojis[$RAND_EMOJI_N]} "
}

# zsh-autosuggestions
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# zsh-syntax-highlighting
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# 별칭
alias ll="ls -la"
alias gs="git status"
alias gl="git log --oneline -20"

# === End ai-dev-setup ===
```

마커 사이의 모든 내용이 ai-dev-setup에서 관리됩니다. 이 마커 전후에 자신의 설정을 추가할 수 있습니다.

---

### 모든 것을 제거하려면?

자세한 단계별 안내는 **[제거 가이드](UNINSTALL.md)**를 참조하세요.

---

### 내 데이터가 안전한가요?

**예.** 이 설치 프로그램은:

**하지 않는 것**:
- ❌ 원격 서버로 데이터 전송 (패키지 다운로드 제외)
- ❌ 텔레메트리 또는 분석 수집
- ❌ 홈 디렉토리 외부 시스템 파일 수정
- ❌ 권한 없이 비공개 데이터 접근

**하는 것**:
- ✅ 오픈 소스 (코드 검토 가능)
- ✅ 공식 패키지 관리자 사용 (Homebrew, npm)
- ✅ `~/` (홈 디렉토리)에만 파일 생성
- ✅ 각 단계마다 권한 요청

**개인 정보 보호**:
- 언어 기본 설정이 로컬에 저장됨 (`~/.dev-setup-lang`)
- 외부 API 호출 없음
- Claude Code API 키가 로컬에 저장됨 (`~/.claude/config.json`)

---

## 문제 해결

### 설치가 실패했는데 어떻게 해야 하나요?

자세한 해결책은 [TROUBLESHOOTING.md](TROUBLESHOOTING.md)를 참조하세요.

**빠른 확인**:
1. **인터넷 연결**: `ping google.com`
2. **디스크 공간**: `df -h` (최소 5GB 여유 공간 필요)
3. **권한**: `sudo` 없이 실행 (명시적으로 필요한 경우 제외)
4. **Homebrew**: `brew doctor` (문제 수정)
5. **재실행**: 대부분의 오류는 일시적이므로 다시 시도

---

### 폰트/테마가 작동하지 않나요?

[TROUBLESHOOTING.md - 폰트 및 터미널 문제](TROUBLESHOOTING.md#폰트-및-터미널-문제)를 참조하세요.

**빠른 수정**:
1. **Terminal 완전히 재시작** (⌘Q, 다시 열기)
2. **폰트 캐시 지우기**: `sudo atsutil databases -remove` (macOS)
3. **프로필 다시 가져오기**: Terminal > 설정 > 프로파일 > 가져오기

---

### 셸 플러그인이 작동하지 않나요?

[TROUBLESHOOTING.md - 셸 및 플러그인 문제](TROUBLESHOOTING.md#셸-및-플러그인-문제)를 참조하세요.

**빠른 수정**:
1. **셸 다시 로드**: `source ~/.zshrc`
2. **설치 확인**: `brew list zsh-autosuggestions`
3. **.zshrc 확인**: `cat ~/.zshrc | grep zsh-autosuggestions`

---

## 도움 받기

### 지원은 어디서 받을 수 있나요?

1. **문서**:
   - [Phase 1 가이드](PHASE1.md)
   - [Phase 2 가이드](PHASE2.md)
   - [문제 해결](TROUBLESHOOTING.md)
   - [워크스페이스 가이드](WORKSPACE.md)

2. **GitHub Issues**: [ai-dev-setup/issues](https://github.com/ejkim-dev/ai-dev-setup/issues)
   - 먼저 기존 이슈 검색
   - 시스템 정보 및 오류 메시지 포함
   - 재현 단계 제공

3. **커뮤니티**:
   - GitHub의 Discussions 탭
   - Stack Overflow (태그: `ai-dev-setup`)

---

### 기여하려면?

**기여 방법**:

1. **버그 보고**: [GitHub Issues](https://github.com/ejkim-dev/ai-dev-setup/issues)
2. **기능 제안**: Discussions 또는 Issues
3. **문서 개선**: 문서에 대한 PR 제출
4. **번역 추가**: 새 로케일 파일 (locale/*.sh)
5. **에이전트 생성**: 유용한 공유 에이전트 공유
6. **다른 시스템에서 테스트**: 호환성 보고

**기여 가이드라인**: 저장소의 `CONTRIBUTING.md`를 참조하세요.

---

## 관련 문서

- [Phase 1 설정 가이드](PHASE1.md)
- [Phase 2 설정 가이드](PHASE2.md)
- [워크스페이스 구조](WORKSPACE.md)
- [문제 해결 가이드](TROUBLESHOOTING.md)
