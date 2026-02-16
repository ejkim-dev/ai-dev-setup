# Uninstall Guide

How to partially or completely remove ai-dev-setup.

## Important Distinction

- **Phase 1 cleanup**: Automated script available (removes temporary install files)
- **Phase 2 cleanup**: Manual only (removes your workspace and data - must be careful)

---

## Phase 1 Uninstall (Automated)

**Automated script available**:

```bash
curl -fsSL https://raw.githubusercontent.com/ejkim-dev/ai-dev-setup/v1.0.0/uninstall-tools.sh -o /tmp/cleanup.sh

bash /tmp/cleanup.sh
```

### Removal Options (User choice for each item)

The script prompts you for each item:

**Main Items**:
- AI CLI tools (Claude Code, Gemini CLI, GitHub Copilot, etc.)
- Homebrew packages (D2Coding font, ripgrep, tmux, zsh plugins)
- Node.js (separate confirmation)
- Oh My Zsh (`~/.oh-my-zsh/`)
- Shell configuration (removes ai-dev-setup section from `.zshrc`)
- tmux configuration (`~/.tmux.conf`)
- Terminal.app Dev profile
- Phase 2 files (`~/claude-code-setup/`, includes `.dev-setup-lang`)

**Additional Cleanup Options**:
- iTerm2 application
- Complete Homebrew removal

### What is NOT Removed Automatically

- Xcode Command Line Tools (may be required by your system)

---

## Phase 2 Uninstall (Manual Only)

⚠️ **Warning**: This removes your Claude workspace including custom agents, templates, and settings. There is NO automated script for Phase 2 cleanup **by design** to prevent accidental data loss.

### Why Manual Only?

- **Phase 1**: Removes temporary install files (safe to automate)
- **Phase 2**: Removes workspace with custom data (risk of data loss)

### When You Might Need This

1. **Complete removal** - Stop using Claude Code entirely
2. **Reset configuration** - Start fresh due to misconfiguration
3. **Test rollback** - Undo after testing

---

## Step-by-Step Manual Uninstall

### Step 1: Backup (Highly Recommended)

```bash
# Backup entire workspace
cp -r ~/claude-workspace ~/claude-workspace-backup-$(date +%F)

# Or backup specific items only
cp -r ~/claude-workspace/shared/agents ~/agents-backup
cp -r ~/claude-workspace/projects ~/projects-backup
cp -r ~/claude-workspace/shared/templates ~/templates-backup
```

### Step 2: Remove Workspace

```bash
# This deletes your custom agents, templates, and settings
rm -rf ~/claude-workspace
```

### Step 3: Remove Shared Agents Symlink

```bash
# Remove symlink to shared agents
rm ~/.claude/agents
```

### Step 4: Remove Project Symlinks

For each project connected to the workspace:

```bash
# Navigate to project
cd /path/to/your/project

# Remove symlinks
rm .claude
rm CLAUDE.md
rm CLAUDE.local.md

# Update .gitignore (remove ai-dev-setup entries)
# Edit manually or use sed:
sed -i '' '/# Claude Code symlink targets/,/CLAUDE.local.md/d' .gitignore
```

### Step 5: Uninstall Claude Code CLI (Optional)

```bash
npm uninstall -g @anthropic-ai/claude-code
```

### Step 6: Uninstall MCP Servers (Optional)

```bash
# Uninstall all MCP servers
npm uninstall -g @anthropic-ai/local-rag-mcp
npm uninstall -g @anthropic-ai/filesystem-mcp
npm uninstall -g serena-mcp
npm uninstall -g @anthropic-ai/fetch-mcp
npm uninstall -g puppeteer-mcp
```

### Step 7: Remove Claude Configuration

```bash
# This removes API keys, settings, and logs
rm -rf ~/.claude
```

### Step 8: Remove Language Setting (Optional)

```bash
rm ~/.dev-setup-lang
```

---

## Verify Removal

Check that everything was removed:

```bash
# Should not exist
ls ~/claude-workspace      # Should show "No such file"
ls ~/.claude              # Should show "No such file"
command -v claude         # Should show "not found"

# Check global npm packages
npm list -g --depth=0 | grep claude
npm list -g --depth=0 | grep mcp
```

---

## Restore from Backup

If you change your mind:

```bash
# Restore workspace
mv ~/claude-workspace-backup-YYYY-MM-DD ~/claude-workspace

# Recreate shared agents symlink
mkdir -p ~/.claude
ln -s ~/claude-workspace/shared/agents ~/.claude/agents

# Reinstall Claude Code
npm install -g @anthropic-ai/claude-code

# Restore configuration (if backed up)
mv ~/.claude-backup ~/.claude
```

---

## Troubleshooting Removal

### Symlink Won't Delete

```bash
# Force remove symlink
unlink ~/.claude/agents
# or
rm -f ~/.claude/agents
```

### Permission Denied

```bash
# Check ownership
ls -la ~/claude-workspace

# If needed, take ownership
sudo chown -R $(whoami) ~/claude-workspace
rm -rf ~/claude-workspace
```

### npm Uninstall Fails

```bash
# Use sudo (not recommended but sometimes necessary)
sudo npm uninstall -g @anthropic-ai/claude-code

# Or remove manually
sudo rm -rf $(npm root -g)/@anthropic-ai/claude-code
sudo rm $(which claude)
```

---

## Optional: Remove Homebrew and Node.js

Only if not used by other tools:

```bash
# Remove Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall-tools.sh)"

# Remove Node.js
brew uninstall node
```

---

## Related Documentation

- [Phase 1 Guide](PHASE1.md)
- [Phase 2 Guide](PHASE2.md)
- [Troubleshooting](TROUBLESHOOTING.md)
- [FAQ](FAQ.md)
