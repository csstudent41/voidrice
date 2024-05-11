#!/bin/sh

[ -d "$1" ] && { tree -CL 3 "$1"; exit; }

if command -V highlight >/dev/null; then
	highlight --force --out-format=ansi -- "$1"
else
	cat "$1"
fi
