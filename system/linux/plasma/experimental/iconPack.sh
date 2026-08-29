#!/bin/bash

# https://github.com/zayronxio/Mkos-Big-Sur
# https://store.kde.org/p/1400021

# Check if jq is installed
if ! command -v jq &> /dev/null; then
    echo "jq could not be found. Please install it to proceed."
    echo "For Debian/Ubuntu, use: sudo apt-get install jq"
    exit 1
fi

# Get the download URL for the latest release asset ending in .tar.xz
LATEST_RELEASE_API_URL="https://api.github.com/repos/zayronxio/Mkos-Big-Sur/releases/latest"
ICON_URL=$(curl -s "$LATEST_RELEASE_API_URL" | jq -r '.assets[] | select(.name | endswith(".tar.xz")) | .browser_download_url')

if [ -z "$ICON_URL" ] || [ "$ICON_URL" == "null" ]; then
    echo "Failed to fetch the download URL for the latest version. Please check the repository and your internet connection."
    exit 1
fi

ICON_ARCHIVE=$(basename "$ICON_URL")
INSTALL_DIR="$HOME/.local/share/icons"

# Create installation directory if it doesn't exist
mkdir -p "$INSTALL_DIR"

# Temporary directory for download
TEMP_DIR=$(mktemp -d)

# Download the icon pack
echo "Downloading Mkos-Big-Sur icon pack..."
if ! wget -q --show-progress -O "$TEMP_DIR/$ICON_ARCHIVE" "$ICON_URL"; then
    echo "Failed to download the icon pack. Please check the URL and your internet connection."
    rm -rf "$TEMP_DIR"
    exit 1
fi

# Extract the icon pack
echo "Extracting icon pack to $INSTALL_DIR..."
if tar -xf "$TEMP_DIR/$ICON_ARCHIVE" -C "$INSTALL_DIR"; then
    echo "Extraction successful."
else
    echo "Failed to extract the icon pack."
    rm -rf "$TEMP_DIR"
    exit 1
fi

# Clean up the temporary directory
rm -rf "$TEMP_DIR"

echo "Mkos-Big-Sur icon pack installed successfully."
echo "You can now select it in System Settings -> Appearance -> Icons."
