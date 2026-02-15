# ai-dev-setup

[English](README.md) | **[한국어]**

개발 환경을 한 번에 설정하세요. macOS와 Windows를 지원합니다.

선택적으로 [Claude Code](https://claude.ai/code) 설정을 포함하여 워크스페이스 관리, MCP 서버, 글로벌 에이전트를 제공합니다.

---

## 📋 추천 대상

- **터미널 초보자**: 명령어가 낯설지만 AI 기반 터미널 환경을 구축하고 싶은 분
- **AI 도구 활용**: Claude Code, Gemini CLI 등 AI 도구를 터미널에서 바로 사용하고 싶은 분
- **빠른 세팅**: 새 Mac/Windows에서 복잡한 설정 없이 한 번에 개발 환경을 갖추고 싶은 분
- **일관된 환경**: 여러 컴퓨터에서 동일한 터미널 환경을 유지하고 싶은 분

---

## 🎯 이 스크립트가 하는 일

### Phase 1: 기본 개발 환경

**7단계** (필수 도구 제외 모두 선택 사항):

1. **언어 선택** (en/ko/ja)
2. **Xcode Command Line Tools** (macOS만)
3. **패키지 관리자** - Homebrew (macOS) 또는 winget (Windows)
4. **필수 패키지** (화살표 키로 다중 선택)
   - Node.js (AI 도구에 필요)
   - ripgrep (빠른 코드 검색)
   - D2Coding 폰트 (한글 코딩 폰트)
   - zsh-autosuggestions (명령어 자동 완성)
   - zsh-syntax-highlighting (문법 강조)
5. **터미널 테마**
   - Terminal.app + iTerm2 (macOS)
   - Windows Terminal (Windows)
6. **쉘 커스터마이징** (다중 선택)
   - agnoster 테마 + 랜덤 이모지
   - zsh 플러그인 설정 (4단계에서 자동 연결)
   - 유용한 별칭 (선택 사항)
7. **tmux** (macOS 터미널 멀티플렉서)

**UI**: `select_menu`로 화살표 키 탐색 - 타이핑 불필요!

**기능**:
- 이미 설치된 도구 자동 감지
- 자동 연결: 4단계에서 설치한 플러그인이 6단계에서 자동 선택됨
- 비활성화 옵션: 설치되지 않은 플러그인은 설정 불가

### Phase 2: Claude Code 설정 (선택 사항)

**8단계**:

1. **Git** + **GitHub CLI** 설치
2. **GitHub 인증** (SSH 키 설정)
3. **Node.js** 확인 (Phase 1에서)
4. **Claude Code CLI** 설치
5. **claude-workspace** 구조 생성
6. **Global Agents** (다중 선택)
   - workspace-manager (추천)
   - translate (추천)
   - doc-writer (추천)
7. **MCP Servers** (다중 선택, 총 5개)
   - local-rag (추천) - 문서/코드 검색
   - filesystem (추천) - 파일 읽기/쓰기
   - serena (추천) - 웹 검색
   - fetch - HTTP 요청
   - puppeteer - 브라우저 자동화
8. **Obsidian** (선택적 노트 작성 앱)

**모든 프롬프트가 화살표 키 메뉴 사용** - 일관된 UI!

---

## 🚀 빠른 시작 (한 줄)

Git 필요 없음. 복사해서 붙여넣기만 하세요.

### macOS

터미널 열기:
```bash
curl -fsSL https://raw.githubusercontent.com/ejkim-dev/ai-dev-setup/main/install.sh | bash
```

### Windows

PowerShell을 관리자 권한으로 열기:
```powershell
irm https://raw.githubusercontent.com/ejkim-dev/ai-dev-setup/main/install.ps1 | iex
```

스크립트가 다운로드하고 압축을 풀어 대화형 설정을 시작합니다. 각 단계마다 화살표 키 메뉴를 사용 - 필요한 것만 선택하세요.

**지원 언어**: 한국어, 영어, 일본어 (시작 시 선택)

---

## 📚 문서

### 빠른 링크

- **[Phase 1 상세](docs/ko/PHASE1.md)** - 기본 환경 설정 가이드
- **[Phase 2 상세](docs/ko/PHASE2.md)** - Claude Code 설정 가이드
- **[Workspace 가이드](docs/ko/WORKSPACE.md)** - Workspace 구조 및 사용법
- **[문제 해결](docs/ko/TROUBLESHOOTING.md)** - 일반적인 문제 및 해결책
- **[FAQ](docs/ko/FAQ.md)** - 자주 묻는 질문

### English Documentation

- **[Phase 1 Details](docs/en/PHASE1.md)** - Basic environment setup guide
- **[Phase 2 Details](docs/en/PHASE2.md)** - Claude Code setup guide
- **[Workspace Guide](docs/en/WORKSPACE.md)** - Workspace structure and usage
- **[Troubleshooting](docs/en/TROUBLESHOOTING.md)** - Common issues and solutions
- **[FAQ](docs/en/FAQ.md)** - Frequently asked questions

---

## 🎨 주요 기능

### 모든 곳에서 화살표 키 탐색

**더 이상 `[Y/n]` 프롬프트 없음!** 모든 메뉴가 화살표 키 사용:

```
  ▸ 설치
    건너뛰기
```

↑↓로 이동, Enter로 선택. 간단하고 일관성 있습니다.

### 다중 선택 메뉴

한 번에 여러 옵션 선택:

```
  ▸ [x] Node.js - JavaScript 런타임 (필수)
    [x] ripgrep - 빠른 코드 검색
    [x] D2Coding 폰트 - 한글 코딩 폰트
    [ ] zsh-autosuggestions - 명령어 제안

  ↑↓: 이동 | Space: 선택/해제 | Enter: 확인
```

### 자동 연결

단계 간 스마트 연결:

**4단계**: `zsh-autosuggestions` 설치
→ **6단계**: "명령어 자동 제안 설정" 자동 선택

4단계에서 설치하지 않은 경우:
→ **6단계**: "설치되지 않음" 표시 및 옵션 비활성화

수동 설정 불필요!

---

## 💡 왜 Git이 Phase 2에 있나요?

Git은 Claude Code 버전 관리 기능을 위해 **권장**됩니다 (필수 아님):

**Git이 있으면**, Claude Code는:
- ✅ 코드 변경사항 추적 (`git status`, `git diff`)
- ✅ AI가 작성한 메시지로 커밋 자동 생성
- ✅ Pull request 생성 (`gh pr create`)
- ✅ 브랜치 관리 및 협업

**Git이 없어도** Claude Code는 작동하지만 버전 관리 통합 기능을 사용할 수 없습니다.

Phase 1에는 Git이 필요하지 않습니다. Phase 2에서 필요 시 자동으로 설치합니다.

---

## 🗂️ Claude Workspace 구조

Phase 2 이후:

```
~/claude-workspace/
├── global/
│   └── agents/              # 모든 프로젝트에서 사용 가능
│       ├── workspace-manager.md
│       ├── translate.md
│       └── doc-writer.md
├── projects/                # 프로젝트별 설정
│   └── my-app/
│       ├── .claude/
│       ├── CLAUDE.md
│       └── CLAUDE.local.md
└── templates/               # MCP, CLAUDE.md 템플릿
```

`workspace-manager` 에이전트가 심볼릭 링크, `.gitignore`, 설정을 자동으로 처리합니다.

**자세히 알아보기**: [Workspace 가이드](docs/ko/WORKSPACE.md)

---

## 🧹 정리 및 재설치

Phase 1 설치를 제거하고 처음부터 다시 시작:

### macOS
```bash
curl -fsSL https://raw.githubusercontent.com/ejkim-dev/ai-dev-setup/main/cleanup-phase1.sh | bash
```

**제거되는 항목**:
- Oh My Zsh (`~/.oh-my-zsh/`)
- 설치된 패키지 (Node.js, ripgrep 등)
- 셸 설정 (`~/.zshrc`)
- tmux 설정 (`~/.tmux.conf`)
- Terminal.app Dev 프로필
- Phase 2 파일 (`~/claude-code-setup/`)

**제거되지 않는 항목** (다른 앱에서 사용 중일 수 있음):
- Homebrew
- Xcode Command Line Tools
- D2Coding 폰트

각 단계마다 인터랙티브 메뉴로 확인을 요청합니다.

---

## 🌐 언어 지원

시작 시 언어를 선택하세요:
- 🇺🇸 English
- 🇰🇷 한국어 (Korean)
- 🇯🇵 日本語 (Japanese)

모든 메뉴, 메시지, 문서가 선택한 언어를 따릅니다.

언제든지 언어 변경:
```bash
rm ~/.dev-setup-lang
./setup.sh  # 다시 언어를 물어봄
```

---

## 🛠️ 커스터마이징

### 언어 추가

`locale/<code>.sh` (Windows용 `.ps1`) 생성하고 번역된 `MSG_*` 변수 작성.

`locale/en.sh`를 참고하세요.

### Global Agent 추가

`claude-code/agents/`에 `.md` 파일 추가. `~/claude-workspace/global/agents/`에 설치되어 모든 프로젝트에서 사용 가능.

### MCP 템플릿 추가

`claude-code/templates/`에 `__PLACEHOLDER__` 변수를 포함한 JSON 파일 추가. 설정 중 치환됨.

---

## 📖 작동 방식

```
install.sh/install.ps1
  ↓ ZIP 다운로드 및 ~/ai-dev-setup/에 압축 해제

setup.sh/setup.ps1 (Phase 1)
  ↓ 언어 선택 (English/한국어/日本語)
  ↓ ~/.dev-setup-lang에 언어 저장
  ↓ 도구 설치 → 터미널/셸 설정
  ↓ claude-code/ 복사 → ~/claude-code-setup/
  ↓ ~/ai-dev-setup/ 삭제 (정리)
  ✅ Phase 1 완료!

  ↓ "Phase 2를 지금 진행하시겠습니까?" (선택한 언어로)
  ├─ 예 → Phase 2로 새 터미널 열림
  └─ 아니오 → 언제든 실행 가능: ~/claude-code-setup/setup-claude.sh

~/claude-code-setup/setup-claude.sh (Phase 2, 선택)
  ↓ ~/.dev-setup-lang에서 언어 로드
  ↓ Git 설정 → workspace → agents → MCP 서버
  ↓ ~/claude-workspace/config.json에 설정 저장
  ✅ 완료!
```

---

## 🆘 도움 받기

- **[문제 해결 가이드](docs/ko/TROUBLESHOOTING.md)** - 일반적인 문제 및 해결책
- **[FAQ](docs/ko/FAQ.md)** - 자주 묻는 질문
- **[GitHub Issues](https://github.com/ejkim-dev/ai-dev-setup/issues)** - 버그 보고 또는 기능 요청

---

## 📄 라이선스

[MIT](LICENSE)

---

## 🔗 링크

- **문서**: [docs/ko/](docs/ko/) | [docs/en/](docs/en/)
- **저장소**: [github.com/ejkim-dev/ai-dev-setup](https://github.com/ejkim-dev/ai-dev-setup)
- **Claude Code**: [claude.ai/code](https://claude.ai/code)
