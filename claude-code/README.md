# Claude Code Setup Guide

## What is Claude Code?

An AI coding assistant that runs in your terminal.
Write code, fix bugs, search files, and more — all through conversation with AI.

```bash
# Install
npm install -g @anthropic-ai/claude-code

# Usage: run in your project folder
cd ~/projects/my-app
claude
```

---

## Quick Setup

### Automated (Recommended)

```bash
./setup-claude.sh
```

This sets up:
- **claude-workspace** — Centralized management for all projects
- **Project connection** — Link projects to workspace via symlinks
- **Shared agents** — Reusable AI assistants (workspace-manager, translate, doc-writer)
- **MCP servers** — Per-project external tool integrations (local-rag, filesystem, etc.)
- **Obsidian** — Markdown note-taking app (optional, integrates with local-rag)
- **Templates** — CLAUDE.md and .mcp.json templates

### Manual

Install Claude Code, then configure manually using the documentation below.

---

## Key Features

### 📁 Claude Workspace
Centralize all Claude configurations in one place using symlinks.
No more scattered `.claude/` folders across projects.

**Learn more:** [`doc/workspace-philosophy.md`](doc/workspace-philosophy.md)

### 🤖 Agents
Specialized AI assistants for specific tasks.
- **workspace-manager** — Manage projects
- **translate** — Translate documents
- **doc-writer** — Generate documentation

**Learn more:** [`doc/claude-guide.md#agents`](doc/claude-guide.md#agents)

### 📝 CLAUDE.md
Project instructions that Claude reads automatically.
Define your architecture, coding rules, and workflows once.

**Learn more:** [`doc/claude-guide.md#claudemd`](doc/claude-guide.md#claudemd)

### 🔌 MCP Servers
Connect Claude to external tools and data sources.
Search documents, browse web, access databases, and more.

**Learn more:** [`doc/claude-guide.md#mcp`](doc/claude-guide.md#mcp-model-context-protocol)

### 💬 Slash Commands
Built-in commands: `/help`, `/agents`, `/model`, `/compact`, `/exit`

**Learn more:** [`doc/claude-guide.md#slash-commands`](doc/claude-guide.md#slash-commands)

---

## Documentation

Reference documentation in `doc/` directory:

| File | Description |
|------|-------------|
| [`getting-started.md`](doc/getting-started.md) / [`.ko.md`](doc/getting-started.ko.md) | Quick start guide |
| [`claude-guide.md`](doc/claude-guide.md) / [`.ko.md`](doc/claude-guide.ko.md) | Complete concepts reference (CLAUDE.md, agents, MCP, etc.) |
| [`workspace-philosophy.md`](doc/workspace-philosophy.md) / [`.ko.md`](doc/workspace-philosophy.ko.md) | Why workspace? Design philosophy |

**Start here:** [`doc/getting-started.md`](doc/getting-started.md)

---

## Next Steps

1. **Run setup:** `./setup-claude.sh`
2. **Read getting-started:** `doc/getting-started.md`
3. **Start coding:** `cd ~/my-project && claude`

---

## Examples

See [examples/](examples/) for sample configurations:
- `CLAUDE.md` — Project instructions template
- `MEMORY.md` — AI memory notebook template
- `.mcp.json` — MCP server configurations
