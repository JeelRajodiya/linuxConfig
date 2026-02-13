#!/bin/bash

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OS="$(uname)"

link_item() {
    local item="$1"
    local dest="$2"
    local target="$dest/$item"
    local source="$DOTFILES_DIR/$item"

    # Check if source exists before linking
    if [ ! -e "$source" ]; then
        echo "Warning: Source $source does not exist. Skipping."
        return
    fi

    [ -e "$target" ] || [ -L "$target" ] && rm -rf "$target"
    mkdir -p "$(dirname "$target")"
    ln -s "$source" "$target"
    echo "Linked $source -> $target"
}

# Common configs
link_item ".bashrc" "$HOME"
link_item ".profile" "$HOME"
link_item ".zshrc" "$HOME"
link_item ".gitconfig" "$HOME"
link_item ".ssh/config" "$HOME"
link_item ".ripgreprc" "$HOME/.config"
link_item "kitty" "$HOME/.config"
link_item "nvim" "$HOME/.config"
link_item "starship" "$HOME/.config"
link_item "television" "$HOME/.config"
link_item "tmux" "$HOME/.config"
link_item "yazi" "$HOME/.config"
link_item "work" "$HOME/.config"
link_item "scripts" "$HOME/.config"
link_item "fastfetch" "$HOME/.config"
link_item "ghostty" "$HOME/.config"

# Linux/KDE specific configs
if [ "$OS" = "Linux" ]; then
    link_item "plasma-org.kde.plasma.desktop-appletsrc" "$HOME/.config"
    link_item "plasmashellrc" "$HOME/.config"
    link_item "powerdevilrc" "$HOME/.config"
    link_item "plasmaparc" "$HOME/.config"
    link_item "kwinrc" "$HOME/.config"
    link_item "plasma" "$HOME/.local/share"
    link_item "spectaclerc" "$HOME/.config"
    link_item "kglobalshortcutsrc" "$HOME/.config"
    link_item "kdeglobals" "$HOME/.config"
    link_item "kxkbrc" "$HOME/.config"
fi

echo "All symlinks created."
