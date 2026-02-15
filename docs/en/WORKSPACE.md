# Claude Workspace Structure

Centralized management for Claude Code resources across all projects.

## Overview

The `claude-workspace` provides a single location to manage:
- Global agents (available in all projects)
- MCP server configurations
- Project templates (CLAUDE.md, .mcp.json)
- Project backups and settings

## Directory Structure

```
~/claude-workspace/
├── global/
│   └── agents/                    # Global agents
│       ├── workspace-manager.md   # Project structure management
│       ├── translate.md           # Multi-language translation
│       └── doc-writer.md          # Documentation generation
│
├── projects/                      # Per-project configurations
│   └── my-app/                    # Example project
│       ├── .claude/               # Project-specific Claude settings
│       ├── CLAUDE.md              # Project rules
│       └── CLAUDE.local.md        # Local-only settings
│
└── templates/                     # Templates for new projects
    ├── CLAUDE.md                  # Template project rules
    ├── CLAUDE.local.md            # Template local settings
    └── .mcp.json                  # Template MCP configuration
```

---

## Global Agents

### What Are Global Agents?

Agents are reusable AI assistants with specific capabilities. Global agents are available in **all projects** without copying files.

### Installed Agents

#### workspace-manager
**Purpose**: Manage project connection to workspace

**Capabilities**:
- Connect project to workspace
- Create project structure
- Set up symlinks
- Manage .gitignore entries
- Check workspace status

**Example usage**:
```
/workspace-manager connect ~/projects/my-app
```

Creates:
- `~/claude-workspace/projects/my-app/`
- Symlinks from project to workspace
- .gitignore entries (ignores symlink targets)

#### translate
**Purpose**: Multi-language document translation

**Capabilities**:
- Translate markdown files (en/ko/ja)
- Preserve formatting and code blocks
- Batch translation
- Locale file generation

**Example usage**:
```
/translate README.md en ko
```

Creates: `README.ko.md` with Korean translation

#### doc-writer
**Purpose**: Generate and maintain documentation

**Capabilities**:
- README generation from code
- CLAUDE.md creation
- API documentation
- Architecture diagrams (text-based)

**Example usage**:
```
/doc-writer create-readme --from-code
```

Generates: `README.md` based on project structure and code

---

## Using Global Agents in Projects

### Method 1: Reference in CLAUDE.md

In your project's `CLAUDE.md`:

```markdown
# My Project

## Available Global Agents

- **workspace-manager**: Project structure management
- **translate**: Multi-language support
- **doc-writer**: Documentation generation

## Project Rules

[Your project-specific rules here]
```

Claude Code automatically loads agents from `~/claude-workspace/global/agents/`.

### Method 2: Direct Invocation

In Claude Code chat:

```
Use the workspace-manager agent to check status
```

Claude will use the global agent without any additional setup.

---

## Per-Project Configuration

### Project Structure

Each project can have its own Claude configuration:

```
my-project/
├── .claude/               # Project-specific Claude settings
│   ├── agents/            # Project-only agents
│   ├── mcp/               # Project-specific MCP servers
│   ├── tools/             # Custom tools
│   └── notes/             # Private development notes
│
├── CLAUDE.md              # Team-shared rules (committed)
└── CLAUDE.local.md        # Personal settings (gitignored)
```

### CLAUDE.md vs CLAUDE.local.md

**CLAUDE.md** (committed to git):
- Project rules and guidelines
- Coding standards
- Architecture decisions
- Available agents and tools
- Shared by entire team

**CLAUDE.local.md** (gitignored):
- Personal preferences
- Local-only notes
- Private reminders
- Individual workflow settings

### Example CLAUDE.md

```markdown
# My Web App

## Tech Stack
- React 18
- TypeScript
- Tailwind CSS

## Code Style
- Use functional components
- Prefer named exports
- Max line length: 100

## Available Global Agents
- workspace-manager
- translate
- doc-writer

## MCP Servers
- local-rag (project documentation)
- filesystem (code access)
- serena (web search)
```

### Example CLAUDE.local.md

```markdown
# Personal Settings

## Preferences
- Prefer verbose explanations
- Focus on TypeScript best practices

## Local MCP Servers
- None (using global only)

## Notes
- Remember to run tests before committing
- Use feature branches for new features
```

---

## MCP Server Configuration

### Global vs Project-Specific MCP

**Global MCP** (`~/.claude/.mcp.json`):
- Servers available in all projects
- Configured during Phase 2 setup
- Examples: local-rag, filesystem, serena

