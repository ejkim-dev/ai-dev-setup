# Claude Code 설정 가이드

## Claude Code란?

터미널에서 실행되는 AI 코딩 어시스턴트입니다.
AI와 대화하며 코드 작성, 버그 수정, 파일 검색 등을 할 수 있습니다.

```bash
# 설치
npm install -g @anthropic-ai/claude-code

# 사용법: 프로젝트 폴더에서 실행
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
- **공유 에이전트** — 재사용 가능한 AI 어시스턴트 (workspace-manager, translate, doc-writer)
- **MCP 서버** — 외부 도구 통합 (local-rag, filesystem 등)
- **템플릿** — CLAUDE.md 및 .mcp.json 템플릿
- **문서** — 상세 가이드

### 수동

Claude Code 설치 후, 아래 문서를 참고하여 수동 설정.

---

## 주요 기능

### 📁 Claude Workspace
심볼릭 링크로 모든 Claude 설정을 한 곳에서 관리.
프로젝트마다 흩어진 `.claude/` 폴더는 이제 그만.

**자세히:** [`~/claude-workspace/doc/workspace-philosophy.ko.md`](doc/workspace-philosophy.ko.md)

### 🤖 에이전트
특정 작업을 위한 전문 AI 어시스턴트.
- **workspace-manager** — 프로젝트 관리
- **translate** — 문서 번역
- **doc-writer** — 문서 생성

**자세히:** [`~/claude-workspace/doc/claude-guide.ko.md#에이전트-agents`](doc/claude-guide.ko.md#에이전트-agents)

### 📝 CLAUDE.md
Claude가 자동으로 읽는 프로젝트 지시사항.
아키텍처, 코딩 규칙, 워크플로우를 한 번만 정의.

**자세히:** [`~/claude-workspace/doc/claude-guide.ko.md#claudemd`](doc/claude-guide.ko.md#claudemd)

### 🔌 MCP 서버
Claude를 외부 도구 및 데이터 소스에 연결.
문서 검색, 웹 브라우징, 데이터베이스 접근 등.

**자세히:** [`~/claude-workspace/doc/claude-guide.ko.md#mcp-model-context-protocol`](doc/claude-guide.ko.md#mcp-model-context-protocol)

### 💬 슬래시 커맨드
내장 명령어: `/help`, `/agents`, `/model`, `/compact`, `/exit`

**자세히:** [`~/claude-workspace/doc/claude-guide.ko.md#슬래시-커맨드`](doc/claude-guide.ko.md#슬래시-커맨드)

---

## 문서

설정 후 `~/claude-workspace/doc/`에서 상세 가이드 확인:

| 파일 | 설명 |
|------|------|
| [`getting-started.md`](doc/getting-started.md) / [`.ko.md`](doc/getting-started.ko.md) | 빠른 시작 가이드 |
| [`claude-guide.md`](doc/claude-guide.md) / [`.ko.md`](doc/claude-guide.ko.md) | 전체 개념 가이드 (CLAUDE.md, 에이전트, MCP 등) |
| [`workspace-philosophy.md`](doc/workspace-philosophy.md) / [`.ko.md`](doc/workspace-philosophy.ko.md) | 워크스페이스란? 설계 철학 |

**여기서 시작:** [`~/claude-workspace/doc/getting-started.ko.md`](doc/getting-started.ko.md)

---

## 다음 단계

1. **설정 실행:** `./setup-claude.sh`
2. **시작 가이드 읽기:** `~/claude-workspace/doc/getting-started.ko.md`
3. **코딩 시작:** `cd ~/my-project && claude`

---

## 예시

[examples/](examples/)에서 샘플 설정 확인:
- `CLAUDE.md` — 프로젝트 지시사항 템플릿
- `MEMORY.md` — AI 메모리 노트북 템플릿
- `.mcp.json` — MCP 서버 설정
