# Claude Code Setup Guide

## What is Claude Code?

An AI coding tool that runs in your terminal.
You can write code, fix bugs, search files, and more — all through conversation.

```bash
# Install
npm install -g @anthropic-ai/claude-code

# Usage: run in your project folder
cd ~/projects/my-app
claude
```

That's all you need to get started!

---

## Want to get more out of it?

Everything below is **optional**. Set them up whenever you need them.

### CLAUDE.md — "Project instructions for AI"

Create a `CLAUDE.md` file in your project root and Claude will understand your project.

Write build commands, folder structure, coding rules, etc.
Claude will reference it automatically without you having to explain every time.

```
my-app/
├── CLAUDE.md        ← Shared with team (commit to git)
├── CLAUDE.local.md  ← Personal settings (add to .gitignore)
├── src/
└── ...
```

Example: [examples/CLAUDE.md](examples/CLAUDE.md)

### MEMORY.md — "AI's notebook"

Lets Claude remember things across conversations.
Jira project keys, common commands, patterns that caused issues —
save them and Claude will remember in future sessions.

Automatically created under `~/.claude/projects/`.

Example: [examples/MEMORY.md](examples/MEMORY.md)

---

## MCP Servers — "Give AI more tools"

By default, Claude Code can only **read/write files** and **run terminal commands**.

MCP (Model Context Protocol) servers let Claude directly use external services.

### Why use them?

| Without MCP | With MCP |
|-------------|----------|
| "What was that Jira ticket number..." manually search and paste | "Show me ticket PROJ-123" → Claude looks it up directly |
| Copy API docs and paste into chat | "How do I use this API?" → Claude searches the docs |
| Open Confluence page and copy manually | "Summarize the spec doc" → Claude reads it directly |

### How does it work?

Create a `.mcp.json` file in your project root:

```
my-app/
├── .mcp.json   ← MCP server config
├── CLAUDE.md
├── src/
└── ...
```

Claude Code automatically connects to MCP servers when you start it.

---

### local-rag (Document Search) — Recommended!

Search PDFs, markdown, and text files with Claude.

**Examples:**
- Add API docs → "What are the parameters for this API?"
- Add meeting notes → "What was decided in the last meeting?"
- Connect your Obsidian vault → Search all your notes

**Config:**

```json
{
  "mcpServers": {
    "local-rag": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "mcp-local-rag"],
      "env": {
        "BASE_DIR": "/path/to/your/project/.claude-data"
      }
    }
  }
}
```

**Usage (inside Claude Code):**
```
> Index this PDF: /path/to/api-docs.pdf
> How does API authentication work?
```

### Atlassian (Jira / Confluence) — Optional

Useful if your team uses Jira/Confluence.

**Examples:**
- "Show me ticket PROJ-123"
- "List my tickets in the current sprint"
- "Add a Jira comment with this bug fix summary"
- "Create a meeting notes page in Confluence"

**Prerequisites:**
1. [Create an Atlassian API token](https://id.atlassian.com/manage-profile/security/api-tokens)
2. Add config to `.mcp.json`

**Config:**

```json
{
  "mcpServers": {
    "atlassian": {
      "command": "npx",
      "args": ["-y", "mcp-atlassian"],
      "env": {
        "ATLASSIAN_BASE_URL": "https://your-company.atlassian.net",
        "ATLASSIAN_EMAIL": "your-email@company.com",
        "ATLASSIAN_API_TOKEN": "your-api-token"
      }
    }
  }
}
```

---

## Automated Setup

You can configure everything manually, or use the setup script:

```bash
./setup-claude.sh          # Interactive setup, step by step
```

| Option | Description |
|--------|-------------|
| claude-workspace | Central management of agents, CLAUDE.md, project settings |
| Obsidian | Markdown note-taking app + RAG integration |
| MCP servers | local-rag, Atlassian setup |
