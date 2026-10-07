#!/usr/bin/env bash
# Show the pane border status line only while the current window is split.
# A single pane has nothing worth labelling, so its border stays bare.
#
# Wired up in tmux.conf from the `v` / `h` split bindings, the `x` kill-pane
# binding and the global pane-exited hook.

set -uo pipefail

# The window can already be gone by the time a pane-exited hook fires.
panes=$(tmux list-panes 2>/dev/null | wc -l) || exit 0
[ "$panes" -gt 0 ] || exit 0

if [ "$panes" -le 1 ]; then
	tmux set-option -w pane-border-status off
	exit 0
fi

# Catppuccin sets the @thm_* palette; fall back to the terminal default so the
# border still renders if the theme has not been loaded (e.g. plugins missing).
thm() {
	local value
	value=$(tmux show-option -gqv "@$1")
	printf '%s' "${value:-default}"
}

tmux set-option -w pane-border-status top
tmux set-option -w pane-border-format \
	"#[fg=#{?pane_active,$(thm thm_blue),$(thm thm_surface_2)}] #{pane_index} #{pane_current_command} "
