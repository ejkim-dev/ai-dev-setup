# Claude Code 시작하기

환영합니다! 이 가이드는 설치 후 Claude Code를 사용하는 방법을 안내합니다.

## 빠른 시작

### 1️⃣ Claude Code 로그인

Claude Code를 처음 실행하면 인증이 필요합니다:

```bash
# 아무 프로젝트 폴더로 이동
cd ~/my-project

# Claude Code 실행
claude
```

**일어나는 일:**
- 브라우저가 자동으로 열림
- Claude 계정으로 로그인 (또는 가입)
- Claude Code CLI 권한 승인
- 준비 완료!

### 2️⃣ 프로젝트 초기화

프로젝트에 Claude Code 설정:

```bash
cd ~/my-project
claude init
```

**생성되는 것:**
- `.claude/` 디렉토리 (프로젝트 설정)
- `CLAUDE.md` (Claude에게 주는 지시사항)
- `CLAUDE.local.md` (개인 메모)

### 3️⃣ AI와 코딩 시작

```bash
claude
```

이제 할 수 있는 것:
- Claude에게 코드 작성 요청
- 설명 요청
- 디버깅 도움 받기
- 기존 코드 리팩토링

## 워크스페이스 구조

`~/claude-workspace/`에는:

```
~/claude-workspace/
├── doc/              ← 문서 (지금 보고 계신 곳!)
├── shared/
│   ├── agents/       ← 공유 에이전트 (모든 프로젝트에서 사용)
│   ├── templates/    ← 프로젝트 템플릿
│   └── mcp/          ← 공유 MCP 서버
├── projects/         ← 연결된 프로젝트 (workspace-manager가 관리)
└── config.json       ← 사용자 설정
```

## 프로젝트 워크스페이스 연결

workspace-manager 에이전트로 프로젝트 연결:

```bash
# Claude Code에서
> @workspace-manager ~/my-app 연결해줘
```

생성되는 것:
- `~/claude-workspace/projects/my-app/.claude/` (설정)
- 실제 프로젝트에서 워크스페이스로 심볼릭 링크
- 중앙 집중식 관리

## 다음 단계

- [Claude 가이드](./claude-guide.ko.md)를 읽고 CLAUDE.md, 에이전트, MCP 등 이해하기
- 공유 에이전트 탐색: workspace-manager, translate, doc-writer
- 프로젝트용 MCP 서버 설정

## 도움이 필요하신가요?

- 문서: https://docs.claude.ai/code
- 워크스페이스 문서: `~/claude-workspace/doc/`
- Claude에게 직접 물어보세요: "어떻게 하면...?"