**Project MCP** (`my-project/.claude/.mcp.json`):
- Servers specific to one project
- Overrides/extends global configuration
- Examples: project-specific databases, APIs

### Global .mcp.json Example

```json
{
  "mcpServers": {
    "local-rag": {
      "command": "local-rag-mcp",
      "env": {
        "RAG_INDEX_PATH": "~/.claude/rag-index"
      }
    },
    "filesystem": {
      "command": "filesystem-mcp",
      "args": ["--root", "~/"]
    },
    "serena": {
      "command": "serena-mcp"
    }
  }
}
```

### Project-Specific .mcp.json

```json
{
  "mcpServers": {
    "postgres": {
      "command": "postgres-mcp",
      "env": {
        "DB_CONNECTION": "postgresql://localhost/mydb"
      }
    },
    "jira": {
      "command": "jira-mcp",
      "env": {
        "JIRA_URL": "https://mycompany.atlassian.net",
        "JIRA_TOKEN": "${JIRA_TOKEN}"
      }
    }
  }
}
```

**Configuration precedence**:
1. Project `.mcp.json` (highest priority)
2. Global `.mcp.json` (fallback)

---

## Symlink Management

### Why Symlinks?

Symlinks allow:
- **Centralized updates**: Change once, apply everywhere
- **Consistency**: Same agents across all projects
- **Easy backup**: One workspace to back up
- **No duplication**: Save disk space

### Automatic Symlink Creation

The `workspace-manager` agent handles symlinks automatically:

```
/workspace-manager connect ~/projects/my-app
```

Creates symlinks:
- `my-app/.claude/agents` → `~/claude-workspace/global/agents`
- `my-app/CLAUDE.md` → `~/claude-workspace/projects/my-app/CLAUDE.md`

### Manual Symlink Creation (macOS/Linux)

```bash
# Link global agents to project
ln -s ~/claude-workspace/global/agents ~/projects/my-app/.claude/agents

# Link project CLAUDE.md to workspace
ln -s ~/claude-workspace/projects/my-app/CLAUDE.md ~/projects/my-app/CLAUDE.md
```

### Symlink Creation (Windows)

**Requirements**: Developer Mode enabled OR admin privileges

```powershell
# Enable Developer Mode: Settings → Update & Security → For developers

# Create symlinks
New-Item -ItemType SymbolicLink -Path "C:\projects\my-app\.claude\agents" -Target "$env:USERPROFILE\claude-workspace\global\agents"
```

### .gitignore Integration

The `workspace-manager` automatically adds symlink targets to `.gitignore`:

```gitignore
# Claude Code symlink targets (managed by workspace-manager)
.claude/agents
CLAUDE.md
CLAUDE.local.md
```

This ensures:
- Symlinks are committed (team knows structure)
- Actual files are not committed (prevents duplication)
- Each team member can have their own workspace

---

## Templates

### Using Templates for New Projects

Templates provide starting points for new projects.

**Available templates**:
- `CLAUDE.md` - Project rules template
- `CLAUDE.local.md` - Local settings template
- `.mcp.json` - MCP configuration template

### Copy Template to New Project

```bash
# Copy CLAUDE.md template
cp ~/claude-workspace/templates/CLAUDE.md ~/projects/new-app/

# Copy MCP template
cp ~/claude-workspace/templates/.mcp.json ~/projects/new-app/.claude/
```

### Template Variables

Templates use `__PLACEHOLDER__` syntax for substitution:

**Template** (`templates/CLAUDE.md`):
```markdown
# __PROJECT_NAME__

Tech stack: __TECH_STACK__
```

**After substitution** (`projects/my-app/CLAUDE.md`):
```markdown
# My App

Tech stack: React, TypeScript, Node.js
```

---

## Workflow Examples

### Starting a New Project

1. **Create project directory**:
   ```bash
   mkdir ~/projects/my-new-app
   cd ~/projects/my-new-app
   ```

2. **Connect to workspace**:
   ```
   /workspace-manager connect .
   ```

3. **Copy templates**:
   ```bash
   cp ~/claude-workspace/templates/CLAUDE.md ./
   cp ~/claude-workspace/templates/.mcp.json ./.claude/
   ```

4. **Edit CLAUDE.md** for your project

5. **Start coding**:
   ```
   claude chat
   ```

### Adding a Global Agent

1. **Create agent file**:
   ```bash
   nano ~/claude-workspace/global/agents/my-agent.md
   ```

2. **Write agent definition**:
   ```markdown
   # My Custom Agent

   ## Purpose
   [Describe what this agent does]

   ## Capabilities
   - Capability 1
   - Capability 2

   ## Example Usage
   [Show how to use this agent]
   ```

