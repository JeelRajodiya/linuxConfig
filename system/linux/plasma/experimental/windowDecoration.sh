#!/bin/bash
# Vivid-Blur-Dark-Aurorae-6 Window Decoration Installer
# Source: https://github.com/L4ki/Vivid-Plasma-Themes

set -e

REPO_URL="https://github.com/L4ki/Vivid-Plasma-Themes.git"
TEMP_DIR="/tmp/Vivid-Plasma-Themes"
THEME_NAME="Vivid-Blur-Dark-Aurorae-6"

# Directory for Aurorae themes
AURORAE_DIR="$HOME/.local/share/aurorae/themes"

# Download theme from GitHub
rm -rf "$TEMP_DIR"
git clone --quiet --depth=1 "$REPO_URL" "$TEMP_DIR"

# Install the window decoration
mkdir -p "$AURORAE_DIR"
cp -r "$TEMP_DIR/Vivid Window Decorations/$THEME_NAME" "$AURORAE_DIR/"

# Cleanup
rm -rf "$TEMP_DIR"

echo "✓ '$THEME_NAME' window decoration installed."
echo "Apply it from System Settings -> Window Decorations."
