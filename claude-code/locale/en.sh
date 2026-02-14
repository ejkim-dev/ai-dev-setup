#!/bin/bash
# English locale

# Prerequisites
MSG_CLAUDE_NOT_INSTALLED="Claude Code is not installed."
MSG_INSTALL_NOW="Install now?"
MSG_CLAUDE_REQUIRED="Claude Code is required. Please install first:"
MSG_CLAUDE_INSTALL_CMD="  npm install -g @anthropic-ai/claude-code"
MSG_NODE_NOT_INSTALLED="Node.js is not installed. Required for MCP servers."
MSG_NODE_INSTALL_ASK="Install Node.js with Homebrew?"
MSG_NPM_NOT_FOUND="npm not found. Please install Node.js first."
MSG_BREW_NOT_FOUND_OBSIDIAN="Homebrew not found. Install Obsidian from: https://obsidian.md/"

# Common
MSG_DONE="Done"
MSG_SKIP="Skipped"
MSG_LANG_SET="Language:"
MSG_ALREADY_INSTALLED="Already installed."
MSG_INSTALLING="Installing..."
MSG_UPDATING="Updating..."
MSG_APPLIED="Applied"

# Workspace
MSG_WS_TITLE="claude-workspace Setup"
MSG_WS_DESC_1="Manage all Claude Code settings in one place."
MSG_WS_DESC_2="Centrally manage agents, CLAUDE.md, and project settings,"
MSG_WS_DESC_3="then link them to each project via symlinks."
MSG_WS_TREE_AGENTS="Global agents (available in all projects)"
MSG_WS_TREE_PROJECTS="Per-project settings"
MSG_WS_TREE_TEMPLATES="MCP, CLAUDE.md templates"
MSG_WS_ASK="Set up claude-workspace?"
MSG_WS_AGENTS_DONE="Global agents installed: workspace-manager, translate, doc-writer"
MSG_WS_TEMPLATES_DONE="Templates copied"
MSG_WS_SYMLINK_EXISTS="~/.claude/agents/ symlink already exists."
MSG_WS_FOLDER_EXISTS="~/.claude/agents/ folder already exists."
MSG_WS_BACKUP_ASK="Back up existing folder and replace with symlink?"
MSG_WS_BACKUP_DONE="Existing folder backed up: ~/.claude/agents.backup"
MSG_WS_SYMLINK_DONE="Symlink created: ~/.claude/agents/ → claude-workspace"
MSG_WS_SYMLINK_NEED_ADMIN="Creating symlinks on Windows requires Developer Mode or admin privileges."
MSG_WS_SYMLINK_ENABLE="Enable Developer Mode: Settings → Update & Security → For developers"
MSG_WS_SYMLINK_SKIP="Skipping symlink. Copy agents folder instead."

# Project
MSG_PROJ_DESC_1="Connect projects to claude-workspace to"
MSG_PROJ_DESC_2="centrally manage CLAUDE.md, agents, and settings."
MSG_PROJ_ASK="Connect a project?"
MSG_PROJ_PATH="Project path (e.g., ~/projects/my-app): "
MSG_PROJ_NOT_FOUND="Path not found:"
MSG_PROJ_EXISTS="already exists. Skipping."
MSG_PROJ_LINK_CLAUDE=".claude/ symlink created"
MSG_PROJ_LINK_CLAUDEMD="CLAUDE.md symlink created"
MSG_PROJ_LINK_LOCALMD="CLAUDE.local.md symlink created"
MSG_PROJ_GITIGNORE=".gitignore updated"
MSG_PROJ_DONE="connected"
MSG_PROJ_NAME_CONFLICT="already exists in workspace. Enter a different name (or leave blank to skip):"

# Obsidian
MSG_OBS_TITLE="Obsidian"
MSG_OBS_DESC_1="A markdown-based note-taking and documentation app."
MSG_OBS_DESC_2="Your documents can be searched by Claude Code via local-rag."
MSG_OBS_ASK="Install Obsidian?"

# MCP
MSG_MCP_TITLE="MCP Servers"
MSG_MCP_DESC_1="By default, Claude Code can only read/write files and use the terminal."
MSG_MCP_DESC_2="MCP servers let Claude directly use external services"
MSG_MCP_DESC_3="like document search and Jira integration."
MSG_MCP_ASK="Set up MCP servers?"

# local-rag
MSG_RAG_TITLE="local-rag (Document Search)"
MSG_RAG_DESC="Search PDFs, markdown, and other documents with Claude."
MSG_RAG_ASK="Set up local-rag?"
MSG_RAG_PATH="Project path (e.g., ~/projects/my-app): "
MSG_MCP_FILE_EXISTS=".mcp.json already exists. Please add manually:"
MSG_MCP_FILE_REF="See template:"
MSG_MCP_FILE_DONE="created"

# Completion
MSG_COMPLETE="Claude Code setup is complete!"
MSG_USAGE="Usage: Type 'claude' in your project folder"
MSG_INFO_WORKSPACE="Workspace:"
MSG_INFO_AGENTS="Global agents: workspace-manager, translate, doc-writer"
MSG_INFO_LANGUAGE="Language:"
MSG_INFO_CONFIG="Config:"
MSG_TIP_ADD_PROJECT="To add projects later, tell Claude Code:"
MSG_TIP_ADD_CMD="'Connect a new project' → workspace-manager handles it"

