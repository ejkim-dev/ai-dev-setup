# Phase 2: Claude Code 설정

Claude Code CLI, 워크스페이스 관리, 전역 에이전트, MCP 서버를 설정합니다.

## 개요

**목표**: 중앙화된 워크스페이스 관리와 함께 Claude Code 설치 및 구성

**전제 조건**: Phase 1 완료 (또는 기본 개발 환경이 이미 설정됨)

**대상 사용자**:
- Claude Code 사용자
- AI 보조 개발 워크플로우
- 중앙 집중식 프로젝트 설정

**소요 시간**: 10-20분

---

## 설치되는 항목

| 구성 요소 | 설명 | macOS | Windows |
|-----------|------|:-----:|:-------:|
| **Git** | 버전 관리 시스템 | ✅ | ✅ |
| **GitHub CLI** | GitHub 명령줄 도구 | ✅ | ✅ |
| **SSH 키** | GitHub 인증 | ✅ | ✅ |
| **Node.js** | 확인 (Phase 1에서 설치됨) | ✅ | ✅ |
| **Claude Code CLI** | Anthropic의 AI 코딩 어시스턴트 | ✅ | ✅ |
| **claude-workspace** | 중앙 설정 구조 | ✅ | ✅ |
| **전역 에이전트** | 재사용 가능한 에이전트 (다중 선택) | ✅ | ✅ |
| **MCP 서버** | 5개 서버 (다중 선택) | ✅ | ✅ |
| **Obsidian** | 노트 앱 (선택사항) | ✅ | ✅ |

---

## 설치 단계

### Step 0: 언어 선택

`~/.dev-setup-lang`에서 언어 기본 설정을 로드합니다 (Phase 1에서 저장됨).

찾을 수 없는 경우 언어 선택 프롬프트가 표시됩니다.

---

### Step 1: Git 설치

**자동 감지**: Git이 이미 설치되어 있으면 이 단계를 건너뜁니다

```
[1/8] Git

  ✅ 이미 설치되어 있습니다: git version 2.39.0
```

**설치되지 않은 경우**:
- macOS: Homebrew를 통해 설치 (`brew install git`)
- Windows: winget을 통해 설치

---

### Step 2: GitHub CLI 설치

**자동 감지**: GitHub CLI가 이미 설치되어 있으면 이 단계를 건너뜁니다

```
[2/8] GitHub CLI

  ⏭️ 이미 설치되어 있습니다: gh version 2.40.0
```

**설치되지 않은 경우**:
- 패키지 관리자를 통해 `gh` 설치
- 인증 프롬프트:

```
GitHub CLI에 인증이 필요합니다.

  ▸ 지금 인증하기
    건너뛰기 (나중에 인증 가능)
```

**인증 과정**:
1. OAuth 로그인을 위해 브라우저 열기
2. 또는 수동 인증을 위한 코드 제공
3. 인증 성공 확인

**왜 인증이 필요한가요?**
- Claude Code에서 풀 리퀘스트 생성
- 이슈 및 저장소 관리
- 적절한 자격 증명으로 코드 푸시

---

### Step 3: Node.js 확인

**자동 감지**: Phase 1의 Node.js 확인

```
[3/8] Node.js

  ✅ 이미 설치되어 있습니다: v20.10.0
```

**찾을 수 없는 경우**:
- 패키지 관리자를 통해 설치 제안
- Claude Code CLI 및 MCP 서버에 필요

---

### Step 4: Claude Code CLI 설치

**자동 감지**: Claude Code가 이미 설치되어 있는지 확인

```
[4/8] Claude Code CLI

  ⏭️ 이미 설치되어 있습니다: claude version 1.2.3
```

**설치되지 않은 경우**:
```
[4/8] Claude Code CLI

  Claude Code 설치 중...
  ✅ Claude Code 설치 완료
```

**설치**: `npm install -g @anthropic-ai/claude-code`

**처음 설정** (API 키가 구성되지 않은 경우):
```
Claude Code 초기 설정이 필요합니다.

지금 설정을 실행하시겠습니까?

  ▸ 예, 설정 실행
    아니오, 건너뛰기 (나중에 수동으로 실행)
```

"예"를 선택하면: `claude init` 실행 (Claude의 자체 인터페이스에서 API 키 입력 프롬프트)

---

### Step 5: claude-workspace 구조

Claude Code 리소스 관리를 위한 중앙 집중식 워크스페이스를 생성합니다.

**디렉토리 구조**:
```
~/claude-workspace/
├── global/
│   └── agents/           # 전역 에이전트 (모든 프로젝트)
├── projects/             # 프로젝트별 설정
└── templates/            # MCP, CLAUDE.md 템플릿
```

**수행 작업**:
1. 디렉토리 구조 생성
2. 사용 지침이 포함된 README.md 생성
3. 워크스페이스가 이미 존재하면 건너뜀 (기존 설정 유지)

