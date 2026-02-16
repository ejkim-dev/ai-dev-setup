# Claude Code 가이드

Claude Code의 주요 개념과 파일들을 설명합니다.

## 목차

1. [CLAUDE.md](#claudemd)
2. [CLAUDE.local.md](#claudelocalmd)
3. [.claude/ 디렉토리](#claude-디렉토리)
4. [Task.md](#taskmd)
5. [에이전트 (Agents)](#에이전트-agents)
6. [슬래시 커맨드](#슬래시-커맨드)
7. [MCP (Model Context Protocol)](#mcp-model-context-protocol)

---

## CLAUDE.md

**목적:** 프로젝트에 대한 Claude의 지시사항.

**위치:** 프로젝트 루트 (예: `~/my-app/CLAUDE.md`)

**포함할 내용:**
- 프로젝트 개요 및 아키텍처
- 코딩 규칙 및 스타일 가이드
- 중요한 파일들과 용도
- 빌드/테스트 명령어
- Claude가 알아야 하거나 피해야 할 것들

**예시:**
```markdown
# My App

## 아키텍처
- 프론트엔드: React + TypeScript
- 백엔드: Node.js + Express
- 데이터베이스: PostgreSQL

## 규칙
- 함수형 컴포넌트 사용
- 모든 새 기능에 테스트 추가
- ESLint 규칙 따르기

## 중요
- config/secrets.json 절대 수정 금지
- 커밋 전 항상 테스트 실행
```

**Git 커밋 여부:** ✅ 예 (팀 공유)

---

## CLAUDE.local.md

**목적:** 개인 메모 및 설정 (팀과 공유 안 함).

**위치:** 프로젝트 루트 (예: `~/my-app/CLAUDE.local.md`)

**포함할 내용:**
- 개인 워크플로우 선호사항
- 코드베이스 관련 개인 메모
- Claude 응답 언어 설정
- 로컬 개발 환경 설정

**예시:**
```markdown
# 내 메모

## 언어
- 한국어로 답변
- 코드/기술 용어는 영어 사용

## 내 환경
- 로컬 DB 포트: 5433
- Redis 포트: 6380

## 리마인더
- 마이그레이션 후 스키마 업데이트 잊지 말기
```

**Git 커밋 여부:** ❌ 아니오 (gitignore, 개인용)

---

## .claude/ 디렉토리

**목적:** 프로젝트별 Claude Code 설정.

**위치:** 프로젝트 루트 (예: `~/my-app/.claude/`)

**구조:**
```
.claude/
├── agents/           # 프로젝트 전용 에이전트
├── mcp/              # MCP 서버 설정
├── tools/            # 커스텀 도구
└── settings.json     # 프로젝트 권한
```

**워크스페이스 사용 시:**
- 실제 파일: `~/claude-workspace/projects/my-app/.claude/`
- 심볼릭 링크: `~/my-app/.claude/` → 워크스페이스

**Git 커밋 여부:** ❌ 아니오 (gitignore)

---

## Task.md

**목적:** 복잡한 작업을 단계별로 나누기.

**위치:** 프로젝트 루트 또는 `.claude/` 디렉토리

**사용 사례:** 여러 단계의 작업이 있을 때 진행 상황 추적.

**예시:**
```markdown
# 사용자 인증 구현

## 작업
- [ ] User 모델 생성
- [ ] 비밀번호 해싱 추가
- [ ] 로그인 엔드포인트 생성
- [ ] JWT 토큰 생성 추가
- [ ] 인증 미들웨어 생성
- [ ] 테스트 추가
```

**Claude가 사용하는 방법:**
- 작업을 읽고 맥락 이해
- 완료하면서 체크박스 업데이트
- 다음 단계 제안

**Git 커밋 여부:** ⚠️ 선택 사항

---

## 에이전트 (Agents)

**에이전트란?** 특정 역할을 가진 전문 AI 어시스턴트.

### 종류

#### 1. 공유 에이전트
**위치:** `~/claude-workspace/shared/agents/`

**기본 제공:**
- **workspace-manager**: 프로젝트 연결/해제, 워크스페이스 관리
- **translate**: 언어 간 문서 번역
- **doc-writer**: README, API 문서, 아키텍처 문서 생성

**사용법:**
```bash
# Claude Code에서
> @workspace-manager 워크스페이스 상태 보여줘
> @translate 이거 한국어로 번역해줘
> @doc-writer API 문서 생성해줘
```

#### 2. 프로젝트 전용 에이전트
**위치:** `~/my-app/.claude/agents/`

**사용 사례:** 프로젝트 특화 에이전트 (예: DB 마이그레이션 에이전트, 배포 에이전트)

**생성 방법:**
1. `~/my-app/.claude/agents/my-agent.md` 생성
2. 에이전트 목적과 기능 정의
3. 사용: `@my-agent 뭔가 해줘`

#### 3. 팀 에이전트
**위치:** 프로젝트 `.claude/agents/`에서 Git으로 공유

**팀 에이전트란?** 팀이 만들어서 팀원끼리 공유하는 에이전트입니다. 개인용 프로젝트 에이전트와 달리 팀 에이전트는 프로젝트 저장소에 커밋되어 모든 팀원이 사용할 수 있습니다.

**사용 사례:**
- 팀 코딩 규칙을 적용하는 코드 리뷰 에이전트
- 팀 배포 프로세스를 따르는 배포 에이전트
- 팀 테스트 패턴을 아는 테스트 에이전트
- 팀 문서화 스타일을 사용하는 문서 에이전트

**공유 방법:**
1. `.claude/agents/my-team-agent.md` 생성
2. git에 커밋: `git add .claude/agents/my-team-agent.md`
3. 팀원들은 사용: `@my-team-agent 뭔가 해줘`

**모범 사례:**
- 에이전트 목적을 명확하게 문서화
- 사용 예시 포함
- 팀 프로세스 변경 시 업데이트
- 에이전트 동작을 정기적으로 검토

### 에이전트 파일 형식

```markdown
# 에이전트 이름

## 역할
에이전트가 하는 일 간단 설명

## 기능
- X 할 수 있음
- Y에 접근 가능
- Z에 대해 앎

## 도구
- tool1
- tool2

## 지시사항
에이전트에 대한 상세 지시사항
```

---

## 슬래시 커맨드

Claude Code는 일반적인 작업을 위한 내장 슬래시 커맨드를 제공합니다:

**세션 관리:**
- `/exit` - Claude Code 세션 종료
- `/clear` - 대화 기록 지우기
- `/compact` - 대화 압축으로 컨텍스트 절약 (이전 메시지 요약)

**설정:**
- `/model` - Claude 모델 전환 (Opus, Sonnet, Haiku)
- `/agents` - 사용 가능한 에이전트 목록 (공유, 프로젝트, 팀 에이전트)
- `/settings` - Claude Code 설정 보기 및 수정

**유틸리티:**
- `/help` - 사용 가능한 명령어 및 기능 표시
- `/tasks` - 작업 목록 보기 및 관리 (TaskCreate/TaskUpdate 사용 시)

**사용법:**
```bash
# Claude Code에서
> /agents              # 사용 가능한 모든 에이전트 목록
> /model               # 다른 Claude 모델로 전환
> /compact             # 컨텍스트가 가득 찰 때 대화 압축
> /exit                # Claude Code 종료
```

**팁:** 언제든지 `/help`를 사용하면 모든 사용 가능한 명령어와 설명을 볼 수 있습니다.

---

## MCP (Model Context Protocol)

**MCP란?** Claude를 외부 데이터 소스 및 도구에 연결하는 표준.

### 사용 가능한 MCP 서버

- **local-rag** — 문서 및 코드 검색 (권장)
- **filesystem** — 프로젝트 파일 읽기/쓰기 (권장)
- **serena** — 웹 브라우징 및 검색 (권장)
- **fetch** — HTTP 요청 및 REST API 호출
- **puppeteer** — 브라우저 자동화 및 스크린샷

자세한 설명, 설정 예시, 설치 방법은 **[Phase 2 가이드 - MCP 서버](../../docs/ko/PHASE2.md#step-2-23-mcp-서버)** 참조.

### MCP 설정

**위치:** `~/my-app/.mcp.json`

**생성 시기:** Phase 2 설치 중 또는 수동

**Git 커밋 안 함:** ❌ (API 키 포함 가능)

---

## 빠른 참조

| 파일/디렉토리 | 목적 | 공유? | Git? |
|--------------|------|-------|------|
| CLAUDE.md | 프로젝트 지시사항 | 팀 | ✅ 예 |
| CLAUDE.local.md | 개인 메모 | 본인 | ❌ 아니오 |
| .claude/ | Claude Code 설정 | 프로젝트 | ❌ 아니오 |
| Task.md | 작업 분류 | 선택 | ⚠️ 선택 |
| .mcp.json | MCP 서버 설정 | 프로젝트 | ❌ 아니오 |

---

## 모범 사례

### CLAUDE.md
✅ **해야 할 것:**
- 프로젝트 변화에 따라 업데이트
- "무엇"뿐만 아니라 "왜" 포함
- 중요한 규칙 문서화

❌ **하지 말아야 할 것:**
- 민감한 정보 포함
- 너무 길게 작성 (Claude 컨텍스트 제한)
- 코드 주석과 중복

### 에이전트
✅ **해야 할 것:**
- 명확하고 구체적인 역할 부여
- 공통 작업에 공유 에이전트 사용
- 특수 요구사항에 프로젝트 에이전트 생성

❌ **하지 말아야 할 것:**
- 중복 에이전트 생성
- 너무 범용적으로 만들기
- 에이전트 기능 문서화 잊기

### MCP
✅ **해야 할 것:**
- 문서 검색에 local-rag 사용
- 파일 접근에 filesystem 설정
- .mcp.json Git에서 제외

❌ **하지 말아야 할 것:**
- .mcp.json에 API 키 커밋
- 과도한 파일 시스템 접근 권한
- 신뢰할 수 없는 MCP 서버 설치

---

## 더 알아보기

- 공식 문서: https://docs.claude.ai/code
- MCP 문서: https://modelcontextprotocol.io
- 커뮤니티 에이전트: https://github.com/topics/claude-agent
