#!/bin/bash

set -o pipefail

sessions="$(sesh list -t)"
session_count="$(printf '%s\n' "$sessions" | awk 'NF { count++ } END { print count + 0 }')"
client_height="$(tmux display-message -p '#{client_height}')"
pane_data="$(tmux list-panes -a -F '#{session_name}|#{window_active}|#{pane_active}|#{pane_current_path}')"

session_path() {
	local target="$1"
	local name window_active pane_active path

	while IFS='|' read -r name window_active pane_active path; do
		if [[ "$name" == "$target" && "$window_active" == "1" && "$pane_active" == "1" ]]; then
			printf '%s' "$path"
			return
		fi
	done <<< "$pane_data"
}

project_icon() {
	local session="$1"
	local path="$2"
	local root="$path"
	local git_root

	git_root="$(git -C "$path" rev-parse --show-toplevel 2>/dev/null)"
	[[ -n "$git_root" ]] && root="$git_root"

	case "$session:$root" in
		*datafusion*) printf '\033[38;5;45m󰆼\033[0m'; return ;;
		*dotfiles*|*linuxConfig*) printf '\033[38;5;220m\033[0m'; return ;;
		home:*|*:"$HOME") printf '\033[38;5;51m\033[0m'; return ;;
		*scripts*) printf '\033[38;5;82m\033[0m'; return ;;
	esac

	if [[ -f "$root/Cargo.toml" ]]; then
		printf '\033[38;5;208m\033[0m'
	elif [[ -f "$root/pom.xml" || -f "$root/build.gradle" || -f "$root/build.gradle.kts" ]]; then
		printf '\033[38;5;203m\033[0m'
	elif [[ -f "$root/package.json" ]]; then
		printf '\033[38;5;76m\033[0m'
	elif [[ -f "$root/pyproject.toml" || -f "$root/requirements.txt" || -f "$root/setup.py" ]]; then
		printf '\033[38;5;220m\033[0m'
	elif [[ -d "$root/.git" ]]; then
		printf '\033[38;5;208m\033[0m'
	else
		printf '\033[38;5;220m󱐋\033[0m'
	fi
}

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
		path="$(session_path "$session")"
		icon="$(project_icon "$session" "$path")"
		printf '%s\t%d. %s %s\n' "$session" "$index" "$icon" "$session"
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
			--prompt '⚡  '
)"

[[ -n "$selection" ]] || exit 0

exec sesh connect "$selection"
