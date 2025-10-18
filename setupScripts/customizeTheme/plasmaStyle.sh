#!/bin/bash
# WhiteSur-dark KDE Theme Installer (Plasma theme only)
# Source: https://github.com/vinceliuice/WhiteSur-kde
# Installs: Plasma desktop theme and look-and-feel only
# Skips: Window decorations, color schemes, SDDM, splash screens

set -e

REPO_URL="https://github.com/vinceliuice/WhiteSur-kde.git"
TEMP_DIR="/tmp/WhiteSur-kde"
THEME_NAME="WhiteSur-dark"

# Directories
PLASMA_DIR="$HOME/.local/share/plasma/desktoptheme"
LOOKFEEL_DIR="$HOME/.local/share/plasma/look-and-feel"

echo "Installing WhiteSur-dark Plasma theme (no window decorations, no color schemes)..."

# Download theme
rm -rf "$TEMP_DIR"
git clone --quiet --depth=1 "$REPO_URL" "$TEMP_DIR"
cd "$TEMP_DIR"

# Manually install only dark theme components
mkdir -p "$PLASMA_DIR" "$LOOKFEEL_DIR"

# Copy only WhiteSur-dark theme files (no color schemes)
cp -r "plasma/desktoptheme/WhiteSur-dark" "$PLASMA_DIR/"
cp -r "plasma/desktoptheme/icons" "$PLASMA_DIR/WhiteSur-dark/"
cp -r "plasma/desktoptheme/weather" "$PLASMA_DIR/WhiteSur-dark/"
cp -r "plasma/look-and-feel/com.github.vinceliuice.WhiteSur-dark" "$LOOKFEEL_DIR/"

echo "✓ Theme files installed"


# Cleanup
cd ~
rm -rf "$TEMP_DIR"

echo "✓ Installation complete!"
echo "The 'WhiteSur-dark' Plasma theme is installed."