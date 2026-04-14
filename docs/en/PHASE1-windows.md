# Phase 1: Basic Development Environment (Windows)

Set up essential development tools and terminal environment on Windows.

**For macOS?** → [See macOS guide](PHASE1-macOS.md)

## Overview

**Goal**: Install package manager, development tools, terminal themes, and shell customization

**Target Users**:
- Terminal beginners
- New Windows setup
- Anyone wanting a consistent development environment

**Time Required**: 15-30 minutes (depending on internet speed)

---

## What Gets Installed (Windows)

| Tool | Description | Installed |
|------|-------------|:---------:|
| **winget** | Package manager (Windows 11) | ✅ |
| **Node.js** | JavaScript runtime (required) | ✅ |
| **ripgrep** | Fast code search tool | ✅ |
| **D2Coding Font** | Coding font with Korean support | ✅ |
| **Git** | Version control | ✅ |
| **Windows Terminal** | Modern terminal (optional) | ⚪ |
| **Oh My Posh** | PowerShell prompt theme | ✅ |

---

## Installation Steps

### Before You Start: Open PowerShell

**Option 1: Using Windows Key (Recommended)**
1. Press `Win + X`
2. Select "Windows PowerShell (Admin)" or "PowerShell (Admin)"
   - **Important**: Choose the one with "(Admin)" for administrator privileges

**Option 2: Using Run Dialog**
1. Press `Win + R`
2. Type `powershell`
3. Press Enter
4. Right-click the window title → "Run as administrator"

**Option 3: Using Windows Terminal (if installed)**
1. Press `Win + X`
2. Select "Windows Terminal (Admin)"
3. Click the dropdown arrow → Select "PowerShell"

⚠️ **Important**: You MUST run PowerShell as administrator. Look for **(Admin)** label in the window title.

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
- Your choice is saved to `%USERPROFILE%\.dev-setup-lang` for future runs

---

### Step 1: winget (Package Manager)

**What it does**: Verifies winget is available on your system

**Auto-detection**: Automatically skips if not available

**About winget**:
- Built into Windows 11
- Windows 10 21H2 or later: Can be installed from Microsoft Store
- Uses PowerShell for package management

**If not available**:
```
❌ winget not found

winget is a built-in package manager for Windows 11.

For Windows 10 (21H2+):
  1. Open Microsoft Store
  2. Search for "App Installer"
  3. Click Install

For earlier versions:
  Please upgrade to Windows 10 21H2 or Windows 11
```

---

### Step 2: Essential Packages

Installs required development tools via winget:

```
[2/6] Essential Packages

  Installing packages...
  → Node.js
  → Git
  → ripgrep
  → D2Coding Font
```

**Package details**:

#### Node.js (required)
- JavaScript runtime environment
- Required for Claude Code and other AI tools
- Includes npm for installing packages

#### Git
- Version control system
- Recommended for Claude Code's version control features
- Tracks code changes and generates commits

#### ripgrep
- Fast code search tool (faster than Windows search)
- Used by modern development tools
- Alternative: fzf for fuzzy file finding

#### D2Coding Font
- Monospace coding font
- Excellent Korean character support
- Readable and clean design

---

### Step 3: Windows Terminal Setup

Choose whether to apply Windows Terminal theme and fonts:

```
[3/6] Windows Terminal

  Windows Terminal provides a modern terminal experience.

  Windows Terminal installed?
  
    ▸ Yes - Apply Dev theme
      No - Install first?
      Skip
```

**What gets configured**:
- **Dev color scheme**: Custom dark theme
- **D2Coding font**: Set as default (11pt)
- **Opacity**: 95% transparency
- **Default profile**: PowerShell

**Requirements**:
- Windows Terminal must be installed (built-in on Windows 11)
- Or install from Microsoft Store on Windows 10

**Manual installation (if needed)**:
```powershell
winget install --id Microsoft.WindowsTerminal
```

---

### Step 4: Oh My Posh

**What it does**: Installs Oh My Posh for beautiful PowerShell prompts

