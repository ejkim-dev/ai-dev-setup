# 왜 Claude Workspace인가?

## 문제점

여러 프로젝트에서 Claude Code를 사용하다 보면 다음과 같은 문제가 발생합니다:

### 1. **분산된 관리 포인트**
각 프로젝트마다 독립적인 Claude 설정이 존재합니다:
```
~/project-a/.claude/
~/project-b/.claude/
~/project-c/.claude/
~/work/client-project/.claude/
```

프로젝트가 늘어날수록 관리 포인트도 함께 증가합니다. 수십 개의 장소에서 에이전트, MCP 서버, 템플릿을 관리해야 합니다.

### 2. **실수로 인한 손실 위험**
모든 설정이 각 프로젝트에 로컬로 저장되기 때문에:
- 프로젝트 폴더를 실수로 삭제하면 소중한 에이전트 설정도 함께 사라집니다
- 버전 관리가 없어 히스토리나 복구가 불가능합니다
- 모든 프로젝트에서 일관되게 백업하기 어렵습니다

### 3. **중복과 불일치**
- 같은 에이전트를 여러 프로젝트에 복사하면 버전이 달라집니다
- 한 프로젝트에서 에이전트를 개선해도 다른 프로젝트는 그대로입니다
- 템플릿과 MCP 설정이 시간이 지나면서 일관성을 잃습니다

### 4. **협업의 어려움**
- 에이전트와 설정이 개별 프로젝트에 갇혀 있습니다
- 팀원들과 설정을 쉽게 공유할 수 없습니다
- "우리 팀은 Claude Code를 이렇게 쓴다"는 중앙 기준점이 없습니다

---

## 해결책: 중앙 집중식 워크스페이스

`~/claude-workspace/` 접근 방식은 **심볼릭 링크 기반 중앙화**로 이 문제들을 해결합니다.

### 핵심 개념

각 프로젝트에 로컬로 저장하는 대신:
```
# 기존 방식 (분산)
~/project-a/.claude/agents/my-agent.md
~/project-b/.claude/agents/my-agent.md  # 중복!
~/project-c/.claude/agents/my-agent.md  # 중복!
```

한 번 저장하고, 어디서나 링크로 연결:
```
# 새로운 방식 (중앙화)
~/claude-workspace/shared/agents/my-agent.md  ← 실제 파일
~/project-a/.claude/agents/  → 워크스페이스로 심볼릭 링크
~/project-b/.claude/agents/  → 워크스페이스로 심볼릭 링크
~/project-c/.claude/agents/  → 워크스페이스로 심볼릭 링크
```

### 장점

**1. 단일 관리 포인트**
- 모든 공유 에이전트를 한 곳에서: `~/claude-workspace/shared/agents/`
- 모든 템플릿을 한 곳에서: `~/claude-workspace/shared/templates/`
- 한 번 수정하면 모든 곳에 적용

**2. 버전 관리 준비 완료**
```bash
cd ~/claude-workspace
git init
git add .
git commit -m "나의 Claude Code 설정"
```

이제 전체 Claude 설정이:
- 자동으로 백업됩니다
- 전체 히스토리를 가집니다
- 언제든 복구할 수 있습니다
- 여러 컴퓨터에서 동기화할 수 있습니다

**3. 쉬운 복구**
프로젝트 폴더를 실수로 삭제해도 에이전트와 설정은 `~/claude-workspace/`에 안전하게 보관됩니다.

**4. 팀 공유**
```bash
# 팀과 워크스페이스 공유
cd ~/claude-workspace
git remote add origin git@github.com:yourteam/claude-workspace.git
git push -u origin main

# 팀원들은 클론
git clone git@github.com:yourteam/claude-workspace.git ~/claude-workspace
```

**5. 프로젝트 간 일관성**
- 모든 프로젝트가 자동으로 최신 에이전트 버전 사용
- 공유 MCP 설정이 동기화 상태 유지
- 템플릿이 일관성 유지

---

## 설계 철학

### 1. **관심사의 분리**

```
~/claude-workspace/
├── shared/          ← 모든 프로젝트에서 공유
│   ├── agents/      ← 재사용 가능한 AI 어시스턴트
│   ├── templates/   ← 프로젝트 시작 파일
│   └── mcp/         ← 외부 통합
├── projects/        ← 프로젝트별 설정
│   └── my-app/
│       └── .claude/ ← 로컬 오버라이드만
└── doc/             ← 문서 (지금 보고 계신 곳!)
```

**공유 리소스**는 **프로젝트별 설정**과 분리됩니다. 이를 통해:
- 프로젝트 비밀은 비공개로 유지하면서 공통 도구 공유
- 프로젝트 데이터 노출 없이 공유 리소스만 버전 관리
- 필요시 프로젝트별로 공유 설정 오버라이드

### 2. **복사보다 심볼릭 링크**

왜 파일 복사 대신 심볼릭 링크인가?

**심볼릭 링크:**
- ✅ 한 번 수정으로 모든 곳에 적용
- ✅ 버전 불일치 없음
- ✅ 최소한의 디스크 공간
- ✅ 명확한 원본 소스

**복사:**
- ❌ 모든 복사본을 수동으로 업데이트해야 함
- ❌ 시간이 지나면서 버전 불일치 발생
- ❌ 디스크 공간 낭비
- ❌ 단일 원본 소스 없음

### 3. **Git 우선 설계**

워크스페이스 구조는 Git 친화적으로 설계되었습니다:

```
# .gitignore가 자동으로 제외:
projects/*/        # 프로젝트별 (별도 관리)
setup-lang/        # 임시 설치 파일
*.key, *.pem       # 비밀 정보

# 나머지는 모두 커밋:
shared/agents/     ✅ 팀과 공유
shared/templates/  ✅ 팀과 공유
doc/               ✅ 팀과 공유
config.json        ✅ 환경설정 공유
```

---

## 확장 전략

### 1. **개인 멀티 머신 설정**

모든 컴퓨터에서 워크스페이스 동기화:

```bash
# 컴퓨터 A
cd ~/claude-workspace
git init
git remote add origin git@github.com:yourname/my-claude-workspace.git
git push -u origin main

# 컴퓨터 B
git clone git@github.com:yourname/my-claude-workspace.git ~/claude-workspace
```

이제 에이전트, 템플릿, 설정이 어디서나 동일합니다.

### 2. **팀 협업**

팀 워크스페이스 저장소 생성:

```bash
# 팀 리드가 설정
cd ~/claude-workspace
git init
git remote add origin git@github.com:acme-corp/claude-workspace.git
git push -u origin main

# 팀원들은 클론
git clone git@github.com:acme-corp/claude-workspace.git ~/claude-workspace

# 누구나 기여 가능
cd ~/claude-workspace
# shared/agents/code-reviewer.md 편집
git commit -am "코드 리뷰 에이전트 개선"
git push
```

### 3. **프로젝트별 확장**

프로젝트는 공유 에이전트를 사용하면서도 자체 에이전트를 가질 수 있습니다:

```
~/my-app/.claude/agents/
├── (공유 에이전트로 심볼릭 링크)
└── deployment-agent.md  ← 프로젝트 전용, 워크스페이스에 없음
```

두 가지 장점을 모두 얻습니다:
- 공통 작업용 공유 에이전트
- 특수 요구사항용 프로젝트 에이전트

### 4. **고급 MCP 관리**

MCP 서버 컬렉션이 증가하면:

```
~/claude-workspace/shared/mcp/
├── local-rag/           # 문서 검색
├── filesystem/          # 파일 접근
├── serena/              # 웹 브라우징
├── database/            # 데이터베이스 도구
└── custom-api/          # 커스텀 통합
```

프로젝트는 `.mcp.json`에서 상대 경로로 참조:

```json
{
  "mcpServers": {
    "local-rag": {
      "command": "npx",
      "args": ["-y", "@local-rag/mcp-server"],
      "env": {
        "DATA_PATH": "${HOME}/claude-workspace/shared/mcp/local-rag-data"
      }
    }
  }
}
```

### 5. **템플릿 라이브러리**

프로젝트 시작용 템플릿 라이브러리 구축:

```
~/claude-workspace/shared/templates/
├── CLAUDE.md.react         # React 프로젝트 템플릿
├── CLAUDE.md.nodejs        # Node.js 백엔드 템플릿
├── CLAUDE.md.python        # Python 프로젝트 템플릿
├── .mcp.json.web           # 웹 프로젝트 MCP 설정
├── .mcp.json.data-science  # 데이터 사이언스 MCP 설정
└── CLAUDE.local.md         # 개인 환경설정
```

적절한 템플릿을 복사하여 새 프로젝트를 더 빠르게 시작하세요.

---

## 모범 사례

### ✅ 해야 할 것

- **워크스페이스를 Git에 커밋** - 버전 관리가 안전망입니다
- **에이전트 문서화** - 미래의 당신이 감사할 것입니다
- **공통 작업엔 공유 에이전트 사용** - 중복 방지
- **템플릿을 최신 상태로 유지** - 정기적으로 검토하고 개선
- **팀과 공유** - 협업은 모두를 더 나아지게 합니다

### ❌ 하지 말아야 할 것

- **비밀 정보 커밋 금지** - API 키는 `.gitignore` 사용
- **프로젝트 코드와 워크스페이스 혼합 금지** - 분리 유지
- **과도한 복잡화 금지** - 간단하게 시작하고 필요에 따라 확장
- **pull 잊지 말기** - 워크스페이스를 동기화 상태로 유지

---

## 마이그레이션 경로

이미 프로젝트 전체에 Claude 설정이 흩어져 있나요? 통합하는 방법:

### 1단계: 공통 리소스 식별

```bash
# 모든 Claude 설정 찾기
find ~ -name ".claude" -type d
```

### 2단계: 공유 에이전트 추출

```bash
# 에이전트를 워크스페이스로 복사
cp ~/old-project/.claude/agents/useful-agent.md \
   ~/claude-workspace/shared/agents/
```

### 3단계: 프로젝트를 워크스페이스에 연결

```bash
# workspace-manager 사용
cd ~/old-project
claude
> @workspace-manager 이 프로젝트 연결해줘
```

### 4단계: 중복 정리

연결되면 워크스페이스로 심볼릭 링크된 중복 파일을 제거하세요.

---

## 요약

**Claude Workspace는 단순한 폴더 구조가 아니라 관리 철학입니다.**

공유 리소스를 중앙화하면서 프로젝트별 설정은 분리함으로써:
- ✅ **단순성**: 모든 것을 한 곳에서 관리
- ✅ **안전성**: 버전 관리와 백업
- ✅ **일관성**: 버전 불일치 없음
- ✅ **협업**: 쉬운 팀 공유
- ✅ **확장성**: 필요에 따라 성장

**간단하게 시작하고, 신중하게 확장하며, 워크스페이스가 AI 지원 개발 여정과 함께 성장하도록 하세요.**
