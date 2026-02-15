#!/bin/bash
# Test: Update iTerm2 profile font dynamically

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ITERM_PROFILE="$SCRIPT_DIR/configs/mac/iterm2-dev-profile.json"
TEST_PROFILE="/tmp/iterm2-test.json"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Test: iTerm2 Font Update"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Copy original
cp "$ITERM_PROFILE" "$TEST_PROFILE"

echo "Original font:"
grep "Normal Font" "$TEST_PROFILE"
echo ""

# Test 1: Update to Nerd Font
echo "Test 1: Update to Nerd Font"
sed -i '' 's/"Normal Font": "D2Coding 11"/"Normal Font": "D2CodingLigature Nerd Font 11"/' "$TEST_PROFILE"

echo "Updated font:"
grep "Normal Font" "$TEST_PROFILE"
echo ""

# Verify JSON is valid
if python3 -m json.tool "$TEST_PROFILE" > /dev/null 2>&1; then
  echo "✅ JSON valid"
else
  echo "❌ JSON invalid"
fi

# Cleanup
rm -f "$TEST_PROFILE"

echo ""
echo "Test complete!"
