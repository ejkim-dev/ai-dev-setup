#!/bin/bash
# Check for hardcoded strings (should use locale variables instead)

echo "🔍 Checking for hardcoded strings..."
echo ""

SCRIPT_DIR="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$SCRIPT_DIR"

errors=0

# 1. Korean hardcoding in bash scripts
echo "1. Korean hardcoding in bash scripts:"
result=$(grep -rn "echo.*[가-힣]" setup.sh lib/*.sh modules/*.sh claude-code/setup-claude.sh 2>/dev/null | grep -v '\$MSG_' | grep -v '^[[:space:]]*#')
if [ -n "$result" ]; then
  echo "  ❌ Found hardcoded Korean:"
  echo "$result" | sed 's/^/     /'
  ((errors++))
else
  echo "  ✅ No hardcoded Korean found"
fi
echo ""

# 2. English hardcoding (messages without MSG_)
echo "2. English hardcoding (user-facing messages):"
result=$(grep -rn 'echo "' setup.sh lib/*.sh modules/*.sh claude-code/setup-claude.sh 2>/dev/null | \
  grep -v '\$MSG_' | \
  grep -v '━' | \
  grep -v '^[[:space:]]*#' | \
  grep -v 'color' | \
  grep -v 'echo ""')
if [ -n "$result" ]; then
  echo "  ⚠️  Potential hardcoded English (review manually):"
  echo "$result" | sed 's/^/     /'
  ((errors++))
else
  echo "  ✅ No obvious hardcoded English found"
fi
echo ""

# 3. Path hardcoding (/Users/ without $HOME)
echo "3. Path hardcoding:"
result=$(grep -rn '"/Users/' setup.sh lib/*.sh modules/*.sh claude-code/setup-claude.sh 2>/dev/null | grep -v '\$HOME')
if [ -n "$result" ]; then
  echo "  ❌ Found hardcoded paths:"
  echo "$result" | sed 's/^/     /'
  ((errors++))
else
  echo "  ✅ No hardcoded paths found"
fi
echo ""

# 4. Japanese hardcoding
echo "4. Japanese hardcoding in bash scripts:"
result=$(grep -rn "echo.*[ぁ-んァ-ヶ]" setup.sh lib/*.sh modules/*.sh claude-code/setup-claude.sh 2>/dev/null | grep -v '\$MSG_' | grep -v '^[[:space:]]*#')
if [ -n "$result" ]; then
  echo "  ❌ Found hardcoded Japanese:"
  echo "$result" | sed 's/^/     /'
  ((errors++))
else
  echo "  ✅ No hardcoded Japanese found"
fi
echo ""

# Summary
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
if [ $errors -eq 0 ]; then
  echo "✅ All checks passed!"
else
  echo "❌ Found $errors issue(s). Please use \$MSG_* variables from locale files."
  exit 1
fi
