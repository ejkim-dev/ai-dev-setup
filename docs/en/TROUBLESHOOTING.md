# Troubleshooting Guide

Common issues and solutions for ai-dev-setup installation and usage.

## Table of Contents

- [Installation Issues](#installation-issues)
- [Font and Terminal Issues](#font-and-terminal-issues)
- [Shell and Plugin Issues](#shell-and-plugin-issues)
- [MCP Server Issues](#mcp-server-issues)
- [Permission Issues](#permission-issues)
- [Network Issues](#network-issues)

---

## Installation Issues

### Homebrew Installation Failed

**Symptom**:
```
❌ Homebrew installation failed
```

**Causes**:
- Network connection issues
- Xcode Command Line Tools not installed
- Insufficient permissions

**Solutions**:

1. **Check network connection**:
   ```bash
   ping github.com
   ```

2. **Install Xcode Command Line Tools first**:
   ```bash
   xcode-select --install
   ```

3. **Try manual installation**:
   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```

4. **Check installation logs**:
   ```bash
   tail -f /tmp/homebrew-install.log
   ```

---

### Node.js Installation Failed

**Symptom**:
```
❌ Node.js installation failed
Node.js is required for AI coding tools.
```

**Causes**:
- Homebrew not working
- Conflicting Node.js installation
- Disk space issues

**Solutions**:

1. **Verify Homebrew**:
   ```bash
   brew doctor
   ```
   Fix any issues reported

2. **Check for existing Node.js**:
   ```bash
   which node
   node --version
   ```
   If using nvm or another version manager, it might conflict

3. **Try manual installation**:
   ```bash
   brew install node
   ```

4. **Check disk space**:
   ```bash
   df -h
   ```
   Ensure at least 5GB free

5. **Alternative: Download from nodejs.org**:
   - Visit https://nodejs.org/
   - Download LTS version
   - Install via PKG installer

---

### npm Permission Errors

**Symptom**:
```
npm ERR! code EACCES
npm ERR! syscall access
npm ERR! path /usr/local/lib/node_modules
```

**Cause**: npm global install requires permissions

**Solutions**:

**Option 1: Fix npm permissions (recommended)**:
```bash
sudo chown -R $(whoami) /usr/local/lib/node_modules
sudo chown -R $(whoami) /usr/local/bin
sudo chown -R $(whoami) /usr/local/share
```

**Option 2: Use npm prefix (alternative)**:
```bash
mkdir ~/.npm-global
npm config set prefix '~/.npm-global'
echo 'export PATH=~/.npm-global/bin:$PATH' >> ~/.zshrc
source ~/.zshrc
```

**Option 3: Use sudo (not recommended)**:
```bash
sudo npm install -g @anthropic-ai/claude-code
```

---

## Font and Terminal Issues

### D2Coding Font Not Showing

**Symptom**: Terminal still shows default font after installation

**Causes**:
- Font cache not updated
- Terminal app not restarted
- Wrong font name selected

**Solutions**:

1. **Restart Terminal.app**:
   - Quit Terminal completely (⌘Q)
   - Reopen Terminal

2. **Clear font cache** (macOS):
   ```bash
   sudo atsutil databases -remove
   sudo atsutil server -shutdown
   sudo atsutil server -ping
   ```

3. **Verify font installation**:
   ```bash
   brew list --cask font-d2coding
   ```

4. **Check font in Font Book**:
   - Open Font Book app
   - Search for "D2Coding"
   - If found: Font is installed correctly
   - If not found: Reinstall font

5. **Reinstall font**:
   ```bash
   brew uninstall --cask font-d2coding
   brew install --cask font-d2coding
   ```

6. **Manually set font in Terminal**:
   - Terminal > Settings (⌘,)
   - Select Dev profile
   - Text tab > Change font
   - Select "D2Coding" from list

---

### Terminal Theme Not Applied

**Symptom**: Terminal still looks like default theme

**Causes**:
- Profile not imported correctly
- Wrong profile set as default
- Terminal not restarted

**Solutions**:

1. **Check current profile**:
   - Terminal > Settings (⌘,)
   - Profiles tab
   - Look for "Dev" profile

2. **Import profile manually**:
   - Terminal > Settings (⌘,)
   - Profiles tab
   - Click ⚙️ (gear icon) > Import...
   - Navigate to: `~/ai-dev-setup/configs/mac/Dev.terminal`
   - Select and open

3. **Set as default**:
   - Select "Dev" profile
   - Click "Default" button

4. **Open new window**:
   - Shell > New Window > Dev
   - Check if theme is applied

5. **Verify via command**:
   ```bash
   defaults read com.apple.Terminal "Default Window Settings"
   ```
   Should output: `Dev`

6. **Force re-import**:
   ```bash
   open ~/ai-dev-setup/configs/mac/Dev.terminal
   ```

---

### iTerm2 Cursor Invisible

**Symptom**: Can't see cursor in iTerm2

**Cause**: Cursor color matches background color

**Solutions**:

1. **Change cursor color**:
   - iTerm2 > Preferences (⌘,)
   - Profiles > Colors tab
   - Cursor Colors > Cursor
   - Choose a contrasting color (white/yellow for dark theme)

2. **Use block cursor**:
   - Profiles > Text tab
   - Cursor section
   - Select "Box" cursor
   - Enable "Blinking cursor"

3. **Reset to default profile**:
   - Profiles > Other Actions > Set as Default
   - Restart iTerm2

---

## Shell and Plugin Issues

### zsh-autosuggestions Not Working

**Symptom**: No command suggestions appear while typing

**Causes**:
- Plugin not installed
- Plugin not sourced in .zshrc
- Syntax error in .zshrc

**Solutions**:

1. **Verify installation**:
   ```bash
   brew list zsh-autosuggestions
   ```
   If not found:
   ```bash
   brew install zsh-autosuggestions
   ```

2. **Check .zshrc**:
   ```bash
   grep "zsh-autosuggestions" ~/.zshrc
   ```
   Should show:
   ```bash
   source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
   ```

3. **Add to .zshrc manually**:
   ```bash
   echo 'source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh' >> ~/.zshrc
   source ~/.zshrc
   ```

4. **Test syntax**:
   ```bash
   zsh -n ~/.zshrc
   ```
   No output = good. Errors shown = fix syntax

5. **Reload shell**:
   ```bash
   exec zsh
   ```

---

### zsh-syntax-highlighting Not Working

**Symptom**: Commands don't have color highlighting

**Causes**:
- Plugin not installed
- Plugin loaded in wrong order
- Conflicting plugin

**Solutions**:

1. **Verify installation**:
   ```bash
   brew list zsh-syntax-highlighting
   ```

2. **Check .zshrc order** (important):
   ```bash
   tail ~/.zshrc
   ```

   **zsh-syntax-highlighting must be sourced LAST**:
   ```bash
   source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
   source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh  # Last!
   ```

3. **Fix order**:
   Edit `~/.zshrc` and move zsh-syntax-highlighting to the end

4. **Reload**:
   ```bash
   source ~/.zshrc
   ```

---

### Oh My Zsh Theme Not Showing

**Symptom**: Prompt looks plain, no Git branch shown

**Causes**:
- Theme not set in .zshrc
- Oh My Zsh not loaded
- .zshrc syntax error

**Solutions**:

1. **Check Oh My Zsh installation**:
   ```bash
   [ -d ~/.oh-my-zsh ] && echo "Installed" || echo "Not installed"
   ```

2. **Check theme setting**:
   ```bash
   grep "^ZSH_THEME=" ~/.zshrc
   ```
   Should show: `ZSH_THEME="agnoster"`

3. **Set theme manually**:
   ```bash
   sed -i '' 's/^ZSH_THEME=.*/ZSH_THEME="agnoster"/' ~/.zshrc
   source ~/.zshrc
   ```

4. **Verify Oh My Zsh is loaded**:
   ```bash
   grep "source.*oh-my-zsh.sh" ~/.zshrc
   ```
   Should show source line

5. **Reinstall Oh My Zsh**:
   ```bash
   sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
   ```

---

### Shell Configuration Conflicts

**Symptom**: New settings not taking effect, errors on startup

**Causes**:
- Multiple conflicting config files
- Syntax errors
- Load order issues

**Solutions**:

1. **Check which shell is active**:
   ```bash
   echo $SHELL
   ```
   Should be: `/bin/zsh`

2. **Check for conflicting configs**:
   ```bash
   ls -la ~/ | grep "^\."
   ```
   Look for: `.bashrc`, `.bash_profile`, `.zprofile`, `.zshrc`, `.zshenv`

3. **Test .zshrc syntax**:
   ```bash
   zsh -n ~/.zshrc
   ```

4. **Start with clean shell**:
   ```bash
   zsh -f
   ```

5. **Rename .zshrc temporarily**:
   ```bash
   mv ~/.zshrc ~/.zshrc.backup
   exec zsh  # Should start with defaults
   mv ~/.zshrc.backup ~/.zshrc
   ```

6. **Check startup errors**:
   ```bash
   zsh -x 2>&1 | less
   ```
   Look for error messages

---

## MCP Server Issues

### MCP Servers Not Loading

**Symptom**: Claude Code can't access MCP servers

**Causes**:
- Invalid .mcp.json syntax
- MCP server not installed
- Wrong command path

**Solutions**:

1. **Check .mcp.json syntax**:
   ```bash
   cat ~/.claude/.mcp.json | jq .
   ```
   If error: Fix JSON syntax (missing commas, brackets)

2. **Verify server installation**:
   ```bash
   npm list -g | grep mcp
   ```
   Should show installed MCP servers

3. **Test server command**:
   ```bash
   local-rag-mcp --version
   # or
   which local-rag-mcp
   ```

4. **Reinstall server**:
   ```bash
   npm install -g @anthropic-ai/local-rag-mcp
   ```

5. **Check Claude Code config**:
   ```bash
   claude config --list
   ```

6. **Example valid .mcp.json**:
   ```json
   {
     "mcpServers": {
       "local-rag": {
         "command": "local-rag-mcp",
         "args": [],
         "env": {
           "RAG_INDEX_PATH": "/Users/you/.claude/rag-index"
         }
       }
     }
   }
   ```
   Note: No trailing comma after last item!

---

### local-rag Not Finding Documents

**Symptom**: local-rag MCP server can't search documents

**Causes**:
- Index path not configured
- Documents not indexed
- Wrong file types

**Solutions**:

1. **Check index path**:
   ```bash
   cat ~/.claude/.mcp.json | jq '.mcpServers["local-rag"].env.RAG_INDEX_PATH'
   ```

2. **Create index directory**:
   ```bash
   mkdir -p ~/.claude/rag-index
   ```

3. **Index documents**:
   ```bash
   # Example: Index Obsidian vault
   local-rag-mcp index ~/claude-workspace/vault/
   ```

4. **Check indexed documents**:
   ```bash
   local-rag-mcp list
   ```

5. **Supported file types**:
   - Markdown (.md)
   - PDF (.pdf)
   - Text (.txt)
   - Code files (.js, .py, .ts, etc.)

---

### filesystem MCP Permission Denied

**Symptom**: filesystem MCP can't read/write files

**Causes**:
- Restricted root path
- File permissions
- macOS sandbox restrictions

**Solutions**:

1. **Check configured root**:
   ```bash
   cat ~/.claude/.mcp.json | jq '.mcpServers.filesystem.args'
   ```

2. **Use accessible path**:
   ```json
   {
     "filesystem": {
       "command": "filesystem-mcp",
       "args": ["--root", "/Users/yourname/"]
     }
   }
   ```

3. **Grant Terminal Full Disk Access** (macOS):
   - System Settings > Privacy & Security
   - Full Disk Access
   - Enable for Terminal.app

4. **Check file permissions**:
   ```bash
   ls -la /path/to/file
   ```

---

## Permission Issues

### "Operation not permitted" on macOS

**Symptom**:
```
operation not permitted
```

**Cause**: macOS security restrictions (SIP, sandbox)

**Solutions**:

1. **Grant Terminal Full Disk Access**:
   - System Settings > Privacy & Security
   - Full Disk Access
   - Click 🔒 to unlock
   - Enable Terminal.app
   - Restart Terminal

2. **For specific directories**:
   - System Settings > Privacy & Security
   - Files and Folders
   - Terminal > Enable folders

3. **Avoid system directories**:
   - Don't try to modify `/System/`
   - Don't try to modify `/usr/bin/`
   - Use `~/` (home) instead

---

### sudo Password Prompts

**Symptom**: Keeps asking for password during installation

**Cause**: Some installations require admin privileges

**Solutions**:

1. **Minimize sudo usage**:
   - Fix npm permissions (see above)
   - Use Homebrew (doesn't need sudo)

2. **Extend sudo timeout**:
   ```bash
   sudo -v
   # Keeps sudo active for 5 minutes
   ```

3. **Run entire script with sudo** (not recommended):
   ```bash
   sudo ./setup.sh
   ```

---

## Network Issues

### Download Failed / Timeout

**Symptom**:
```
Failed to download
Connection timeout
```

**Causes**:
- Slow/unstable network
- Firewall blocking
- Proxy configuration

**Solutions**:

1. **Check internet connection**:
   ```bash
   ping google.com
   curl -I https://github.com
   ```

2. **Try different DNS**:
   ```bash
   # Use Google DNS
   networksetup -setdnsservers Wi-Fi 8.8.8.8 8.8.4.4
   ```

3. **Configure proxy** (if behind corporate firewall):
   ```bash
   export HTTP_PROXY=http://proxy.company.com:8080
   export HTTPS_PROXY=http://proxy.company.com:8080
   ```

4. **Increase timeout**:
   ```bash
   npm config set timeout 60000
   ```

5. **Retry installation**:
   ```bash
   ./setup.sh
   ```
   Most installers automatically resume

---

### GitHub Connection Issues

**Symptom**:
```
Failed to connect to github.com
```

**Causes**:
- Network firewall
- SSH key not configured
- GitHub service down

**Solutions**:

1. **Check GitHub status**:
   - Visit https://www.githubstatus.com/

2. **Test connection**:
   ```bash
   ssh -T git@github.com
   ```
   Should show: "Hi username! You've successfully authenticated..."

3. **Use HTTPS instead of SSH**:
   ```bash
   git config --global url."https://github.com/".insteadOf git@github.com:
   ```

4. **Configure SSH key**:
   ```bash
   gh auth login
   ```
   Follow prompts

5. **Check firewall**:
   - Ensure ports 22 (SSH) and 443 (HTTPS) are open

---

## Getting More Help

### Enable Debug Mode

**macOS**:
```bash
set -x  # Enable debug output
./setup.sh
set +x  # Disable debug output
```

**Windows**:
```powershell
$DebugPreference = "Continue"
.\setup.ps1
```

### Collect System Information

```bash
# System info
uname -a
sw_vers  # macOS version

# Installed tools
brew --version
node --version
npm --version
git --version

# Shell info
echo $SHELL
zsh --version

# PATH
echo $PATH
```

### Check Logs

**Homebrew logs**:
```bash
cat /tmp/homebrew-install.log
```

**npm logs**:
```bash
npm config get cache
ls -la ~/.npm/_logs/
```

**Claude Code logs**:
```bash
ls -la ~/.claude/logs/
```

### Report an Issue

If none of the above helps, please report an issue:

1. **Gather information** (use commands above)
2. **Include in report**:
   - macOS/Windows version
   - Error message (full output)
   - Steps to reproduce
   - System info
3. **Submit to**: [GitHub Issues](https://github.com/ejkim-dev/ai-dev-setup/issues)

---

## Complete Removal

### Phase 1 Cleanup (Automated)

**Automated script available**:
```bash
curl -fsSL https://raw.githubusercontent.com/ejkim-dev/ai-dev-setup/main/uninstall-tools.sh -o /tmp/uninstall-tools.sh

bash /tmp/uninstall-tools.sh
```

**What gets removed**:
- Oh My Zsh (`~/.oh-my-zsh/`)
- Shell configuration (`~/.zshrc`)
- tmux configuration (`~/.tmux.conf`)
- Terminal.app Dev profile
- Phase 2 files (`~/claude-code-setup/`)
- Language settings (`~/.dev-setup-lang`)

**What is NOT removed**:
- Homebrew (may be used by other tools)
- Xcode Command Line Tools
- D2Coding font
- Installed packages (Node.js, ripgrep, etc.)

---

### Phase 2 Uninstall (Manual Only)

⚠️ **Warning**: This removes your Claude workspace including custom agents, templates, and settings. There is NO automated script for Phase 2 cleanup to prevent accidental data loss.

**Why manual only?**
- Phase 1: Removes temporary install files (safe to automate)
- Phase 2: Removes your workspace with custom data (risk of data loss)

**When you might need this**:
1. **Complete removal** - Stop using Claude Code entirely
2. **Reset configuration** - Start fresh due to misconfiguration
3. **Test rollback** - Undo after testing

#### Step-by-Step Manual Uninstall

**Step 1: Backup (Highly Recommended)**

```bash
# Backup entire workspace
cp -r ~/claude-workspace ~/claude-workspace-backup-$(date +%F)

# Or backup specific items only
cp -r ~/claude-workspace/shared/agents ~/agents-backup
cp -r ~/claude-workspace/projects ~/projects-backup
cp -r ~/claude-workspace/shared/templates ~/templates-backup
```

**Step 2: Remove Workspace**

```bash
# This deletes your custom agents, templates, and settings
rm -rf ~/claude-workspace
```

**Step 3: Remove Shared Agents Symlink**

```bash
# Remove symlink to shared agents
rm ~/.claude/agents
```

**Step 4: Remove Project Symlinks**

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

**Step 5: Uninstall Claude Code CLI (Optional)**

```bash
npm uninstall -g @anthropic-ai/claude-code
```

**Step 6: Uninstall MCP Servers (Optional)**

```bash
# Uninstall all MCP servers
npm uninstall -g @anthropic-ai/local-rag-mcp
npm uninstall -g @anthropic-ai/filesystem-mcp
npm uninstall -g serena-mcp
npm uninstall -g @anthropic-ai/fetch-mcp
npm uninstall -g puppeteer-mcp

# Or uninstall all global packages at once (be careful!)
# npm list -g --depth=0 | grep mcp | awk '{print $2}' | xargs npm uninstall -g
```

**Step 7: Remove Claude Configuration**

```bash
# This removes API keys, settings, and logs
rm -rf ~/.claude
```

**Step 8: Remove Language Setting (Optional)**

```bash
rm ~/.dev-setup-lang
```

#### Verify Removal

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

#### Restore from Backup

If you change your mind:

```bash
# Restore workspace
mv ~/claude-workspace-backup-YYYY-MM-DD ~/claude-workspace

# Recreate shared agents symlink
mkdir -p ~/.claude
ln -s ~/claude-workspace/shared/agents ~/.claude/agents

# Reinstall Claude Code
npm install -g @anthropic-ai/claude-code

# Restore configuration
mv ~/.claude-backup ~/.claude  # If you backed up config
```

#### Troubleshooting Removal

**Symlink won't delete**:
```bash
# Force remove symlink
unlink ~/.claude/agents
# or
rm -f ~/.claude/agents
```

**Permission denied**:
```bash
# Check ownership
ls -la ~/claude-workspace

# If needed, take ownership
sudo chown -R $(whoami) ~/claude-workspace
rm -rf ~/claude-workspace
```

**npm uninstall fails**:
```bash
# Use sudo (not recommended but sometimes necessary)
sudo npm uninstall -g @anthropic-ai/claude-code

# Or remove manually
sudo rm -rf $(npm root -g)/@anthropic-ai/claude-code
sudo rm $(which claude)
```

---

## Related Documentation

- [Phase 1 Guide](PHASE1.md)
- [Phase 2 Guide](PHASE2.md)
- [FAQ](FAQ.md)
- [Workspace Structure](WORKSPACE.md)
