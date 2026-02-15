# Phase 2: Claude Code Setup

Set up Claude Code CLI, workspace management, global agents, and MCP servers.

## Overview

**Goal**: Install and configure Claude Code with centralized workspace management

**Prerequisites**: Phase 1 completed (or basic dev environment already set up)

**Target Users**:
- Claude Code users
- AI-assisted development workflow
- Centralized project configuration

**Time Required**: 10-20 minutes

---

## What Gets Installed

| Component | Description | macOS | Windows |
|-----------|-------------|:-----:|:-------:|
| **Git** | Version control system | ✅ | ✅ |
| **GitHub CLI** | GitHub command-line tool | ✅ | ✅ |
| **SSH Key** | GitHub authentication | ✅ | ✅ |
| **Node.js** | Verification (installed in Phase 1) | ✅ | ✅ |
| **Claude Code CLI** | Anthropic's AI coding assistant | ✅ | ✅ |
| **claude-workspace** | Central configuration structure | ✅ | ✅ |
| **Global Agents** | Reusable agents (multi-select) | ✅ | ✅ |
| **MCP Servers** | 5 servers (multi-select) | ✅ | ✅ |
| **Obsidian** | Note-taking app (optional) | ✅ | ✅ |

---

## Installation Steps

### Step 0: Language Selection

Loads language preference from `~/.dev-setup-lang` (saved in Phase 1).

If not found, prompts for language selection.

---

### Step 1: Git Installation

**Auto-detection**: If Git is already installed, skips this step

```
[1/8] Git

  ✅ Already installed: git version 2.39.0
```

**If not installed**:
- macOS: Installs via Homebrew (`brew install git`)
- Windows: Installs via winget

---

### Step 2: GitHub CLI Installation

**Auto-detection**: If GitHub CLI is already installed, skips this step

```
[2/8] GitHub CLI

  ⏭️ Already installed: gh version 2.40.0
```

**If not installed**:
- Installs `gh` via package manager
- Prompts for authentication:

```
GitHub CLI requires authentication.

  ▸ Authenticate now
    Skip (can authenticate later)
```

**Authentication process**:
1. Opens browser for OAuth login
2. Or provides code for manual authentication
3. Verifies authentication succeeded

**Why authenticate?**
- Create pull requests from Claude Code
- Manage issues and repositories
- Push code with proper credentials

---

### Step 3: Node.js Verification

**Auto-detection**: Verifies Node.js from Phase 1

```
[3/8] Node.js

  ✅ Already installed: v20.10.0
```

**If not found**:
- Offers to install via package manager
- Required for Claude Code CLI and MCP servers

---

### Step 4: Claude Code CLI Installation

**Auto-detection**: Checks if Claude Code is already installed

```
[4/8] Claude Code CLI

  ⏭️ Already installed: claude version 1.2.3
```

**If not installed**:
```
[4/8] Claude Code CLI

  Installing Claude Code...
  ✅ Claude Code installed
```

**Installation**: `npm install -g @anthropic-ai/claude-code`

**First-time setup** (if no API key configured):
```
Claude Code needs initial setup.

Run setup now?

  ▸ Yes, run setup
    No, skip (run manually later)
```

