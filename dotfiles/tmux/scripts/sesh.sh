#!/bin/bash

set -o pipefail

selection="$(
	sesh list -t --icons |
		awk '{ print NR ". " $0 }' |
		fzf --tmux top,20%,10 \
			--no-sort \
			--ansi \
			--layout reverse \
			--border-label ' sesh ' \
			--prompt '⚡  '
)"

[[ -n "$selection" ]] || exit 0

selection="${selection#*. }"

exec sesh connect "$selection"
