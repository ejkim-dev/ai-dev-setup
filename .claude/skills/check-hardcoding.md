---
name: check-hardcoding
description: Check for hardcoded strings (should use locale variables)
---

# Hardcoding Check

Check for hardcoded user-facing text in bash scripts. All user-facing text should use `$MSG_*` variables from locale files.

## What This Checks

Execute:
```bash
./.claude/tools/check-hardcoding.sh
```

### Checks performed:

1. **Korean hardcoding** - `echo` with Korean characters (가-힣)
   - Should use: `$MSG_VARIABLE` from locale/ko.sh

2. **English hardcoding** - User-facing English text without `$MSG_*`
   - Should use: `$MSG_VARIABLE` from locale/en.sh

3. **Japanese hardcoding** - `echo` with Japanese characters (ぁ-んァ-ヶ)
   - Should use: `$MSG_VARIABLE` from locale/ja.sh

4. **Path hardcoding** - `/Users/` without `$HOME`
   - Should use: `$HOME` or `$SCRIPT_DIR`

## Expected Result

```
🔍 Checking for hardcoded strings...

1. Korean hardcoding in bash scripts:
  ✅ No hardcoded Korean found

2. English hardcoding (user-facing messages):
  ✅ No obvious hardcoded English found

3. Path hardcoding:
  ✅ No hardcoded paths found

4. Japanese hardcoding in bash scripts:
  ✅ No hardcoded Japanese found

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ All checks passed!
```

## If Issues Found

**Example error:**
```
❌ Found hardcoded Korean:
   setup.sh:33:echo "언어를 선택하세요:"
```

**Fix:**
1. Add to locale files:
   ```bash
   # locale/ko.sh
   MSG_SELECT_LANG="언어를 선택하세요:"

   # locale/en.sh
   MSG_SELECT_LANG="Select your language:"

   # locale/ja.sh
   MSG_SELECT_LANG="言語を選択してください:"
   ```

2. Update code:
   ```bash
   # Before
   echo "언어를 선택하세요:"

   # After
   echo "$MSG_SELECT_LANG"
   ```

## Reference

See `.claude/notes/ui-ux-checklist.md` section 2 (Hardcoding Check) for complete guidelines.
