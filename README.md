# ai-dev-setup

**[English]** | [한국어](README.ko.md)

Set up a new development environment in one step. Supports macOS and Windows.

Includes optional [Claude Code](https://claude.ai/code) setup with central workspace management, MCP servers, and global agents.

## 📋 Who Is This For?

- **Terminal beginners**: New to commands but want to set up an AI-powered terminal development environment
- **AI tool users**: Want to use Claude Code, Gemini CLI, and other AI tools directly in the terminal
- **Quick setup**: Want to set up an AI-powered terminal development environment on a new Mac/Windows without complex configuration
- **Consistent environment**: Want to maintain the same terminal environment across multiple computers

## 🎯 What This Does

### 1️⃣ Basic Installation & Terminal Environment Setup (`setup.sh` / `setup.ps1`)

**Step 1: Xcode Command Line Tools (macOS only)**
- Includes Git, make, gcc, and other development tools
- Essential foundation for macOS development

**Step 2: Package Manager**
- macOS: Homebrew installation (foundation for all subsequent tool installations)
- Windows: winget verification (built-in on Windows 11)

**Step 3: Essential Packages**
- **Node.js**: JavaScript runtime (required for Claude Code and other AI tools)
- **ripgrep**: Fast code search tool
- **tmux** (macOS only): Terminal multiplexer for split panes and session management
- **zsh-autosuggestions**: Command auto-completion suggestions
- **zsh-syntax-highlighting**: Command syntax highlighting

**Step 4: D2Coding Font**
- Coding font with excellent Korean character support
- Readable monospace font

**Step 5: Terminal + Shell Environment**
- **Terminal.app + iTerm2** (macOS):
  - Auto-apply Dev dark theme profile
  - D2Coding font with Korean support
  - Optional iTerm2 installation
- **Windows Terminal** (Windows):
  - Auto-configure dark theme + fonts
- **Oh My Zsh** (macOS):
  - Apply agnoster theme (displays Git branch)
  - Plugins: git, zsh-autosuggestions, zsh-syntax-highlighting
- **Oh My Posh** (Windows):
  - PowerShell prompt theme
- **Auto-apply .zshrc / .tmux.conf** configuration files

**Step 6: AI Coding Tools (multi-select)**
- **Claude Code**: Anthropic's AI coding assistant
- **Gemini CLI**: Google's AI CLI tool
- **Codex CLI**: OpenAI's code generation tool
- **GitHub Copilot CLI**: Only available when GitHub CLI (gh) is installed

**Wrap-up:**
- Copy claude-code setup files to ~/claude-code-setup/
- Choose whether to proceed to Phase 2 (Claude Code setup)

### 2️⃣ Claude Code Setup (Optional, `claude-code/setup-claude.sh` / `setup-claude.ps1`)

**AI development environment:**
- Claude Code CLI installation
- Additional AI CLI tools (Gemini CLI, Codex CLI, etc.)
- MCP server configuration (filesystem, memory, etc.)
- Global agent installation (workspace-manager, translate, doc-writer)

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

### Phase 1: Basic Environment

Essential tools and terminal setup. All steps are optional.

| Tool | Description | macOS | Windows |
|------|-------------|:-----:|:-------:|
| Package manager | Homebrew / winget | ✅ | ✅ |
| Node.js | JavaScript runtime (for Claude Code) | ✅ | ✅ |
| ripgrep | Fast code search tool | ✅ | ✅ |
| D2Coding | Dev font with Korean support | ✅ | ✅ |
| Terminal.app theme | Dark theme profile | ✅ | - |
| Windows Terminal | Dark theme + font config | - | ✅ |
| iTerm2 | Advanced terminal (optional) | ✅ | - |
| Oh My Zsh / Oh My Posh | Shell theme + plugins | ✅ | ✅ |
| tmux | Terminal multiplexer | ✅ | - |
| AI coding tools | Claude Code, Gemini CLI, GitHub Copilot CLI | ✅ | ✅ |

### Phase 2: Claude Code Setup (Optional)

Run separately after Phase 1:

```bash
# macOS
~/claude-code-setup/setup-claude.sh

# Windows (PowerShell)
~\claude-code-setup\setup-claude.ps1
```

This sets up:

| Feature | Description | macOS | Windows |
|---------|-------------|:-----:|:-------:|
| **Git + GitHub CLI** | Version control (recommended for Claude features) | ✅ | ✅ |
| **SSH key** | GitHub authentication | ✅ | ✅ |
| **claude-workspace** | Central management via symlinks | ✅ | ✅ |
| **Global agents** | workspace-manager, translate, doc-writer | ✅ | ✅ |
| **MCP: local-rag** | Document search (PDFs, markdown) | ✅ | ✅ |
| **Obsidian** | Note-taking app (optional) | ✅ | ✅ |

#### Why Git in Phase 2?

Git is **recommended** for Claude Code to use version control features:
- Track code changes (`git status`, `git diff`)
- Auto-generate commits (AI writes commit messages)
- GitHub integration (create PRs, manage issues)
- Collaborate with version control

**Claude Code works without Git**, but you'll miss out on version control features.

## Claude Code Workspace Structure

```
~/claude-workspace/
├── global/agents/    ← Available in every project
│   ├── workspace-manager.md
│   ├── translate.md
│   └── doc-writer.md
├── projects/         ← Per-project settings
│   └── my-app/
│       ├── .claude/
│       ├── CLAUDE.md
│       └── CLAUDE.local.md
└── templates/        ← MCP, CLAUDE.md templates
```

Connect projects and the workspace-manager agent handles symlinks, `.gitignore`, and configuration.

### Global Agents

| Agent | Description |
|-------|-------------|
| **workspace-manager** | Connect/disconnect projects, manage symlinks, set up MCP, check status |
| **translate** | Translate documents between languages, preserving markdown and code blocks |
| **doc-writer** | Generate README, CLAUDE.md, API docs, architecture docs from code |

### MCP Servers

| Server | Description |
|--------|-------------|
| **local-rag** | Search PDFs, markdown, and documents with Claude |

## File Structure

```
ai-dev-setup/
├── install.sh / install.ps1        # One-line installer (downloads + runs setup)
├── setup.sh / setup.ps1            # Phase 1: Basic environment
├── Brewfile                        # Homebrew packages (macOS)
├── configs/
│   ├── mac/Dev.terminal            # Terminal.app dark theme
│   ├── windows/windows-terminal.json
│   └── shared/.zshrc, .tmux.conf
└── claude-code/
    ├── setup-claude.sh / .ps1      # Phase 2: Claude Code setup
    ├── agents/                     # Global agent definitions
    ├── locale/                     # i18n (en, ko, ja)
    ├── templates/                  # MCP config templates
    └── examples/                   # CLAUDE.md, MEMORY.md examples
```

## How It Works

```
install.sh
  ↓ download ZIP + extract
setup.sh (Phase 1)
  ↓ language selection → install tools → configure
  ↓ copy claude-code/ → ~/claude-code-setup/
  ↓ delete install directory (including .git if cloned)
  ✅ Phase 1 Complete!

  ↓ "Continue to Phase 2 now?" [Y/n]
  ├─ Yes → "Open new terminal?" [Y/n]
  │         ├─ Yes → automatically opens new terminal with Phase 2
  │         └─ No → instructions to run manually later
  └─ No → Phase 2 skipped (can run anytime later)

~/claude-code-setup/setup-claude.sh (Phase 2, optional)
  ↓ runs automatically in new terminal (if you chose Yes above)
  ↓ OR run manually anytime: ~/claude-code-setup/setup-claude.sh
  ↓ language selection → Git setup → workspace → agents → MCP → Obsidian
  ↓ save config to ~/claude-workspace/config.json
  Done!
```

## Customization

**Add a language**: Create `claude-code/locale/<code>.sh` (and `.ps1` for Windows) with translated `MSG_*` variables. See `locale/en.sh` as reference.

**Add an agent**: Drop a `.md` file in `claude-code/agents/`. It will be installed to `~/claude-workspace/global/agents/` and available in all projects.

**Add an MCP template**: Add a JSON file in `claude-code/templates/` with `__PLACEHOLDER__` variables that get substituted during setup.

## License

[MIT](LICENSE)