# ============================
# Parent setup script messages
# ============================

# Welcome
MSG_SETUP_WELCOME_MAC="Starting macOS development environment setup!"
MSG_SETUP_WELCOME_WIN="Starting Windows development environment setup!"
MSG_SETUP_EACH_STEP="Each step will ask whether to install."

# Steps
MSG_STEP_XCODE="Xcode Command Line Tools (includes git)"
MSG_STEP_HOMEBREW="Homebrew"
MSG_STEP_PACKAGES="Install packages (git, node, ripgrep, tmux, font)"
MSG_STEP_PACKAGES_WIN="Install packages (Node.js, GitHub CLI, ripgrep)"
MSG_STEP_D2CODING="D2Coding developer font"
MSG_STEP_FONT_D2CODING_BREW="Installed via Brewfile."
MSG_STEP_SSH="SSH key (for GitHub)"
MSG_STEP_MACOS_SETTINGS="macOS developer settings"
MSG_STEP_TERMINAL="Terminal settings"
MSG_STEP_OHMYZSH="Oh My Zsh"
MSG_STEP_CLAUDE="Claude Code"
MSG_STEP_AI_TOOLS="AI Coding Tools"
MSG_AI_TOOLS_HINT="↑↓ move, Space toggle, Enter confirm"

# Xcode
MSG_XCODE_INSTALLING="Installing... (click 'Install' if a popup appears)"
MSG_XCODE_ENTER="Press Enter after installation completes..."

# SSH
MSG_SSH_EXISTS="SSH key already exists."
MSG_SSH_REGISTER="Register existing key to GitHub?"
MSG_SSH_COPIED="SSH public key copied to clipboard!"
MSG_SSH_GITHUB_URL="→ Go to https://github.com/settings/keys and click 'New SSH key' to paste"
MSG_SSH_ENTER="Press Enter after registration..."
MSG_SSH_GENERATE="Generate SSH key?"
MSG_SSH_EMAIL="Enter your GitHub email: "

# macOS settings
MSG_MACOS_APPLY="Apply macOS developer settings?"
MSG_MACOS_HIDDEN="Show hidden files in Finder"
MSG_MACOS_KEYBOARD="Faster keyboard repeat (key repeat on hold)"
MSG_MACOS_SCREENSHOT="Change screenshot location to ~/Screenshots"

# Terminal
MSG_TERMINAL_OPT1="Terminal.app only (apply dark theme)"
MSG_TERMINAL_OPT2="Install iTerm2"
MSG_TERMINAL_OPT3="Both"
MSG_TERMINAL_OPT4="Skip"
MSG_TERMINAL_APPLIED="Terminal.app 'Dev' profile applied"

# Oh My Zsh
MSG_OHMYZSH_INSTALL="Install Oh My Zsh?"
MSG_ZSHRC_ASK="Add default settings to .zshrc?"
MSG_ZSHRC_DONE=".zshrc settings added"
MSG_TMUX_ASK="Apply tmux settings?"
MSG_TMUX_DONE=".tmux.conf copied"

# Claude Code (parent)
MSG_CLAUDE_INSTALL="Install Claude Code?"
MSG_CLAUDE_UPDATE_ASK="Update Claude Code?"
MSG_CLAUDE_EXTRA="Claude Code additional setup (MCP, RAG, etc.) can be run later:"

# Completion (parent)
MSG_SETUP_COMPLETE="Installation complete!"
MSG_OPEN_NEW_TERMINAL="Open a new terminal window to verify."
MSG_CLAUDE_EXTRA_SETUP="Claude Code additional setup:"

# Windows-specific
MSG_WINGET_NOT_INSTALLED="winget is not installed."
MSG_WINGET_STORE="→ Install 'App Installer' from the Microsoft Store."
MSG_WINGET_UPDATE="→ Or update to Windows 10 version 1709 or later."
MSG_WINGET_ENTER="Press Enter after installation..."
MSG_STEP_WINGET="winget (package manager)"
MSG_STEP_GIT="Git"
MSG_STEP_WINTERMINAL="Windows Terminal theme"
MSG_STEP_OHMYPOSH="Oh My Posh (PowerShell theme)"
MSG_WINTERMINAL_NOT_INSTALLED="Windows Terminal is not installed."
MSG_WINTERMINAL_INSTALL="Install Windows Terminal?"
MSG_WINTERMINAL_APPLY="Apply 'Dev' theme to Windows Terminal?"
MSG_WINTERMINAL_BACKUP="Existing settings backed up:"
MSG_WINTERMINAL_DONE="Dev theme + D2Coding font applied"
MSG_WINTERMINAL_RESTORE="To restore original settings:"
MSG_OHMYPOSH_INSTALL="Install Oh My Posh?"
MSG_OHMYPOSH_PROFILE="Installed. Add the following to your PowerShell profile:"
MSG_D2CODING_MANUAL="winget install failed. Manual installation may be needed."
MSG_D2CODING_MANUAL_URL="→ https://github.com/naver/d2codingfont/releases"
MSG_EXISTING_FOLDER="Existing ai-dev-setup folder found. Updating."

# Install script
MSG_DOWNLOADING="Downloading ai-dev-setup..."
MSG_DOWNLOAD_DONE="Download complete"
MSG_EXTRACT_DONE="Extraction complete"
MSG_INSTALL_LOCATION="Install location:"
MSG_STARTING_SETUP="Starting setup..."
