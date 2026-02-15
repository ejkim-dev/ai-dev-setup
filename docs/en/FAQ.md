# Frequently Asked Questions (FAQ)

Common questions about ai-dev-setup installation and usage.

## General Questions

### What is ai-dev-setup?

ai-dev-setup is a one-line installer for development environments on macOS and Windows. It sets up:
- Package managers (Homebrew/winget)
- Essential development tools (Node.js, Git, etc.)
- Terminal themes and shell customization
- Optional: Claude Code with workspace management

**Target users**: Terminal beginners, new computer setup, anyone wanting a consistent AI-powered development environment.

---

### Do I need Git to install this?

**No, Git is NOT required** for installation.

**Phase 1** (basic environment):
- Uses `curl` to download (macOS) or `irm` (Windows)
- No Git needed at all

**Phase 2** (Claude Code setup):
- Installs Git if not already present
- Only needed for Claude Code version control features

---

### What's the difference between Phase 1 and Phase 2?

**Phase 1: Basic Development Environment**
- Package manager (Homebrew/winget)
- Node.js, ripgrep, development tools
- Terminal themes (Terminal.app, Windows Terminal, iTerm2)
- Shell customization (Oh My Zsh/Oh My Posh)
- Time: ~15-30 minutes

**Phase 2: Claude Code Setup** (optional)
- Git + GitHub CLI
- Claude Code installation
- Global agents (workspace-manager, translate, doc-writer)
- MCP servers (local-rag, filesystem, serena, etc.)
- Workspace management structure
- Time: ~10-20 minutes

**You can run Phase 1 without Phase 2**, but Phase 2 requires Phase 1 tools (Node.js, etc.).

---

### Can I skip certain steps?

**Yes! Every step is optional** (except critical requirements).

**Required steps**:
- Homebrew (macOS) - needed for all other installations
- Node.js - required for Claude Code and AI tools

**Optional steps**:
- Terminal themes
- Shell customization
- tmux
- Specific packages (ripgrep, fonts, etc.)
- AI tools
- MCP servers

The installer will ask for each step. Navigate with arrow keys and select what you want.

---

### Why does it ask [Y/n] vs using arrow keys?

**It doesn't!** All prompts use **arrow-key navigation**.

**Old versions** used text input like `[Y/n]`. **Current version** uses interactive menus:

```
  ▸ Install
    Skip
```

Navigate with ↑↓, select with Enter. No typing required.

If you see `[Y/n]` prompts, you're using an outdated version. Update to latest:
```bash
curl -fsSL https://raw.githubusercontent.com/ejkim-dev/ai-dev-setup/main/install.sh | bash
```

---

### How do I change language after installation?

The language is saved in `~/.dev-setup-lang`. To change it:

**Method 1: Delete and re-run**
```bash
rm ~/.dev-setup-lang
~/claude-code-setup/setup-claude.sh
```
You'll be prompted to select language again.

**Method 2: Edit directly**
```bash
echo "ko" > ~/.dev-setup-lang  # Korean
echo "en" > ~/.dev-setup-lang  # English
echo "ja" > ~/.dev-setup-lang  # Japanese
```

---

### How do I reinstall or clean up?

**Clean up Phase 1** (macOS):
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
- Language settings

**What is NOT removed** (might be used by other apps):
- Homebrew
- Xcode Command Line Tools
- D2Coding font
- Installed packages (Node.js, ripgrep, etc.)

**Clean up Phase 2**:
```bash
rm -rf ~/claude-workspace
rm -rf ~/.claude
npm uninstall -g @anthropic-ai/claude-code
```

**Full reinstall**:
```bash
# 1. Clean up
curl -fsSL https://raw.githubusercontent.com/ejkim-dev/ai-dev-setup/main/uninstall-tools.sh -o /tmp/uninstall-tools.sh

bash /tmp/uninstall-tools.sh

# 2. Reinstall
curl -fsSL https://raw.githubusercontent.com/ejkim-dev/ai-dev-setup/main/install.sh | bash
```

---

## Installation Questions

### What if I already have Homebrew?