3. **Use immediately** (no restart needed):
   ```
   /my-agent [task]
   ```

### Backing Up a Project

```bash
# Back up project-specific settings to workspace
cp -r ~/projects/my-app/.claude ~/claude-workspace/projects/my-app/
cp ~/projects/my-app/CLAUDE.md ~/claude-workspace/projects/my-app/
```

Now the project settings are safely stored in the workspace.

### Restoring a Project

```bash
# Restore from workspace backup
cp -r ~/claude-workspace/projects/my-app/.claude ~/projects/my-app/
cp ~/claude-workspace/projects/my-app/CLAUDE.md ~/projects/my-app/
```

---

## Best Practices

### Do's

✅ **Use global agents for common tasks**
- workspace-manager for all projects
- translate for multi-language docs
- doc-writer for README generation

✅ **Keep CLAUDE.md focused**
- Project-specific rules only
- Reference global agents, don't duplicate
- Update when architecture changes

✅ **Use CLAUDE.local.md for personal settings**
- Individual preferences
- Local-only notes
- Temporary reminders

✅ **Back up workspace regularly**
```bash
cp -r ~/claude-workspace ~/Dropbox/backups/claude-workspace-$(date +%F)
```

### Don'ts

❌ **Don't commit symlink targets to git**
- Let .gitignore handle it
- Prevents duplication and conflicts

❌ **Don't duplicate global agents in projects**
- Reference them, don't copy
- Updates propagate automatically

❌ **Don't store secrets in CLAUDE.md**
- Use environment variables
- Reference via `${ENV_VAR}` in MCP config

❌ **Don't manually edit .mcp.json without backup**
- JSON syntax errors break Claude Code
- Keep a backup before editing

---

## Troubleshooting

### Symlink Not Working

**Symptom**: Agent files not found

**Solution**:
```bash
# Check symlink
ls -la ~/projects/my-app/.claude/agents

# Should show: agents -> /Users/you/claude-workspace/global/agents

# If broken, recreate:
rm ~/projects/my-app/.claude/agents
ln -s ~/claude-workspace/global/agents ~/projects/my-app/.claude/agents
```

### MCP Server Not Loading

**Symptom**: Claude Code can't access MCP server

**Check .mcp.json syntax**:
```bash
cat ~/.claude/.mcp.json | jq .
```

If error: Fix JSON syntax (commas, brackets, quotes)

**Check server installation**:
```bash
npm list -g | grep local-rag-mcp
```

If not found: Reinstall server

### Global Agent Not Available

**Symptom**: Claude Code doesn't recognize agent

**Check agent file exists**:
```bash
ls ~/claude-workspace/global/agents/workspace-manager.md
```

**Check CLAUDE.md references agent**:
```bash
grep "workspace-manager" ~/projects/my-app/CLAUDE.md
```

Add if missing:
```markdown
## Available Global Agents
- workspace-manager
```

---

## Advanced Topics

### Multiple Workspaces

You can have multiple workspaces for different contexts:

```bash
# Work workspace
~/claude-workspace/

# Personal projects workspace
~/claude-workspace-personal/
```

Set via environment variable:
```bash
export CLAUDE_WORKSPACE=~/claude-workspace-personal
```

### Workspace Sharing (Team)

Share workspace structure (not content) with team:

1. **Commit workspace structure** (not files):
   ```bash
   git init ~/claude-workspace
   cd ~/claude-workspace
   git add templates/
   git commit -m "Add project templates"
   ```

2. **Team members clone**:
   ```bash
   git clone <repo-url> ~/claude-workspace
   ```

3. **Each member adds own agents**:
   ```bash
   cp custom-agent.md ~/claude-workspace/global/agents/
   ```

### Custom MCP Servers

Create project-specific MCP server:

1. **Create server package**:
   ```bash
   mkdir my-mcp-server
   cd my-mcp-server
   npm init -y
   # Implement MCP server
   ```

2. **Install locally**:
   ```bash
   npm install -g .
   ```

3. **Add to .mcp.json**:
   ```json
   {
     "mcpServers": {
       "my-server": {
         "command": "my-mcp-server",
         "args": ["--config", "config.json"]
       }
     }
   }
   ```

---

## Related Documentation

- [Phase 2 Setup](PHASE2.md) - Initial workspace creation
- [Troubleshooting](TROUBLESHOOTING.md) - Common issues
- [FAQ](FAQ.md) - Frequently asked questions
