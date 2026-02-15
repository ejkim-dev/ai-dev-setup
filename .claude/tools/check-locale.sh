#!/bin/bash
# Check locale file completeness (all 3 languages have same MSG_ variables)

echo "🌐 Checking locale file completeness..."
echo ""

SCRIPT_DIR="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$SCRIPT_DIR"

errors=0

# Extract MSG_ variables from each locale file
echo "1. Extracting MSG_ variables..."
EN_VARS=$(grep "^MSG_" claude-code/locale/en.sh 2>/dev/null | cut -d'=' -f1 | sort)
KO_VARS=$(grep "^MSG_" claude-code/locale/ko.sh 2>/dev/null | cut -d'=' -f1 | sort)
JA_VARS=$(grep "^MSG_" claude-code/locale/ja.sh 2>/dev/null | cut -d'=' -f1 | sort)

EN_COUNT=$(echo "$EN_VARS" | wc -l | tr -d ' ')
KO_COUNT=$(echo "$KO_VARS" | wc -l | tr -d ' ')
JA_COUNT=$(echo "$JA_VARS" | wc -l | tr -d ' ')

echo "  en.sh: $EN_COUNT variables"
echo "  ko.sh: $KO_COUNT variables"
echo "  ja.sh: $JA_COUNT variables"
echo ""

# Compare ko.sh with en.sh
echo "2. Korean (ko.sh) vs English (en.sh):"
DIFF_KO=$(diff <(echo "$EN_VARS") <(echo "$KO_VARS"))
if [ -n "$DIFF_KO" ]; then
  echo "  ❌ Mismatch found:"

  # Find missing in ko.sh
  MISSING_KO=$(comm -23 <(echo "$EN_VARS") <(echo "$KO_VARS"))
  if [ -n "$MISSING_KO" ]; then
    echo "     Missing in ko.sh:"
    echo "$MISSING_KO" | sed 's/^/       /'
  fi

  # Find extra in ko.sh
  EXTRA_KO=$(comm -13 <(echo "$EN_VARS") <(echo "$KO_VARS"))
  if [ -n "$EXTRA_KO" ]; then
    echo "     Extra in ko.sh (not in en.sh):"
    echo "$EXTRA_KO" | sed 's/^/       /'
  fi

  ((errors++))
else
  echo "  ✅ Complete (matches en.sh)"
fi
echo ""

# Compare ja.sh with en.sh
echo "3. Japanese (ja.sh) vs English (en.sh):"
DIFF_JA=$(diff <(echo "$EN_VARS") <(echo "$JA_VARS"))
if [ -n "$DIFF_JA" ]; then
  echo "  ❌ Mismatch found:"

  # Find missing in ja.sh
  MISSING_JA=$(comm -23 <(echo "$EN_VARS") <(echo "$JA_VARS"))
  if [ -n "$MISSING_JA" ]; then
    echo "     Missing in ja.sh:"
    echo "$MISSING_JA" | sed 's/^/       /'
  fi

  # Find extra in ja.sh
  EXTRA_JA=$(comm -13 <(echo "$EN_VARS") <(echo "$JA_VARS"))
  if [ -n "$EXTRA_JA" ]; then
    echo "     Extra in ja.sh (not in en.sh):"
    echo "$EXTRA_JA" | sed 's/^/       /'
  fi

  ((errors++))
else
  echo "  ✅ Complete (matches en.sh)"
fi
echo ""

# Check for empty values
echo "4. Checking for empty values:"
EMPTY_EN=$(grep "^MSG_.*=\"\"$" claude-code/locale/en.sh 2>/dev/null | wc -l | tr -d ' ')
EMPTY_KO=$(grep "^MSG_.*=\"\"$" claude-code/locale/ko.sh 2>/dev/null | wc -l | tr -d ' ')
EMPTY_JA=$(grep "^MSG_.*=\"\"$" claude-code/locale/ja.sh 2>/dev/null | wc -l | tr -d ' ')

if [ "$EMPTY_EN" -gt 0 ] || [ "$EMPTY_KO" -gt 0 ] || [ "$EMPTY_JA" -gt 0 ]; then
  echo "  ⚠️  Empty values found:"
  [ "$EMPTY_EN" -gt 0 ] && echo "     en.sh: $EMPTY_EN empty values"
  [ "$EMPTY_KO" -gt 0 ] && echo "     ko.sh: $EMPTY_KO empty values"
  [ "$EMPTY_JA" -gt 0 ] && echo "     ja.sh: $EMPTY_JA empty values"
  ((errors++))
else
  echo "  ✅ No empty values found"
fi
echo ""

# Summary
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
if [ $errors -eq 0 ]; then
  echo "✅ All locale files are complete and consistent!"
else
  echo "❌ Found $errors locale issue(s)."
  echo "   Please add missing MSG_ variables to all 3 locale files."
  exit 1
fi
