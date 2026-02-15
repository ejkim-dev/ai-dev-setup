# ai-dev-setup

**[English]** | [한국어](README.ko.md)

Set up a complete development environment in one step. Supports macOS and Windows.

Includes optional [Claude Code](https://claude.ai/code) setup with workspace management, MCP servers, and global agents.

---

## 📋 Who Is This For?

- **Terminal beginners**: New to commands but want an AI-powered terminal environment
- **AI tool users**: Want Claude Code, Gemini CLI, and other AI tools in the terminal
- **Quick setup**: Set up a complete dev environment on a new Mac/Windows without complex configuration
- **Consistent environment**: Maintain the same terminal setup across multiple computers

---

## 🎯 What This Does

### Phase 1: Basic Development Environment

**7 Steps** (all optional except required tools):

1. **Language selection** (en/ko/ja)
2. **Xcode Command Line Tools** (macOS only)
3. **Package Manager** - Homebrew (macOS) or winget (Windows)
4. **Essential Packages** (multi-select with arrow keys)
   - Node.js (required for AI tools)
   - ripgrep (fast code search)
   - D2Coding font (Korean coding font)
   - zsh-autosuggestions (command auto-completion)
   - zsh-syntax-highlighting (syntax highlighting)
5. **Terminal themes**
   - Terminal.app + iTerm2 (macOS)
   - Windows Terminal (Windows)
6. **Shell customization** (multi-select)
   - agnoster theme + random emoji
   - zsh plugin configurations (auto-linked from step 4)
   - Useful aliases (optional)
7. **tmux** (macOS terminal multiplexer)

**UI**: Arrow-key navigation with `select_menu` - no typing required!

**Features**:
- Auto-detect already installed tools
- Auto-link: Plugins installed in step 4 are auto-selected in step 6
- Disabled options: Can't configure plugins that aren't installed

### Phase 2: Claude Code Setup (Optional)

**Prerequisites** (auto-checked):
- **Node.js** verification (from Phase 1)
- **Claude Code CLI** installation

**4 Steps**:

1. **[1/4] claude-workspace** structure creation
   - Create ~/claude-workspace/ structure
   - Install **Global Agents** (all 3 installed automatically)
     - workspace-manager - Project management
     - translate - Multi-language translation
     - doc-writer - Documentation generation
   - Copy templates (CLAUDE.md, .mcp.json examples)
   - Symlink ~/.claude/agents/
   - Optional: Connect existing projects

2. **[2/4] MCP Servers** (multi-select, 5 total)
   - local-rag (recommended) - Document/code search
   - filesystem (recommended) - File read/write
   - serena (recommended) - Web search
   - fetch - HTTP requests
   - puppeteer - Browser automation

3. **[3/4] Obsidian** (optional note-taking app)

4. **[4/4] Git + GitHub** (optional but recommended)
   - Git installation
   - Git configuration (name/email)
   - SSH key generation
   - GitHub authentication

**All prompts use arrow-key menus** - consistent UI throughout!

---

## 🚀 Quick Start (One Line)

No Git required. Just copy and paste.

### macOS

Open Terminal:
```bash
curl -fsSL https://raw.githubusercontent.com/ejkim-dev/ai-dev-setup/main/install.sh | bash
```

### Windows

Open PowerShell as Administrator:
```powershell
irm https://raw.githubusercontent.com/ejkim-dev/ai-dev-setup/main/install.ps1 | iex
```

The script downloads, extracts, and starts an interactive setup. Each step uses arrow-key menus - choose what you need.

**Supports**: English, Korean, and Japanese (selected at startup)

---

## 📚 Documentation

### Quick Links

- **[Phase 1 Details](docs/en/PHASE1.md)** - Basic environment setup guide
- **[Phase 2 Details](docs/en/PHASE2.md)** - Claude Code setup guide
- **[Workspace Guide](docs/en/WORKSPACE.md)** - Workspace structure and usage
- **[Troubleshooting](docs/en/TROUBLESHOOTING.md)** - Common issues and solutions
- **[FAQ](docs/en/FAQ.md)** - Frequently asked questions

### 한국어 문서

- **[Phase 1 상세](docs/ko/PHASE1.md)** - 기본 환경 설정 가이드
- **[Phase 2 상세](docs/ko/PHASE2.md)** - Claude Code 설정 가이드
- **[Workspace 가이드](docs/ko/WORKSPACE.md)** - Workspace 구조 및 사용법
- **[문제 해결](docs/ko/TROUBLESHOOTING.md)** - 일반적인 문제 및 해결책
- **[FAQ](docs/ko/FAQ.md)** - 자주 묻는 질문

---

## 🎨 Key Features

### Arrow-Key Navigation Everywhere

**No more `[Y/n]` prompts!** All menus use arrow keys:

```
  ▸ Install
    Skip
```

Navigate with ↑↓, select with Enter. Simple and consistent.

### Multi-Select Menus

Choose multiple options at once:

```
  ▸ [x] Node.js - JavaScript runtime (required)
    [x] ripgrep - Fast code search
    [x] D2Coding Font - Korean coding font
    [ ] zsh-autosuggestions - Command suggestions

  ↑↓: navigate | Space: toggle | Enter: confirm
```

### Auto-Linking

Smart connections between steps:

**Step 4**: Install `zsh-autosuggestions`
→ **Step 6**: Auto-selects "Command auto-suggestions config"

If you didn't install it in step 4:
→ **Step 6**: Shows "Not installed" and disables the option

No manual configuration needed!

---

## 💡 Why Git in Phase 2?

Git is **recommended** (not required) for Claude Code version control features:

**With Git**, Claude Code can:
- ✅ Track code changes (`git status`, `git diff`)
- ✅ Auto-generate commits with AI-written messages
- ✅ Create pull requests (`gh pr create`)
- ✅ Manage branches and collaborate

**Without Git**, Claude Code still works but you'll miss version control integration.

Phase 1 doesn't require Git. Phase 2 installs it automatically if needed.

---

## 🗂️ Claude Workspace Structure

After Phase 2:

```
~/claude-workspace/
├── global/
│   └── agents/              # Available in all projects
│       ├── workspace-manager.md
│       ├── translate.md
│       └── doc-writer.md
├── projects/                # Per-project settings
│   └── my-app/
│       ├── .claude/
│       ├── CLAUDE.md
│       └── CLAUDE.local.md
└── templates/               # MCP, CLAUDE.md templates
```

The `workspace-manager` agent handles symlinks, `.gitignore`, and configuration automatically.

**Learn more**: [Workspace Guide](docs/en/WORKSPACE.md)

---

## 🧹 Cleanup & Reinstall

Remove Phase 1 installation and start over:

### macOS
```bash
curl -fsSL https://raw.githubusercontent.com/ejkim-dev/ai-dev-setup/main/cleanup-phase1.sh | bash
```

**What gets removed**:
- Oh My Zsh (`~/.oh-my-zsh/`)
- Installed packages (Node.js, ripgrep, etc.)
- Shell configuration (`~/.zshrc`)
- tmux configuration (`~/.tmux.conf`)
- Terminal.app Dev profile
- Phase 2 files (`~/claude-code-setup/`)

**What is NOT removed** (may be used by other apps):
- Homebrew
- Xcode Command Line Tools
- D2Coding font

Each step asks for confirmation with an interactive menu.

---

## 🌐 Language Support

Select your language at startup:
- 🇺🇸 English
- 🇰🇷 한국어 (Korean)
- 🇯🇵 日本語 (Japanese)

All menus, messages, and documentation follow your choice.

Change language anytime:
```bash
rm ~/.dev-setup-lang
./setup.sh  # Prompts for language again
```

---

## 🛠️ Customization

### Add a Language

Create `locale/<code>.sh` (and `.ps1` for Windows) with translated `MSG_*` variables.

See `locale/en.sh` as reference.

### Add a Global Agent

Drop a `.md` file in `claude-code/agents/`. It will be installed to `~/claude-workspace/global/agents/` and available in all projects.

### Add an MCP Template

Add a JSON file in `claude-code/templates/` with `__PLACEHOLDER__` variables that get substituted during setup.

---

## 📖 How It Works

```
install.sh/install.ps1
  ↓ Downloads ZIP and extracts to ~/ai-dev-setup/

setup.sh/setup.ps1 (Phase 1)
  ↓ Language selection (English/한국어/日本語)
  ↓ Saves language to ~/.dev-setup-lang
  ↓ Installs tools → configures terminal/shell
  ↓ Copies claude-code/ → ~/claude-code-setup/
  ↓ Deletes ~/ai-dev-setup/ (cleanup)
  ✅ Phase 1 Complete!

  ↓ "Continue to Phase 2 now?" (in selected language)
  ├─ Yes → Opens new terminal with Phase 2
  └─ No → Can run anytime: ~/claude-code-setup/setup-claude.sh

~/claude-code-setup/setup-claude.sh (Phase 2, optional)
  ↓ Loads language from ~/.dev-setup-lang
  ↓ Git setup → workspace → agents → MCP servers
  ↓ Saves config to ~/claude-workspace/config.json
  ✅ Done!
```

---

## 🆘 Getting Help

- **[Troubleshooting Guide](docs/en/TROUBLESHOOTING.md)** - Common issues and fixes
- **[FAQ](docs/en/FAQ.md)** - Frequently asked questions
- **[GitHub Issues](https://github.com/ejkim-dev/ai-dev-setup/issues)** - Report bugs or request features

---

## 📄 License

[MIT](LICENSE)

---

## 🔗 Links

- **Documentation**: [docs/en/](docs/en/) | [docs/ko/](docs/ko/)
- **Repository**: [github.com/ejkim-dev/ai-dev-setup](https://github.com/ejkim-dev/ai-dev-setup)
- **Claude Code**: [claude.ai/code](https://claude.ai/code)
