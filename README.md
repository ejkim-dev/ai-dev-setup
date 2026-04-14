# ai-dev-setup

**[English]** | [한국어](README.ko.md)

Set up a complete development environment in one step. Supports macOS and Windows.

Includes optional [Claude Code](https://claude.ai/code) setup with workspace management, MCP servers, and shared agents.

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

3 steps to set up Claude Code workspace:
- Shared agents (workspace-manager, translate, doc-writer)
- MCP servers (local-rag, filesystem, serena, etc.)
- Obsidian integration

**[→ Phase 2 Details](docs/en/PHASE2.md)**

### What You Get

After Phase 2, you'll have a complete Claude Code workspace:

```
~/claude-workspace/
├── shared/agents/          # Available in all projects
├── shared/templates/       # CLAUDE.md, .mcp.json examples
├── shared/mcp/             # MCP server configs
├── projects/               # Per-project settings
└── config.json             # User settings
```

**[→ Workspace Guide](docs/en/WORKSPACE.md)** | **[→ Design Philosophy](claude-code/doc/en/workspace-philosophy.md)**

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

> **Security**: The install script automatically fetches the latest release, verifies SHA256 checksum, and aborts if mismatched.

---

## 📚 Documentation

**Phase 1: Basic Environment**
- **[macOS Guide](docs/en/PHASE1-macOS.md)** - Terminal setup on macOS
- **[Windows Guide](docs/en/PHASE1-windows.md)** - Terminal setup on Windows

**Phase 2 & Beyond**
- **[Phase 2 Details](docs/en/PHASE2.md)** - Claude Code setup
- **[Workspace Guide](docs/en/WORKSPACE.md)** - Workspace structure and usage
- **[Troubleshooting](docs/en/TROUBLESHOOTING.md)** - Common issues and fixes
- **[FAQ](docs/en/FAQ.md)** - Frequently asked questions
- **[Uninstall Guide](docs/en/UNINSTALL.md)** - Removal instructions

---

## 🧹 Cleanup

Remove Phase 1 installation:

```bash
curl -fsSL https://raw.githubusercontent.com/ejkim-dev/ai-dev-setup/main/uninstall-tools.sh -o /tmp/cleanup.sh

bash /tmp/cleanup.sh
```

**[→ Complete uninstall guide](docs/en/UNINSTALL.md)**

---

## 🆘 Getting Help

- **[Troubleshooting](docs/en/TROUBLESHOOTING.md)** - Common issues and fixes
- **[FAQ](docs/en/FAQ.md)** - Frequently asked questions
- **[GitHub Issues](https://github.com/ejkim-dev/ai-dev-setup/issues)** - Report bugs or request features

---

## 📝 Blog

- **[The Hardest Part of AI Coding Isn't AI – It's the Setup](https://medium.com/@biz.ejkim/one-line-to-start-building-an-ai-dev-environment-setup-script-with-claude-code-c220e3813696)** - Project motivation, Claude Code workflow, and lessons learned

---

## 📄 License

[MIT](LICENSE)
