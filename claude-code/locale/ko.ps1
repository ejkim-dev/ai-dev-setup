# Korean locale

# Prerequisites
$MSG_CLAUDE_NOT_INSTALLED = "Claude Code가 설치되어 있지 않습니다."
$MSG_INSTALL_NOW = "지금 설치하시겠습니까?"
$MSG_CLAUDE_REQUIRED = "Claude Code가 필요합니다. 먼저 설치해주세요:"
$MSG_CLAUDE_INSTALL_CMD = "  npm install -g @anthropic-ai/claude-code"
$MSG_CLAUDE_RESTART_TERMINAL = "PowerShell을 재시작하고 이 스크립트를 다시 실행해주세요."
$MSG_CLAUDE_INSTALL_FAILED = "설치 실패"
$MSG_CLAUDE_CHECK_HEADER = "다음을 확인해주세요:"
$MSG_CLAUDE_CHECK_NPM = "1. npm이 동작하는지: npm --version"
$MSG_CLAUDE_CHECK_INTERNET = "2. 인터넷 연결"
$MSG_CLAUDE_CHECK_PERMISSIONS = "3. 필요시 관리자 권한으로 PowerShell 실행"
$MSG_CLAUDE_TRY_MANUAL = "수동 시도: npm install -g @anthropic-ai/claude-code"
$MSG_CLAUDE_NOT_IN_PATH = "Claude Code가 설치되었지만 PATH에 없습니다"
$MSG_NODE_NOT_INSTALLED = "Node.js가 설치되어 있지 않습니다. MCP 서버에 필요합니다."
$MSG_NODE_INSTALL_ASK = "winget으로 Node.js를 설치하시겠습니까?"
$MSG_NPM_NOT_FOUND = "npm을 찾을 수 없습니다. Node.js를 먼저 설치해주세요."

# Common
$MSG_DONE = "완료"
$MSG_SKIP = "건너뛰기"
$MSG_LANG_SET = "언어:"
$MSG_ALREADY_INSTALLED = "이미 설치되어 있습니다."
$MSG_INSTALLING = "설치 중..."
$MSG_UPDATING = "업데이트 중..."
$MSG_APPLIED = "적용됨"
$MSG_YES = "예"
$MSG_NO = "아니오"

# Workspace
$MSG_WS_TITLE = "claude-workspace 설정"
$MSG_WS_DESC_1 = "Claude Code의 모든 설정을 한 곳에서 관리합니다."
$MSG_WS_DESC_2 = "에이전트, CLAUDE.md, 프로젝트 설정을 중앙에서 관리하고"
$MSG_WS_DESC_3 = "심링크로 각 프로젝트에 연결합니다."
$MSG_WS_TREE_AGENTS = "공유 에이전트 (모든 프로젝트에서 사용)"
$MSG_WS_TREE_PROJECTS = "프로젝트별 설정"
$MSG_WS_TREE_TEMPLATES = "MCP, CLAUDE.md 템플릿"
$MSG_WS_ASK = "claude-workspace를 설정하시겠습니까?"
$MSG_WS_AGENTS_DONE = "공유 에이전트 설치: workspace-manager, translate, doc-writer"
$MSG_WS_TEMPLATES_DONE = "템플릿 복사 완료"
$MSG_WS_SYMLINK_EXISTS = "~\.claude\agents\ 심링크가 이미 존재합니다."
$MSG_WS_FOLDER_EXISTS = "~\.claude\agents\ 폴더가 이미 존재합니다."
$MSG_WS_BACKUP_ASK = "기존 폴더를 백업하고 심링크로 교체하시겠습니까?"
$MSG_WS_BACKUP_DONE = "기존 폴더 백업: ~\.claude\agents.backup"
$MSG_WS_SYMLINK_DONE = "심링크 연결: ~\.claude\agents\ → claude-workspace"
$MSG_WS_SYMLINK_NEED_ADMIN = "Windows에서 심링크 생성은 개발자 모드 또는 관리자 권한이 필요합니다."
$MSG_WS_SYMLINK_ENABLE = "개발자 모드 활성화: 설정 → 업데이트 및 보안 → 개발자용"
$MSG_WS_SYMLINK_SKIP = "심링크를 건너뜁니다. 대신 에이전트 폴더를 복사합니다."

