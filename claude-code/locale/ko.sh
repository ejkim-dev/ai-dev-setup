#!/bin/bash
# Korean locale

# Prerequisites
MSG_CLAUDE_NOT_INSTALLED="Claude Code가 설치되어 있지 않습니다."
MSG_INSTALL_NOW="지금 설치하시겠습니까?"
MSG_CLAUDE_REQUIRED="Claude Code가 필요합니다. 먼저 설치해주세요:"
MSG_CLAUDE_INSTALL_CMD="  npm install -g @anthropic-ai/claude-code"
MSG_NODE_NOT_INSTALLED="Node.js가 설치되어 있지 않습니다. MCP 서버에 필요합니다."
MSG_NODE_INSTALL_ASK="Homebrew로 Node.js를 설치하시겠습니까?"
MSG_NPM_NOT_FOUND="npm을 찾을 수 없습니다. Node.js를 먼저 설치해주세요."
MSG_BREW_NOT_FOUND_OBSIDIAN="Homebrew를 찾을 수 없습니다. Obsidian을 직접 설치해주세요: https://obsidian.md/"

# Common
MSG_DONE="완료"
MSG_SKIP="건너뛰기"
MSG_LANG_SET="언어:"
MSG_ALREADY_INSTALLED="이미 설치되어 있습니다."
MSG_INSTALLING="설치 중..."
MSG_UPDATING="업데이트 중..."
MSG_APPLIED="적용됨"

# Workspace
MSG_WS_TITLE="claude-workspace 설정"
MSG_WS_DESC_1="Claude Code의 모든 설정을 한 곳에서 관리합니다."
MSG_WS_DESC_2="에이전트, CLAUDE.md, 프로젝트 설정을 중앙에서 관리하고"
MSG_WS_DESC_3="심링크로 각 프로젝트에 연결합니다."
MSG_WS_TREE_AGENTS="전역 에이전트 (모든 프로젝트에서 사용)"
MSG_WS_TREE_PROJECTS="프로젝트별 설정"
MSG_WS_TREE_TEMPLATES="MCP, CLAUDE.md 템플릿"
MSG_WS_ASK="claude-workspace를 설정하시겠습니까?"
MSG_WS_AGENTS_DONE="전역 에이전트 설치: workspace-manager, translate, doc-writer"
MSG_WS_TEMPLATES_DONE="템플릿 복사 완료"
MSG_WS_SYMLINK_EXISTS="~/.claude/agents/ 심링크가 이미 존재합니다."
MSG_WS_FOLDER_EXISTS="~/.claude/agents/ 폴더가 이미 존재합니다."
MSG_WS_BACKUP_ASK="기존 폴더를 백업하고 심링크로 교체하시겠습니까?"
MSG_WS_BACKUP_DONE="기존 폴더 백업: ~/.claude/agents.backup"
MSG_WS_SYMLINK_DONE="심링크 연결: ~/.claude/agents/ → claude-workspace"
MSG_WS_SYMLINK_NEED_ADMIN="Windows에서 심링크 생성은 개발자 모드 또는 관리자 권한이 필요합니다."
MSG_WS_SYMLINK_ENABLE="개발자 모드 활성화: 설정 → 업데이트 및 보안 → 개발자용"
MSG_WS_SYMLINK_SKIP="심링크를 건너뜁니다. 대신 에이전트 폴더를 복사합니다."

# Project
MSG_PROJ_DESC_1="프로젝트를 claude-workspace에 연결하면"
MSG_PROJ_DESC_2="CLAUDE.md, 에이전트, 설정을 중앙에서 관리할 수 있습니다."
MSG_PROJ_ASK="프로젝트를 연결하시겠습니까?"
MSG_PROJ_PATH="프로젝트 경로 (예: ~/projects/my-app): "
MSG_PROJ_NOT_FOUND="경로를 찾을 수 없습니다:"
MSG_PROJ_EXISTS="이미 존재. 건너뜁니다."
MSG_PROJ_LINK_CLAUDE=".claude/ 심링크 연결"
MSG_PROJ_LINK_CLAUDEMD="CLAUDE.md 심링크 연결"
MSG_PROJ_LINK_LOCALMD="CLAUDE.local.md 심링크 연결"
MSG_PROJ_GITIGNORE=".gitignore 업데이트"
MSG_PROJ_DONE="연결 완료"
MSG_PROJ_NAME_CONFLICT="이름이 워크스페이스에 이미 존재합니다. 다른 이름을 입력하세요 (빈 값이면 건너뜁니다):"

