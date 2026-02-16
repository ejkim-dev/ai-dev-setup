#!/bin/bash
#
# ai-dev-setup installer (runs without Git)
# Usage: paste this one line in Terminal
#   curl -fsSL https://raw.githubusercontent.com/ejkim-dev/ai-dev-setup/main/install.sh | bash
#

set -e

VERSION="1.0.0"
REPO_URL="https://github.com/ejkim-dev/ai-dev-setup/archive/refs/tags/v${VERSION}.zip"
EXPECTED_SHA256="031b7c84dab1c3bbd49c02315669ba476d6bf4444aaab7b46d0d9f4d6cb2662f"
DOWNLOAD_DIR="/tmp/ai-dev-setup-download"
INSTALL_DIR="$HOME/ai-dev-setup"

echo ""
echo "🔧 Downloading ai-dev-setup..."

# Clean up existing temp files
rm -rf "$DOWNLOAD_DIR"
mkdir -p "$DOWNLOAD_DIR"

# Download + extract ZIP
curl -fsSL "$REPO_URL" -o "$DOWNLOAD_DIR/ai-dev-setup.zip"
echo "  ✅ Download complete"

# SHA256 verification
ACTUAL_SHA256=$(shasum -a 256 "$DOWNLOAD_DIR/ai-dev-setup.zip" | awk '{print $1}')
if [ "$ACTUAL_SHA256" != "$EXPECTED_SHA256" ]; then
  echo "  ❌ SHA256 mismatch!"
  echo "     Expected: $EXPECTED_SHA256"
  echo "     Actual:   $ACTUAL_SHA256"
  echo "     Download may be corrupted or tampered with."
  rm -rf "$DOWNLOAD_DIR"
  exit 1
fi
echo "  ✅ SHA256 verified"

unzip -q "$DOWNLOAD_DIR/ai-dev-setup.zip" -d "$DOWNLOAD_DIR"
echo "  ✅ Extraction complete"

# Move to install directory
if [ -d "$INSTALL_DIR" ]; then
  echo "  Existing ai-dev-setup folder found. Updating."
  rm -rf "$INSTALL_DIR"
fi
mv "$DOWNLOAD_DIR/ai-dev-setup-${VERSION}" "$INSTALL_DIR"

# Clean up temp files
rm -rf "$DOWNLOAD_DIR"

# Set permissions
chmod +x "$INSTALL_DIR/setup.sh"
chmod +x "$INSTALL_DIR/claude-code/setup-claude.sh"

echo ""
echo "  📁 Install location: $INSTALL_DIR"
echo ""
echo "  Starting setup..."
echo ""

# Run setup (< /dev/tty: restore interactive input when run via curl | bash)
cd "$INSTALL_DIR"
./setup.sh < /dev/tty
