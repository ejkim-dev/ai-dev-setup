#!/bin/bash
# Check UI/UX pattern consistency

echo "🎨 Checking UI/UX pattern consistency..."
echo ""

SCRIPT_DIR="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$SCRIPT_DIR"

errors=0

# 1. select_multi usage (should use variables, not hardcoded options)
echo "1. select_multi usage pattern:"
result=$(grep -A 3 "select_multi" setup.sh lib/*.sh modules/*.sh claude-code/setup-claude.sh 2>/dev/null | \
  grep -v "local opt_" | \
  grep -v "^\-\-$" | \
  grep '".*"' | \
  grep -v '\$opt_' | \
  grep -v '\$MSG_')
if [ -n "$result" ]; then
  echo "  ⚠️  Potential hardcoded select_multi options:"
  echo "$result" | sed 's/^/     /'
  echo "  → Use variables: local opt_item=\"\$MSG_ITEM - description\""
  ((errors++))
else
  echo "  ✅ All select_multi calls use variables"
fi
echo ""

# 2. Section title format ([n/N] $MSG_TITLE)
echo "2. Section title format:"
result=$(grep -n '\[.*\]' setup.sh lib/*.sh modules/*.sh claude-code/setup-claude.sh 2>/dev/null | \
  grep 'echo' | \
  grep -v '\$MSG_' | \
  grep -v '^[[:space:]]*#' | \
  grep -v 'x\]' | \
  grep -v ' \]')
if [ -n "$result" ]; then
  echo "  ⚠️  Section titles without MSG_ variable:"
  echo "$result" | sed 's/^/     /'
  echo "  → Use: echo -e \"\${color_cyan}[1/4] \$MSG_TITLE\${color_reset}\""
  ((errors++))
else
  echo "  ✅ All section titles use MSG_ variables"
fi
echo ""

# 3. Status message usage (done_msg, skip_msg)
echo "3. Status message functions:"
direct_done=$(grep -n 'echo.*✅' setup.sh lib/*.sh modules/*.sh claude-code/setup-claude.sh 2>/dev/null | \
  grep -v 'done_msg' | \
  grep -v '^[[:space:]]*#' | \
  grep -v 'echo "  ✅' | \
  wc -l | tr -d ' ')
direct_skip=$(grep -n 'echo.*⏭' setup.sh lib/*.sh modules/*.sh claude-code/setup-claude.sh 2>/dev/null | \
  grep -v 'skip_msg' | \
  grep -v '^[[:space:]]*#' | \
  wc -l | tr -d ' ')

if [ "$direct_done" -gt 0 ] || [ "$direct_skip" -gt 0 ]; then
  echo "  ⚠️  Direct status echo instead of using functions:"
  echo "     done_msg: $direct_done occurrences"
  echo "     skip_msg: $direct_skip occurrences"
  echo "  → Use: done_msg() or skip_msg() functions"
  ((errors++))
else
  echo "  ✅ All status messages use done_msg/skip_msg functions"
fi
echo ""

# 4. Menu option format (name - description pattern)
echo "4. Menu option format (spot check):"
# This is a heuristic check - manual review still needed
inconsistent=$(grep "select_multi" -A 10 setup.sh lib/*.sh modules/*.sh claude-code/setup-claude.sh 2>/dev/null | \
  grep '"' | \
  grep -v '\$opt_' | \
  grep -v '^\-\-$' | \
  grep -v 'select_multi' | \
  wc -l | tr -d ' ')

if [ "$inconsistent" -gt 5 ]; then
  echo "  ⚠️  Many options without \$opt_ pattern detected"
  echo "     Review select_multi calls for consistency"
  echo "  → Pattern: local opt_item=\"\$MSG_NAME - description (\$MSG_STATUS)\""
  ((errors++))
else
  echo "  ✅ Most options follow variable pattern"
fi
echo ""

# Summary
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
if [ $errors -eq 0 ]; then
  echo "✅ All pattern checks passed!"
else
  echo "❌ Found $errors pattern issue(s)."
  echo "   Review .claude/notes/ui-ux-checklist.md for correct patterns."
  exit 1
fi