# Obsidian
MSG_OBS_TITLE="Obsidian"
MSG_OBS_DESC_1="마크다운으로 메모/문서를 작성하는 앱입니다."
MSG_OBS_DESC_2="작성한 문서를 Claude Code에 검색시킬 수 있습니다. (local-rag 연동)"
MSG_OBS_ASK="Obsidian을 설치하시겠습니까?"

# MCP
MSG_MCP_TITLE="MCP 서버"
MSG_MCP_DESC_1="기본 Claude Code는 파일 읽기/쓰기, 터미널만 사용합니다."
MSG_MCP_DESC_2="MCP 서버를 연결하면 문서 검색, Jira 연동 등"
MSG_MCP_DESC_3="외부 서비스를 Claude가 직접 사용할 수 있습니다."
MSG_MCP_ASK="MCP 서버를 설정하시겠습니까?"

# local-rag
MSG_RAG_TITLE="local-rag (문서 검색)"
MSG_RAG_DESC="PDF, 마크다운 등 문서를 Claude에게 검색시킬 수 있습니다."
MSG_RAG_ASK="local-rag를 설정하시겠습니까?"
MSG_RAG_PATH="프로젝트 경로 (예: ~/projects/my-app): "
MSG_MCP_FILE_EXISTS=".mcp.json이 이미 존재합니다. 수동으로 추가해주세요:"
MSG_MCP_FILE_REF="참고:"
MSG_MCP_FILE_DONE="생성 완료"

# Completion
MSG_COMPLETE="Claude Code 설정이 완료되었습니다!"
MSG_USAGE="사용법: 프로젝트 폴더에서 'claude' 입력"
MSG_INFO_WORKSPACE="워크스페이스:"
MSG_INFO_AGENTS="전역 에이전트: workspace-manager, translate, doc-writer"
MSG_INFO_LANGUAGE="언어:"
MSG_INFO_CONFIG="설정 파일:"
MSG_TIP_ADD_PROJECT="나중에 프로젝트 추가하려면 Claude Code에서:"
MSG_TIP_ADD_CMD="'새 프로젝트 연결해줘' → workspace-manager가 처리"

# ============================
# Parent setup script messages
# ============================

# Welcome
MSG_SETUP_WELCOME_MAC="Mac 개발환경 설정을 시작합니다!"
MSG_SETUP_WELCOME_WIN="Windows 개발환경 설정을 시작합니다!"
MSG_SETUP_EACH_STEP="각 단계마다 설치 여부를 물어봅니다."

# Steps
MSG_STEP_XCODE="Xcode Command Line Tools (git 포함)"
MSG_STEP_HOMEBREW="Homebrew"
MSG_STEP_PACKAGES="기본 패키지 설치 (git, node, ripgrep, tmux, 폰트)"
MSG_STEP_PACKAGES_WIN="기본 패키지 설치 (Node.js, GitHub CLI, ripgrep)"
MSG_STEP_D2CODING="D2Coding 개발용 폰트"
MSG_STEP_FONT_D2CODING_BREW="Brewfile에서 설치되었습니다."
MSG_STEP_SSH="SSH 키 생성 (GitHub 연결용)"
MSG_STEP_MACOS_SETTINGS="macOS 개발자 설정"
MSG_STEP_TERMINAL="터미널 설정"
MSG_STEP_OHMYZSH="Oh My Zsh"
MSG_STEP_CLAUDE="Claude Code"
MSG_STEP_AI_TOOLS="AI 코딩 도구"
MSG_AI_TOOLS_HINT="↑↓ 이동, Space 선택/해제, Enter 확인"

# Xcode
MSG_XCODE_INSTALLING="설치 중... (팝업이 뜨면 '설치'를 눌러주세요)"
MSG_XCODE_ENTER="설치가 완료되면 Enter를 눌러주세요..."

# SSH
MSG_SSH_EXISTS="SSH 키가 이미 존재합니다."
MSG_SSH_REGISTER="기존 키를 GitHub에 등록하시겠습니까?"
MSG_SSH_COPIED="SSH 공개키가 클립보드에 복사되었습니다!"
MSG_SSH_GITHUB_URL="→ https://github.com/settings/keys 에서 'New SSH key'를 눌러 붙여넣기 하세요"
MSG_SSH_ENTER="등록 완료 후 Enter를 눌러주세요..."
MSG_SSH_GENERATE="SSH 키를 생성하시겠습니까?"
MSG_SSH_EMAIL="GitHub 이메일을 입력하세요: "

