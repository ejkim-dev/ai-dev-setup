# English locale

# Prerequisites
$MSG_CLAUDE_NOT_INSTALLED = "Claude Code is not installed."
$MSG_INSTALL_NOW = "Install now?"
$MSG_CLAUDE_REQUIRED = "Claude Code is required. Please install first:"
$MSG_CLAUDE_INSTALL_CMD = "  npm install -g @anthropic-ai/claude-code"
$MSG_CLAUDE_RESTART_TERMINAL = "Please restart PowerShell and re-run this script."
$MSG_CLAUDE_INSTALL_FAILED = "Installation failed"
$MSG_CLAUDE_CHECK_HEADER = "Please check:"
$MSG_CLAUDE_CHECK_NPM = "1. npm is working: npm --version"
$MSG_CLAUDE_CHECK_INTERNET = "2. Internet connection"
$MSG_CLAUDE_CHECK_PERMISSIONS = "3. Run PowerShell as Administrator if needed"
$MSG_CLAUDE_TRY_MANUAL = "Try manually: npm install -g @anthropic-ai/claude-code"
$MSG_CLAUDE_NOT_IN_PATH = "Claude Code installed but not in PATH"
$MSG_NODE_NOT_INSTALLED = "Node.js is not installed. Required for MCP servers."
$MSG_NODE_INSTALL_ASK = "Install Node.js with winget?"
$MSG_NPM_NOT_FOUND = "npm not found. Please install Node.js first."

# Common
$MSG_DONE = "Done"
$MSG_SKIP = "Skipped"
$MSG_LANG_SET = "Language:"
$MSG_ALREADY_INSTALLED = "Already installed."
$MSG_INSTALLING = "Installing..."
$MSG_UPDATING = "Updating..."
$MSG_APPLIED = "Applied"
$MSG_YES = "Yes"
$MSG_NO = "No"

# Workspace
$MSG_WS_TITLE = "claude-workspace Setup"
$MSG_WS_DESC_1 = "Manage all Claude Code settings in one place."
$MSG_WS_DESC_2 = "Centrally manage agents, CLAUDE.md, and project settings,"
$MSG_WS_DESC_3 = "then link them to each project via symlinks."
$MSG_WS_TREE_AGENTS = "Shared agents (available in all projects)"
$MSG_WS_TREE_PROJECTS = "Per-project settings"
$MSG_WS_TREE_TEMPLATES = "MCP, CLAUDE.md templates"
$MSG_WS_ASK = "Set up claude-workspace?"
$MSG_WS_AGENTS_DONE = "Shared agents installed: workspace-manager, translate, doc-writer"
$MSG_WS_TEMPLATES_DONE = "Templates copied"
$MSG_WS_SYMLINK_EXISTS = "~\.claude\agents\ symlink already exists."
$MSG_WS_FOLDER_EXISTS = "~\.claude\agents\ folder already exists."
$MSG_WS_BACKUP_ASK = "Back up existing folder and replace with symlink?"
$MSG_WS_BACKUP_DONE = "Existing folder backed up: ~\.claude\agents.backup"
$MSG_WS_SYMLINK_DONE = "Symlink created: ~\.claude\agents\ → claude-workspace"
$MSG_WS_SYMLINK_NEED_ADMIN = "Creating symlinks on Windows requires Developer Mode or admin privileges."
$MSG_WS_SYMLINK_ENABLE = "Enable Developer Mode: Settings → Update & Security → For developers"
$MSG_WS_SYMLINK_SKIP = "Skipping symlink. Copying agents folder instead."

