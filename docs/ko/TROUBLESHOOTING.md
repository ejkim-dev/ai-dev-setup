# 문제 해결 가이드

ai-dev-setup 설치 및 사용 시 일반적인 문제와 해결책입니다.

## 목차

- [설치 문제](#설치-문제)
- [폰트 및 터미널 문제](#폰트-및-터미널-문제)
- [셸 및 플러그인 문제](#셸-및-플러그인-문제)
- [MCP 서버 문제](#mcp-서버-문제)
- [권한 문제](#권한-문제)
- [네트워크 문제](#네트워크-문제)

---

## 설치 문제

### Homebrew 설치 실패

**증상**:
```
❌ Homebrew 설치 실패
```

**원인**:
- 네트워크 연결 문제
- Xcode Command Line Tools가 설치되지 않음
- 권한 부족

**해결책**:

1. **네트워크 연결 확인**:
   ```bash
   ping github.com
   ```

2. **Xcode Command Line Tools 먼저 설치**:
   ```bash
   xcode-select --install
   ```

3. **수동 설치 시도**:
   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```

4. **설치 로그 확인**:
   ```bash
   tail -f /tmp/homebrew-install.log
   ```

---

### Node.js 설치 실패

**증상**:
```
❌ Node.js 설치 실패
Node.js는 AI 코딩 도구에 필요합니다.
```

**원인**:
- Homebrew가 작동하지 않음
- 충돌하는 Node.js 설치
- 디스크 공간 문제

**해결책**:

1. **Homebrew 확인**:
   ```bash
   brew doctor
   ```
   보고된 문제 수정

2. **기존 Node.js 확인**:
   ```bash
   which node
   node --version
   ```
   nvm 또는 다른 버전 관리자를 사용하는 경우 충돌할 수 있음

3. **수동 설치 시도**:
   ```bash
   brew install node
   ```

4. **디스크 공간 확인**:
   ```bash
   df -h
   ```
   최소 5GB 이상 여유 공간 확보

5. **대안: nodejs.org에서 다운로드**:
   - https://nodejs.org/ 방문
   - LTS 버전 다운로드
   - PKG 설치 프로그램으로 설치

---

### npm 권한 오류

**증상**:
```
npm ERR! code EACCES
npm ERR! syscall access
npm ERR! path /usr/local/lib/node_modules
```

**원인**: npm 전역 설치에 권한 필요

**해결책**:

**옵션 1: npm 권한 수정 (권장)**:
```bash
sudo chown -R $(whoami) /usr/local/lib/node_modules
sudo chown -R $(whoami) /usr/local/bin
sudo chown -R $(whoami) /usr/local/share
```

**옵션 2: npm prefix 사용 (대안)**:
```bash
mkdir ~/.npm-global
npm config set prefix '~/.npm-global'
echo 'export PATH=~/.npm-global/bin:$PATH' >> ~/.zshrc
source ~/.zshrc
```

**옵션 3: Homebrew를 통한 Claude Code 설치 (macOS)**:
```bash
brew install claude-code
```

**옵션 4: 공식 설치 프로그램 사용**:
- https://claude.ai/code 방문 후 네이티브 설치 프로그램 사용

---

## 폰트 및 터미널 문제

### D2Coding 폰트가 표시되지 않음

**증상**: 설치 후에도 터미널이 기본 폰트를 표시함

**원인**:
- 폰트 캐시가 업데이트되지 않음
- 터미널 앱이 재시작되지 않음
- 잘못된 폰트 이름 선택

**해결책**:

1. **Terminal.app 재시작**:
   - Terminal을 완전히 종료 (⌘Q)
   - Terminal 다시 열기

2. **폰트 캐시 지우기** (macOS):
   ```bash
   sudo atsutil databases -remove
   sudo atsutil server -shutdown
   sudo atsutil server -ping
   ```

3. **폰트 설치 확인**:
   ```bash
   brew list --cask font-d2coding
   ```

4. **Font Book에서 폰트 확인**:
   - Font Book 앱 열기
   - "D2Coding" 검색
   - 발견됨: 폰트가 올바르게 설치됨
   - 발견되지 않음: 폰트 재설치

5. **폰트 재설치**:
   ```bash
   brew uninstall --cask font-d2coding
   brew install --cask font-d2coding
   ```

6. **Terminal에서 수동으로 폰트 설정**:
   - Terminal > 설정 (⌘,)
   - Dev 프로필 선택
   - 텍스트 탭 > 폰트 변경
   - 목록에서 "D2Coding" 선택

---

### 터미널 테마가 적용되지 않음

**증상**: 터미널이 여전히 기본 테마처럼 보임

**원인**:
- 프로필이 올바르게 가져오기되지 않음
- 잘못된 프로필이 기본값으로 설정됨
- 터미널이 재시작되지 않음

**해결책**:

1. **현재 프로필 확인**:
   - Terminal > 설정 (⌘,)
   - 프로파일 탭
   - "Dev" 프로필 찾기

2. **프로필 수동 가져오기**:
   - Terminal > 설정 (⌘,)
   - 프로파일 탭
   - ⚙️ (톱니바퀴 아이콘) 클릭 > 가져오기...
   - 이동: `~/ai-dev-setup/configs/mac/Dev.terminal`
   - 선택 후 열기

3. **기본값으로 설정**:
   - "Dev" 프로필 선택
   - "기본값" 버튼 클릭

4. **새 창 열기**:
   - 셸 > 새로운 윈도우 > Dev
   - 테마가 적용되었는지 확인

5. **명령어로 확인**:
   ```bash
   defaults read com.apple.Terminal "Default Window Settings"
   ```
   출력: `Dev`

6. **강제로 다시 가져오기**:
   ```bash
   open ~/ai-dev-setup/configs/mac/Dev.terminal
   ```

---

### iTerm2 커서가 보이지 않음

**증상**: iTerm2에서 커서를 볼 수 없음

**원인**: 커서 색상이 배경 색상과 일치함

**해결책**:

1. **커서 색상 변경**:
   - iTerm2 > 환경설정 (⌘,)
   - 프로파일 > Colors 탭
   - Cursor Colors > Cursor
   - 대조되는 색상 선택 (다크 테마의 경우 흰색/노란색)

2. **블록 커서 사용**:
   - 프로파일 > Text 탭
   - Cursor 섹션
   - "Box" 커서 선택
   - "Blinking cursor" 활성화

3. **기본 프로필로 재설정**:
   - 프로파일 > Other Actions > Set as Default
   - iTerm2 재시작

---

## 셸 및 플러그인 문제

### zsh-autosuggestions가 작동하지 않음

**증상**: 입력하는 동안 명령어 제안이 나타나지 않음

**원인**:
- 플러그인이 설치되지 않음
- 플러그인이 .zshrc에서 소스되지 않음
- .zshrc의 구문 오류

**해결책**:

1. **설치 확인**:
   ```bash
   brew list zsh-autosuggestions
   ```
   찾을 수 없는 경우:
   ```bash
   brew install zsh-autosuggestions
   ```

2. **.zshrc 확인**:
   ```bash
   grep "zsh-autosuggestions" ~/.zshrc
   ```
   다음이 표시되어야 함:
   ```bash
   source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
   ```

3. **.zshrc에 수동으로 추가**:
   ```bash
   echo 'source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh' >> ~/.zshrc
   source ~/.zshrc
   ```

4. **구문 테스트**:
   ```bash
   zsh -n ~/.zshrc
   ```
   출력 없음 = 정상. 오류 표시 = 구문 수정

5. **셸 다시 로드**:
   ```bash
   exec zsh
   ```

---

### zsh-syntax-highlighting이 작동하지 않음

**증상**: 명령어에 색상 강조가 표시되지 않음

**원인**:
- 플러그인이 설치되지 않음
- 플러그인이 잘못된 순서로 로드됨
- 충돌하는 플러그인

**해결책**:

1. **설치 확인**:
   ```bash
   brew list zsh-syntax-highlighting
   ```

2. **.zshrc 순서 확인** (중요):
   ```bash
   tail ~/.zshrc
   ```

   **zsh-syntax-highlighting은 마지막에 소스되어야 함**:
   ```bash
   source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
   source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh  # 마지막!
   ```

3. **순서 수정**:
   `~/.zshrc`를 편집하고 zsh-syntax-highlighting을 끝으로 이동

4. **다시 로드**:
   ```bash
   source ~/.zshrc
   ```

---

### Oh My Zsh 테마가 표시되지 않음

**증상**: 프롬프트가 평범해 보이고 Git 브랜치가 표시되지 않음

**원인**:
- .zshrc에서 테마가 설정되지 않음
- Oh My Zsh가 로드되지 않음
- .zshrc 구문 오류

**해결책**:

1. **Oh My Zsh 설치 확인**:
   ```bash
   [ -d ~/.oh-my-zsh ] && echo "설치됨" || echo "설치되지 않음"
   ```

2. **테마 설정 확인**:
   ```bash
   grep "^ZSH_THEME=" ~/.zshrc
   ```
   다음이 표시되어야 함: `ZSH_THEME="agnoster"`

3. **수동으로 테마 설정**:
   ```bash
   sed -i '' 's/^ZSH_THEME=.*/ZSH_THEME="agnoster"/' ~/.zshrc
   source ~/.zshrc
   ```

4. **Oh My Zsh가 로드되는지 확인**:
   ```bash
   grep "source.*oh-my-zsh.sh" ~/.zshrc
   ```
   source 줄이 표시되어야 함

5. **Oh My Zsh 재설치**:
   ```bash
   sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
   ```

---

### 셸 설정 충돌

**증상**: 새 설정이 적용되지 않음, 시작 시 오류 발생

**원인**:
- 여러 충돌하는 설정 파일
- 구문 오류
- 로드 순서 문제

**해결책**:

1. **활성 셸 확인**:
   ```bash
   echo $SHELL
   ```
   다음이어야 함: `/bin/zsh`

2. **충돌하는 설정 확인**:
   ```bash
   ls -la ~/ | grep "^\."
   ```
   찾기: `.bashrc`, `.bash_profile`, `.zprofile`, `.zshrc`, `.zshenv`

3. **.zshrc 구문 테스트**:
   ```bash
   zsh -n ~/.zshrc
   ```

4. **깨끗한 셸로 시작**:
   ```bash
   zsh -f
   ```

5. **.zshrc 임시로 이름 변경**:
   ```bash
   mv ~/.zshrc ~/.zshrc.backup
   exec zsh  # 기본값으로 시작해야 함
   mv ~/.zshrc.backup ~/.zshrc
   ```

6. **시작 오류 확인**:
   ```bash
   zsh -x 2>&1 | less
   ```
   오류 메시지 찾기

---

## MCP 서버 문제

### MCP 서버가 로드되지 않음

**증상**: Claude Code가 MCP 서버에 접근할 수 없음

**원인**:
- 잘못된 .mcp.json 구문
- MCP 서버가 설치되지 않음
- 잘못된 명령어 경로

**해결책**:

1. **.mcp.json 구문 확인**:
   ```bash
   cat ~/.claude/.mcp.json | jq .
   ```
   오류 발생 시: JSON 구문 수정 (쉼표, 대괄호 누락)

2. **서버 설치 확인**:
   ```bash
   npm list -g | grep mcp
   ```
   설치된 MCP 서버가 표시되어야 함

3. **서버 명령어 테스트**:
   ```bash
   local-rag-mcp --version
   # 또는
   which local-rag-mcp
   ```

4. **서버 재설치**:
   ```bash
   npm install -g @anthropic-ai/local-rag-mcp
   ```

5. **Claude Code 설정 확인**:
   ```bash
   claude config --list
   ```

6. **유효한 .mcp.json 예시**:
   ```json
   {
     "mcpServers": {
       "local-rag": {
         "command": "local-rag-mcp",
         "args": [],
         "env": {
           "RAG_INDEX_PATH": "/Users/you/.claude/rag-index"
         }
       }
     }
   }
   ```
   주의: 마지막 항목 뒤에 쉼표 없음!

---

### local-rag가 문서를 찾지 못함

**증상**: local-rag MCP 서버가 문서를 검색할 수 없음

**원인**:
- 색인 경로가 구성되지 않음
- 문서가 색인되지 않음
- 잘못된 파일 유형

**해결책**:

1. **색인 경로 확인**:
   ```bash
   cat ~/.claude/.mcp.json | jq '.mcpServers["local-rag"].env.RAG_INDEX_PATH'
   ```

2. **색인 디렉토리 생성**:
   ```bash
   mkdir -p ~/.claude/rag-index
   ```

3. **문서 색인**:
   ```bash
   # 예시: Obsidian 볼트 색인
   local-rag-mcp index ~/claude-workspace/vault/
   ```

4. **색인된 문서 확인**:
   ```bash
   local-rag-mcp list
   ```

5. **지원되는 파일 유형**:
   - 마크다운 (.md)
   - PDF (.pdf)
   - 텍스트 (.txt)
   - 코드 파일 (.js, .py, .ts 등)

---

### filesystem MCP 권한 거부됨

**증상**: filesystem MCP가 파일을 읽거나 쓸 수 없음

**원인**:
- 제한된 루트 경로
- 파일 권한
- macOS 샌드박스 제한

**해결책**:

1. **구성된 루트 확인**:
   ```bash
   cat ~/.claude/.mcp.json | jq '.mcpServers.filesystem.args'
   ```

2. **접근 가능한 경로 사용**:
   ```json
   {
     "filesystem": {
       "command": "filesystem-mcp",
       "args": ["--root", "/Users/yourname/"]
     }
   }
   ```

3. **Terminal에 전체 디스크 접근 권한 부여** (macOS):
   - 시스템 설정 > 개인 정보 보호 및 보안
   - 전체 디스크 접근 권한
   - Terminal.app 활성화

4. **파일 권한 확인**:
   ```bash
   ls -la /path/to/file
   ```

---

## 권한 문제

### macOS에서 "작업이 허용되지 않음"

**증상**:
```
operation not permitted
```

**원인**: macOS 보안 제한 (SIP, 샌드박스)

**해결책**:

1. **Terminal에 전체 디스크 접근 권한 부여**:
   - 시스템 설정 > 개인 정보 보호 및 보안
   - 전체 디스크 접근 권한
   - 🔒 클릭하여 잠금 해제
   - Terminal.app 활성화
   - Terminal 재시작

2. **특정 디렉토리의 경우**:
   - 시스템 설정 > 개인 정보 보호 및 보안
   - 파일 및 폴더
   - Terminal > 폴더 활성화

3. **시스템 디렉토리 피하기**:
   - `/System/` 수정 시도하지 않기
   - `/usr/bin/` 수정 시도하지 않기
   - 대신 `~/` (홈) 사용

---

### sudo 비밀번호 프롬프트

**증상**: 설치 중 비밀번호를 계속 요청함

**원인**: 일부 설치에 관리자 권한 필요

**해결책**:

1. **sudo 사용 최소화**:
   - npm 권한 수정 (위 참조)
   - Homebrew 사용 (sudo 불필요)

2. **sudo 시간 초과 연장**:
   ```bash
   sudo -v
   # sudo를 5분 동안 활성 상태로 유지
   ```

3. **sudo로 전체 스크립트 실행** (권장하지 않음):
   ```bash
   sudo ./setup.sh
   ```

---

## 네트워크 문제

### 다운로드 실패 / 시간 초과

**증상**:
```
다운로드 실패
연결 시간 초과
```

**원인**:
- 느리거나 불안정한 네트워크
- 방화벽 차단
- 프록시 설정

**해결책**:

1. **인터넷 연결 확인**:
   ```bash
   ping google.com
   curl -I https://github.com
   ```

2. **다른 DNS 시도**:
   ```bash
   # Google DNS 사용
   networksetup -setdnsservers Wi-Fi 8.8.8.8 8.8.4.4
   ```

3. **프록시 구성** (기업 방화벽 뒤에 있는 경우):
   ```bash
   export HTTP_PROXY=http://proxy.company.com:8080
   export HTTPS_PROXY=http://proxy.company.com:8080
   ```

4. **시간 초과 증가**:
   ```bash
   npm config set timeout 60000
   ```

5. **설치 재시도**:
   ```bash
   ./setup.sh
   ```
   대부분의 설치 프로그램이 자동으로 재개됨

---

### GitHub 연결 문제

**증상**:
```
github.com에 연결할 수 없습니다
```

**원인**:
- 네트워크 방화벽
- SSH 키가 구성되지 않음
- GitHub 서비스 다운

**해결책**:

1. **GitHub 상태 확인**:
   - https://www.githubstatus.com/ 방문

2. **연결 테스트**:
   ```bash
   ssh -T git@github.com
   ```
   다음이 표시되어야 함: "Hi username! You've successfully authenticated..."

3. **SSH 대신 HTTPS 사용**:
   ```bash
   git config --global url."https://github.com/".insteadOf git@github.com:
   ```

4. **SSH 키 구성**:
   ```bash
   gh auth login
   ```
   프롬프트 따르기

5. **방화벽 확인**:
   - 포트 22 (SSH)와 443 (HTTPS)이 열려 있는지 확인

---

## 추가 도움말 받기

### 디버그 모드 활성화

**macOS**:
```bash
set -x  # 디버그 출력 활성화
./setup.sh
set +x  # 디버그 출력 비활성화
```

**Windows**:
```powershell
$DebugPreference = "Continue"
.\setup.ps1
```

### 시스템 정보 수집

```bash
# 시스템 정보
uname -a
sw_vers  # macOS 버전

# 설치된 도구
brew --version
node --version
npm --version
git --version

# 셸 정보
echo $SHELL
zsh --version

# PATH
echo $PATH
```

### 로그 확인

**Homebrew 로그**:
```bash
cat /tmp/homebrew-install.log
```

**npm 로그**:
```bash
npm config get cache
ls -la ~/.npm/_logs/
```

**Claude Code 로그**:
```bash
ls -la ~/.claude/logs/
```

### 문제 보고

위의 방법으로 해결되지 않는 경우 문제를 보고하세요:

1. **정보 수집** (위의 명령어 사용)
2. **보고서에 포함**:
   - macOS/Windows 버전
   - 오류 메시지 (전체 출력)
   - 재현 단계
   - 시스템 정보
3. **제출**: [GitHub Issues](https://github.com/ejkim-dev/ai-dev-setup/issues)

---

## 완전 제거

Phase 1 및 Phase 2의 자세한 단계별 제거 방법은 **[제거 가이드](UNINSTALL.md)**를 참조하세요.

---

## 관련 문서

- [Phase 1 가이드](PHASE1.md)
- [Phase 2 가이드](PHASE2.md)
- [FAQ](FAQ.md)
- [워크스페이스 구조](WORKSPACE.md)