# Project
$MSG_PROJ_DESC_1 = "프로젝트를 claude-workspace에 연결하면"
$MSG_PROJ_DESC_2 = "CLAUDE.md, 에이전트, 설정을 중앙에서 관리할 수 있습니다."
$MSG_PROJ_ASK = "프로젝트를 연결하시겠습니까?"
$MSG_PROJ_NOW = "지금 연결"
$MSG_PROJ_LATER = "나중에"
$MSG_PROJ_PATH = "프로젝트 경로 (예: C:\projects\my-app): "
$MSG_PROJ_SKIP = "건너뜀. 프로젝트 연결 메뉴로 돌아갑니다."
$MSG_PROJ_NOT_FOUND = "경로를 찾을 수 없습니다:"
$MSG_PROJ_TRY_AGAIN = "다시 입력하거나 빈 값으로 건너뛰세요."
$MSG_PROJ_EXISTS = "이미 존재. 건너뜁니다."
$MSG_PROJ_LINK_CLAUDE = ".claude\ 심링크 연결"
$MSG_PROJ_LINK_CLAUDEMD = "CLAUDE.md 심링크 연결"
$MSG_PROJ_LINK_LOCALMD = "CLAUDE.local.md 심링크 연결"
$MSG_PROJ_GITIGNORE = ".gitignore 업데이트"
$MSG_PROJ_DONE = "연결 완료"
$MSG_PROJ_NAME_CONFLICT = "이름이 워크스페이스에 이미 존재합니다."
$MSG_PROJ_USE_EXISTING = "기존 워크스페이스 설정을 사용하시겠습니까?"
$MSG_PROJ_USE_EXISTING_YES = "기존 설정 사용"
$MSG_PROJ_NEW = "새로 만들기"
$MSG_PROJ_AUTO_NAMED = "자동 이름 지정:"
$MSG_PROJ_ALREADY_CONNECTED = "이미 연결된 프로젝트입니다."

# Obsidian
$MSG_OBS_TITLE = "Obsidian"
$MSG_OBS_DESC_1 = "마크다운으로 메모/문서를 작성하는 앱입니다."
$MSG_OBS_DESC_2 = "작성한 문서를 Claude Code에 검색시킬 수 있습니다. (local-rag 연동)"
$MSG_OBS_ASK = "Obsidian을 설치하시겠습니까?"

# MCP
$MSG_MCP_TITLE = "MCP 서버"
$MSG_MCP_DESC_1 = "기본 Claude Code는 파일 읽기/쓰기, 터미널만 사용합니다."
$MSG_MCP_DESC_2 = "MCP 서버를 연결하면 문서 검색, Jira 연동 등"
$MSG_MCP_DESC_3 = "외부 서비스를 Claude가 직접 사용할 수 있습니다."
$MSG_MCP_ASK = "MCP 서버를 설정하시겠습니까?"
$MSG_MCP_NOW = "지금 설정"
$MSG_MCP_LATER = "나중에"

# MCP Server options
$MSG_MCP_SERVER_LOCALRAG = "local-rag - 문서/코드 검색"
$MSG_MCP_SERVER_FILESYSTEM = "filesystem - 파일 읽기/쓰기"
$MSG_MCP_SERVER_SERENA = "serena - 웹 검색"
$MSG_MCP_SERVER_FETCH = "fetch - HTTP 요청"
$MSG_MCP_SERVER_PUPPETEER = "puppeteer - 브라우저 자동화"
$MSG_RECOMMENDED = "(추천)"

# local-rag
$MSG_RAG_TITLE = "local-rag (문서 검색)"
$MSG_RAG_DESC = "PDF, 마크다운 등 문서를 Claude에게 검색시킬 수 있습니다."
$MSG_RAG_ASK = "local-rag를 설정하시겠습니까?"
$MSG_RAG_PATH = "프로젝트 경로 (예: C:\projects\my-app): "
$MSG_MCP_FILE_EXISTS = ".mcp.json이 이미 존재합니다. 수동으로 추가해주세요:"
$MSG_MCP_FILE_REF = "참고:"
$MSG_MCP_FILE_DONE = "생성 완료"

