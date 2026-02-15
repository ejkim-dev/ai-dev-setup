# CLAUDE.md

## Project Overview

A public repo for setting up development environments in one step. Supports macOS + Windows. Designed for terminal beginners to set up a dev environment with a single script.

## Structure

```
setup.sh              — [177 lines] Main orchestration only (macOS)
setup.ps1             — Windows install (PowerShell, 8 steps)
Brewfile              — Homebrew packages (macOS only)
lib/                  — Shared utilities (macOS)
├── colors.sh         — [16 lines] Terminal color codes
├── core.sh           — [46 lines] Global variables, step(), done_msg(), skip_msg(), ask_yn()
├── ui.sh             — [220 lines] UI components (spinner, select_menu, select_multi)
└── installer.sh      — [81 lines] Package installation wrappers
modules/              — Domain-specific logic (macOS)
├── xcode.sh          — [20 lines] Xcode CLI Tools installation
├── homebrew.sh       — [86 lines] Homebrew setup with error handling
├── packages.sh       — [42 lines] Essential packages via Brewfile
├── fonts.sh          — [40 lines] Font installation (D2Coding)
├── terminal.sh       — [153 lines] Terminal.app and iTerm2 configuration
├── shell.sh          — [141 lines] Oh My Zsh and .zshrc customization
├── tmux.sh           — [36 lines] tmux configuration
└── ai-tools.sh       — [112 lines] AI CLI tools (Claude Code, Gemini CLI, etc.)
configs/
├── mac/              — Terminal.app profile
├── windows/          — Windows Terminal theme
└── shared/           — .zshrc, .tmux.conf (macOS only)
claude-code/
├── setup-claude.sh   — Claude Code setup (macOS)
├── setup-claude.ps1  — Claude Code setup (Windows)
├── agents/           — Global agents (workspace-manager, translate, doc-writer)
├── locale/           — i18n strings (en, ko, ja)
├── templates/        — .mcp.json templates (placeholder substitution)
└── examples/         — CLAUDE.md, MEMORY.md examples
.claude/              — (gitignored) Project-specific Claude settings
├── agents/           — Project-specific agents
├── mcp/              — Local MCP server configs
├── tools/            — Custom tools
└── notes/            — Private development notes
CLAUDE.local.md       — (gitignored) Personal local settings and notes
```

## Core Design Principles

- **Every step is optional**: Interactive menus (select_menu, select_multi) with clear options
- **Beginner-friendly**: Minimal technical jargon, clear explanations, visual progress (spinners)
- **Modular architecture**: lib/ (utilities) + modules/ (domain logic) for testability (macOS)
- **OS-specific separation**: macOS (setup.sh) / Windows (setup.ps1) as separate scripts
- **Two-phase setup**: Basic environment → Claude Code additional setup runs separately
- **Template substitution**: MCP templates use `__PLACEHOLDER__` replaced by sed/PowerShell
- **i18n support**: Language selected at setup start, all messages switch to that language via locale files

## OS Differences

| Item | macOS | Windows |
|------|-------|---------|
| Package manager | Homebrew | winget |
| Terminal theme | Dev.terminal + iTerm2 | Windows Terminal settings.json |
| Shell theme | Oh My Zsh | Oh My Posh |
| Clipboard copy | pbcopy | Set-Clipboard |
| Font install | brew cask | winget |
| Symlinks | ln -s | New-Item -ItemType SymbolicLink |

## Script Rules

- macOS: `set -e`, bash, modular architecture (lib/ + modules/)
- Windows: `$ErrorActionPreference = "Stop"`, PowerShell 5.1+
- Common: Color output (cyan=step, green=done, yellow=skip) via lib/colors.sh
- Common: Auto-detect already-installed tools and skip
- Common: UI components (select_menu, select_multi, spinner) via lib/ui.sh
- Common: `ask_yn()` in lib/core.sh for legacy Y/n prompts (prefer select_menu)
- Common: Locale files sourced after language selection for all UI strings
- Modules: Each module = single responsibility, clear dependencies, independently testable

## Code Quality & UI/UX Consistency

**IMPORTANT**: Before making any changes, review `.claude/notes/ui-ux-checklist.md` for complete guidelines.

**Critical Rules**:
1. **No hardcoding**: All user-facing text must use `$MSG_*` variables from locale files (en.sh, ko.sh, ja.sh)
2. **Pattern consistency**: Menu options follow `"name - description (status)"` format
3. **Locale completeness**: Add messages to all 3 locale files simultaneously
4. **Single responsibility**: Functions < 50 lines, one purpose per function
5. **Module separation**: lib/ (utilities) + modules/ (domain logic), no cross-contamination

**Menu Option Pattern** (unified across all menus):
```bash
# Build option with locale messages and status
local opt_item="$MSG_ITEM"
[ $installed -eq 1 ] && opt_item="$opt_item - $MSG_ALREADY_INSTALLED"
[ $required -eq 1 ] && opt_item="$opt_item ($MSG_REQUIRED)"
[ $recommended -eq 1 ] && opt_item="$opt_item ($MSG_RECOMMENDED)"

# Result: "Node.js - Already installed" or "local-rag - Search docs/code (recommended)"
```

**Auto-check tools** (use before committing):
```bash
.claude/tools/check-hardcoding.sh   # Find hardcoded strings
.claude/tools/check-patterns.sh     # Verify UI/UX patterns
.claude/tools/check-locale.sh       # Check locale completeness
```

**When adding new features**:
1. Check existing patterns in `.claude/notes/ui-ux-checklist.md`
2. Add locale messages first (en, ko, ja)
3. Use variables for all options
4. Run check scripts before committing

## Project-specific Claude Settings

**Use `.claude/` for all project-local Claude Code resources:**
- MCP servers installed for this project → `.claude/mcp/`
- Project-specific agents → `.claude/agents/`
- Custom tools → `.claude/tools/`
- Private notes → `.claude/notes/` or `CLAUDE.local.md`

**CLAUDE.local.md pattern:**
- `CLAUDE.md` — Team-shared rules (committed to git)
- `CLAUDE.local.md` — Personal local settings (gitignored)

This keeps project-specific Claude resources isolated from global `~/.claude/` config.
