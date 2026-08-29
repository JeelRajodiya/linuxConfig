#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
mkdir -p "$tmp/home/.config" "$tmp/bin"
ln -s "$REPO_DIR/dotfiles/common/.config/nvim" "$tmp/home/.config/legacy"
touch "$tmp/home/.config/keep"
printf '#!/bin/sh\nexit 0\n' > "$tmp/bin/stow"
printf '#!/bin/sh\nmkdir -p "$3"\n' > "$tmp/bin/git"
chmod +x "$tmp/bin/stow" "$tmp/bin/git"

HOME="$tmp/home" PATH="$tmp/bin:$PATH" "$REPO_DIR/bin/sync.sh" >/dev/null

[ ! -L "$tmp/home/.config/legacy" ]
[ -f "$tmp/home/.config/keep" ]
[ -d "$tmp/home/.config/tmux/plugins/tpm" ]
