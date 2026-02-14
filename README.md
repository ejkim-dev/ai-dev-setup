# ai-dev-setup

Set up a new development environment in one step. Supports macOS and Windows.

Includes optional [Claude Code](https://claude.ai/code) setup with central workspace management, MCP servers, and global agents.

## Quick Start (one line)

No Git required. Just copy and paste.

**macOS** — Open Terminal:
```bash
curl -fsSL https://raw.githubusercontent.com/ejkim-dev/ai-dev-setup/main/install.sh | bash
```

**Windows** — Open PowerShell as Administrator:
```powershell
irm https://raw.githubusercontent.com/ejkim-dev/ai-dev-setup/main/install.ps1 | iex
```

The script downloads, extracts, and starts an interactive setup. Each step asks Y/n — choose what you need.

Supports **English**, **Korean**, and **Japanese** (selected at startup).

## What It Installs

| Tool | Description | macOS | Windows |
|------|-------------|:-----:|:-------:|
| Package manager | Homebrew / winget | O | O |
| git, gh, node, ripgrep | Essential dev tools | O | O |
| D2Coding | Dev font with Korean support | O | O |
| SSH key | GitHub connection | O | O |
| OS dev settings | Show hidden files, key repeat, etc. | O | - |
| Terminal.app theme | Dark theme profile | O | - |
| Windows Terminal theme | Dark theme + font | - | O |
| iTerm2 | Advanced terminal | O | - |
| Oh My Zsh / Oh My Posh | Shell theme + plugins | O | O |
| tmux | Terminal multiplexer | O | - |
| AI coding tools | Claude Code, Gemini CLI, GitHub Copilot CLI | O | O |

## Claude Code Setup (optional)

After the main setup completes, you can run the Claude Code setup separately:

```bash
# macOS
~/claude-code-setup/setup-claude.sh

# Windows (PowerShell)
~\claude-code-setup\setup-claude.ps1
```

This sets up:

### 1. claude-workspace — Central Management

Manage all Claude Code settings from one place via symlinks.

```
~/claude-workspace/
├── global/agents/    ← Available in every project
│   ├── workspace-manager.md
│   ├── translate.md
│   └── doc-writer.md
├── projects/         ← Per-project CLAUDE.md, agents
│   └── my-app/
│       ├── .claude/
│       ├── CLAUDE.md
│       └── CLAUDE.local.md
└── templates/        ← MCP, CLAUDE.md templates
```

Connect projects and the workspace-manager agent handles symlinks, `.gitignore`, and configuration.

### 2. Global Agents

| Agent | Description |
|-------|-------------|
| **workspace-manager** | Connect/disconnect projects, manage symlinks, set up MCP, check status |
| **translate** | Translate documents between languages, preserving markdown and code blocks |
| **doc-writer** | Generate README, CLAUDE.md, API docs, architecture docs from code |

### 3. MCP Servers

| Server | Description |
|--------|-------------|
| **local-rag** | Search PDFs, markdown, and documents with Claude |

### 4. Obsidian

Optional markdown note-taking app, searchable via local-rag.

## File Structure

```
ai-dev-setup/
├── install.sh / install.ps1        # One-line installer (downloads + runs setup)
├── setup.sh / setup.ps1            # Main setup script (macOS / Windows)
├── Brewfile                        # Homebrew packages (macOS)
├── configs/
│   ├── mac/Dev.terminal            # Terminal.app dark theme
│   ├── windows/windows-terminal.json
│   └── shared/.zshrc, .tmux.conf
└── claude-code/
    ├── setup-claude.sh / .ps1      # Claude Code setup script
    ├── agents/                     # Global agent definitions
    ├── locale/                     # i18n (en, ko, ja)
    ├── templates/                  # MCP config templates
    └── examples/                   # CLAUDE.md, MEMORY.md examples
```

## How It Works

```
install.sh
  ↓ download ZIP + extract
setup.sh
  ↓ language selection → install tools → configure
  ↓ copy claude-code/ → ~/claude-code-setup/
  ↓ delete install directory (including .git if cloned)
  Done!

~/claude-code-setup/setup-claude.sh  (run later, optional)
  ↓ language selection → workspace → agents → MCP → Obsidian
  ↓ save config to ~/claude-workspace/config.json
  Done!
```

## Customization

**Add a language**: Create `claude-code/locale/<code>.sh` (and `.ps1` for Windows) with translated `MSG_*` variables. See `locale/en.sh` as reference.

**Add an agent**: Drop a `.md` file in `claude-code/agents/`. It will be installed to `~/claude-workspace/global/agents/` and available in all projects.

**Add an MCP template**: Add a JSON file in `claude-code/templates/` with `__PLACEHOLDER__` variables that get substituted during setup.

## License

[MIT](LICENSE)