If "Yes": Runs `claude init` (prompts for API key in Claude's own interface)

---

### Step 5: claude-workspace Structure

Creates centralized workspace for managing Claude Code resources.

**Directory structure**:
```
~/claude-workspace/
├── global/
│   └── agents/           # Global agents (all projects)
├── projects/             # Per-project settings
└── templates/            # MCP, CLAUDE.md templates
```

**What it does**:
1. Creates directory structure
2. Generates README.md with usage instructions
3. Skips if workspace already exists (preserves existing config)

**Benefits**:
- **Centralized management**: One place for all global resources
- **Reusable agents**: Available across all projects
- **Template library**: Quick project initialization
- **Backup location**: Project-specific configs

---

### Step 6: Global Agents Installation

**Multi-select menu** for choosing agents:

```
[6/8] Global Agents

  Select agents to install:

  ▸ [x] workspace-manager - Project structure management (recommended)
    [x] translate - Multi-language translation (recommended)
    [x] doc-writer - Documentation generation (recommended)

  ↑↓: navigate | Space: toggle | Enter: confirm
```

**Default selection**: All 3 agents are recommended and pre-selected

**Agent descriptions**:

#### workspace-manager (recommended)
**What it does**:
- Connect/disconnect projects to workspace
- Manage symlinks automatically
- Set up .gitignore entries
- Check workspace status

**Use cases**:
- Initialize new project structure
- Link existing project to workspace
- Sync CLAUDE.md across projects

#### translate (recommended)
**What it does**:
- Translate documents between languages (en/ko/ja)
- Preserve markdown formatting
- Preserve code blocks
- Batch translation

**Use cases**:
- Translate README files
- Localize documentation
- Create multi-language guides

#### doc-writer (recommended)
**What it does**:
- Generate README from code
- Create CLAUDE.md for projects
- Write API documentation
- Generate architecture docs

**Use cases**:
- Bootstrap project documentation
- Update docs after code changes
- Standardize documentation format

**Installation**: Copies selected agents to `~/claude-workspace/global/agents/`

**Usage in projects**: Reference in CLAUDE.md:
```markdown
# Available Global Agents
- workspace-manager
- translate
- doc-writer
```

---

### Step 7: MCP Servers Installation

**Multi-select menu** for choosing MCP servers (5 total):

```
[7/8] MCP Servers

  Select servers to install:

  ▸ [x] local-rag - Search docs/code (recommended)
    [x] filesystem - Read/write files (recommended)
    [x] serena - Web search (recommended)
    [ ] fetch - HTTP requests
    [ ] puppeteer - Browser automation

  ↑↓: navigate | Space: toggle | Enter: confirm
```

**Default selection**: First 3 servers (local-rag, filesystem, serena)

**MCP Server descriptions**:

#### local-rag (recommended)
**What it does**:
- Index and search local documents
- RAG (Retrieval-Augmented Generation)
- Search PDFs, markdown, code files

**Use cases**:
- "Find all references to authentication in docs"
- "Search my notes about API design"
- Project-specific knowledge base

**Configuration**:
```json
{
  "command": "local-rag-mcp",
  "env": {
    "RAG_INDEX_PATH": "~/.claude/rag-index"
  }
}
```

#### filesystem (recommended)
**What it does**:
- Safe file read/write operations
- Directory traversal
- File system queries

**Use cases**:
- "Read the config file"
- "Create a new component file"
- "List all test files"

**Configuration**:
```json
{
  "command": "filesystem-mcp",
  "args": ["--root", "~/"]
}
```

#### serena (recommended)
**What it does**:
- Web search capability
- Real-time information
- API documentation lookup

**Use cases**:
- "Search for latest React best practices"
- "Find documentation for this library"
- "What's the current syntax for X?"

**Configuration**:
```json
{
  "command": "serena-mcp"
}
```

#### fetch
**What it does**:
- HTTP requests (GET, POST, etc.)
- REST API calls
- Web data retrieval

**Use cases**:
- "Fetch data from this API"
- "Test this REST endpoint"
- "Download this JSON file"

**Configuration**:
```json
{
  "command": "fetch-mcp"
}
```

#### puppeteer
**What it does**:
- Browser automation
- Screenshot capture
- Web scraping

**Use cases**:
- "Take a screenshot of this page"
- "Scrape data from this website"
- "Test UI interactions"

**Configuration**:
```json
{
  "command": "puppeteer-mcp",
  "args": ["--headless"]
}
```

**Installation process**:
1. Installs selected servers via npm: `npm install -g <server-package>`
2. Generates `.mcp.json` configuration file
3. Saves to `~/.claude/.mcp.json`

**Generated .mcp.json example** (if all 3 recommended selected):
```json
{
  "mcpServers": {
    "local-rag": {
      "command": "local-rag-mcp",
      "args": [],
      "env": {
        "RAG_INDEX_PATH": "~/.claude/rag-index"
      }
    },
    "filesystem": {
      "command": "filesystem-mcp",
      "args": ["--root", "~/"],
      "env": {}
    },
    "serena": {
      "command": "serena-mcp",
      "args": [],
      "env": {}
    }
  }
}
```

---

### Step 8: Obsidian Installation (Optional)

Markdown-based note-taking app with Claude Code integration.

```
[8/8] Obsidian

  A markdown-based note-taking and documentation app.
  Your documents can be searched by Claude Code via local-rag.

  Install Obsidian?

  ▸ Yes
    No
```

**If "Yes"**:
- macOS: `brew install --cask obsidian`
- Windows: `winget install Obsidian.Obsidian`

**Integration with local-rag**:
1. Create vault in `~/claude-workspace/vault/`
2. Write notes in markdown
3. Index vault with local-rag MCP server
4. Search notes from Claude Code

**Use cases**:
- Project documentation
- Meeting notes
- Technical knowledge base
- Learning notes

---

## Completion Summary

After Phase 2 completes, you'll see:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✨ Phase 2 Complete!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Next steps:

  1. Initialize Claude Code (if not done):
     claude init

  2. Create project structure:
     mkdir -p .claude/{agents,mcp,tools,notes}
     touch CLAUDE.md CLAUDE.local.md

  3. Check installed agents:
     ls ~/claude-workspace/global/agents/

  4. Verify MCP servers:
     cat ~/.claude/.mcp.json

  5. Start coding with Claude:
     claude chat

Happy coding with Claude! 🚀
```

---

## Workspace Structure

See [WORKSPACE.md](WORKSPACE.md) for detailed workspace organization and usage.

---

## UI/UX Patterns

### Arrow-Key Navigation
Same as Phase 1 - all menus use arrow keys:
- ↑↓ - Navigate
- Space - Toggle (multi-select)
- Enter - Confirm

### Multi-Select Menus
Visual indicators:
- `[x]` - Selected
- `[ ]` - Not selected
- `(recommended)` - Suggested options

### Status Messages
- ✅ `Done` - Success
- ⏭️ `Skipped` - Already installed or user skipped
- ❌ `Failed` - Error with recovery instructions

---

## Error Handling

### npm Install Failed

```
❌ MCP server installation failed

Troubleshooting:
  1. Check network connection
  2. Verify npm is working: npm --version
  3. Try manual install: npm install -g <package>

Continue anyway?

  ▸ Yes, continue
    No, exit
```

### GitHub Authentication Failed

```
⚠️ GitHub authentication failed

You can authenticate later:
  gh auth login

Continue without authentication?

  ▸ Yes
    No
```

### API Key Not Configured

```
Claude Code needs an API key.

Get your key at: https://console.anthropic.com/

Run setup now?

  ▸ Yes, run setup
    No, skip (configure later)
```

---

## Configuration Files

### ~/.claude/.mcp.json
MCP server configuration:
```json
{
  "mcpServers": {
    "local-rag": { ... },
    "filesystem": { ... },
    "serena": { ... }
  }
}
```

### ~/claude-workspace/
Central workspace structure:
```
claude-workspace/
├── global/agents/        # Global agents
│   ├── workspace-manager.md
│   ├── translate.md
│   └── doc-writer.md
├── projects/             # Project backups
└── templates/            # Templates
```

### ~/.dev-setup-lang
Language preference (saved from Phase 1):
```
en
```

---

## Troubleshooting

See [TROUBLESHOOTING.md](TROUBLESHOOTING.md) for common issues and solutions.

## FAQ

See [FAQ.md](FAQ.md) for frequently asked questions.

## Workspace Guide

See [WORKSPACE.md](WORKSPACE.md) for detailed workspace usage.