**이점**:
- **중앙 집중식 관리**: 모든 전역 리소스를 한 곳에서 관리
- **재사용 가능한 에이전트**: 모든 프로젝트에서 사용 가능
- **템플릿 라이브러리**: 빠른 프로젝트 초기화
- **백업 위치**: 프로젝트별 설정

---

### Step 6: 전역 에이전트 설치

에이전트 선택을 위한 **다중 선택 메뉴**:

```
[6/8] 전역 에이전트

  설치할 에이전트를 선택하세요:

  ▸ [x] workspace-manager - 프로젝트 구조 관리 (권장)
    [x] translate - 다국어 번역 (권장)
    [x] doc-writer - 문서 생성 (권장)

  ↑↓: 이동 | Space: 선택/해제 | Enter: 확인
```

**기본 선택**: 3개 에이전트 모두 권장되며 미리 선택됨

**에이전트 설명**:

#### workspace-manager (권장)
**역할**:
- 워크스페이스에 프로젝트 연결/연결 해제
- 심볼릭 링크 자동 관리
- .gitignore 항목 설정
- 워크스페이스 상태 확인

**사용 사례**:
- 새 프로젝트 구조 초기화
- 기존 프로젝트를 워크스페이스에 연결
- 프로젝트 간 CLAUDE.md 동기화

#### translate (권장)
**역할**:
- 언어 간 문서 번역 (en/ko/ja)
- 마크다운 형식 유지
- 코드 블록 유지
- 일괄 번역

**사용 사례**:
- README 파일 번역
- 문서 현지화
- 다국어 가이드 생성

#### doc-writer (권장)
**역할**:
- 코드에서 README 생성
- 프로젝트용 CLAUDE.md 생성
- API 문서 작성
- 아키텍처 문서 생성

**사용 사례**:
- 프로젝트 문서 부트스트랩
- 코드 변경 후 문서 업데이트
- 문서 형식 표준화

**설치**: 선택한 에이전트를 `~/claude-workspace/global/agents/`에 복사

**프로젝트에서 사용**: CLAUDE.md에서 참조:
```markdown
# 사용 가능한 전역 에이전트
- workspace-manager
- translate
- doc-writer
```

---

### Step 7: MCP 서버 설치

MCP 서버 선택을 위한 **다중 선택 메뉴** (총 5개):

```
[7/8] MCP 서버

  설치할 서버를 선택하세요:

  ▸ [x] local-rag - 문서/코드 검색 (권장)
    [x] filesystem - 파일 읽기/쓰기 (권장)
    [x] serena - 웹 검색 (권장)
    [ ] fetch - HTTP 요청
    [ ] puppeteer - 브라우저 자동화

  ↑↓: 이동 | Space: 선택/해제 | Enter: 확인
```

**기본 선택**: 처음 3개 서버 (local-rag, filesystem, serena)

**MCP 서버 설명**:

#### local-rag (권장)
**역할**:
- 로컬 문서 색인 및 검색
- RAG (Retrieval-Augmented Generation)
- PDF, 마크다운, 코드 파일 검색

**사용 사례**:
- "문서에서 인증과 관련된 모든 참조 찾기"
- "API 디자인에 대한 내 노트 검색"
- 프로젝트별 지식 베이스

**설정**:
```json
{
  "command": "local-rag-mcp",
  "env": {
    "RAG_INDEX_PATH": "~/.claude/rag-index"
  }
}
```

#### filesystem (권장)
**역할**:
- 안전한 파일 읽기/쓰기 작업
- 디렉토리 탐색
- 파일 시스템 쿼리

**사용 사례**:
- "설정 파일 읽기"
- "새 컴포넌트 파일 생성"
- "모든 테스트 파일 나열"

**설정**:
```json
{
  "command": "filesystem-mcp",
  "args": ["--root", "~/"]
}
```

#### serena (권장)
**역할**:
- 웹 검색 기능
- 실시간 정보
- API 문서 조회

**사용 사례**:
- "최신 React 모범 사례 검색"
- "이 라이브러리 문서 찾기"
- "X의 현재 구문은 무엇인가요?"

**설정**:
```json
{
  "command": "serena-mcp"
}
```

#### fetch
**역할**:
- HTTP 요청 (GET, POST 등)
- REST API 호출
- 웹 데이터 검색

**사용 사례**:
- "이 API에서 데이터 가져오기"
- "이 REST 엔드포인트 테스트"
- "이 JSON 파일 다운로드"

**설정**:
```json
{
  "command": "fetch-mcp"
}
```

#### puppeteer
**역할**:
- 브라우저 자동화
- 스크린샷 캡처
- 웹 스크래핑

**사용 사례**:
- "이 페이지의 스크린샷 찍기"
- "이 웹사이트에서 데이터 스크랩"
- "UI 상호작용 테스트"

**설정**:
```json
{
  "command": "puppeteer-mcp",
  "args": ["--headless"]
}
```

