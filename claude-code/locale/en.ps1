# English locale

# Prerequisites
$MSG_CLAUDE_NOT_INSTALLED = "Claude Code is not installed."
$MSG_INSTALL_NOW = "Install now?"
$MSG_CLAUDE_REQUIRED = "Claude Code is required. Please install first:"
$MSG_CLAUDE_INSTALL_CMD = "  npm install -g @anthropic-ai/claude-code"
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

# Workspace
$MSG_WS_TITLE = "claude-workspace Setup"
$MSG_WS_DESC_1 = "Manage all Claude Code settings in one place."
$MSG_WS_DESC_2 = "Centrally manage agents, CLAUDE.md, and project settings,"
$MSG_WS_DESC_3 = "then link them to each project via symlinks."
$MSG_WS_TREE_AGENTS = "Global agents (available in all projects)"
$MSG_WS_TREE_PROJECTS = "Per-project settings"
$MSG_WS_TREE_TEMPLATES = "MCP, CLAUDE.md templates"
$MSG_WS_ASK = "Set up claude-workspace?"
$MSG_WS_AGENTS_DONE = "Global agents installed: workspace-manager, translate, doc-writer"
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
$MSG_PROJ_PATH = "Project path (e.g., C:\projects\my-app): "
$MSG_PROJ_NOT_FOUND = "Path not found:"
$MSG_PROJ_EXISTS = "already exists. Skipping."
$MSG_PROJ_LINK_CLAUDE = ".claude\ symlink created"
$MSG_PROJ_LINK_CLAUDEMD = "CLAUDE.md symlink created"
$MSG_PROJ_LINK_LOCALMD = "CLAUDE.local.md symlink created"
$MSG_PROJ_GITIGNORE = ".gitignore updated"
$MSG_PROJ_DONE = "connected"
$MSG_PROJ_NAME_CONFLICT = "already exists in workspace. Enter a different name (or leave blank to skip):"

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

# local-rag
$MSG_RAG_TITLE = "local-rag (Document Search)"
$MSG_RAG_DESC = "Search PDFs, markdown, and other documents with Claude."
$MSG_RAG_ASK = "Set up local-rag?"
$MSG_RAG_PATH = "Project path (e.g., C:\projects\my-app): "
$MSG_MCP_FILE_EXISTS = ".mcp.json already exists. Please add manually:"
$MSG_MCP_FILE_REF = "See template:"
$MSG_MCP_FILE_DONE = "created"

# Completion
$MSG_COMPLETE = "Claude Code setup is complete!"
$MSG_USAGE = "Usage: Type 'claude' in your project folder"
$MSG_INFO_WORKSPACE = "Workspace:"
$MSG_INFO_AGENTS = "Global agents: workspace-manager, translate, doc-writer"
$MSG_INFO_LANGUAGE = "Language:"
$MSG_INFO_CONFIG = "Config:"
$MSG_TIP_ADD_PROJECT = "To add projects later, tell Claude Code:"
$MSG_TIP_ADD_CMD = "'Connect a new project' → workspace-manager handles it"

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
