# 제거 가이드

ai-dev-setup을 부분적으로 또는 완전히 제거하는 방법입니다.

## 중요한 구분

- **Phase 1 정리**: 자동화 스크립트 제공 (임시 설치 파일 제거)
- **Phase 2 정리**: 수동으로만 가능 (워크스페이스와 데이터 제거 - 주의 필요)

---

## Phase 1 제거 (자동화)

**자동화 스크립트 사용 가능**:

```bash
curl -fsSL https://raw.githubusercontent.com/ejkim-dev/ai-dev-setup/main/cleanup-phase1.sh | bash
```

### 제거되는 항목

- Oh My Zsh (`~/.oh-my-zsh/`)
- 셸 설정 (`~/.zshrc`)
- tmux 설정 (`~/.tmux.conf`)
- Terminal.app Dev 프로필
- Phase 2 파일 (`~/claude-code-setup/`)
- 언어 설정 (`~/.dev-setup-lang`)

### 제거되지 않는 항목

다른 앱에서 사용 중일 수 있음:
- Homebrew
- Xcode Command Line Tools
- D2Coding 폰트
- 설치된 패키지 (Node.js, ripgrep 등)

---

## Phase 2 제거 (수동만 가능)

⚠️ **경고**: Claude 워크스페이스와 커스텀 에이전트, 템플릿, 설정이 모두 제거됩니다. Phase 2 정리를 위한 자동화 스크립트는 **의도적으로 제공하지 않습니다** (실수로 데이터 손실을 방지하기 위함).

### 왜 수동만 가능한가요?

- **Phase 1**: 임시 설치 파일 제거 (자동화해도 안전)
- **Phase 2**: 커스텀 데이터가 있는 워크스페이스 제거 (데이터 손실 위험)

### 언제 필요한가요?

1. **완전 제거** - Claude Code 사용을 완전히 중단
2. **설정 초기화** - 잘못된 설정으로 인해 처음부터 다시 시작
3. **테스트 롤백** - 테스트 후 원래대로 되돌리기

---

## 단계별 수동 제거

### 1단계: 백업 (강력 권장)

```bash
# 전체 워크스페이스 백업
cp -r ~/claude-workspace ~/claude-workspace-backup-$(date +%F)

# 또는 특정 항목만 백업
cp -r ~/claude-workspace/global/agents ~/agents-backup
cp -r ~/claude-workspace/projects ~/projects-backup
cp -r ~/claude-workspace/templates ~/templates-backup
```

### 2단계: 워크스페이스 제거

```bash
# 커스텀 에이전트, 템플릿, 설정이 모두 삭제됩니다
rm -rf ~/claude-workspace
```

### 3단계: 전역 심볼릭 링크 제거

```bash
# 전역 에이전트로의 심볼릭 링크 제거
rm ~/.claude/agents
```

### 4단계: 프로젝트 심볼릭 링크 제거

워크스페이스에 연결된 각 프로젝트에서:

```bash
# 프로젝트로 이동
cd /path/to/your/project

# 심볼릭 링크 제거
rm .claude
rm CLAUDE.md
rm CLAUDE.local.md

# .gitignore 업데이트 (ai-dev-setup 항목 제거)
# 수동으로 편집하거나 sed 사용:
sed -i '' '/# Claude Code symlink targets/,/CLAUDE.local.md/d' .gitignore
```

### 5단계: Claude Code CLI 제거 (선택사항)

```bash
npm uninstall -g @anthropic-ai/claude-code
```

### 6단계: MCP 서버 제거 (선택사항)

```bash
# 모든 MCP 서버 제거
npm uninstall -g @anthropic-ai/local-rag-mcp
npm uninstall -g @anthropic-ai/filesystem-mcp
npm uninstall -g serena-mcp
npm uninstall -g @anthropic-ai/fetch-mcp
npm uninstall -g puppeteer-mcp
```

### 7단계: Claude 설정 제거

```bash
# API 키, 설정, 로그가 모두 삭제됩니다
rm -rf ~/.claude
```

### 8단계: 언어 설정 제거 (선택사항)

```bash
rm ~/.dev-setup-lang
```

---

## 제거 확인

모든 항목이 제거되었는지 확인:

```bash
# 존재하지 않아야 함
ls ~/claude-workspace      # "No such file" 표시되어야 함
ls ~/.claude              # "No such file" 표시되어야 함
command -v claude         # "not found" 표시되어야 함

# 전역 npm 패키지 확인
npm list -g --depth=0 | grep claude
npm list -g --depth=0 | grep mcp
```

---

## 백업에서 복원

마음이 바뀐 경우:

```bash
# 워크스페이스 복원
mv ~/claude-workspace-backup-YYYY-MM-DD ~/claude-workspace

# 전역 심볼릭 링크 재생성
mkdir -p ~/.claude
ln -s ~/claude-workspace/global/agents ~/.claude/agents

# Claude Code 재설치
npm install -g @anthropic-ai/claude-code

# 설정 복원 (백업한 경우)
mv ~/.claude-backup ~/.claude
```

---

## 제거 문제 해결

### 심볼릭 링크가 삭제되지 않음

```bash
# 강제로 심볼릭 링크 제거
unlink ~/.claude/agents
# 또는
rm -f ~/.claude/agents
```

### 권한 거부됨

```bash
# 소유권 확인
ls -la ~/claude-workspace

# 필요시 소유권 가져오기
sudo chown -R $(whoami) ~/claude-workspace
rm -rf ~/claude-workspace
```

### npm uninstall 실패

```bash
# sudo 사용 (권장하지 않지만 때때로 필요)
sudo npm uninstall -g @anthropic-ai/claude-code

# 또는 수동으로 제거
sudo rm -rf $(npm root -g)/@anthropic-ai/claude-code
sudo rm $(which claude)
```

---

## 선택사항: Homebrew 및 Node.js 제거

다른 도구에서 사용하지 않는 경우에만:

```bash
# Homebrew 제거
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"

# Node.js 제거
brew uninstall node
```

---

## 관련 문서

- [Phase 1 가이드](PHASE1.md)
- [Phase 2 가이드](PHASE2.md)
- [문제 해결](TROUBLESHOOTING.md)
- [FAQ](FAQ.md)
