#!/bin/bash
#
# ai-dev-setup installer (runs without Git)
# Usage: paste this one line in Terminal
#   curl -fsSL https://raw.githubusercontent.com/ejkim-dev/ai-dev-setup/main/install.sh | bash
#

set -e

REPO_URL="https://github.com/ejkim-dev/ai-dev-setup/archive/refs/heads/main.zip"
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

unzip -q "$DOWNLOAD_DIR/ai-dev-setup.zip" -d "$DOWNLOAD_DIR"
echo "  ✅ Extraction complete"

# Move to install directory
if [ -d "$INSTALL_DIR" ]; then
  echo "  Existing ai-dev-setup folder found. Updating."
  rm -rf "$INSTALL_DIR"
fi
mv "$DOWNLOAD_DIR/ai-dev-setup-main" "$INSTALL_DIR"

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

# Run setup
cd "$INSTALL_DIR"
./setup.sh
