# CLAUDE.md

## Project Overview

A public repo for setting up development environments in one step. Supports macOS + Windows. Designed for terminal beginners to set up a dev environment with a single script.

## Structure

```
setup.sh              — macOS install (bash, 9 steps)
setup.ps1             — Windows install (PowerShell, 8 steps)
Brewfile              — Homebrew packages (macOS only)
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

- **Every step is optional**: Everything except essential tools asks [Y/n]
- **Beginner-friendly**: Minimal technical jargon, clear explanations
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

- macOS: `set -e`, bash
- Windows: `$ErrorActionPreference = "Stop"`, PowerShell 5.1+
- Common: Color output (cyan=step, green=done, yellow=skip)
- Common: Auto-detect already-installed tools and skip
- Common: `ask_yn()` / `Ask-YN()` for unified Y/n prompts
- Common: Locale files sourced after language selection for all UI strings

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
