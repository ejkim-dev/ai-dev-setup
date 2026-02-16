# Claude Code Guide

This guide explains key Claude Code concepts and files.

## Table of Contents

1. [CLAUDE.md](#claudemd)
2. [CLAUDE.local.md](#claudelocalmd)
3. [.claude/ Directory](#claude-directory)
4. [Task.md](#taskmd)
5. [Agents](#agents)
6. [Slash Commands](#slash-commands)
7. [MCP (Model Context Protocol)](#mcp-model-context-protocol)

---

## CLAUDE.md

**Purpose:** Instructions for Claude about your project.

**Location:** Project root (e.g., `~/my-app/CLAUDE.md`)

**What to include:**
- Project overview and architecture
- Coding conventions and style guide
- Important files and their purposes
- Build/test commands
- Things Claude should know or avoid

**Example:**
```markdown
# My App

## Architecture
- Frontend: React + TypeScript
- Backend: Node.js + Express
- Database: PostgreSQL

## Conventions
- Use functional components
- Add tests for all new features
- Follow ESLint rules

## Important
- Never modify config/secrets.json
- Always run tests before committing
```

**Checked into Git:** ✅ Yes (team-shared)

---

## CLAUDE.local.md

**Purpose:** Personal notes and preferences (not shared with team).

**Location:** Project root (e.g., `~/my-app/CLAUDE.local.md`)

**What to include:**
- Your personal workflow preferences
- Private notes about the codebase
- Language preference for Claude responses
- Local development setup

**Example:**
```markdown
# My Notes

## Language
- Respond in Korean
- Use English for code/technical terms

## My Setup
- Local DB runs on port 5433
- Redis on 6380

## Reminders
- Remember to update schema after migration
```

**Checked into Git:** ❌ No (gitignored, personal only)

---

## .claude/ Directory

**Purpose:** Project-specific Claude Code settings.

**Location:** Project root (e.g., `~/my-app/.claude/`)

**Structure:**
```
.claude/
├── agents/           # Project-specific agents
├── mcp/              # MCP server configs
├── tools/            # Custom tools
└── settings.json     # Project permissions
```

**When using workspace:**
- Actual files: `~/claude-workspace/projects/my-app/.claude/`
- Symlink: `~/my-app/.claude/` → workspace

**Checked into Git:** ❌ No (gitignored)

---

## Task.md

**Purpose:** Break down complex tasks into steps.

**Location:** Project root or `.claude/` directory

**Use case:** When you have a multi-step task, create Task.md to track progress.

**Example:**
```markdown
# Implement User Authentication

## Tasks
- [ ] Create User model
- [ ] Add password hashing
- [ ] Create login endpoint
- [ ] Add JWT token generation
- [ ] Create middleware for auth
- [ ] Add tests
```

**How Claude uses it:**
- Reads tasks to understand context
- Updates checkboxes as it completes work
- Suggests next steps

**Checked into Git:** ⚠️ Optional (your choice)

---

## Agents

**What are agents?** Specialized AI assistants with specific roles.

### Types

#### 1. Shared Agents
**Location:** `~/claude-workspace/shared/agents/`

**Available by default:**
- **workspace-manager**: Connect/disconnect projects, manage workspace
- **translate**: Translate documents between languages
- **doc-writer**: Generate README, API docs, architecture docs

**How to use:**
```bash
# In Claude Code
> @workspace-manager show workspace status
> @translate translate this to Korean
> @doc-writer generate API documentation
```

#### 2. Project-Specific Agents
**Location:** `~/my-app/.claude/agents/`

**Use case:** Agents specific to your project (e.g., database migration agent, deployment agent)

**How to create:**
1. Create `~/my-app/.claude/agents/my-agent.md`
2. Define agent's purpose and capabilities
3. Use: `@my-agent do something`

#### 3. Team Agents
**Location:** Can be shared via Git in project `.claude/agents/`

**What are team agents?** Agents that your team creates and shares across team members. Unlike personal project agents, team agents are committed to the project repository so everyone on the team can use them.

**Use case:**
- Code review agent with team-specific standards
- Deployment agent following your team's deployment process
- Testing agent that knows your team's test patterns
- Documentation agent using your team's documentation style

**How to share:**
1. Create agent in `.claude/agents/my-team-agent.md`
2. Commit to git: `git add .claude/agents/my-team-agent.md`
3. Team members can use: `@my-team-agent do something`

**Best practices:**
- Document the agent's purpose clearly
- Include examples of how to use it
- Update when team processes change
- Review agent behavior regularly

### Agent File Format

```markdown
# Agent Name

## Role
Brief description of what this agent does

## Capabilities
- Can do X
- Can access Y
- Knows about Z

## Tools
- tool1
- tool2

## Instructions
Detailed instructions for the agent
```

---

## Slash Commands

Claude Code provides built-in slash commands for common operations:

**Session Management:**
- `/exit` - Exit Claude Code session
- `/clear` - Clear conversation history
- `/compact` - Compress conversation to save context (summarizes earlier messages)

**Configuration:**
- `/model` - Switch between Claude models (Opus, Sonnet, Haiku)
- `/agents` - List available agents (shared, project-specific, team agents)
- `/settings` - View and modify Claude Code settings

**Utilities:**
- `/help` - Show available commands and features
- `/tasks` - View and manage task list (if using TaskCreate/TaskUpdate)

**How to use:**
```bash
# In Claude Code
> /agents              # List all available agents
> /model               # Switch to different Claude model
> /compact             # Compress conversation when context is full
> /exit                # Exit Claude Code
```

**Tip:** Use `/help` anytime to see all available commands and their descriptions.

---

## MCP (Model Context Protocol)

**What is MCP?** Standard for connecting Claude to external data sources and tools.

### Available MCP Servers

- **local-rag** — Search documents and code (recommended)
- **filesystem** — Read/write files in your project (recommended)
- **serena** — Web browsing and research (recommended)
- **fetch** — HTTP requests and REST API calls
- **puppeteer** — Browser automation and screenshots

For detailed descriptions, configuration examples, and setup instructions, see **[Phase 2 Guide - MCP Servers](../../docs/en/PHASE2.md#step-2-23-mcp-servers)**.

### MCP Configuration

**Location:** `~/my-app/.mcp.json`

**Created during:** Phase 2 setup or manually

**Not checked into Git:** ❌ (may contain API keys)

---

## Quick Reference

| File/Dir | Purpose | Shared? | Git? |
|----------|---------|---------|------|
| CLAUDE.md | Project instructions | Team | ✅ Yes |
| CLAUDE.local.md | Personal notes | You | ❌ No |
| .claude/ | Claude Code settings | Project | ❌ No |
| Task.md | Task breakdown | Optional | ⚠️ Your choice |
| .mcp.json | MCP servers config | Project | ❌ No |

---

## Best Practices

### CLAUDE.md
✅ **Do:**
- Keep it updated as project evolves
- Include "why" not just "what"
- Document important conventions

❌ **Don't:**
- Put sensitive information
- Make it too long (Claude has context limits)
- Duplicate what's in code comments

### Agents
✅ **Do:**
- Give agents clear, specific roles
- Use shared agents for common tasks
- Create project agents for specialized needs

❌ **Don't:**
- Create duplicate agents
- Make agents too general-purpose
- Forget to document agent capabilities

### MCP
✅ **Do:**
- Use local-rag for documentation search
- Configure filesystem for file access
- Keep .mcp.json out of Git

❌ **Don't:**
- Commit API keys in .mcp.json
- Give excessive file system access
- Install untrusted MCP servers

---

## Learn More

- Official docs: https://docs.claude.ai/code
- MCP documentation: https://modelcontextprotocol.io
- Community agents: https://github.com/topics/claude-agent