The installer **auto-detects** existing Homebrew and skips installation:

```
[2/7] Homebrew

  ✅ Already installed
  ⏭️ Skipped
```

No conflicts, no re-installation.

---

### What if I already have Node.js?

Same as Homebrew - **auto-detects and skips**:

```
[3/7] Essential Packages

  ▸ [x] Node.js - JavaScript runtime - Already installed
```

The checkbox will show "Already installed" and be disabled (cannot be unchecked).

If you have a different Node.js version (from nvm, etc.), the installer detects it and skips Homebrew installation.

---

### Can I use this on multiple computers?

**Yes!** This is a common use case.

**Same setup on all computers**:
```bash
# Computer 1
curl -fsSL https://raw.githubusercontent.com/ejkim-dev/ai-dev-setup/main/install.sh | bash

# Computer 2
curl -fsSL https://raw.githubusercontent.com/ejkim-dev/ai-dev-setup/main/install.sh | bash

# Computer 3
curl -fsSL https://raw.githubusercontent.com/ejkim-dev/ai-dev-setup/main/install.sh | bash
```

Each installation is independent, but follows the same configuration pattern.

**Sync workspace across computers**:
```bash
# Use Dropbox/iCloud for workspace
ln -s ~/Dropbox/claude-workspace ~/claude-workspace
```

Or use Git to sync:
```bash
cd ~/claude-workspace
git init
git remote add origin <your-repo>
git push
```

---

### Does this work on Apple Silicon (M1/M2/M3)?

**Yes!** Fully tested on Apple Silicon.

**Automatic adjustments**:
- Homebrew installs to `/opt/homebrew/` (Apple Silicon standard)
- PATH automatically configured for ARM architecture
- All packages use native ARM versions when available

No manual configuration needed.

---

### Does this work on Intel Macs?

**Yes!** Works on both Intel and Apple Silicon.

**Differences**:
- Homebrew location: `/usr/local/` (Intel) vs `/opt/homebrew/` (ARM)
- Script automatically detects and handles both

---

### Can I run this without internet?

**No.** Internet connection is required for:
- Downloading installer script
- Downloading Homebrew
- Installing packages via brew/winget
- Installing npm packages (Claude Code, MCP servers)

**Offline alternative**:
Clone the repository on a computer with internet, then transfer:
```bash
# Online computer
git clone https://github.com/ejkim-dev/ai-dev-setup.git
tar -czf ai-dev-setup.tar.gz ai-dev-setup/

# Transfer to offline computer (USB, etc.)

# Offline computer
tar -xzf ai-dev-setup.tar.gz
cd ai-dev-setup
./setup.sh
```

Note: Package downloads will still fail without internet.

---

## Usage Questions

### Why use select_menu instead of [Y/n]?

**User Experience Reasons**:

1. **No typing required** - Arrow keys only
2. **No typos** - Can't accidentally press wrong key
3. **Clear options** - See all choices at once
4. **Consistent interface** - Same pattern everywhere
5. **Accessibility** - Keyboard-only navigation

**Old way** (confusing):
```
Install Node.js? [Y/n]: y
Install Node.js? [Y/n]: yes
Install Node.js? [Y/n]: Yes
Install Node.js? [Y/n]: n
Install Node.js? [Y/n]: no
Install Node.js? [Y/n]: [just Enter]
```

**New way** (clear):
```
  ▸ Install Node.js
    Skip
```

Press ↓ to move cursor, Enter to select. No ambiguity.

---

### What's the auto-linking feature?

**Auto-linking** connects package installation (Step 3) with shell configuration (Step 5).

**Example**:

**Step 3: Install packages**
```
  ▸ [x] zsh-autosuggestions - Command suggestions
    [x] zsh-syntax-highlighting - Syntax highlighting
```

**Step 5: Shell config** (auto-selected based on Step 3)
```
  ▸ [x] Command auto-suggestions config  ← Auto-selected!
    [x] Syntax highlighting config       ← Auto-selected!
```

