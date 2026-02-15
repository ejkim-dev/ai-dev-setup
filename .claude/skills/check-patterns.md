---
name: check-patterns
description: Verify UI/UX pattern consistency across the codebase
---

# UI/UX Pattern Consistency Check

Verify that all UI elements follow consistent patterns across the codebase for a unified user experience.

## What This Checks

Execute:
```bash
./.claude/tools/check-patterns.sh
```

### Checks performed:

1. **select_multi usage** - Menu options should use variables
   - ✅ Good: `local opt_item="$MSG_ITEM"; select_multi "$opt_item"`
   - ❌ Bad: `select_multi "hardcoded option"`

2. **Section title format** - Consistent `[n/N] $MSG_TITLE` pattern
   - ✅ Good: `echo -e "${color_cyan}[1/4] $MSG_TITLE${color_reset}"`
   - ❌ Bad: `echo "[1/4] Hardcoded Title"`

3. **Status message functions** - Use `done_msg()` and `skip_msg()`
   - ✅ Good: `done_msg`
   - ❌ Bad: `echo "✅ Done"`

4. **Menu option format** - Consistent "name - description (status)"
   - ✅ Good: `"Node.js - JavaScript runtime (required)"`
   - ❌ Bad: `"Node.js (required) - runtime"`

## Expected Result

```
🎨 Checking UI/UX pattern consistency...

1. select_multi usage pattern:
  ✅ All select_multi calls use variables

2. Section title format:
  ✅ All section titles use MSG_ variables

3. Status message functions:
  ✅ All status messages use done_msg/skip_msg functions

4. Menu option format (spot check):
  ✅ Most options follow variable pattern

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ All pattern checks passed!
```

## If Issues Found

### Hardcoded select_multi Options

**Example error:**
```
⚠️ Potential hardcoded select_multi options:
   ai-tools.sh:102: select_multi "Claude Code" "Gemini CLI"
```

**Fix:**
```bash
# Before
select_multi "Claude Code" "Gemini CLI" "Codex CLI"

# After
local opt_claude="$MSG_AI_TOOL_CLAUDE"
local opt_gemini="$MSG_AI_TOOL_GEMINI"
local opt_codex="$MSG_AI_TOOL_CODEX"

select_multi "$opt_claude" "$opt_gemini" "$opt_codex"
```

### Direct Status Echo

**Example error:**
```
⚠️ Direct status echo instead of using functions:
   done_msg: 3 occurrences
```

**Fix:**
```bash
# Before
echo "  ✅ Installation complete"

# After
done_msg
```

### Inconsistent Option Format

**Example error:**
```
⚠️ Menu option format inconsistent:
   Expected: "name - description (status)"
   Found: "name (status) - description"
```

**Fix:**
```bash
# Before
local opt_item="Node.js (required) - JavaScript runtime"

# After
local opt_item="Node.js - JavaScript runtime ($MSG_REQUIRED)"
```

## Pattern Reference

### Unified Menu Option Pattern

```bash
# Build option with locale messages
local opt_item="$MSG_ITEM_NAME"

# Add description (always with " - ")
opt_item="$MSG_ITEM_NAME - $MSG_ITEM_DESC"

# Add status if needed
[ $installed -eq 1 ] && opt_item="$opt_item - $MSG_ALREADY_INSTALLED"
[ $required -eq 1 ] && opt_item="$opt_item ($MSG_REQUIRED)"
[ $recommended -eq 1 ] && opt_item="$opt_item ($MSG_RECOMMENDED)"

# Result examples:
# "Node.js - JavaScript runtime (required)"
# "ripgrep - Fast code search - Already installed"
# "local-rag - Search docs/code (recommended)"
```

### Status Message Usage

```bash
# Success
done_msg  # Outputs: ✅ $MSG_DONE

# Skipped
skip_msg  # Outputs: ⏭  $MSG_SKIP

# Error (use specific message)
echo "  ❌ $MSG_SPECIFIC_ERROR"
echo "     $MSG_TRY_MANUALLY: command here"
```

## Reference

See `.claude/notes/ui-ux-checklist.md` section 1 (UI/UX Consistency) for complete pattern guidelines.
