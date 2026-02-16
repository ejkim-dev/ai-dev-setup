# ai-dev-setup

[English](README.md) | **[한국어]**

개발 환경을 한 번에 설정하세요. macOS와 Windows를 지원합니다.

선택적으로 [Claude Code](https://claude.ai/code) 설정을 포함하여 워크스페이스 관리, MCP 서버, 공유 에이전트를 제공합니다.

---

## 📋 추천 대상

- **터미널 초보자**: 명령어가 낯설지만 AI 기반 터미널 환경을 구축하고 싶은 분
- **AI 도구 활용**: Claude Code, Gemini CLI 등 AI 도구를 터미널에서 바로 사용하고 싶은 분
- **빠른 세팅**: 새 Mac/Windows에서 복잡한 설정 없이 한 번에 개발 환경을 갖추고 싶은 분
- **일관된 환경**: 여러 컴퓨터에서 동일한 터미널 환경을 유지하고 싶은 분

---

## 🎯 이 스크립트가 하는 일

### Phase 1: 기본 개발 환경

터미널, 셸, 필수 패키지를 설정하는 7단계:
- 패키지 관리자 (Homebrew/winget)
- Node.js, ripgrep, 폰트
- 터미널 테마 & 셸 커스터마이징
- tmux (macOS)

**[→ Phase 1 상세 가이드](docs/ko/PHASE1.md)**

### Phase 2: Claude Code 설정 (선택 사항)

Claude Code 워크스페이스를 설정하는 3단계:
- 공유 에이전트 (workspace-manager, translate, doc-writer)
- MCP 서버 (local-rag, filesystem, serena 등)
- Obsidian 연동

**[→ Phase 2 상세 가이드](docs/ko/PHASE2.md)**

### 설치 후 구조

Phase 2 이후 완전한 Claude Code 워크스페이스가 구성됩니다:

```
~/claude-workspace/
├── shared/agents/          # 모든 프로젝트에서 사용 가능
├── shared/templates/       # CLAUDE.md, .mcp.json 예시
├── shared/mcp/             # MCP 서버 설정
├── projects/               # 프로젝트별 설정
└── config.json             # 사용자 설정
```

**[→ Workspace 가이드](docs/ko/WORKSPACE.md)** | **[→ 설계 철학](claude-code/doc/ko/workspace-philosophy.md)**

---

## 🚀 빠른 시작

### macOS

```bash
curl -fsSL https://raw.githubusercontent.com/ejkim-dev/ai-dev-setup/main/install.sh | bash
```

### Windows

```powershell
irm https://raw.githubusercontent.com/ejkim-dev/ai-dev-setup/main/install.ps1 | iex
```

화살표 키 메뉴로 진행되는 대화형 설정. 한국어, 영어, 일본어를 지원합니다.

> **보안**: 설치 스크립트가 최신 릴리즈를 자동으로 가져오고, SHA256 체크섬을 검증하여 불일치 시 설치를 중단합니다.

---

## 📚 문서

- **[Phase 1 가이드](docs/ko/PHASE1.md)** - 기본 환경 설정
- **[Phase 2 가이드](docs/ko/PHASE2.md)** - Claude Code 설정
- **[Workspace 가이드](docs/ko/WORKSPACE.md)** - Workspace 구조 및 사용법
- **[문제 해결](docs/ko/TROUBLESHOOTING.md)** - 일반적인 문제 및 해결책
- **[FAQ](docs/ko/FAQ.md)** - 자주 묻는 질문
- **[제거 가이드](docs/ko/UNINSTALL.md)** - 제거 방법

---

## 🧹 정리

Phase 1 설치 제거:

```bash
curl -fsSL https://raw.githubusercontent.com/ejkim-dev/ai-dev-setup/main/uninstall-tools.sh -o /tmp/cleanup.sh

bash /tmp/cleanup.sh
```

**[→ 완전 제거 가이드](docs/ko/UNINSTALL.md)**

---

## 🆘 도움 받기

- **[문제 해결](docs/ko/TROUBLESHOOTING.md)** - 일반적인 문제 및 해결책
- **[FAQ](docs/ko/FAQ.md)** - 자주 묻는 질문
- **[GitHub Issues](https://github.com/ejkim-dev/ai-dev-setup/issues)** - 버그 보고 또는 기능 요청

---

## 📝 개발 이야기

- **[한 줄로 끝나는 AI 개발 환경 설치 스크립트를 만든 이야기](https://www.keyflow.me/ko/@ejkim/post/2026-02-16-%ED%95%9C-%EC%A4%84%EB%A1%9C-%EB%81%9D%EB%82%98%EB%8A%94-ai-%EA%B0%9C%EB%B0%9C-%ED%99%98%EA%B2%BD-%EC%84%A4%EC%B9%98-%EC%8A%A4%ED%81%AC%EB%A6%BD%ED%8A%B8%EB%A5%BC-%EB%A7%8C%EB%93%A0-%EC%9D%B4%EC%95%BC%EA%B8%B0)** - 프로젝트 동기, Claude Code 활용기, 개발 과정에서 겪은 일들

---

## 📄 라이선스

[MIT](LICENSE)
