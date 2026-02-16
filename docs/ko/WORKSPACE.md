# Claude 워크스페이스 구조

모든 프로젝트에 걸친 Claude Code 리소스의 중앙 집중식 관리.

## 개요

`claude-workspace`는 다음을 관리하기 위한 단일 위치를 제공합니다:
- 공유 에이전트 (모든 프로젝트에서 사용 가능)
- MCP 서버 설정
- 프로젝트 템플릿 (CLAUDE.md, .mcp.json)
- 프로젝트 백업 및 설정

## 디렉토리 구조

```
~/claude-workspace/
├── shared/
│   ├── agents/                    # 공유 에이전트
│   │   ├── workspace-manager.md   # 프로젝트 구조 관리
│   │   ├── translate.md           # 다국어 번역
│   │   └── doc-writer.md          # 문서 생성
│   ├── templates/                 # 새 프로젝트용 템플릿
│   │   ├── CLAUDE.md              # 템플릿 프로젝트 규칙
│   │   ├── CLAUDE.local.md        # 템플릿 로컬 설정
│   │   └── .mcp.json              # 템플릿 MCP 설정
│   └── mcp/                       # MCP 설정
│
├── projects/                      # 프로젝트별 설정
│   └── my-app/                    # 예시 프로젝트
│       ├── .claude/               # 프로젝트별 Claude 설정
│       ├── CLAUDE.md              # 프로젝트 규칙
│       └── CLAUDE.local.md        # 로컬 전용 설정
│
├── config.json                   # 사용자 설정
└── .gitignore
```

---

## 공유 에이전트

### 공유 에이전트란?

에이전트는 특정 기능을 가진 재사용 가능한 AI 어시스턴트입니다. 공유 에이전트는 파일을 복사하지 않고 **모든 프로젝트**에서 사용할 수 있습니다.

### 설치된 에이전트

#### workspace-manager
**목적**: 워크스페이스에 프로젝트 연결 관리

**기능**:
- 워크스페이스에 프로젝트 연결
- 프로젝트 구조 생성
- 심볼릭 링크 설정
- .gitignore 항목 관리
- 워크스페이스 상태 확인

**사용 예시**:
```
/workspace-manager connect ~/projects/my-app
```

생성 항목:
- `~/claude-workspace/projects/my-app/`
- 프로젝트에서 워크스페이스로의 심볼릭 링크
- .gitignore 항목 (심볼릭 링크 타겟 무시)

#### translate
**목적**: 다국어 문서 번역

**기능**:
- 마크다운 파일 번역 (en/ko/ja)
- 형식 및 코드 블록 유지
- 일괄 번역
- 로케일 파일 생성

**사용 예시**:
```
/translate README.md en ko
```

생성: 한국어 번역이 포함된 `README.ko.md`

#### doc-writer
**목적**: 문서 생성 및 유지

**기능**:
- 코드에서 README 생성
- CLAUDE.md 생성
- API 문서
- 아키텍처 다이어그램 (텍스트 기반)

**사용 예시**:
```
/doc-writer create-readme --from-code
```

생성: 프로젝트 구조 및 코드 기반 `README.md`

---

## 프로젝트에서 공유 에이전트 사용

### 방법 1: CLAUDE.md에서 참조

프로젝트의 `CLAUDE.md`에서:

```markdown
# 내 프로젝트

## 사용 가능한 공유 에이전트

- **workspace-manager**: 프로젝트 구조 관리
- **translate**: 다국어 지원
- **doc-writer**: 문서 생성

## 프로젝트 규칙

[여기에 프로젝트별 규칙]
```

Claude Code는 `~/claude-workspace/shared/agents/`에서 자동으로 에이전트를 로드합니다.

### 방법 2: 직접 호출

Claude Code 채팅에서:

```
workspace-manager 에이전트를 사용하여 상태 확인
```

Claude는 추가 설정 없이 공유 에이전트를 사용합니다.

---

## 프로젝트별 설정

### 프로젝트 구조

각 프로젝트는 자체 Claude 설정을 가질 수 있습니다:

```
my-project/
├── .claude/               # 프로젝트별 Claude 설정
│   ├── agents/            # 프로젝트 전용 에이전트
│   ├── mcp/               # 프로젝트별 MCP 서버
│   ├── tools/             # 커스텀 도구
│   └── notes/             # 비공개 개발 노트
│
├── CLAUDE.md              # 팀 공유 규칙 (커밋됨)
└── CLAUDE.local.md        # 개인 설정 (gitignore됨)
```

### CLAUDE.md vs CLAUDE.local.md

| | CLAUDE.md | CLAUDE.local.md |
|---|---|---|
| **용도** | 팀 공유 프로젝트 규칙 | 개인 설정 |
| **Git** | 커밋됨 | Gitignore됨 |
| **내용** | 아키텍처, 코딩 표준, 에이전트 | 비공개 노트, 로컬 설정 |

자세한 예시 및 사용법은 **[Claude 가이드 - CLAUDE.md](../../claude-code/doc/ko/claude-guide.md#claudemd)** 참조.

---

## MCP 서버 설정

### 공유 vs 프로젝트별 MCP

**공유 MCP** (`~/.claude/.mcp.json`):
- 모든 프로젝트에서 사용 가능한 서버
- Phase 2 설정 중 구성됨
- 예시: local-rag, filesystem, serena

**프로젝트 MCP** (`my-project/.claude/.mcp.json`):
- 한 프로젝트에만 특정된 서버
- 공유 설정을 재정의/확장
- 예시: 프로젝트별 데이터베이스, API

### 공유 .mcp.json 예시

```json
{
  "mcpServers": {
    "local-rag": {
      "command": "local-rag-mcp",
      "env": {
        "RAG_INDEX_PATH": "~/.claude/rag-index"
      }
    },
    "filesystem": {
      "command": "filesystem-mcp",
      "args": ["--root", "~/"]
    },
    "serena": {
      "command": "serena-mcp"
    }
  }
}
```

### 프로젝트별 .mcp.json

```json
{
  "mcpServers": {
    "postgres": {
      "command": "postgres-mcp",
      "env": {
        "DB_CONNECTION": "postgresql://localhost/mydb"
      }
    },
    "jira": {
      "command": "jira-mcp",
      "env": {
        "JIRA_URL": "https://mycompany.atlassian.net",
        "JIRA_TOKEN": "${JIRA_TOKEN}"
      }
    }
  }
}
```

**설정 우선순위**:
1. 프로젝트 `.mcp.json` (최우선)
2. 공유 `.mcp.json` (폴백)

---

## 심볼릭 링크 관리

### 왜 심볼릭 링크인가?

심볼릭 링크를 사용하면:
- **중앙 집중식 업데이트**: 한 번 변경하면 모든 곳에 적용
- **일관성**: 모든 프로젝트에서 동일한 에이전트
- **쉬운 백업**: 하나의 워크스페이스만 백업
- **중복 없음**: 디스크 공간 절약

### 자동 심볼릭 링크 생성

`workspace-manager` 에이전트가 심볼릭 링크를 자동으로 처리합니다:

```
/workspace-manager connect ~/projects/my-app
```

심볼릭 링크 생성:
- `my-app/.claude/agents` → `~/claude-workspace/shared/agents`
- `my-app/CLAUDE.md` → `~/claude-workspace/projects/my-app/CLAUDE.md`

### 수동 심볼릭 링크 생성 (macOS/Linux)

```bash
# 공유 에이전트를 프로젝트에 연결
ln -s ~/claude-workspace/shared/agents ~/projects/my-app/.claude/agents

# 프로젝트 CLAUDE.md를 워크스페이스에 연결
ln -s ~/claude-workspace/projects/my-app/CLAUDE.md ~/projects/my-app/CLAUDE.md
```

### 심볼릭 링크 생성 (Windows)

**요구 사항**: 개발자 모드 활성화 또는 관리자 권한

```powershell
# 개발자 모드 활성화: 설정 → 업데이트 및 보안 → 개발자용

# 심볼릭 링크 생성
New-Item -ItemType SymbolicLink -Path "C:\projects\my-app\.claude\agents" -Target "$env:USERPROFILE\claude-workspace\shared\agents"
```

### .gitignore 통합

`workspace-manager`가 자동으로 심볼릭 링크 타겟을 `.gitignore`에 추가합니다:

```gitignore
# Claude Code 심볼릭 링크 타겟 (workspace-manager가 관리)
.claude/agents
CLAUDE.md
CLAUDE.local.md
```

이렇게 하면:
- 심볼릭 링크가 커밋됨 (팀이 구조를 알 수 있음)
- 실제 파일은 커밋되지 않음 (중복 방지)
- 각 팀원이 자신의 워크스페이스를 가질 수 있음

---

## 템플릿

### 새 프로젝트에 템플릿 사용

템플릿은 새 프로젝트의 시작점을 제공합니다.

**사용 가능한 템플릿**:
- `CLAUDE.md` - 프로젝트 규칙 템플릿
- `CLAUDE.local.md` - 로컬 설정 템플릿
- `.mcp.json` - MCP 설정 템플릿

### 새 프로젝트에 템플릿 복사

```bash
# CLAUDE.md 템플릿 복사
cp ~/claude-workspace/shared/templates/CLAUDE.md ~/projects/new-app/

# MCP 템플릿 복사
cp ~/claude-workspace/shared/templates/.mcp.json ~/projects/new-app/.claude/
```

### 템플릿 변수

템플릿은 치환을 위해 `__PLACEHOLDER__` 구문을 사용합니다:

**템플릿** (`shared/templates/CLAUDE.md`):
```markdown
# __PROJECT_NAME__

기술 스택: __TECH_STACK__
```

**치환 후** (`projects/my-app/CLAUDE.md`):
```markdown
# My App

기술 스택: React, TypeScript, Node.js
```

---

## 워크플로우 예시

### 새 프로젝트 시작

1. **프로젝트 디렉토리 생성**:
   ```bash
   mkdir ~/projects/my-new-app
   cd ~/projects/my-new-app
   ```

2. **워크스페이스에 연결**:
   ```
   /workspace-manager connect .
   ```

3. **템플릿 복사**:
   ```bash
   cp ~/claude-workspace/shared/templates/CLAUDE.md ./
   cp ~/claude-workspace/shared/templates/.mcp.json ./.claude/
   ```

4. **프로젝트에 맞게 CLAUDE.md 편집**

5. **코딩 시작**:
   ```
   claude chat
   ```

### 공유 에이전트 추가

1. **에이전트 파일 생성**:
   ```bash
   nano ~/claude-workspace/shared/agents/my-agent.md
   ```

2. **에이전트 정의 작성**:
   ```markdown
   # 내 커스텀 에이전트

   ## 목적
   [이 에이전트가 하는 일 설명]

   ## 기능
   - 기능 1
   - 기능 2

   ## 사용 예시
   [이 에이전트 사용 방법 표시]
   ```

3. **즉시 사용** (재시작 불필요):
   ```
   /my-agent [작업]
   ```

### 프로젝트 백업

```bash
# 프로젝트별 설정을 워크스페이스에 백업
cp -r ~/projects/my-app/.claude ~/claude-workspace/projects/my-app/
cp ~/projects/my-app/CLAUDE.md ~/claude-workspace/projects/my-app/
```

이제 프로젝트 설정이 워크스페이스에 안전하게 저장됩니다.

### 프로젝트 복원

```bash
# 워크스페이스 백업에서 복원
cp -r ~/claude-workspace/projects/my-app/.claude ~/projects/my-app/
cp ~/claude-workspace/projects/my-app/CLAUDE.md ~/projects/my-app/
```

---

## 모범 사례

### 해야 할 일

✅ **공통 작업에는 공유 에이전트 사용**
- 모든 프로젝트에 workspace-manager
- 다국어 문서에 translate
- README 생성에 doc-writer

✅ **CLAUDE.md를 집중적으로 유지**
- 프로젝트별 규칙만
- 공유 에이전트 참조, 복제하지 않기
- 아키텍처 변경 시 업데이트

✅ **개인 설정에는 CLAUDE.local.md 사용**
- 개별 선호도
- 로컬 전용 노트
- 임시 리마인더

✅ **워크스페이스를 정기적으로 백업**
```bash
cp -r ~/claude-workspace ~/Dropbox/backups/claude-workspace-$(date +%F)
```

### 하지 말아야 할 일

❌ **심볼릭 링크 타겟을 git에 커밋하지 않기**
- .gitignore가 처리하도록 두기
- 중복 및 충돌 방지

❌ **프로젝트에서 공유 에이전트 복제하지 않기**
- 참조만 하기, 복사하지 않기
- 업데이트가 자동으로 전파됨

❌ **CLAUDE.md에 비밀 저장하지 않기**
- 환경 변수 사용
- MCP 설정에서 `${ENV_VAR}`를 통해 참조

❌ **백업 없이 .mcp.json 수동으로 편집하지 않기**
- JSON 구문 오류로 Claude Code가 중단됨
- 편집 전 백업 유지

---

## 문제 해결

### 심볼릭 링크가 작동하지 않음

**증상**: 에이전트 파일을 찾을 수 없음

**해결책**:
```bash
# 심볼릭 링크 확인
ls -la ~/projects/my-app/.claude/agents

# 다음이 표시되어야 함: agents -> /Users/you/claude-workspace/shared/agents

# 손상된 경우 재생성:
rm ~/projects/my-app/.claude/agents
ln -s ~/claude-workspace/shared/agents ~/projects/my-app/.claude/agents
```

### MCP 서버가 로드되지 않음

**증상**: Claude Code가 MCP 서버에 접근할 수 없음

**.mcp.json 구문 확인**:
```bash
cat ~/.claude/.mcp.json | jq .
```

오류 발생 시: JSON 구문 수정 (쉼표, 대괄호, 따옴표)

**서버 설치 확인**:
```bash
npm list -g | grep local-rag-mcp
```

찾을 수 없는 경우: 서버 재설치

### 공유 에이전트를 사용할 수 없음

**증상**: Claude Code가 에이전트를 인식하지 못함

**에이전트 파일 존재 확인**:
```bash
ls ~/claude-workspace/shared/agents/workspace-manager.md
```

**CLAUDE.md가 에이전트를 참조하는지 확인**:
```bash
grep "workspace-manager" ~/projects/my-app/CLAUDE.md
```

없는 경우 추가:
```markdown
## 사용 가능한 공유 에이전트
- workspace-manager
```

---

## 고급 주제

### 다중 워크스페이스

다른 컨텍스트를 위한 여러 워크스페이스를 가질 수 있습니다:

```bash
# 작업 워크스페이스
~/claude-workspace/

# 개인 프로젝트 워크스페이스
~/claude-workspace-personal/
```

환경 변수를 통해 설정:
```bash
export CLAUDE_WORKSPACE=~/claude-workspace-personal
```

### 워크스페이스 공유 (팀)

팀과 워크스페이스 구조(내용 아님) 공유:

1. **워크스페이스 구조 커밋** (파일 아님):
   ```bash
   git init ~/claude-workspace
   cd ~/claude-workspace
   git add shared/
   git commit -m "Add project templates"
   ```

2. **팀원이 클론**:
   ```bash
   git clone <repo-url> ~/claude-workspace
   ```

3. **각 멤버가 자신의 에이전트 추가**:
   ```bash
   cp custom-agent.md ~/claude-workspace/shared/agents/
   ```

### 커스텀 MCP 서버

프로젝트별 MCP 서버 생성:

1. **서버 패키지 생성**:
   ```bash
   mkdir my-mcp-server
   cd my-mcp-server
   npm init -y
   # MCP 서버 구현
   ```

2. **로컬로 설치**:
   ```bash
   npm install -g .
   ```

3. **.mcp.json에 추가**:
   ```json
   {
     "mcpServers": {
       "my-server": {
         "command": "my-mcp-server",
         "args": ["--config", "config.json"]
       }
     }
   }
   ```

---

## 관련 문서

- [Phase 2 설정](PHASE2.md) - 초기 워크스페이스 생성
- [문제 해결](TROUBLESHOOTING.md) - 일반적인 문제
- [FAQ](FAQ.md) - 자주 묻는 질문
