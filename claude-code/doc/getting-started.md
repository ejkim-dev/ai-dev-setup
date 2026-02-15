# Getting Started with Claude Code

Welcome! This guide will help you start using Claude Code after installation.

## Quick Start

### 1️⃣ Log in to Claude Code

First time running Claude Code requires authentication:

```bash
# Go to any project folder
cd ~/my-project

# Run Claude Code
claude
```

**What happens:**
- Browser opens automatically
- Sign in with your Claude account (or create one)
- Authorize Claude Code CLI
- You're ready!

### 2️⃣ Initialize Your Project

Set up Claude Code for your project:

```bash
cd ~/my-project
claude init
```

**This creates:**
- `.claude/` directory (project settings)
- `CLAUDE.md` (instructions for Claude)
- `CLAUDE.local.md` (your personal notes)

### 3️⃣ Start Coding with AI

```bash
claude
```

Now you can:
- Ask Claude to write code
- Request explanations
- Get debugging help
- Refactor existing code

## Workspace Structure

Your workspace at `~/claude-workspace/` contains:

```
~/claude-workspace/
├── doc/              ← Documentation (you are here!)
├── shared/
│   ├── agents/       ← Shared agents (available in all projects)
│   ├── templates/    ← Project templates
│   └── mcp/          ← Shared MCP servers
├── projects/         ← Connected projects (managed by workspace-manager)
└── config.json       ← Your preferences
```

## Connecting Projects to Workspace

Use the workspace-manager agent to connect projects:

```bash
# In Claude Code
> @workspace-manager connect ~/my-app
```

This creates:
- `~/claude-workspace/projects/my-app/.claude/` (settings)
- Symlinks from your actual project to workspace
- Centralized management

## Next Steps

- Read [Claude Guide](./claude-guide.md) to understand CLAUDE.md, agents, MCP, etc.
- Explore shared agents: workspace-manager, translate, doc-writer
- Configure MCP servers for your projects

## Need Help?

- Documentation: https://docs.claude.ai/code
- Workspace docs: `~/claude-workspace/doc/`
- Ask Claude directly: "How do I...?"
