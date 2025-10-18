#!/bin/bash

# Get active icon theme
THEME=$(kreadconfig5 --group "Icons" --key "Theme")
echo "Current icon theme: $THEME"
HICOLOR="$HOME/.local/share/icons/hicolor"
THEME_DIR="$HOME/.local/share/icons/$THEME"

# Common icon sizes
sizes=(16 32 48 128 256 512)

for s in "${sizes[@]}"; do
  src="$HICOLOR/${s}x${s}/apps"
  dst="$THEME_DIR/${s}x${s}/apps"
  mkdir -p "$dst"
  for f in "$src"/chrome-*.png; do
    [ -e "$f" ] || continue
    ln -sf "$f" "$dst/$(basename "$f")"
  done
done

# Clear caches and rebuild
rm -f "$HOME/.cache/icon-cache.kcache"
kbuildsycoca5 --noincremental

# Restart plasmashell to apply changes
kquitapp5 plasmashell
kstart5 plasmashell