**If NOT installed** in Step 3:
```
  ▸ [-] Command auto-suggestions config - Not installed  ← Disabled
    [-] Syntax highlighting config - Not installed       ← Disabled
```

**Benefits**:
- No manual configuration needed
- Prevents errors (can't configure what's not installed)
- Logical workflow (install → configure)

---

### What are disabled options?

**Disabled options** appear grayed out with `[-]` marker:

```
  ▸ [x] Node.js - JavaScript runtime (required)
    [-] ripgrep - Fast code search - Already installed
```

**Reasons for disabling**:
1. **Required items**: Node.js cannot be unchecked
2. **Already installed**: No need to reinstall
3. **Dependencies not met**: zsh plugins without plugin installed

**Visual indicators**:
- `[-]` - Disabled checkbox
- Gray text - Cannot be selected
- Space bar does nothing - Cannot toggle

---

### How do I update installed tools?

**Update Homebrew packages**:
```bash
brew update           # Update package list
brew upgrade          # Upgrade all packages
brew upgrade node     # Upgrade specific package
```

**Update npm global packages**:
```bash
npm update -g                           # Update all global packages
npm update -g @anthropic-ai/claude-code # Update specific package
```

**Update Claude Code**:
```bash
npm update -g @anthropic-ai/claude-code
```

**Update MCP servers**:
```bash
npm update -g @anthropic-ai/local-rag-mcp
npm update -g @anthropic-ai/filesystem-mcp
```

**Update Oh My Zsh**:
```bash
omz update
```

---

## Claude Code Questions

### Do I need Claude Code to use Phase 1?

**No.** Phase 1 is a standalone development environment setup.

**Without Claude Code**, you get:
- Terminal with beautiful theme
- Fast shell with auto-suggestions
- Development tools (Node.js, Git, ripgrep)
- Configured shell (.zshrc)

**With Claude Code** (Phase 2), you additionally get:
- AI coding assistant
- Workspace management
- Global agents
- MCP servers

Phase 1 is useful for anyone, not just Claude Code users.

---

### What's claude-workspace?

`claude-workspace` is a **centralized management structure** for Claude Code resources.

**Location**: `~/claude-workspace/`

**Purpose**:
- Store global agents (available in all projects)
- Manage project templates (CLAUDE.md, .mcp.json)
- Back up project-specific settings
- Organize documentation

**Benefits**:
- **Single source of truth**: Update once, apply everywhere
- **Consistency**: Same agents across projects
- **Easy backup**: One directory to backup
- **No duplication**: Symlinks instead of copying

See [WORKSPACE.md](WORKSPACE.md) for details.

---

### What are global agents?

**Global agents** are reusable AI assistants available in all projects.

**Included agents**:

1. **workspace-manager**
   - Connect/disconnect projects
   - Manage symlinks and .gitignore
   - Check workspace status

2. **translate**
   - Multi-language translation (en/ko/ja)
   - Preserve markdown formatting
   - Batch translation

3. **doc-writer**
   - Generate README from code
   - Create CLAUDE.md
   - Write API documentation

**Usage**:
```
/workspace-manager connect ~/projects/my-app
/translate README.md en ko
/doc-writer create-readme
```

**Location**: `~/claude-workspace/global/agents/`

---

### What are MCP servers?

**MCP (Model Context Protocol)** servers extend Claude Code's capabilities.

**Default capabilities** (without MCP):
- Read/write files
- Run terminal commands
- Code analysis

**With MCP servers**:
- **local-rag**: Search documents and code
- **filesystem**: Advanced file operations
- **serena**: Web search
- **fetch**: HTTP requests
- **puppeteer**: Browser automation

**Example**:
```
"Search my project docs for authentication flow"
→ local-rag searches all markdown/PDF files
→ Returns relevant sections
```

**Configuration**: `~/.claude/.mcp.json`

See [PHASE2.md](PHASE2.md) for server details.

---

### Can I use Claude Code without Git?

**Yes**, but you'll miss version control features.

**Without Git**, Claude Code can:
- ✅ Read/write files
- ✅ Run terminal commands
- ✅ Generate code
- ✅ Use MCP servers
- ✅ Chat interface

