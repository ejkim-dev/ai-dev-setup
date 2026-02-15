# ai-dev-setup

[English](README.md) | **[한국어]**

개발 환경을 한 번에 설정하세요. macOS와 Windows를 지원합니다.

선택적으로 [Claude Code](https://claude.ai/code) 설정을 포함하여 중앙 워크스페이스 관리, MCP 서버, 글로벌 에이전트를 제공합니다.

## 📋 추천 대상

- **터미널 초보자**: 명령어가 낯설지만 AI 기반 터미널 개발 환경을 구축하고 싶은 분
- **AI 도구 활용**: Claude Code, Gemini CLI 등 AI 도구를 터미널에서 바로 사용하고 싶은 분
- **빠른 세팅**: 새 Mac/Windows에서 복잡한 설정 없이 한 번에 AI 기반 터미널 개발 환경을 갖추고 싶은 분
- **일관된 환경**: 여러 컴퓨터에서 동일한 터미널 환경을 유지하고 싶은 분

## 🎯 이 스크립트가 하는 일

### 1️⃣ 기본 설치 및 터미널 환경 세팅 (`setup.sh` / `setup.ps1`)

**Step 1: Xcode Command Line Tools (macOS만)**
- Git, make, gcc 등 개발 도구 포함
- macOS 개발의 기본 필수 도구

**Step 2: 패키지 매니저**
- macOS: Homebrew 설치 (이후 모든 도구 설치의 기반)
- Windows: winget 확인 (Windows 11 기본 탑재)

**Step 3: 필수 패키지**
- **Node.js**: JavaScript 런타임 (Claude Code 등 AI 도구 실행에 필요)
- **ripgrep**: 빠른 코드 검색 도구
- **tmux** (macOS만): 터미널 분할 및 세션 관리
- **zsh-autosuggestions**: 명령어 자동 완성 제안
- **zsh-syntax-highlighting**: 명령어 문법 강조

**Step 4: D2Coding 폰트**
- 한글 잘 나오는 코딩 전용 폰트
- 가독성 좋은 고정폭 폰트

**Step 5: 터미널 + 쉘 환경**
- **Terminal.app + iTerm2** (macOS):
  - Dev 다크 테마 프로필 자동 적용
  - Meslo Nerd Font 설치 (아이콘 지원)
  - iTerm2 설치 여부 선택 가능
- **Windows Terminal** (Windows):
  - 다크 테마 + 폰트 자동 설정
- **Oh My Zsh** (macOS):
  - agnoster 테마 적용 (Git 브랜치 표시)
  - git, zsh-autosuggestions, zsh-syntax-highlighting 플러그인
- **Oh My Posh** (Windows):
  - PowerShell 프롬프트 테마
- **.zshrc / .tmux.conf** 설정 파일 자동 적용

**Step 6: AI 코딩 도구 (다중 선택 가능)**
- **Claude Code**: Anthropic의 AI 코딩 어시스턴트
- **Gemini CLI**: Google의 AI CLI 도구
- **Codex CLI**: OpenAI의 코드 생성 도구
- **GitHub Copilot CLI**: GitHub CLI (gh) 설치되어 있을 때만 선택 가능

**마무리:**
- claude-code 설정 파일을 ~/claude-code-setup/으로 복사
- Phase 2 (Claude Code 세팅) 진행 여부 선택

### 2️⃣ Claude Code 세팅 (선택 사항, `claude-code/setup-claude.sh` / `setup-claude.ps1`)

**AI 개발 환경 구축:**
- Claude Code CLI 설치
- 추가 AI CLI 도구 (Gemini CLI, Codex CLI 등)
- MCP 서버 설정 (파일 시스템, 메모리 등)
- 전역 에이전트 설치 (workspace-manager, translate, doc-writer)

## 빠른 시작 (한 줄)

Git 필요 없음. 복사해서 붙여넣기만 하세요.

**macOS** — 터미널 열기:
```bash
curl -fsSL https://raw.githubusercontent.com/ejkim-dev/ai-dev-setup/main/install.sh | bash
```

**Windows** — PowerShell을 관리자 권한으로 열기:
```powershell
irm https://raw.githubusercontent.com/ejkim-dev/ai-dev-setup/main/install.ps1 | iex
```

스크립트가 다운로드하고 압축을 풀어 대화형 설정을 시작합니다. 각 단계마다 Y/n을 물어보니 필요한 것만 선택하세요.

**한국어**, **영어**, **일본어**를 지원합니다 (시작 시 선택).

## 설치되는 항목

### Phase 1: 기본 환경

필수 도구와 터미널 설정. 모든 단계는 선택사항입니다.

| 도구 | 설명 | macOS | Windows |
|------|------|:-----:|:-------:|
| 패키지 관리자 | Homebrew / winget | ✅ | ✅ |
| Node.js | JavaScript 런타임 (Claude Code용) | ✅ | ✅ |
| ripgrep | 빠른 코드 검색 도구 | ✅ | ✅ |
| D2Coding | 한글 지원 개발 폰트 | ✅ | ✅ |
| Terminal.app 테마 | 다크 테마 프로필 | ✅ | - |
| Windows Terminal | 다크 테마 + 폰트 설정 | - | ✅ |
| iTerm2 | 고급 터미널 (선택) | ✅ | - |
| Oh My Zsh / Oh My Posh | 쉘 테마 + 플러그인 | ✅ | ✅ |
| tmux | 터미널 멀티플렉서 | ✅ | - |
| AI 코딩 도구 | Claude Code, Gemini CLI, GitHub Copilot CLI | ✅ | ✅ |

### Phase 2: Claude Code 설정 (선택)

Phase 1 이후 별도로 실행:

```bash
# macOS
~/claude-code-setup/setup-claude.sh

# Windows (PowerShell)
~\claude-code-setup\setup-claude.ps1
```

다음을 설정합니다:

| 기능 | 설명 | macOS | Windows |
|------|------|:-----:|:-------:|
| **Git + GitHub CLI** | 버전 관리 (Claude 기능에 권장) | ✅ | ✅ |
| **SSH 키** | GitHub 인증 | ✅ | ✅ |
| **claude-workspace** | 심볼릭 링크를 통한 중앙 관리 | ✅ | ✅ |
| **글로벌 에이전트** | workspace-manager, translate, doc-writer | ✅ | ✅ |
| **MCP: local-rag** | 문서 검색 (PDF, 마크다운) | ✅ | ✅ |
| **Obsidian** | 노트 작성 앱 (선택) | ✅ | ✅ |

#### 왜 Git이 Phase 2에 있나요?

Git은 Claude Code의 버전 관리 기능을 사용하기 위해 **권장**됩니다:
- 코드 변경사항 추적 (`git status`, `git diff`)
- 자동 커밋 생성 (AI가 커밋 메시지 작성)
- GitHub 연동 (PR 생성, 이슈 관리)
- 버전 관리로 협업

**Git 없이도 Claude Code는 작동**하지만, 버전 관리 기능은 사용할 수 없습니다.

## Claude Code 워크스페이스 구조

```
~/claude-workspace/
├── global/agents/    ← 모든 프로젝트에서 사용 가능
│   ├── workspace-manager.md
│   ├── translate.md
│   └── doc-writer.md
├── projects/         ← 프로젝트별 설정
│   └── my-app/
│       ├── .claude/
│       ├── CLAUDE.md
│       └── CLAUDE.local.md
└── templates/        ← MCP, CLAUDE.md 템플릿
```

프로젝트를 연결하면 workspace-manager 에이전트가 심볼릭 링크, `.gitignore`, 설정을 자동으로 처리합니다.

### 글로벌 에이전트

| 에이전트 | 설명 |
|----------|------|
| **workspace-manager** | 프로젝트 연결/해제, 심볼릭 링크 관리, MCP 설정, 상태 확인 |
| **translate** | 마크다운과 코드 블록을 보존하며 문서를 언어 간 번역 |
| **doc-writer** | 코드에서 README, CLAUDE.md, API 문서, 아키텍처 문서 생성 |

### MCP 서버

| 서버 | 설명 |
|------|------|
| **local-rag** | Claude로 PDF, 마크다운, 문서 검색 |

## 파일 구조

```
ai-dev-setup/
├── install.sh / install.ps1        # 한 줄 설치 스크립트 (다운로드 + 실행)
├── setup.sh / setup.ps1            # Phase 1: 기본 환경
├── Brewfile                        # Homebrew 패키지 (macOS)
├── configs/
│   ├── mac/Dev.terminal            # Terminal.app 다크 테마
│   ├── windows/windows-terminal.json
│   └── shared/.zshrc, .tmux.conf
└── claude-code/
    ├── setup-claude.sh / .ps1      # Phase 2: Claude Code 설정
    ├── agents/                     # 글로벌 에이전트 정의
    ├── locale/                     # 다국어 지원 (en, ko, ja)
    ├── templates/                  # MCP 설정 템플릿
    └── examples/                   # CLAUDE.md, MEMORY.md 예제
```

## 작동 방식

```
install.sh
  ↓ ZIP 다운로드 + 압축 해제
setup.sh (Phase 1)
  ↓ 언어 선택 → 도구 설치 → 설정
  ↓ claude-code/ 복사 → ~/claude-code-setup/
  ↓ 설치 디렉토리 삭제 (.git 포함)
  ✅ Phase 1 완료!

  ↓ "Phase 2 계속 진행?" [Y/n]
  ├─ Yes → "새 터미널 열기?" [Y/n]
  │         ├─ Yes → Phase 2로 새 터미널 자동 열림
  │         └─ No → 나중에 수동 실행 안내
  └─ No → Phase 2 건너뛰기 (언제든 나중에 실행 가능)

~/claude-code-setup/setup-claude.sh (Phase 2, 선택)
  ↓ 새 터미널에서 자동 실행 (위에서 Yes 선택 시)
  ↓ 또는 언제든 수동 실행: ~/claude-code-setup/setup-claude.sh
  ↓ 언어 선택 → Git 설정 → workspace → agents → MCP → Obsidian
  ↓ 설정을 ~/claude-workspace/config.json에 저장
  완료!
```

## 커스터마이징

**언어 추가**: `claude-code/locale/<code>.sh` (Windows용 `.ps1`) 생성하고 번역된 `MSG_*` 변수 작성. `locale/en.sh` 참고.

**에이전트 추가**: `claude-code/agents/`에 `.md` 파일 추가. `~/claude-workspace/global/agents/`에 설치되어 모든 프로젝트에서 사용 가능.

**MCP 템플릿 추가**: `claude-code/templates/`에 `__PLACEHOLDER__` 변수를 포함한 JSON 파일 추가. 설정 중 치환됨.

## 라이선스

[MIT](LICENSE)