# Project
$MSG_PROJ_DESC_1 = "Connect projects to claude-workspace to"
$MSG_PROJ_DESC_2 = "centrally manage CLAUDE.md, agents, and settings."
$MSG_PROJ_ASK = "Connect a project?"
$MSG_PROJ_NOW = "Connect now"
$MSG_PROJ_LATER = "Later"
$MSG_PROJ_PATH = "Project path (e.g., C:\projects\my-app): "
$MSG_PROJ_SKIP = "Skipped. Returning to project connection menu."
$MSG_PROJ_NOT_FOUND = "Path not found:"
$MSG_PROJ_TRY_AGAIN = "Please try again or leave blank to skip."
$MSG_PROJ_EXISTS = "already exists. Skipping."
$MSG_PROJ_LINK_CLAUDE = ".claude\ symlink created"
$MSG_PROJ_LINK_CLAUDEMD = "CLAUDE.md symlink created"
$MSG_PROJ_LINK_LOCALMD = "CLAUDE.local.md symlink created"
$MSG_PROJ_GITIGNORE = ".gitignore updated"
$MSG_PROJ_DONE = "connected"
$MSG_PROJ_NAME_CONFLICT = "already exists in workspace."
$MSG_PROJ_USE_EXISTING = "Use existing workspace settings?"
$MSG_PROJ_USE_EXISTING_YES = "Use existing"
$MSG_PROJ_NEW = "Create new"
$MSG_PROJ_AUTO_NAMED = "Auto-named as"
$MSG_PROJ_ALREADY_CONNECTED = "This project is already connected."

# Obsidian
$MSG_OBS_TITLE = "Obsidian"
$MSG_OBS_DESC_1 = "A markdown-based note-taking and documentation app."
$MSG_OBS_DESC_2 = "Your documents can be searched by Claude Code via local-rag."
$MSG_OBS_ASK = "Install Obsidian?"

# MCP
$MSG_MCP_TITLE = "MCP Servers"
$MSG_MCP_DESC_1 = "By default, Claude Code can only read/write files and use the terminal."
$MSG_MCP_DESC_2 = "MCP servers let Claude directly use external services"
$MSG_MCP_DESC_3 = "like document search and Jira integration."
$MSG_MCP_ASK = "Set up MCP servers?"
$MSG_MCP_NOW = "Set up now"
$MSG_MCP_LATER = "Later"

# MCP Server options
$MSG_MCP_SERVER_LOCALRAG = "local-rag - Search docs/code"
$MSG_MCP_SERVER_FILESYSTEM = "filesystem - Read/write files"
$MSG_MCP_SERVER_SERENA = "serena - Web search"
$MSG_MCP_SERVER_FETCH = "fetch - HTTP requests"
$MSG_MCP_SERVER_PUPPETEER = "puppeteer - Browser automation"
$MSG_RECOMMENDED = "(recommended)"

# local-rag
$MSG_RAG_TITLE = "local-rag (Document Search)"
$MSG_RAG_DESC = "Search PDFs, markdown, and other documents with Claude."
$MSG_RAG_ASK = "Set up local-rag?"
$MSG_RAG_PATH = "Project path (e.g., C:\projects\my-app): "
$MSG_MCP_FILE_EXISTS = ".mcp.json already exists. Please add manually:"
$MSG_MCP_FILE_REF = "See template:"
$MSG_MCP_FILE_DONE = "created"

# MCP server selection
$MSG_MCP_SELECT_PROMPT = "Select MCP servers to install:"
$MSG_MCP_SELECT_HINT = "Enter numbers separated by commas (e.g., 1,2,3)"
$MSG_MCP_RECOMMENDED_HEADER = "Recommended core setup (3):"
$MSG_MCP_RECOMMENDED_DESC_1 = "  local-rag    - Search your docs/code"
$MSG_MCP_RECOMMENDED_DESC_2 = "  filesystem   - Read/write files"
$MSG_MCP_RECOMMENDED_DESC_3 = "  serena       - Web search"
$MSG_MCP_ADDITIONAL_HEADER = "Additional servers (optional):"
$MSG_MCP_ADDITIONAL_DESC_1 = "  fetch        - HTTP requests"
$MSG_MCP_ADDITIONAL_DESC_2 = "  puppeteer    - Browser automation"
$MSG_MCP_NO_SERVERS = "No MCP servers selected"
$MSG_MCP_INSTALLING_COUNT = "Configuring {0} MCP server(s)..."
$MSG_MCP_PROJECT_ASK_EACH = "Add MCP servers to '{0}' project?"
$MSG_MCP_NO_PROJECTS = "No connected projects. You can manually create .mcp.json in your project later."
$MSG_MCP_CREATING_FILE = "Creating {0}..."
$MSG_MCP_FILE_CREATED = ".mcp.json created with {0} server(s)"
$MSG_MCP_INSTALLING_PREFIX = "Adding {0}..."