# MCP server selection
$MSG_MCP_SELECT_PROMPT = "설치할 MCP 서버를 선택하세요:"
$MSG_MCP_SELECT_HINT = "쉼표로 구분하여 번호 입력 (예: 1,2,3)"
$MSG_MCP_RECOMMENDED_HEADER = "추천 핵심 설정 (3개):"
$MSG_MCP_RECOMMENDED_DESC_1 = "  local-rag    - 문서/코드 검색"
$MSG_MCP_RECOMMENDED_DESC_2 = "  filesystem   - 파일 읽기/쓰기"
$MSG_MCP_RECOMMENDED_DESC_3 = "  serena       - 웹 검색"
$MSG_MCP_ADDITIONAL_HEADER = "추가 서버 (선택사항):"
$MSG_MCP_ADDITIONAL_DESC_1 = "  fetch        - HTTP 요청"
$MSG_MCP_ADDITIONAL_DESC_2 = "  puppeteer    - 브라우저 자동화"
$MSG_MCP_NO_SERVERS = "선택한 MCP 서버가 없습니다"
$MSG_MCP_INSTALLING_COUNT = "{0}개 MCP 서버 설정 중..."
$MSG_MCP_PROJECT_ASK_EACH = "'{0}' 프로젝트에 MCP 서버를 추가하시겠습니까?"
$MSG_MCP_NO_PROJECTS = "연결된 프로젝트가 없습니다. 나중에 프로젝트의 .mcp.json을 수동으로 생성하세요."
$MSG_MCP_CREATING_FILE = "{0} 생성 중..."
$MSG_MCP_FILE_CREATED = ".mcp.json이 {0}개 서버로 생성됨"
$MSG_MCP_INSTALLING_PREFIX = "{0} 추가 중..."

# Phase 1 → 2 Transition
$MSG_PHASE1_COMPLETE = "Phase 1 완료!"
$MSG_PHASE2_NEXT = "다음: Phase 2 - Claude Code 설정 (선택 사항)"
$MSG_PHASE2_DESC_1 = "  워크스페이스 관리 (중앙 설정)"
$MSG_PHASE2_DESC_2 = "  공유 에이전트 (workspace-manager, translate, doc-writer)"
$MSG_PHASE2_DESC_3 = "  MCP 서버 (문서 검색)"
$MSG_PHASE2_DESC_4 = "  Git + GitHub (Claude 기능 활용 권장)"
$MSG_PHASE2_ASK = "Phase 2를 지금 진행하시겠습니까?"
$MSG_PHASE2_RESTART_WARN = "Phase 2를 위해 터미널 재시작이 필요합니다"
$MSG_PHASE2_RESTART_REASON = "(업데이트된 PATH와 환경 변수를 로드하기 위해)"
$MSG_PHASE2_OPEN_TERM_ASK = "새 PowerShell을 열고 Phase 2를 시작하시겠습니까?"
$MSG_PHASE2_OPENING = "새 PowerShell을 여는 중..."
$MSG_PHASE2_OPENED = "새 PowerShell에서 Phase 2 설치가 시작되었습니다"
$MSG_PHASE2_CLOSE_INFO = "Phase 2가 시작되면 이 창을 닫으셔도 됩니다"
$MSG_PHASE2_MANUAL = "나중에 새 PowerShell에서 Phase 2 실행하기:"
$MSG_PHASE2_MANUAL_LATER = "언제든지 Phase 2 실행 가능:"

# Completion
$MSG_COMPLETE = "Claude Code 설정이 완료되었습니다!"
$MSG_USAGE = "사용법: 프로젝트 폴더에서 'claude' 입력"
$MSG_INFO_WORKSPACE = "워크스페이스:"
$MSG_INFO_AGENTS = "공유 에이전트: workspace-manager, translate, doc-writer"
$MSG_INFO_LANGUAGE = "언어:"
$MSG_INFO_CONFIG = "설정 파일:"
$MSG_TIP_ADD_PROJECT = "나중에 프로젝트 추가하려면 Claude Code에서:"
$MSG_TIP_ADD_CMD = "'새 프로젝트 연결해줘' → workspace-manager가 처리"

# Next Steps
$MSG_NEXT_STEPS = "다음 단계:"
$MSG_STEP_1_TITLE = "1. Claude Code 로그인"
$MSG_STEP_1_DESC = "프로젝트 폴더에서: claude"
$MSG_STEP_1_NOTE = "-> 브라우저가 열리며 로그인/가입 진행"
$MSG_STEP_2_TITLE = "2. 프로젝트 초기화"
$MSG_STEP_2_DESC = "cd ~\my-project; claude init"
$MSG_STEP_3_TITLE = "3. Claude Code 시작"
$MSG_STEP_3_DESC = "claude"
$MSG_STEP_3_NOTE = "-> AI 코딩 어시스턴트 시작!"
$MSG_DOCS_AVAILABLE = "상세 문서: ~\claude-workspace\doc\"

# ============================
# Parent setup script messages
# ============================

# Welcome
$MSG_SETUP_WELCOME_WIN = "Windows 개발환경 설정을 시작합니다!"
$MSG_SETUP_EACH_STEP = "각 단계마다 설치 여부를 물어봅니다."

