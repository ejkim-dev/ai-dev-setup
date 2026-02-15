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

7 interactive steps to set up terminal, shell, and essential packages:
- Package manager (Homebrew/winget)
- Node.js, ripgrep, fonts
- Terminal themes & shell customization
- tmux (macOS)

**[→ Phase 1 Details](docs/en/PHASE1.md)**

### Phase 2: Claude Code Setup (Optional)

4 steps to set up Claude Code workspace:
- Global agents (workspace-manager, translate, doc-writer)
- MCP servers (local-rag, filesystem, serena, etc.)
- Obsidian integration
- Git + GitHub setup

**[→ Phase 2 Details](docs/en/PHASE2.md)**

---

## 🚀 Quick Start

### macOS

```bash
curl -fsSL https://raw.githubusercontent.com/ejkim-dev/ai-dev-setup/main/install.sh | bash
```

### Windows

```powershell
irm https://raw.githubusercontent.com/ejkim-dev/ai-dev-setup/main/install.ps1 | iex
```

Interactive setup with arrow-key menus. Supports English, Korean, and Japanese.

---

## 🗂️ What You Get

After Phase 2, you'll have a complete Claude Code workspace:

```
~/claude-workspace/
├── global/agents/          # Available in all projects
├── projects/               # Per-project settings
└── templates/              # CLAUDE.md, .mcp.json examples
```

**[→ Workspace Guide](docs/en/WORKSPACE.md)**

---

## 📚 Documentation

- **[Phase 1 Details](docs/en/PHASE1.md)** - Basic environment setup
- **[Phase 2 Details](docs/en/PHASE2.md)** - Claude Code setup
- **[Workspace Guide](docs/en/WORKSPACE.md)** - Workspace structure and usage
- **[Troubleshooting](docs/en/TROUBLESHOOTING.md)** - Common issues and fixes
- **[FAQ](docs/en/FAQ.md)** - Frequently asked questions
- **[Uninstall Guide](docs/en/UNINSTALL.md)** - Removal instructions

---

## 🧹 Cleanup

Remove Phase 1 installation:

```bash
curl -fsSL https://raw.githubusercontent.com/ejkim-dev/ai-dev-setup/main/uninstall.sh -o /tmp/cleanup.sh

bash /tmp/cleanup.sh
```

**[→ Complete uninstall guide](docs/en/UNINSTALL.md)**

---

## 🆘 Getting Help

- **[Troubleshooting](docs/en/TROUBLESHOOTING.md)** - Common issues and fixes
- **[FAQ](docs/en/FAQ.md)** - Frequently asked questions
- **[GitHub Issues](https://github.com/ejkim-dev/ai-dev-setup/issues)** - Report bugs or request features

---

## 📄 License

[MIT](LICENSE)