**설치 과정**:
1. npm을 통해 선택한 서버 설치: `npm install -g <server-package>`
2. `.mcp.json` 설정 파일 생성
3. `~/.claude/.mcp.json`에 저장

**생성된 .mcp.json 예시** (권장 3개 모두 선택한 경우):
```json
{
  "mcpServers": {
    "local-rag": {
      "command": "local-rag-mcp",
      "args": [],
      "env": {
        "RAG_INDEX_PATH": "~/.claude/rag-index"
      }
    },
    "filesystem": {
      "command": "filesystem-mcp",
      "args": ["--root", "~/"],
      "env": {}
    },
    "serena": {
      "command": "serena-mcp",
      "args": [],
      "env": {}
    }
  }
}
```

---

### Step 8: Obsidian 설치 (선택사항)

Claude Code 통합이 가능한 마크다운 기반 노트 앱.

```
[8/8] Obsidian

  마크다운 기반 노트 및 문서 앱입니다.
  문서는 local-rag를 통해 Claude Code에서 검색할 수 있습니다.

  Obsidian을 설치하시겠습니까?

  ▸ 예
    아니오
```

**"예"를 선택하면**:
- macOS: `brew install --cask obsidian`
- Windows: `winget install Obsidian.Obsidian`

**local-rag와의 통합**:
1. `~/claude-workspace/vault/`에 볼트 생성
2. 마크다운으로 노트 작성
3. local-rag MCP 서버로 볼트 색인
4. Claude Code에서 노트 검색

**사용 사례**:
- 프로젝트 문서
- 회의 노트
- 기술 지식 베이스
- 학습 노트

---

## 완료 요약

Phase 2가 완료되면 다음이 표시됩니다:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✨ Phase 2 완료!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

다음 단계:

  1. Claude Code 초기화 (완료하지 않은 경우):
     claude init

  2. 프로젝트 구조 생성:
     mkdir -p .claude/{agents,mcp,tools,notes}
     touch CLAUDE.md CLAUDE.local.md

  3. 설치된 에이전트 확인:
     ls ~/claude-workspace/global/agents/

  4. MCP 서버 확인:
     cat ~/.claude/.mcp.json

  5. Claude로 코딩 시작:
     claude chat

Happy coding with Claude! 🚀
```

---

## 워크스페이스 구조

자세한 워크스페이스 구성 및 사용법은 [WORKSPACE.md](WORKSPACE.md)를 참조하세요.

---

## UI/UX 패턴

### 화살표 키 탐색
Phase 1과 동일 - 모든 메뉴가 화살표 키 사용:
- ↑↓ - 이동
- Space - 선택/해제 (다중 선택)
- Enter - 확인

### 다중 선택 메뉴
시각적 표시:
- `[x]` - 선택됨
- `[ ]` - 선택 안 됨
- `(권장)` - 제안 옵션

### 상태 메시지
- ✅ `완료` - 성공
- ⏭️ `건너뜀` - 이미 설치되어 있거나 사용자가 건너뜀
- ❌ `실패` - 복구 지침과 함께 오류 발생

---

## 에러 처리

### npm 설치 실패

```
❌ MCP 서버 설치 실패

문제 해결:
  1. 네트워크 연결 확인
  2. npm이 작동하는지 확인: npm --version
  3. 수동 설치 시도: npm install -g <package>

계속하시겠습니까?

  ▸ 예, 계속
    아니오, 종료
```

### GitHub 인증 실패

```
⚠️ GitHub 인증 실패

나중에 인증할 수 있습니다:
  gh auth login

인증 없이 계속하시겠습니까?

  ▸ 예
    아니오
```

### API 키가 구성되지 않음

```
Claude Code에 API 키가 필요합니다.

키 받기: https://console.anthropic.com/

지금 설정을 실행하시겠습니까?

  ▸ 예, 설정 실행
    아니오, 건너뛰기 (나중에 구성)
```

---

## 설정 파일

### ~/.claude/.mcp.json
MCP 서버 설정:
```json
{
  "mcpServers": {
    "local-rag": { ... },
    "filesystem": { ... },
    "serena": { ... }
  }
}
```

### ~/claude-workspace/
중앙 워크스페이스 구조:
```
claude-workspace/
├── global/agents/        # 전역 에이전트
│   ├── workspace-manager.md
│   ├── translate.md
│   └── doc-writer.md
├── projects/             # 프로젝트 백업
└── templates/            # 템플릿
```

### ~/.dev-setup-lang
언어 기본 설정 (Phase 1에서 저장됨):
```
ko
```

---

## 문제 해결

일반적인 문제와 해결책은 [TROUBLESHOOTING.md](TROUBLESHOOTING.md)를 참조하세요.

## FAQ

자주 묻는 질문은 [FAQ.md](FAQ.md)를 참조하세요.

## 워크스페이스 가이드

자세한 워크스페이스 사용법은 [WORKSPACE.md](WORKSPACE.md)를 참조하세요.
