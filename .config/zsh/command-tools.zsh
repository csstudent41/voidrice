whereis_alias() {
	location="$(zsh -xic exit 2>&1 | sed -E "/alias[ '$]*$1=/!d" |
		fzf --exit-0 --select-1 --ansi --header-first --header='Select alias location' |
		sed -n "s|^\+\(/.*:[0-9]*\)>.*$|\1|p")"

	if [ -z "$location" ]; then
		echo "$0: '$1' not found in zsh debug log" >&2; return 1
	elif [ "$location" != "${location#*shortcutrc}" ]; then
		awk "/^$1/ {print FILENAME\":\"NR}" ~/.config/shell/bm-{files,dirs}
	else
		echo "$location"
	fi
}

edit-command() {
	[ -z "$1" ] && echo "USAGE: $0 <command>" >&2 && return 2
	cmd="$1"
	cmdtype=$(whence -w "$cmd" | cut -d: -f2 | tr -d ' ')

	case "$cmdtype" in
		alias)
			query="alias ${cmd}="
			location="$(whereis_alias "$cmd")" || return
			file="${location%%:*}"
			line="${location##*:}"
			[ "$file" != "${file#*/bm-}" ] && query="^$cmd"
			;;
		function)
			query="^\s*${cmd}\s*()"
			file=$(whence -v "$cmd" | awk '{print $NF}')
			;;
		command)
			file=$(whence -ps "$cmd" | awk -F' -> ' '{print $NF}')
			case "$(file --mime-type --brief "$file")" in
				text/*) $EDITOR "$file" ;;
				*) echo "$0: not a text file: $file" >&2; return 2 ;;
			esac
			return
			;;
		builtin) echo "$0: $cmd is a builtin command" >&2; return 2 ;;
		reserved) echo "$0: $cmd is a reserved command" >&2; return 2 ;;
		none) echo "$0: $cmd not found" >&2; return 2 ;;
		*) echo "$0: unknown command type: $cmdtype" >&2; return 2 ;;
	esac

	if [ -n "$query" ]; then
		$EDITOR +${line:-1} +/"$query" "$file"
	else
		$EDITOR "$file"
	fi
}

_edit-command() {
	[ -z "$BUFFER" ] && return 2
	cmd=(${=BUFFER}); cmd="${cmd[1]}"
	zle push-line
	BUFFER="edit-command $cmd"
	zle accept-line
}
zle -N edit-command _edit-command
bindkey '^[e' edit-command