**Without Git**, Claude Code CANNOT:
- ❌ Track changes (`git status`, `git diff`)
- ❌ Create commits with AI-written messages
- ❌ Create pull requests (`gh pr create`)
- ❌ Manage branches
- ❌ GitHub integration

**Recommendation**: Install Git (Phase 2 does this automatically) for full Claude Code experience.

---

## Technical Questions

### What shell does this use?

**macOS**: zsh (default since macOS Catalina)
**Windows**: PowerShell

**Customization**:
- **macOS**: Oh My Zsh + agnoster theme
- **Windows**: Oh My Posh

**Why zsh?**: Modern shell with better auto-completion, theming, and plugin ecosystem.

---

### Where are configuration files stored?

**Shell configuration**:
- `~/.zshrc` - zsh configuration (macOS)
- `~/.tmux.conf` - tmux configuration (macOS)
- PowerShell profile (Windows)

**Terminal configuration**:
- `~/Library/Preferences/com.apple.Terminal.plist` - Terminal.app (macOS)
- `~/Library/Application Support/iTerm2/DynamicProfiles/` - iTerm2
- `%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_*\LocalState\settings.json` (Windows)

**Claude Code configuration**:
- `~/.claude/` - Claude Code settings
- `~/.claude/.mcp.json` - MCP server configuration
- `~/claude-workspace/` - Workspace management

**Language preference**:
- `~/.dev-setup-lang` - Saved language choice

---

### What's in the .zshrc file?

After ai-dev-setup, your `.zshrc` contains:

```bash
# === ai-dev-setup ===

# Oh My Zsh
ZSH_THEME="agnoster"
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
source $ZSH/oh-my-zsh.sh

# agnoster emoji prompt
prompt_context() {
  emojis=("🔥" "👑" "😎" "🍺" "🐵" "🦄" "🌈" "🚀" "🐧" "🎉")
  RAND_EMOJI_N=$(( $RANDOM % ${#emojis[@]} ))
  prompt_segment black default "%(!.%{%F{yellow}%}.) $USER ${emojis[$RAND_EMOJI_N]} "
}

# zsh-autosuggestions
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# zsh-syntax-highlighting
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Aliases
alias ll="ls -la"
alias gs="git status"
alias gl="git log --oneline -20"

# === End ai-dev-setup ===
```

Everything between markers is managed by ai-dev-setup. You can add your own config before or after these markers.

---

### How do I uninstall everything?

**Important distinction**:

- **Phase 1 cleanup**: Automated script available (removes temporary install files)
- **Phase 2 cleanup**: Manual only (removes your workspace and data - must be careful)

#### Phase 1 Uninstall (Automated)

**Complete removal** (macOS):

```bash
# Run cleanup script
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

**What is NOT removed** (might be used by other apps):
- Homebrew
- Xcode Command Line Tools
- D2Coding font
- Installed packages (Node.js, ripgrep, etc.)

#### Phase 2 Uninstall (Manual Only)

⚠️ **Warning**: This removes your Claude workspace including custom agents, templates, and settings.

**When you might need this**:
- Complete removal - Stop using Claude Code entirely
- Reset configuration - Start fresh due to misconfiguration
- Test rollback - Undo after testing

**Step 1: Backup (Optional but Recommended)**

```bash
# Backup entire workspace
cp -r ~/claude-workspace ~/claude-workspace-backup

