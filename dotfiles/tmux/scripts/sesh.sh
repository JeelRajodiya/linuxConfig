#!/bin/bash

set -o pipefail

sessions="$(sesh list -t)"
session_count="$(printf '%s\n' "$sessions" | awk 'NF { count++ } END { print count + 0 }')"
client_height="$(tmux display-message -p '#{client_height}')"

min_height=10
max_height=$((client_height * 40 / 100))
((max_height < min_height)) && max_height=$min_height

popup_height=$((session_count + 5))
((popup_height < min_height)) && popup_height=$min_height
((popup_height > max_height)) && popup_height=$max_height

items="$(
	index=0
	while IFS= read -r session; do
		[[ -n "$session" ]] || continue
		index=$((index + 1))
		printf '%s\t%d. \033[38;5;220m\033[0m %s\n' "$session" "$index" "$session"
	done <<< "$sessions"
)"

selection="$(
	printf '%s\n' "$items" |
		fzf --tmux "top,20%,${popup_height}" \
			--no-sort \
			--ansi \
			--delimiter $'\t' \
			--with-nth 2 \
			--accept-nth 1 \
			--layout reverse \
			--bind 'one:accept' \
			--border-label ' sesh ' \
				--prompt $'\033[38;5;220m\033[0m  '
)"

[[ -n "$selection" ]] || exit 0

exec sesh connect "$selection"
