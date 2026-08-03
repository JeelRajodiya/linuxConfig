#!/bin/bash

set -o pipefail

sessions="$(sesh list -t --icons)"
session_count="$(printf '%s\n' "$sessions" | awk 'NF { count++ } END { print count + 0 }')"
client_height="$(tmux display-message -p '#{client_height}')"

min_height=10
max_height=$((client_height * 40 / 100))
((max_height < min_height)) && max_height=$min_height

popup_height=$((session_count + 5))
((popup_height < min_height)) && popup_height=$min_height
((popup_height > max_height)) && popup_height=$max_height

selection="$(
	printf '%s\n' "$sessions" |
		awk '{ print NR ". " $0 }' |
		fzf --tmux "top,20%,${popup_height}" \
			--no-sort \
			--ansi \
			--layout reverse \
			--bind 'one:accept' \
			--border-label ' sesh ' \
			--prompt '⚡  '
)"

[[ -n "$selection" ]] || exit 0

selection="${selection#*. }"

exec sesh connect "$selection"
