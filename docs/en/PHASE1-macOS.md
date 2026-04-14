# Phase 1: Basic Development Environment (macOS)

Set up essential development tools and terminal environment on macOS.

**For Windows?** → [See Windows guide](PHASE1-windows.md)

## Overview

**Goal**: Install package manager, development tools, terminal themes, and shell customization

**Target Users**:
- Terminal beginners
- New Mac setup
- Anyone wanting a consistent development environment

**Time Required**: 15-30 minutes (depending on internet speed)

---

## What Gets Installed (macOS)

| Tool | Description | Installed |
|------|-------------|:---------:|
| **Xcode Command Line Tools** | Git, make, gcc, and other dev tools | ✅ |
| **Homebrew** | Package manager | ✅ |
| **Node.js** | JavaScript runtime (required) | ✅ |
| **ripgrep** | Fast code search tool | ✅ |
| **D2Coding Font** | Coding font with Korean support | ✅ |
| **zsh-autosuggestions** | Command auto-completion | ✅ |
| **zsh-syntax-highlighting** | Syntax highlighting | ✅ |
| **Terminal.app theme** | Dark theme profile | ✅ |
| **iTerm2** | Advanced terminal (optional) | ⚪ |
| **Oh My Zsh** | Shell theme + plugins | ✅ |
| **tmux** | Terminal multiplexer | ✅ |

---

## Installation Steps

### Before You Start: Open Terminal

**Option 1: Using Spotlight Search (Recommended)**
1. Press `Cmd + Space`
2. Type `terminal`
3. Press Enter

**Option 2: Using Finder**
1. Open Finder
2. Go to Applications → Utilities
3. Double-click "Terminal"

**Option 3: Using LaunchPad**
1. Click the LaunchPad icon in Dock
2. Search for "Terminal"
3. Click "Terminal"

---

### Step 0: Language Selection

Choose your preferred language at startup:

```
Select your language:

  ▸ English
    한국어
    日本語
```

- Navigate: ↑↓ arrow keys
- Select: Enter
- Your choice is saved to `~/.dev-setup-lang` for future runs

---

### Step 1: Xcode Command Line Tools

**What it does**: Installs Git, make, gcc, and other essential development tools

**Auto-detection**: If already installed, automatically skips this step

**If not installed**:
```
[1/7] Xcode Command Line Tools

  Required for Git, make, and other developer tools.

  ▸ Install Xcode Command Line Tools
    Skip (installation will fail)
```

**Installation**: A GUI dialog appears. Click "Install" and agree to the license.

**Error handling**:
- Already installing: "Installation in progress" message
- Installation failed: Retry instructions provided

---

### Step 2: Homebrew (Package Manager)

**What it does**: Installs Homebrew package manager

**Auto-detection**: If already installed, automatically skips this step

**If not installed**:
```
[2/7] Homebrew (Package Manager)

  Required for installing development tools.
  Official site: https://brew.sh

  ▸ Install Homebrew
    Skip (cannot install packages)
```

**What it does**: Downloads and installs Homebrew from the official script

**After installation**: On Apple Silicon Macs, automatically adds Homebrew to PATH

---

### Step 3: Essential Packages

**Multi-select menu** with arrow-key navigation:

```
[3/7] Essential Packages

  Select packages to install:

  ▸ [x] Node.js - JavaScript runtime (required)
    [x] ripgrep - Fast code search
    [x] D2Coding Font - Korean coding font
    [x] zsh-autosuggestions - Command suggestions
    [x] zsh-syntax-highlighting - Syntax highlighting

  ↑↓: navigate | Space: toggle | Enter: confirm
```

**Features**:
- **Required items**: Node.js cannot be unchecked (required for AI tools)
- **Already installed**: Shows "- Already installed" and is disabled
- **Default selection**: All packages are checked by default
- **Installation**: Each selected package is installed via Homebrew

**Package details**:

#### Node.js (required)
- JavaScript runtime environment
- Required for Claude Code and other AI tools
- Includes npm for installing packages

#### ripgrep
- Fast code search tool (faster than grep)
- Used by many modern development tools

#### D2Coding Font
- Monospace coding font
- Excellent Korean character support
- Readable and clean design

#### zsh-autosuggestions
- Shows suggestions based on command history
- Press → to accept suggestion
- Speeds up terminal workflow

#### zsh-syntax-highlighting
- Highlights valid/invalid commands
- Green = valid command
- Red = invalid command

---

### Step 4: Terminal Setup

Choose which terminal application(s) to configure:

```
[4/7] Terminal Setup

  Choose terminal application:

  ▸ Terminal.app only (with Dev theme)
    iTerm2 only
    Both Terminal.app + iTerm2
    Skip
```

**Option 1: Terminal.app only**
- Imports Dev dark theme profile
- Sets D2Coding font (11pt)
- Applies custom color scheme
- Sets as default profile

**Option 2: iTerm2 only**
- Installs iTerm2 via Homebrew
- Applies Dev profile
- Sets D2Coding font

**Option 3: Both**
- Configures both Terminal.app and iTerm2
- You can switch between them anytime

**Option 4: Skip**
- No terminal configuration
- Keeps current settings

**Font check**: If D2Coding font is not installed, prompts to install it before applying theme

---

### Step 5: Shell Customization

#### Part 1: Oh My Zsh Installation

If not already installed:

```
[5/7] Shell Setup

  Oh My Zsh provides beautiful theme and plugins for zsh.

  ▸ Install Oh My Zsh
    Skip
```

**What it does**: Downloads and installs Oh My Zsh framework for zsh

#### Part 2: .zshrc Customization

