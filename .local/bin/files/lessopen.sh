#!/bin/sh

[ -d "$1" ] && {
	# ls -alhF --group-directories-first --color=always "$1"
	tree -CL 3
	exit
}

if command -V highlight >/dev/null; then
	highlight --force --out-format=ansi -- "$1"
else
	cat "$1"
fi
