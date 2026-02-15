#!/bin/bash
# Test: Update font in Dev.terminal

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DEV_TERMINAL="$SCRIPT_DIR/configs/mac/Dev.terminal"
TEST_TERMINAL="/tmp/Dev-test.terminal"

# Function to update font in terminal profile
# Usage: update_terminal_font "path/to/profile.terminal" "FontName"
update_terminal_font() {
  local terminal_file="$1"
  local font_name="$2"

  echo "Updating font to: $font_name"

  # Convert to XML
  plutil -convert xml1 "$terminal_file" 2>/dev/null || return 1

  # Update font using PlistBuddy
  # Font data is stored as binary plist, we need to extract and modify it
  local temp_font_plist="/tmp/font-data-$$.plist"

  # Extract current font data
  /usr/libexec/PlistBuddy -c "Print :Font" "$terminal_file" -x > "$temp_font_plist" 2>/dev/null || {
    echo "Failed to extract font data"
    return 1
  }

  # Update font name in the extracted plist
  /usr/libexec/PlistBuddy -c "Set :NSName $font_name" "$temp_font_plist" 2>/dev/null || {
    echo "Failed to update font name"
    rm -f "$temp_font_plist"
    return 1
  }

  # Merge back
  /usr/libexec/PlistBuddy -c "Delete :Font" "$terminal_file" 2>/dev/null
  /usr/libexec/PlistBuddy -c "Add :Font data" "$terminal_file" 2>/dev/null
  /usr/libexec/PlistBuddy -c "Merge $temp_font_plist :" "$terminal_file" 2>/dev/null || {
    echo "Failed to merge font data back"
    rm -f "$temp_font_plist"
    return 1
  }

  # Cleanup
  rm -f "$temp_font_plist"

  # Convert back to binary
  plutil -convert binary1 "$terminal_file" 2>/dev/null || return 1

  echo "✅ Font updated successfully"
  return 0
}

# Test
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Test: Update Dev.terminal font"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Copy original
cp "$DEV_TERMINAL" "$TEST_TERMINAL"

# Test 1: D2Coding Nerd Font
echo "Test 1: D2CodingLigature Nerd Font"
if update_terminal_font "$TEST_TERMINAL" "D2CodingLigature Nerd Font"; then
  echo "✅ Test 1 passed"
else
  echo "❌ Test 1 failed"
fi

echo ""

# Verify
plutil -convert xml1 "$TEST_TERMINAL" -o - | grep -A 10 "Font" | grep -i "d2coding"

# Cleanup
rm -f "$TEST_TERMINAL"

echo ""
echo "Test complete"
