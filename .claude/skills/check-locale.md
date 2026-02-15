---
name: check-locale
description: Check locale file completeness (all 3 languages have same variables)
---

# Locale Completeness Check

Verify that all 3 locale files (en, ko, ja) have the same `MSG_*` variables and no missing translations.

## What This Checks

Execute:
```bash
./.claude/tools/check-locale.sh
```

### Checks performed:

1. **Variable count** - Extract all `MSG_*` variables from each locale file
   - `locale/en.sh` (reference)
   - `locale/ko.sh` (Korean)
   - `locale/ja.sh` (Japanese)

2. **Completeness** - Compare ko.sh and ja.sh against en.sh
   - Find missing variables
   - Find extra variables (not in en.sh)

3. **Empty values** - Check for `MSG_VAR=""`
   - All variables should have non-empty values

## Expected Result

```
🌐 Checking locale file completeness...

1. Extracting MSG_ variables...
  en.sh: 229 variables
  ko.sh: 229 variables
  ja.sh: 229 variables

2. Korean (ko.sh) vs English (en.sh):
  ✅ Complete (matches en.sh)

3. Japanese (ja.sh) vs English (en.sh):
  ✅ Complete (matches en.sh)

4. Checking for empty values:
  ✅ No empty values found

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ All locale files are complete and consistent!
```

## If Issues Found

### Missing Variables

**Example error:**
```
❌ Mismatch found:
   Missing in ko.sh:
     MSG_MCP_SERVER_GITHUB
     MSG_DOCKER_DESC
```

**Fix:**
Add missing variables to ko.sh:
```bash
# locale/ko.sh
MSG_MCP_SERVER_GITHUB="github - GitHub API"
MSG_DOCKER_DESC="Docker - 컨테이너 플랫폼"
```

### Extra Variables

**Example error:**
```
❌ Mismatch found:
   Extra in ko.sh (not in en.sh):
     MSG_OLD_FEATURE
```

**Fix:**
Remove extra variable from ko.sh or add to all 3 files if needed.

### Empty Values

**Example error:**
```
⚠️ Empty values found:
   ko.sh: 2 empty values
```

**Fix:**
Find and fill empty variables:
```bash
# Before
MSG_SOME_VAR=""

# After
MSG_SOME_VAR="Some translated text"
```

## Best Practice

**When adding new messages:**

1. Add to **all 3 files simultaneously**:
   ```bash
   # locale/en.sh
   MSG_NEW_FEATURE="New feature description"

   # locale/ko.sh
   MSG_NEW_FEATURE="새 기능 설명"

   # locale/ja.sh
   MSG_NEW_FEATURE="新機能の説明"
   ```

2. Run this check before committing:
   ```bash
   /check-locale
   ```

## Reference

See `.claude/notes/ui-ux-checklist.md` section 2.1 (Text Hardcoding) for locale usage guidelines.
