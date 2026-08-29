#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../dotfiles" && pwd)"
packages=(common agents)

case "$(uname)" in
    Linux) packages+=(linux) ;;
    Darwin) packages+=(macos) ;;
    *) echo "Unsupported OS: $(uname)" >&2; exit 1 ;;
esac

command -v stow >/dev/null || {
    echo "GNU Stow is required. Run bin/bootstrap.sh first." >&2
    exit 1
}

# Remove only links made by the previous sync.sh layout; keep real conflicts.
while IFS= read -r -d '' link; do
    case "$(readlink "$link")" in
        "$DOTFILES_DIR"/*) rm "$link" ;;
    esac
done < <(
    find "$HOME" -maxdepth 1 -type l -print0
    for dir in .ssh .config .agents .claude .codex .pi/agent \
        "Library/Application Support/k9s" \
        "Library/Application Support/lazygit"; do
        [ ! -d "$HOME/$dir" ] || find "$HOME/$dir" -type l -print0
    done
)

stow --no-folding --dir="$DOTFILES_DIR" --target="$HOME" "${packages[@]}"

if [ ! -d "$HOME/.config/tmux/plugins/tpm" ]; then
    git clone https://github.com/tmux-plugins/tpm "$HOME/.config/tmux/plugins/tpm"
fi

echo "Linked: ${packages[*]}"