```
[4/6] Oh My Posh

  Customize your PowerShell prompt with themes.

  ▸ Install Oh My Posh
    Skip
```

**After installation**, add to your PowerShell profile:

```powershell
oh-my-posh init pwsh | Invoke-Expression
```

**What you'll see**:
- Current directory path
- Git branch and status (if in a git repo)
- Beautiful icons and colors
- Custom prompt theme

**Profile location**:
- Typically: `%USERPROFILE%\Documents\PowerShell\profile.ps1`

---

### Step 5: Wrap-up

**Actions taken**:
1. Saves language selection to `%USERPROFILE%\.dev-setup-lang`
2. Copies Phase 2 files to `%USERPROFILE%\claude-code-setup\`
3. Verifies all required files were copied
4. Deletes installation directory (cleanup)

**Phase 2 Prompt**:

```
✨ Phase 1 Complete!

  Next: Phase 2 - Claude Code Setup (optional)

  • Workspace management (central config)
  • Shared agents (workspace-manager, translate, doc-writer)
  • MCP servers (document search)
  • Obsidian integration

Continue to Phase 2 now?

  ▸ Yes, open new PowerShell
    No, run manually later
```

**Option 1: Yes, open new PowerShell** (recommended)
- Opens new PowerShell window with admin privileges
- Automatically runs Phase 2 setup
- Ensures PATH and profile are loaded

**Option 2: No, run manually later**
- Shows command to run later: `~\claude-code-setup\setup-claude.ps1`

---

## UI/UX Patterns

### Arrow-Key Navigation

**All menus use arrow keys** - no typing required:
- ↑↓ - Navigate options
- Space - Toggle selection (multi-select menus)
- Enter - Confirm selection

### Visual Indicators

- `▸ Option` - Currently selected (cyan color)
- `  Option` - Not selected
- ✅ Done (green)
- ⏭️ Skipped (yellow)
- ❌ Failed (red)

---

## Error Handling

### winget Not Available

**Important on Windows 10**:
- Windows 11: Built-in, should work
- Windows 10 21H2+: Install "App Installer" from Microsoft Store
- Earlier versions: Upgrade Windows

```
❌ winget not available

Please install App Installer from Microsoft Store:
  https://www.microsoft.com/store/productId/9NBLGGH4NNS1

Then re-run this script.
```

### Node.js Installation Failed

**Critical error** - Phase 1 cannot complete without Node.js:

```
❌ Node.js installation failed

Node.js is required for AI coding tools.

Please install manually:
  winget install --id OpenJS.NodeJS.LTS

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

### PATH Not Refreshed

If installed tools aren't found immediately:

```
⚠️ Tools installed, but PATH needs refresh

Please close and open a new PowerShell window (as administrator)
to complete setup.
```

**Solution**: Close PowerShell and open a new one.

---

## Success Criteria

### Minimum Requirements (Phase 1 Complete)
- ✅ winget verified or unavailable on older Windows
- ✅ Node.js installed and working
- ✅ Git installed (recommended)
- ✅ Phase 2 files copied to `%USERPROFILE%\claude-code-setup\`
- ✅ Installation directory cleaned up

### Optional Success
- ⚪ Windows Terminal theme applied (user choice)
- ⚪ Oh My Posh installed (user choice)

---

## What's Next?

After Phase 1, you can:

1. **Proceed to Phase 2** (recommended for Claude Code users)
   - Claude Code CLI installation
   - Shared agents installation
   - MCP servers configuration
   - Obsidian integration

2. **Skip Phase 2 and start coding**
   - You have a complete development environment
   - Terminal is configured with theme and plugins

3. **Run Phase 2 later**
   - Anytime: Open PowerShell (Admin) and run `~\claude-code-setup\setup-claude.ps1`
   - Language preference is saved

---

## Troubleshooting

See [TROUBLESHOOTING.md](TROUBLESHOOTING.md) for common issues and solutions.

## FAQ

See [FAQ.md](FAQ.md) for frequently asked questions.
