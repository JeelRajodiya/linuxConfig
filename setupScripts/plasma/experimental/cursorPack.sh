#!/bin/bash

# Bibata cursor theme installer for KDE Plasma
# GH: https://github.com/ful1e5/Bibata_Cursor
# KDE Store: https://store.kde.org/p/1197198
# This script will download and install the Bibata ICE cursor pack

set -e

CURSOR_NAME="Bibata-Modern-Ice"
INSTALL_DIR="$HOME/.local/share/icons"
TEMP_DIR=$(mktemp -d)

# Check if jq is installed
if ! command -v jq &> /dev/null; then
    echo "jq could not be found. Please install it to proceed."
    echo "For Debian/Ubuntu, use: sudo apt-get install jq"
    exit 1
fi

echo "Installing Bibata Modern Ice cursor theme..."

# Get the download URL for the latest release
LATEST_RELEASE_API_URL="https://api.github.com/repos/ful1e5/Bibata_Cursor/releases/latest"
CURSOR_URL=$(curl -s "$LATEST_RELEASE_API_URL" | jq -r '.assets[] | select(.name == "Bibata-Modern-Ice.tar.xz") | .browser_download_url')

if [ -z "$CURSOR_URL" ] || [ "$CURSOR_URL" == "null" ]; then
    echo "Failed to fetch the download URL for Bibata Modern Ice. Please check the repository and your internet connection."
    rm -rf "$TEMP_DIR"
    exit 1
fi

CURSOR_ARCHIVE=$(basename "$CURSOR_URL")

# Create installation directory if it doesn't exist
mkdir -p "$INSTALL_DIR"

# Download the cursor pack
echo "Downloading $CURSOR_NAME cursor pack..."
if ! wget -q --show-progress -O "$TEMP_DIR/$CURSOR_ARCHIVE" "$CURSOR_URL"; then
    echo "Failed to download the cursor pack. Please check the URL and your internet connection."
    rm -rf "$TEMP_DIR"
    exit 1
fi

# Extract the cursor pack
echo "Extracting cursor pack to $INSTALL_DIR..."
if tar -xf "$TEMP_DIR/$CURSOR_ARCHIVE" -C "$INSTALL_DIR"; then
    echo "Extraction successful."
else
    echo "Failed to extract the cursor pack."
    rm -rf "$TEMP_DIR"
    exit 1
fi

# Clean up the temporary directory
rm -rf "$TEMP_DIR"

# Update icon cache for KDE to detect the new cursor theme
echo "Updating icon cache..."
if command -v kbuildsycoca6 &> /dev/null; then
    kbuildsycoca6 &> /dev/null
elif command -v kbuildsycoca5 &> /dev/null; then
    kbuildsycoca5 &> /dev/null
fi

# Optionally restart plasmashell to refresh (commented out by default)
# echo "Restarting Plasma shell to apply changes..."
# killall plasmashell && kstart5 plasmashell &> /dev/null & disown

echo "✓ Installation complete!"
echo "The '$CURSOR_NAME' cursor theme is now installed."
echo ""
echo "To activate:"
echo "1. Go to: System Settings > Colors & Themes > Cursors"
echo "2. Select 'Bibata-Modern-Ice' from the list"
echo "3. Click 'Apply'"
echo ""
echo "Note: If the cursor doesn't appear in the list, try logging out and back in."