---
name: check-ui
description: Run all UI/UX consistency and quality checks
---

# UI/UX Consistency Check

Run all quality checks for the ai-dev-setup project to ensure consistent UI/UX patterns, proper localization, and code quality.

## Checks to Run

Execute the following checks **in order** and report results:

### 1. Hardcoding Check
```bash
./.claude/tools/check-hardcoding.sh
```

**What it checks:**
- Korean/Japanese/English text hardcoded in bash scripts
- User-facing messages without `$MSG_*` variables
- Hardcoded paths (`/Users/` without `$HOME`)

**Expected:** ✅ All checks passed

---

### 2. Pattern Check
```bash
./.claude/tools/check-patterns.sh
```

**What it checks:**
- `select_multi` usage (should use variables, not hardcoded strings)
- Section title format (`[n/N] $MSG_TITLE`)
- Status message functions (`done_msg`, `skip_msg` usage)
- Menu option format consistency

**Expected:** ✅ All pattern checks passed

---

### 3. Locale Check
```bash
./.claude/tools/check-locale.sh
```

**What it checks:**
- en.sh, ko.sh, ja.sh have same `MSG_*` variables
- No missing translations
- No empty values

**Expected:** ✅ All locale files are complete and consistent

---

## Output Format

Report summary in this format:

```
🔍 UI/UX Consistency Check Results
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

1. Hardcoding Check:    ✅ Passed / ❌ Failed
   - Korean: 0 issues
   - English: 0 issues
   - Paths: 0 issues

2. Pattern Check:       ✅ Passed / ❌ Failed
   - select_multi: OK
   - Section titles: OK
   - Status messages: OK

3. Locale Check:        ✅ Passed / ❌ Failed
   - en.sh: 229 variables
   - ko.sh: 229 variables
   - ja.sh: 229 variables

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Overall: ✅ All checks passed! / ❌ X issue(s) found
```

If any check fails, show the detailed error output and suggest fixes based on `.claude/notes/ui-ux-checklist.md`.

## When to Use

- Before committing code changes
- After adding new features or UI elements
- When modifying menu options or user-facing text
- During code review
- When user asks to verify consistency