# Git (Phase 2)
$MSG_GIT_TITLE = "Git + SSH (Version Control)"
$MSG_GIT_DESC_1 = "To get the most out of Claude Code, Git is recommended:"
$MSG_GIT_DESC_2 = "  Claude can track code changes (git status, git diff)"
$MSG_GIT_DESC_3 = "  Auto-generate commits (AI writes commit messages)"
$MSG_GIT_DESC_4 = "  GitHub integration (create PRs, manage issues)"
$MSG_GIT_DESC_5 = "  Version control and collaboration"
$MSG_GIT_DESC_NOTE = "Claude Code works without Git, but version control features require it."
$MSG_GIT_INSTALL_ASK = "Install Git?"
$MSG_GIT_CONFIG_ASK = "Configure Git user info? (name & email)"
$MSG_GIT_NAME = "Your name: "
$MSG_GIT_EMAIL = "Your email: "
$MSG_GIT_CONFIG_DONE = "Git configured"

# Phase 1 → 2 Transition
$MSG_PHASE1_COMPLETE = "Phase 1 Complete!"
$MSG_PHASE2_NEXT = "Next: Phase 2 - Claude Code Setup (optional)"
$MSG_PHASE2_DESC_1 = "  Workspace management (central config)"
$MSG_PHASE2_DESC_2 = "  Shared agents (workspace-manager, translate, doc-writer)"
$MSG_PHASE2_DESC_3 = "  MCP servers (document search)"
$MSG_PHASE2_DESC_4 = "  Git + GitHub (recommended for Claude features)"
$MSG_PHASE2_ASK = "Continue to Phase 2 now?"
$MSG_PHASE2_RESTART_WARN = "Terminal restart required for Phase 2"
$MSG_PHASE2_RESTART_REASON = "(to load updated PATH and environment)"
$MSG_PHASE2_OPEN_TERM_ASK = "Open new PowerShell and start Phase 2?"
$MSG_PHASE2_OPENING = "Opening new PowerShell..."
$MSG_PHASE2_OPENED = "New PowerShell opened with Phase 2 setup"
$MSG_PHASE2_CLOSE_INFO = "You can close this window after Phase 2 starts"
$MSG_PHASE2_MANUAL = "Run Phase 2 later in a new PowerShell:"
$MSG_PHASE2_MANUAL_LATER = "You can run Phase 2 anytime:"

# Completion
$MSG_COMPLETE = "Claude Code setup is complete!"
$MSG_USAGE = "Usage: Type 'claude' in your project folder"
$MSG_INFO_WORKSPACE = "Workspace:"
$MSG_INFO_AGENTS = "Shared agents: workspace-manager, translate, doc-writer"
$MSG_INFO_LANGUAGE = "Language:"
$MSG_INFO_CONFIG = "Config:"
$MSG_TIP_ADD_PROJECT = "To add projects later, tell Claude Code:"
$MSG_TIP_ADD_CMD = "'Connect a new project' → workspace-manager handles it"

# Next Steps
$MSG_NEXT_STEPS = "Next Steps:"
$MSG_STEP_1_TITLE = "1. Log in to Claude Code"
$MSG_STEP_1_DESC = "In your project folder: claude"
$MSG_STEP_1_NOTE = "-> Browser will open for login/signup"
$MSG_STEP_2_TITLE = "2. Initialize project"
$MSG_STEP_2_DESC = "cd ~\my-project; claude init"
$MSG_STEP_3_TITLE = "3. Start Claude Code"
$MSG_STEP_3_DESC = "claude"
$MSG_STEP_3_NOTE = "-> AI coding assistant starts!"
$MSG_DOCS_AVAILABLE = "Detailed docs: ~\claude-workspace\doc\"

# ============================
# Parent setup script messages
# ============================

# Welcome
$MSG_SETUP_WELCOME_WIN = "Starting Windows development environment setup!"
$MSG_SETUP_EACH_STEP = "Each step will ask whether to install."

