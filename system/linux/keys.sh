#!/usr/bin/env bash
set -e

read -r -p "Enter your email: " email
key="$HOME/.ssh/id_ed25519"

ssh-keygen -t ed25519 -C "$email" -f "$key"
eval "$(ssh-agent -s)"
ssh-add "$key"
