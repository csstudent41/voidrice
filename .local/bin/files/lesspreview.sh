#!/bin/sh

TEMPFILE=$(mktemp)
# echo "$TEMPFILE" >> "$HOME/.cache/less-tmp-files-list.txt"
preview "$1" >"$TEMPFILE"
[ -s $TEMPFILE ] && echo $TEMPFILE || rm -f $TEMPFILE