# Steps
$MSG_STEP_WINGET = "winget (패키지 관리자)"
$MSG_STEP_GIT = "Git"
$MSG_STEP_PACKAGES_WIN = "기본 패키지 설치 (Node.js, GitHub CLI, ripgrep)"
$MSG_NODE_REQUIRED = "AI 코딩 도구(Claude Code, Gemini CLI)를 사용하려면 Node.js가 필요합니다."
$MSG_NODE_MANUAL_INSTALL = "Node.js를 수동으로 설치해주세요:"
$MSG_NODE_VERIFY = "그 다음 설치를 확인하세요:"
$MSG_STEP_D2CODING = "D2Coding 개발용 폰트"
$MSG_STEP_SSH = "SSH 키 생성 (GitHub 연결용)"
$MSG_STEP_WINTERMINAL = "Windows Terminal 테마 설정"
$MSG_STEP_OHMYPOSH = "Oh My Posh (PowerShell 테마)"
$MSG_STEP_CLAUDE = "Claude Code"
$MSG_STEP_AI_TOOLS = "AI 코딩 도구"
$MSG_AI_TOOLS_HINT = "쉼표로 구분하여 번호 입력 (예: 1,2)"

# winget
$MSG_WINGET_NOT_INSTALLED = "winget이 설치되어 있지 않습니다."
$MSG_WINGET_STORE = "→ Microsoft Store에서 'App Installer'를 설치해주세요."
$MSG_WINGET_UPDATE = "→ 또는 Windows 10 1709 이상으로 업데이트하세요."
$MSG_WINGET_ENTER = "설치 후 Enter를 눌러주세요..."

# Windows Terminal
$MSG_WINTERMINAL_NOT_INSTALLED = "Windows Terminal이 설치되어 있지 않습니다."
$MSG_WINTERMINAL_INSTALL = "Windows Terminal을 설치하시겠습니까?"
$MSG_WINTERMINAL_APPLY = "Windows Terminal에 'Dev' 테마를 적용하시겠습니까?"
$MSG_WINTERMINAL_BACKUP = "기존 설정 백업:"
$MSG_WINTERMINAL_DONE = "Dev 테마 + D2Coding 폰트 적용 완료"
$MSG_WINTERMINAL_RESTORE = "원래 설정으로 돌리려면:"
$MSG_WINTERMINAL_VERIFY_HEADER = "터미널 테마 확인"
$MSG_WINTERMINAL_VERIFY_DESC = "Windows Terminal을 재시작하여 Dev 테마를 확인하세요"
$MSG_WINTERMINAL_MANUAL_SETUP = "테마가 적용되지 않았다면 수동 설정:"
$MSG_WINTERMINAL_MANUAL = "Settings(Ctrl+,) → Color schemes에서 Dev 확인 → Profiles → Defaults → Appearance → Color scheme: Dev"
$MSG_WINTERMINAL_PARSE_FAIL = "settings.json 파싱 실패 (JSONC 형식 미지원). 테마가 적용되지 않았습니다."
$MSG_WINTERMINAL_BACKUP_RESTORED = "백업에서 기존 설정을 복원했습니다."

# Oh My Posh
$MSG_OHMYPOSH_INSTALL = "Oh My Posh를 설치하시겠습니까?"
$MSG_OHMYPOSH_PROFILE = "설치 완료. PowerShell 프로필에 다음을 추가하세요:"

# D2Coding
$MSG_D2CODING_MANUAL = "winget으로 설치 실패. 수동 설치가 필요할 수 있습니다."
$MSG_D2CODING_MANUAL_URL = "→ https://github.com/naver/d2codingfont/releases"

# Claude Code (parent)
$MSG_CLAUDE_INSTALL = "Claude Code를 설치하시겠습니까?"
$MSG_CLAUDE_UPDATE_ASK = "Claude Code를 업데이트하시겠습니까?"
$MSG_CLAUDE_EXTRA = "Claude Code 추가 설정 (MCP, RAG 등)은 나중에 실행하세요:"

# Completion (parent)
$MSG_SETUP_COMPLETE = "설치가 완료되었습니다!"
$MSG_OPEN_NEW_TERMINAL = "새 터미널 윈도우를 열어서 확인해보세요."
$MSG_CLAUDE_EXTRA_SETUP = "Claude Code 추가 설정:"
$MSG_EXISTING_FOLDER = "기존 ai-dev-setup 폴더가 있습니다. 업데이트합니다."

# Install script
$MSG_DOWNLOADING = "ai-dev-setup 다운로드 중..."
$MSG_DOWNLOAD_DONE = "다운로드 완료"
$MSG_EXTRACT_DONE = "압축 해제 완료"
$MSG_INSTALL_LOCATION = "설치 위치:"
$MSG_STARTING_SETUP = "설정을 시작합니다..."
