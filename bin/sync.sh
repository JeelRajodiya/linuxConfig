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

stow --no-folding --dir="$DOTFILES_DIR" --target="$HOME" "${packages[@]}"
echo "Already linked: ${packages[*]}"