**Multi-select menu** for shell features:

```
  Customize .zshrc

  ▸ [x] agnoster theme + random emoji
    [x] Command auto-suggestions config
    [x] Syntax highlighting config
    [ ] Useful aliases (ll, gs, gl)

  ↑↓: navigate | Space: toggle | Enter: confirm
```

**Auto-linking feature**:
- If zsh-autosuggestions was installed in Step 3, it's auto-selected here
- If zsh-syntax-highlighting was installed in Step 3, it's auto-selected here
- If NOT installed, shows "Not installed" and is disabled

**Customization details**:

#### agnoster theme + emoji
- Shows current directory and Git branch
- Random emoji in prompt (changes each session)
- Color-coded Git status

#### Command auto-suggestions
- Sources zsh-autosuggestions from Homebrew location
- Only available if installed in Step 3

#### Syntax highlighting
- Sources zsh-syntax-highlighting from Homebrew location
- Only available if installed in Step 3

#### Useful aliases
- `ll` → `ls -la` (detailed file listing)
- `gs` → `git status`
- `gl` → `git log --oneline -20`

**What happens**: Selected configurations are added to `~/.zshrc` between markers:
```bash
# === ai-dev-setup ===
[your configurations]
# === End ai-dev-setup ===
```

---

### Step 6: tmux (Terminal Multiplexer)

Terminal multiplexer for split panes and session management.

```
[6/7] tmux (Terminal Multiplexer)

  Split terminal windows and manage sessions.

  ▸ Install tmux
    Skip
```

**What it does**:
- Installs tmux via Homebrew
- Copies `.tmux.conf` configuration file to your home directory
- Enables split panes, session management, and more

**Basic tmux commands** (after installation):
- `tmux` - Start new session
- `Ctrl+b %` - Split vertically
- `Ctrl+b "` - Split horizontally
- `Ctrl+b arrow` - Navigate panes

---

### Step 7: Wrap-up

**Actions taken**:
1. Saves language selection to `~/.dev-setup-lang`
2. Copies Phase 2 files to `~/claude-code-setup/`
3. Verifies all required files were copied
4. Deletes installation directory (cleanup)

**Phase 2 Prompt**:

```
✨ Phase 1 Complete!

  Next: Phase 2 - Claude Code Setup (optional)

  • Workspace management (central config)
  • Shared agents (workspace-manager, translate, doc-writer)
  • MCP servers (document search)
  • Git + GitHub (recommended for Claude features)

Continue to Phase 2 now?

  ▸ Yes, open new terminal
    No, run manually later
```

**Option 1: Yes, open new terminal** (recommended)
- Opens new Terminal.app window
- Automatically runs Phase 2 setup
- Ensures new PATH and shell configs are loaded

**Option 2: No, run manually later**
- Shows command to run later: `~/claude-code-setup/setup-claude.sh`

---

## UI/UX Patterns

### Arrow-Key Navigation

**All menus use arrow keys** - no typing required:
- ↑↓ - Navigate options
- Space - Toggle selection (multi-select menus)
- Enter - Confirm selection

### Multi-Select Menus

Visual indicators:
- `[x]` - Selected
- `[ ]` - Not selected
- `[-]` - Disabled (cannot be changed)
- `▸` - Current cursor position

Color coding:
- Cyan - Selected items
- Gray - Disabled items
- Bold - Current item

### Status Messages

- ✅ `Done` - Green, successful completion
- ⏭️ `Skipped` - Yellow, intentionally skipped
- ❌ `Failed` - Red, error occurred (with solution)

---

## Error Handling

### Node.js Installation Failed

**Critical error** - Phase 1 cannot complete without Node.js:

```
❌ Node.js installation failed

Node.js is required for AI coding tools.

Please install manually:
  brew install node

Then verify:
  node --version
```

Script exits and provides manual installation instructions.

### Package Installation Failed

**Non-critical** - Phase 1 continues:

```
⚠️ ripgrep installation returned error, continuing...
```

Logs warning but doesn't stop the installation process.

### Terminal Profile Import Failed

**Recoverable** - Provides manual instructions:

```
⚠️ Terminal profile import failed

📋 Please import manually:
   Terminal > Settings (⌘,) > Profiles > Import...
   Select: /path/to/Dev.terminal
```

### Homebrew Not Available

**Critical** - Cannot proceed without package manager:

```
❌ Homebrew not available

Please install Homebrew first:
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

Then re-run this script.
```

---

## Success Criteria

### Minimum Requirements (Phase 1 Complete)
- ✅ Xcode Command Line Tools installed
- ✅ Homebrew installed and working
- ✅ Node.js installed and working
- ✅ Phase 2 files copied to `~/claude-code-setup/`
- ✅ Installation directory cleaned up

### Optional Success
- ⚪ Terminal theme applied (user choice)
- ⚪ Oh My Zsh installed (user choice)
- ⚪ tmux installed (user choice)

---

## What's Next?

After Phase 1, you can:

1. **Proceed to Phase 2** (recommended for Claude Code users)
   - Claude Code CLI installation
   - Shared agents installation
   - MCP servers configuration

2. **Skip Phase 2 and start coding**
   - You have a complete development environment
   - Terminal is configured with theme and plugins
   - Shell aliases are ready to use

3. **Run Phase 2 later**
   - Anytime: `~/claude-code-setup/setup-claude.sh`
   - Language preference is saved

---

## Troubleshooting

See [TROUBLESHOOTING.md](TROUBLESHOOTING.md) for common issues and solutions.

## FAQ

See [FAQ.md](FAQ.md) for frequently asked questions.
