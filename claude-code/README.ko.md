# Claude Code 설정 가이드

## Claude Code란?

터미널에서 실행되는 AI 코딩 어시스턴트입니다.
AI와 대화하며 코드 작성, 버그 수정, 파일 검색 등을 할 수 있습니다.

**Claude Code 설치:**
- 방문: https://claude.ai/code
- 또는 설정 실행: `./setup-claude.sh`

**사용법:**
```bash
cd ~/projects/my-app
claude
```

---

## 빠른 설정

### 자동화 (권장)

```bash
./setup-claude.sh
```

설치되는 것들:
- **claude-workspace** — 모든 프로젝트를 중앙에서 관리
- **프로젝트 연결** — 심볼릭 링크로 프로젝트를 워크스페이스에 연결
- **공유 에이전트** — 재사용 가능한 AI 어시스턴트 (workspace-manager, translate, doc-writer)
- **MCP 서버** — 프로젝트별 외부 도구 통합 (local-rag, filesystem 등)
- **Obsidian** — 마크다운 메모 앱 (선택, local-rag 연동)
- **템플릿** — CLAUDE.md 및 .mcp.json 템플릿

### 수동

Claude Code 설치 후, 아래 문서를 참고하여 수동 설정.

---

## 주요 기능

### 📁 Claude Workspace
심볼릭 링크로 모든 Claude 설정을 한 곳에서 관리.
프로젝트마다 흩어진 `.claude/` 폴더는 이제 그만.

**자세히:** [`doc/ko/workspace-philosophy.md`](doc/ko/workspace-philosophy.md)

### 🤖 에이전트
특정 작업을 위한 전문 AI 어시스턴트.
- **workspace-manager** — 프로젝트 관리
- **translate** — 문서 번역
- **doc-writer** — 문서 생성

**자세히:** [`doc/ko/claude-guide.md#에이전트-agents`](doc/ko/claude-guide.md#에이전트-agents)

### 📝 CLAUDE.md
Claude가 자동으로 읽는 프로젝트 지시사항.
아키텍처, 코딩 규칙, 워크플로우를 한 번만 정의.

**자세히:** [`doc/ko/claude-guide.md#claudemd`](doc/ko/claude-guide.md#claudemd)

### 🔌 MCP 서버
Claude를 외부 도구 및 데이터 소스에 연결.
문서 검색, 웹 브라우징, 데이터베이스 접근 등.

**자세히:** [`doc/ko/claude-guide.md#mcp-model-context-protocol`](doc/ko/claude-guide.md#mcp-model-context-protocol)

### 💬 슬래시 커맨드
내장 명령어: `/help`, `/agents`, `/model`, `/compact`, `/exit`

**자세히:** [`doc/ko/claude-guide.md#슬래시-커맨드`](doc/ko/claude-guide.md#슬래시-커맨드)

---

## 문서

`doc/` 디렉토리에서 참고 문서 확인:

| 파일 | EN | KO |
|------|----|----|
| 시작 가이드 | [`doc/en/getting-started.md`](doc/en/getting-started.md) | [`doc/ko/getting-started.md`](doc/ko/getting-started.md) |
| Claude 가이드 | [`doc/en/claude-guide.md`](doc/en/claude-guide.md) | [`doc/ko/claude-guide.md`](doc/ko/claude-guide.md) |
| 워크스페이스 철학 | [`doc/en/workspace-philosophy.md`](doc/en/workspace-philosophy.md) | [`doc/ko/workspace-philosophy.md`](doc/ko/workspace-philosophy.md) |

**여기서 시작:** [`doc/ko/getting-started.md`](doc/ko/getting-started.md)

---

## 다음 단계

1. **설정 실행:** `./setup-claude.sh`
2. **시작 가이드 읽기:** `doc/ko/getting-started.md`
3. **코딩 시작:** `cd ~/my-project && claude`

---

## 예시

[examples/](examples/)에서 샘플 설정 확인:
- `CLAUDE.md` — 프로젝트 지시사항 템플릿
- `MEMORY.md` — AI 메모리 노트북 템플릿
- `.mcp.json` — MCP 서버 설정
