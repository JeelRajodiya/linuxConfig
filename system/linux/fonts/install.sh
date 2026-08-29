#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Install Ubuntu Nerd Fonts and RecMonoCasual Nerd Fonts under /usr/share/fonts/custom/."
sudo install -m 644 "$SCRIPT_DIR/local.conf" /etc/fonts/local.conf
fc-cache -f
