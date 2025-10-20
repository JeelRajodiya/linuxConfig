#!/bin/bash

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Map of items to destinations
declare -A SYMLINKS=(
    [.bashrc]="$HOME"
    [.profile]="$HOME"
    [.tmux]="$HOME"
    [.zshrc]="$HOME"
    [kitty]="$HOME/.config"
    [nvim]="$HOME/.config"
    [starship]="$HOME/.config"
    [television]="$HOME/.config"
    [tmux]="$HOME/.config"
    [yazi]="$HOME/.config"
    [work]="$HOME/.config"
    [scripts]="$HOME/.config"
    [fastfetch]="$HOME/.config"
    # apply plasma settings
    [plasma-org.kde.plasma.desktop-appletsrc]="$HOME/.config"
    [plasmashellrc]="$HOME/.config"
    [powerdevilrc]="$HOME/.config"
    [plasmaparc]="$HOME/.config"
    [kwinrc]="$HOME/.config"
    [plasma]="$HOME/.local/share"
    [spectaclerc]="$HOME/.config"
    [kglobalshortcutsrc]="$HOME/.config"
    [kdeglobals]="$HOME/.config"

)

link_item() {
    local item="$1"
    local dest="${SYMLINKS[$item]}"
    local target="$dest/$item"
    local source="$DOTFILES_DIR/$item"

    [ -e "$target" ] || [ -L "$target" ] && rm -rf "$target"
    mkdir -p "$dest"
    ln -s "$source" "$target"
    echo "Linked $source -> $target"
}

for item in "${!SYMLINKS[@]}"; do
    link_item "$item"
done

echo "All symlinks created."
