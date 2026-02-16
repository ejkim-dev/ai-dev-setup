#!/bin/bash
#
# ai-dev-setup installer (runs without Git)
# Usage: paste this one line in Terminal
#   curl -fsSL https://raw.githubusercontent.com/ejkim-dev/ai-dev-setup/main/install.sh | bash
#

set -e

REPO="ejkim-dev/ai-dev-setup"
DOWNLOAD_DIR="/tmp/ai-dev-setup-download"
INSTALL_DIR="$HOME/ai-dev-setup"

echo ""
echo "🔧 Downloading ai-dev-setup..."

# Get latest release tag
VERSION=$(curl -fsSL "https://api.github.com/repos/${REPO}/releases/latest" | grep '"tag_name"' | sed 's/.*"tag_name": *"//;s/".*//')
if [ -z "$VERSION" ]; then
  echo "  ❌ Failed to fetch latest release version."
  exit 1
fi
VERSION_NUM="${VERSION#v}"
echo "  📦 Version: $VERSION"

REPO_URL="https://github.com/${REPO}/archive/refs/tags/${VERSION}.zip"

# Clean up existing temp files
rm -rf "$DOWNLOAD_DIR"
mkdir -p "$DOWNLOAD_DIR"

# Download ZIP
curl -fsSL "$REPO_URL" -o "$DOWNLOAD_DIR/ai-dev-setup.zip"
echo "  ✅ Download complete"

# SHA256 verification (if checksum available in release)
CHECKSUMS_URL="https://github.com/${REPO}/releases/download/${VERSION}/SHA256SUMS"
if curl -fsSL "$CHECKSUMS_URL" -o "$DOWNLOAD_DIR/SHA256SUMS" 2>/dev/null; then
  EXPECTED_SHA256=$(grep "source.zip" "$DOWNLOAD_DIR/SHA256SUMS" | awk '{print $1}')
  ACTUAL_SHA256=$(shasum -a 256 "$DOWNLOAD_DIR/ai-dev-setup.zip" | awk '{print $1}')
  if [ -n "$EXPECTED_SHA256" ] && [ "$ACTUAL_SHA256" != "$EXPECTED_SHA256" ]; then
    echo "  ❌ SHA256 mismatch!"
    echo "     Expected: $EXPECTED_SHA256"
    echo "     Actual:   $ACTUAL_SHA256"
    echo "     Download may be corrupted or tampered with."
    rm -rf "$DOWNLOAD_DIR"
    exit 1
  fi
  echo "  ✅ SHA256 verified"
else
  echo "  ⚠️  SHA256 checksum not available, skipping verification"
fi

unzip -q "$DOWNLOAD_DIR/ai-dev-setup.zip" -d "$DOWNLOAD_DIR"
echo "  ✅ Extraction complete"

# Move to install directory
if [ -d "$INSTALL_DIR" ]; then
  echo "  Existing ai-dev-setup folder found. Updating."
  rm -rf "$INSTALL_DIR"
fi
mv "$DOWNLOAD_DIR/ai-dev-setup-${VERSION_NUM}" "$INSTALL_DIR"

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