# Backup specific items only
cp -r ~/claude-workspace/global/agents ~/agents-backup
cp -r ~/claude-workspace/projects ~/projects-backup
```

**Step 2: Remove Workspace**

```bash
rm -rf ~/claude-workspace
```

**Step 3: Remove Global Symlink**

```bash
rm ~/.claude/agents
```

**Step 4: Remove Project Symlinks**

For each connected project:
```bash
cd /path/to/your/project
rm .claude
rm CLAUDE.md
rm CLAUDE.local.md
```

**Step 5: Uninstall Claude Code CLI (Optional)**

```bash
npm uninstall -g @anthropic-ai/claude-code
```

**Step 6: Uninstall MCP Servers (Optional)**

```bash
npm uninstall -g @anthropic-ai/local-rag-mcp
npm uninstall -g @anthropic-ai/filesystem-mcp
npm uninstall -g serena-mcp
npm uninstall -g @anthropic-ai/fetch-mcp
npm uninstall -g puppeteer-mcp
```

**Step 7: Remove Configuration**

```bash
rm -rf ~/.claude
```

**Restore from Backup**

If you change your mind:
```bash
mv ~/claude-workspace-backup ~/claude-workspace
ln -s ~/claude-workspace/global/agents ~/.claude/agents
```

**Optional: Remove Homebrew and Node.js**

Only if not used by other tools:
```bash
# Remove Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall-tools.sh)"

# Remove Node.js
brew uninstall node
```

---

### Is my data safe?

**Yes.** This installer:

**Does NOT**:
- ❌ Send data to remote servers (except package downloads)
- ❌ Collect telemetry or analytics
- ❌ Modify system files outside home directory
- ❌ Access private data without permission

**Does**:
- ✅ Open source (you can review the code)
- ✅ Uses official package managers (Homebrew, npm)
- ✅ Creates files only in `~/` (home directory)
- ✅ Asks permission for each step

**Privacy**:
- Language preference stored locally (`~/.dev-setup-lang`)
- No external API calls
- Claude Code API key stored locally (`~/.claude/config.json`)

---

## Troubleshooting

### Installation failed, what should I do?

See [TROUBLESHOOTING.md](TROUBLESHOOTING.md) for detailed solutions.

**Quick checks**:
1. **Internet connection**: `ping google.com`
2. **Disk space**: `df -h` (need at least 5GB free)
3. **Permissions**: Run without `sudo` (except where explicitly needed)
4. **Homebrew**: `brew doctor` (fix any issues)
5. **Re-run**: Most errors are transient, try again

---

### Font/theme not working?

See [TROUBLESHOOTING.md - Font and Terminal Issues](TROUBLESHOOTING.md#font-and-terminal-issues)

**Quick fixes**:
1. **Restart Terminal** completely (⌘Q, reopen)
2. **Clear font cache**: `sudo atsutil databases -remove` (macOS)
3. **Re-import profile**: Terminal > Settings > Profiles > Import

---

### Shell plugins not working?

See [TROUBLESHOOTING.md - Shell and Plugin Issues](TROUBLESHOOTING.md#shell-and-plugin-issues)

**Quick fixes**:
1. **Reload shell**: `source ~/.zshrc`
2. **Check installation**: `brew list zsh-autosuggestions`
3. **Check .zshrc**: `cat ~/.zshrc | grep zsh-autosuggestions`

---

## Getting Help

### Where can I get support?

1. **Documentation**:
   - [Phase 1 Guide](PHASE1.md)
   - [Phase 2 Guide](PHASE2.md)
   - [Troubleshooting](TROUBLESHOOTING.md)
   - [Workspace Guide](WORKSPACE.md)

2. **GitHub Issues**: [ai-dev-setup/issues](https://github.com/ejkim-dev/ai-dev-setup/issues)
   - Search existing issues first
   - Include system info and error messages
   - Provide steps to reproduce

3. **Community**:
   - Discussions tab on GitHub
   - Stack Overflow (tag: `ai-dev-setup`)

---

### How can I contribute?

**Ways to contribute**:

1. **Report bugs**: [GitHub Issues](https://github.com/ejkim-dev/ai-dev-setup/issues)
2. **Suggest features**: Discussions or Issues
3. **Improve documentation**: Submit PR for docs
4. **Add translations**: New locale files (locale/*.sh)
5. **Create agents**: Share useful global agents
6. **Test on different systems**: Report compatibility

**Contributing guidelines**: See `CONTRIBUTING.md` in repository.

---

## Related Documentation

- [Phase 1 Setup Guide](PHASE1.md)
- [Phase 2 Setup Guide](PHASE2.md)
- [Workspace Structure](WORKSPACE.md)
- [Troubleshooting Guide](TROUBLESHOOTING.md)
