#!/bin/bash

interval="$(tmux show-option -gqv @continuum-save-interval)"

if [[ ! "$interval" =~ ^[0-9]+$ ]] || ((interval <= 0)); then
	printf '#[fg=#f38ba8]󰆓 off #[fg=#585b70]│ '
	exit 0
fi

last_save="$(tmux show-option -gqv @continuum-save-last-timestamp)"
if [[ ! "$last_save" =~ ^[0-9]+$ ]]; then
	last_save="$(date +%s)"
fi

remaining=$((last_save + interval * 60 - $(date +%s)))
((remaining < 0)) && remaining=0
remaining_minutes=$(((remaining + 59) / 60))

printf '#[fg=#a6e3a1]󰆓 %dm #[fg=#585b70]│ ' "$remaining_minutes"
