#!/usr/bin/env python3
"""Update font in Terminal.app profile (.terminal file)"""

import sys
import plistlib
from pathlib import Path

def update_terminal_font(terminal_file, font_name, font_size=12.0):
    """
    Update font in a .terminal file

    Args:
        terminal_file: Path to .terminal file
        font_name: Font name (e.g., "D2CodingLigature Nerd Font", "D2Coding")
        font_size: Font size (default: 12.0)
    """
    terminal_path = Path(terminal_file)

    if not terminal_path.exists():
        print(f"Error: File not found: {terminal_file}", file=sys.stderr)
        return False

    try:
        # Read plist
        with open(terminal_path, 'rb') as f:
            plist_data = plistlib.load(f)

        # Create new font data
        # NSFont archived format for Terminal.app
        font_data = {
            '$archiver': 'NSKeyedArchiver',
            '$version': 100000,
            '$objects': [
                '$null',
                {
                    '$class': {'CF$UID': 3},
                    'NSName': {'CF$UID': 2},
                    'NSSize': font_size,
                    'NSfFlags': 16
                },
                font_name,
                {
                    '$classes': ['NSFont', 'NSObject'],
                    '$classname': 'NSFont'
                }
            ],
            '$top': {
                'root': {'CF$UID': 1}
            }
        }

        # Update font in plist
        plist_data['Font'] = plistlib.Data(plistlib.dumps(font_data))

        # Write back
        with open(terminal_path, 'wb') as f:
            plistlib.dump(plist_data, f, fmt=plistlib.FMT_BINARY)

        return True

    except Exception as e:
        print(f"Error: {e}", file=sys.stderr)
        return False

if __name__ == '__main__':
    if len(sys.argv) < 3:
        print("Usage: update-terminal-font.py <terminal-file> <font-name> [font-size]")
        print("")
        print("Examples:")
        print('  update-terminal-font.py Dev.terminal "D2CodingLigature Nerd Font"')
        print('  update-terminal-font.py Dev.terminal "D2Coding" 13')
        sys.exit(1)

    terminal_file = sys.argv[1]
    font_name = sys.argv[2]
    font_size = float(sys.argv[3]) if len(sys.argv) > 3 else 12.0

    if update_terminal_font(terminal_file, font_name, font_size):
        print(f"✅ Font updated to '{font_name}' (size: {font_size})")
        sys.exit(0)
    else:
        print(f"❌ Failed to update font")
        sys.exit(1)