# Steps
$MSG_STEP_WINGET = "winget (package manager)"
$MSG_STEP_GIT = "Git"
$MSG_STEP_PACKAGES_WIN = "Install packages (Node.js, GitHub CLI, ripgrep)"
$MSG_NODE_REQUIRED = "Node.js is required for AI coding tools (Claude Code, Gemini CLI)."
$MSG_NODE_MANUAL_INSTALL = "Please install Node.js manually:"
$MSG_NODE_VERIFY = "Then verify the installation:"
$MSG_STEP_D2CODING = "D2Coding developer font"
$MSG_STEP_SSH = "SSH key (for GitHub)"
$MSG_STEP_WINTERMINAL = "Windows Terminal theme"
$MSG_STEP_OHMYPOSH = "Oh My Posh (PowerShell theme)"
$MSG_STEP_CLAUDE = "Claude Code"
$MSG_STEP_AI_TOOLS = "AI Coding Tools"
$MSG_AI_TOOLS_HINT = "Enter numbers separated by commas (e.g., 1,2)"

# winget
$MSG_WINGET_NOT_INSTALLED = "winget is not installed."
$MSG_WINGET_STORE = "→ Install 'App Installer' from the Microsoft Store."
$MSG_WINGET_UPDATE = "→ Or update to Windows 10 version 1709 or later."
$MSG_WINGET_ENTER = "Press Enter after installation..."

# SSH
$MSG_SSH_EXISTS = "SSH key already exists."
$MSG_SSH_REGISTER = "Register existing key to GitHub?"
$MSG_SSH_COPIED = "SSH public key copied to clipboard!"
$MSG_SSH_GITHUB_URL = "→ Go to https://github.com/settings/keys and click 'New SSH key' to paste"
$MSG_SSH_ENTER = "Press Enter after registration..."
$MSG_SSH_GENERATE = "Generate SSH key?"
$MSG_SSH_EMAIL = "Enter your GitHub email: "

# Windows Terminal
$MSG_WINTERMINAL_NOT_INSTALLED = "Windows Terminal is not installed."
$MSG_WINTERMINAL_INSTALL = "Install Windows Terminal?"
$MSG_WINTERMINAL_APPLY = "Apply 'Dev' theme to Windows Terminal?"
$MSG_WINTERMINAL_BACKUP = "Existing settings backed up:"
$MSG_WINTERMINAL_DONE = "Dev theme + D2Coding font applied"
$MSG_WINTERMINAL_RESTORE = "To restore original settings:"
$MSG_WINTERMINAL_VERIFY_HEADER = "Verify Terminal Theme"
$MSG_WINTERMINAL_VERIFY_DESC = "Restart Windows Terminal and check if Dev theme is applied"
$MSG_WINTERMINAL_MANUAL_SETUP = "If theme is not applied, follow manual setup:"
$MSG_WINTERMINAL_MANUAL = "Settings(Ctrl+,) → Color schemes → Verify Dev exists → Profiles → Defaults → Appearance → Color scheme: Dev"

# Oh My Posh
$MSG_OHMYPOSH_INSTALL = "Install Oh My Posh?"
$MSG_OHMYPOSH_PROFILE = "Installed. Add the following to your PowerShell profile:"

# D2Coding
$MSG_D2CODING_MANUAL = "winget install failed. Manual installation may be needed."
$MSG_D2CODING_MANUAL_URL = "→ https://github.com/naver/d2codingfont/releases"

# Claude Code (parent)
$MSG_CLAUDE_INSTALL = "Install Claude Code?"
$MSG_CLAUDE_UPDATE_ASK = "Update Claude Code?"
$MSG_CLAUDE_EXTRA = "Claude Code additional setup (MCP, RAG, etc.) can be run later:"

# Completion (parent)
$MSG_SETUP_COMPLETE = "Installation complete!"
$MSG_OPEN_NEW_TERMINAL = "Open a new terminal window to verify."
$MSG_CLAUDE_EXTRA_SETUP = "Claude Code additional setup:"
$MSG_EXISTING_FOLDER = "Existing ai-dev-setup folder found. Updating."

# Install script
$MSG_DOWNLOADING = "Downloading ai-dev-setup..."
$MSG_DOWNLOAD_DONE = "Download complete"
$MSG_EXTRACT_DONE = "Extraction complete"
$MSG_INSTALL_LOCATION = "Install location:"
$MSG_STARTING_SETUP = "Starting setup..."