# macOS settings
MSG_MACOS_APPLY="macOS 개발자 설정을 적용하시겠습니까?"
MSG_MACOS_HIDDEN="Finder에서 숨김파일 표시"
MSG_MACOS_KEYBOARD="키보드 반복 속도 빠르게 (길게 누르면 문자 반복)"
MSG_MACOS_SCREENSHOT="스크린샷 저장 폴더를 ~/Screenshots로 변경"

# Terminal
MSG_TERMINAL_OPT1="Terminal.app만 (다크 테마 적용)"
MSG_TERMINAL_OPT2="iTerm2 설치"
MSG_TERMINAL_OPT3="둘 다"
MSG_TERMINAL_OPT4="건너뛰기"
MSG_TERMINAL_APPLIED="Terminal.app 'Dev' 프로파일 적용 완료"

# Oh My Zsh
MSG_OHMYZSH_INSTALL="Oh My Zsh를 설치하시겠습니까?"
MSG_ZSHRC_ASK=".zshrc에 기본 설정을 추가하시겠습니까?"
MSG_ZSHRC_DONE=".zshrc 설정 추가 완료"
MSG_TMUX_ASK="tmux 설정을 적용하시겠습니까?"
MSG_TMUX_DONE=".tmux.conf 복사 완료"

# Claude Code (parent)
MSG_CLAUDE_INSTALL="Claude Code를 설치하시겠습니까?"
MSG_CLAUDE_UPDATE_ASK="Claude Code를 업데이트하시겠습니까?"
MSG_CLAUDE_EXTRA="Claude Code 추가 설정 (MCP, RAG 등)은 나중에 실행하세요:"

# Completion (parent)
MSG_SETUP_COMPLETE="설치가 완료되었습니다!"
MSG_OPEN_NEW_TERMINAL="새 터미널 윈도우를 열어서 확인해보세요."
MSG_CLAUDE_EXTRA_SETUP="Claude Code 추가 설정:"

# Windows-specific
MSG_WINGET_NOT_INSTALLED="winget이 설치되어 있지 않습니다."
MSG_WINGET_STORE="→ Microsoft Store에서 'App Installer'를 설치해주세요."
MSG_WINGET_UPDATE="→ 또는 Windows 10 1709 이상으로 업데이트하세요."
MSG_WINGET_ENTER="설치 후 Enter를 눌러주세요..."
MSG_STEP_WINGET="winget (패키지 관리자)"
MSG_STEP_GIT="Git"
MSG_STEP_WINTERMINAL="Windows Terminal 테마 설정"
MSG_STEP_OHMYPOSH="Oh My Posh (PowerShell 테마)"
MSG_WINTERMINAL_NOT_INSTALLED="Windows Terminal이 설치되어 있지 않습니다."
MSG_WINTERMINAL_INSTALL="Windows Terminal을 설치하시겠습니까?"
MSG_WINTERMINAL_APPLY="Windows Terminal에 'Dev' 테마를 적용하시겠습니까?"
MSG_WINTERMINAL_BACKUP="기존 설정 백업:"
MSG_WINTERMINAL_DONE="Dev 테마 + D2Coding 폰트 적용 완료"
MSG_WINTERMINAL_RESTORE="원래 설정으로 돌리려면:"
MSG_OHMYPOSH_INSTALL="Oh My Posh를 설치하시겠습니까?"
MSG_OHMYPOSH_PROFILE="설치 완료. PowerShell 프로필에 다음을 추가하세요:"
MSG_D2CODING_MANUAL="winget으로 설치 실패. 수동 설치가 필요할 수 있습니다."
MSG_D2CODING_MANUAL_URL="→ https://github.com/naver/d2codingfont/releases"
MSG_EXISTING_FOLDER="기존 ai-dev-setup 폴더가 있습니다. 업데이트합니다."

# Install script
MSG_DOWNLOADING="ai-dev-setup 다운로드 중..."
MSG_DOWNLOAD_DONE="다운로드 완료"
MSG_EXTRACT_DONE="압축 해제 완료"
MSG_INSTALL_LOCATION="설치 위치:"
MSG_STARTING_SETUP="설정을 시작합니다..."
