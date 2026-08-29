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

link_agent_skills() {
    local source_dir="$DOTFILES_DIR/.agents/skills"
    local codex_target_dir="$HOME/.agents/skills"
    local pi_target_dir="$HOME/.pi/agent/skills"
    local claude_target="$HOME/.claude/skills"

    [ -d "$source_dir" ] || return
    mkdir -p "$codex_target_dir" "$pi_target_dir" "$(dirname "$claude_target")"

    [ -e "$claude_target" ] || [ -L "$claude_target" ] && rm -rf "$claude_target"
    ln -s "$source_dir" "$claude_target"
    echo "Linked $source_dir -> $claude_target"

    for source in "$source_dir"/*; do
        [ -d "$source" ] || continue

        local skill_name
        local target
        skill_name="$(basename "$source")"

        for target in "$codex_target_dir/$skill_name" "$pi_target_dir/$skill_name"; do
            [ -e "$target" ] || [ -L "$target" ] && rm -rf "$target"
            ln -s "$source" "$target"
            echo "Linked $source -> $target"
        done
    done
}

link_agent_instructions() {
    local source="$DOTFILES_DIR/AGENTS.md"

    [ -e "$source" ] || return

    for target in "$HOME/.codex/AGENTS.md" "$HOME/.claude/CLAUDE.md" "$HOME/.config/opencode/AGENTS.md" "$HOME/.pi/agent/AGENTS.md"; do
        [ -e "$target" ] || [ -L "$target" ] && rm -rf "$target"
        mkdir -p "$(dirname "$target")"
        ln -s "$source" "$target"
        echo "Linked $source -> $target"
    done
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
link_item "btop" "$HOME/.config"
link_item "atuin" "$HOME/.config"

# OpenCode's config directory also contains runtime-managed files, so only
# link portable configuration files.
link_item "opencode/opencode.jsonc" "$HOME/.config"
link_item "opencode/tui.json" "$HOME/.config"
link_item "opencode/agents/understand.md" "$HOME/.config"
link_item "opencode/agents/understand-fast.md" "$HOME/.config"
link_item "opencode/agents/understand-thorough.md" "$HOME/.config"
link_item "opencode/agents/iterate.md" "$HOME/.config"
link_item "opencode/agents/iterate-fast.md" "$HOME/.config"

# Zed configs (individual files, not the whole dir — it has runtime data: prompts, conversations)
link_item "zed/settings.json" "$HOME/.config"
link_item "zed/keymap.json" "$HOME/.config"

# Shared agent skills live in .agents/skills. Claude links directly to that
# directory; Codex and Pi get per-skill links so externally installed skills remain.
link_agent_skills

# Codex, Claude, and OpenCode share one global instruction file.
link_agent_instructions

# Claude Code configs (individual files, not the whole dir — it has runtime data)
link_item ".claude/settings.json" "$HOME"
link_item ".claude/statusline.sh" "$HOME"
link_item ".claude/commands" "$HOME"

# Codex configs (the rest of ~/.codex is runtime data: sessions, auth, sqlite)
link_item ".codex/config.toml" "$HOME"
link_item ".codex/agents/understand.toml" "$HOME"
link_item ".codex/agents/understand-fast.toml" "$HOME"
link_item ".codex/agents/understand-thorough.toml" "$HOME"
link_item ".codex/agents/iterate.toml" "$HOME"
link_item ".codex/agents/iterate-fast.toml" "$HOME"

# Pi configs (the rest of ~/.pi/agent is runtime data: auth and sessions)
link_item ".pi/agent/settings.json" "$HOME"
link_item ".pi/agent/models.json" "$HOME"
link_item ".pi/agent/extensions/workflows.ts" "$HOME"
link_item ".pi/agent/extensions/openai-codex-fast.ts" "$HOME"
link_item ".pi/agent/extensions/codex-usage.ts" "$HOME"

# lazygit: config path differs per OS
if [ "$OS" = "Darwin" ]; then
    link_item "lazygit/config.yml" "$HOME/Library/Application Support"
else
    link_item "lazygit" "$HOME/.config"
fi

# k9s: only sync skins (k9s writes runtime files to its config dir)
if [ "$OS" = "Darwin" ]; then
    link_item "k9s/skins" "$HOME/Library/Application Support"
else
    link_item "k9s/skins" "$HOME/.config"
fi

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
