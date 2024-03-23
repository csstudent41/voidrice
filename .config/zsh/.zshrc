#############################
##   SHELL CONFIGURATION   ##
#############################

bindkey -e
alias find="2> >(grep -v 'Permission denied' >&2) find"

source ~/.profile
[ -n "$SDOTDIR" ] || export SDOTDIR="${XDG_CONFIG_HOME:-$HOME/.config}/shell"
[ -n "$ZDOTDIR" ] || export ZDOTDIR="${XDG_CONFIG_HOME:-HOME/.config}/zsh"

source "$ZDOTDIR/zshnameddirrc"
source "$ZDOTDIR/command-tools.zsh"
source "$ZDOTDIR/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
source "$ZDOTDIR/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$ZDOTDIR/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh"
source "$ZDOTDIR/fzf/key-bindings.zsh"
source "$ZDOTDIR/fzf/completion.zsh"

ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_ACCEPT_WIDGETS=(end-of-line vi-end-of-line vi-add-eol)
ZSH_AUTOSUGGEST_PARTIAL_ACCEPT_WIDGETS+=(forward-char vi-forward-char)

# Enable colors and change prompt:
autoload -U colors && colors
PS1="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%1~%{$fg[red]%}]%{$reset_color%}$%b "
#PS1="%B%{$fg[red]%} %~ >%{$fg[yellow]%}%{$reset_color%}%b "
[ -n "$LF_LEVEL" ] && PS1="$PS1(lf: $LF_LEVEL) "

# # Change cursor shape for different vi modes.
# function zle-keymap-select {
#     case $KEYMAP in
#         vicmd) echo -ne '\e[1 q';;      # block
#         viins|main) echo -ne '\e[5 q';; # beam
#     esac
# }
# zle -N zle-keymap-select
# zle-line-init() { echo -ne "\e[5 q"; }
# zle -N zle-line-init
# # echo -ne '\e[5 q' # Use beam shape cursor on startup.
# preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.

setopt correct  # Auto correct mistakes
setopt extended_glob  # Allows using regular expressions with *
setopt rc_expand_param  # Array expension with parameters
setopt no_check_jobs  # Don't warn about running processes when exiting
setopt rm_star_silent  # Don't warn when using glob with rm
setopt numeric_glob_sort  # Sort filenames numerically when it makes sense
setopt no_beep  # No beep
setopt append_history  # Immediately append history instead of overwriting
setopt extended_history  # Add timestamps to history
setopt hist_ignore_all_dups  # If a new command is a duplicate, remove the older one
setopt auto_cd  # if only directory path is entered, cd there.
setopt auto_pushd
setopt pushd_ignore_dups
setopt pushd_minus
setopt interactive_comments
setopt histignorespace

# Completion.
autoload -Uz compinit
compinit -d ~/.cache/zshcompdump-$ZSH_VERSION
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'       # Case insensitive tab completion
zstyle ':completion:*' rehash true                              # automatically find new executables in path
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"         # Colored completion (different colors for dirs/files/etc)
zstyle ':completion:*' completer _expand _complete _ignored _approximate
zstyle ':completion:*' menu select
zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'
zstyle ':completion:*:descriptions' format '%U%F{cyan}%d%f%u'

# Speed up completions
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.cache/zsh

# automatically load bash completion functions
autoload -U +X bashcompinit && bashcompinit
source "$ZDOTDIR/completion/arduino-cli.zsh"

HISTFILE="$HOME/.local/share/zsh/history"
HISTSIZE=100000
SAVEHIST=50000

_ng_yargs_completions()
{
  local reply
  local si=$IFS
  IFS=$'
' reply=($(COMP_CWORD="$((CURRENT-1))" COMP_LINE="$BUFFER" COMP_POINT="$CURSOR" ng --get-yargs-completions "${words[@]}"))
  IFS=$si
  _describe 'values' reply
}
compdef _ng_yargs_completions ng


export PREV_BUFFER="$ZSH_CACHE_DIR/previous-command-buffer-$$.tmp"
_exec-zsh() {
	echo "$BUFFER" > "$PREV_BUFFER"
	BUFFER=' exec zsh'
	zle accept-line
}
zle -N exec-zsh _exec-zsh
bindkey '^[r' exec-zsh

[ -f "$PREV_BUFFER" ] && {
	[ -n "$TMUX" ] || [ -z "$TERMUX_VERSION" ] && {
		sleep 0.1
		if [ -n "$TMUX" ]; then
			tmux send-keys -l "$(cat "$PREV_BUFFER")"
		else
			xdotool type --window "$(xdotool getactivewindow)" \
				"$(cat "$PREV_BUFFER")"
		fi
		rm -f "$PREV_BUFFER"
	} & disown
}

_cd_path_history() {
	FZF_ALT_C_COMMAND="cat ~/.local/share/cdhist" \
		FZF_ALT_C_OPTS="--tac --tiebreak=index --no-sort" \
		zle fzf-cd-widget
}
zle -N cd-path-history _cd_path_history
bindkey '^[k' cd-path-history

bindkey -s '^[o' '^[q lfcd^M'
bindkey -s '^[j' '^[q lfcd "$(ff)"^M'
bindkey -s '^[l' '^[q l^M'
bindkey -s '^[L' '^[q lsblk^M'
bindkey -s '^[D' '^[q dirs -v^M'
bindkey -s '^[i' '^[q pushd -1^M'
bindkey -s '^[-' '^[q cd -^M'
bindkey -s '^[B' '^[q bindkey | less^M'

bindkey jk vi-cmd-mode
bindkey "^j" autosuggest-execute

bindkey '^P' history-substring-search-up
bindkey '^N' history-substring-search-down
bindkey '^[p' history-beginning-search-backward
bindkey '^[n' history-beginning-search-forward

autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey -M vicmd 'k' up-line-or-beginning-search
bindkey -M vicmd 'j' down-line-or-beginning-search

autoload -U edit-command-line; zle -N edit-command-line
bindkey '^[E' edit-command-line

typeset -g -A key
if (( ${+terminfo[smkx]} && ${+terminfo[rmkx]} )); then
	autoload -Uz add-zle-hook-widget
	function zle_application_mode_start { echoti smkx }
	function zle_application_mode_stop { echoti rmkx }
	add-zle-hook-widget -Uz zle-line-init zle_application_mode_start
	add-zle-hook-widget -Uz zle-line-finish zle_application_mode_stop
fi

_command_fail_hook() {
	case "$?" in
		1)
			if [ -n "$TMUX" ]; then
				tmux send-keys C-p
			else
				xdotool key --window "$(xdotool getactivewindow)" ctrl+p
			fi
			;;
	esac
}
add-zsh-hook precmd _command_fail_hook

_cd_history_hook() {
	sed -i "\|^$PWD$|d" ~/.local/share/cdhist
	echo "$PWD" >> ~/.local/share/cdhist
}
add-zsh-hook -Uz chpwd _cd_history_hook


get-help() {
	cmd="$1"; cmdinfo="$(command -v "$cmd")"
	case "${$(whence -w "$cmd")##*: }" in
		builtin) MANPAGER="less +/'^       $cmd'" man zshbuiltins && export FOUND=1 ;;
		reserved) MANPAGER="less +/'^reserved' +/'$cmd'" man zshall && export FOUND=1 ;;
		alias) echo "$cmdinfo"; cmd="$(alias "$cmd" | sed "s/$cmd='\(\S*\) .*'/\1/")" ;;
	esac
	[ -n "$cmdinfo" ] && help "$cmd" || help "$1"
}
alias run-help='get-help'
alias which-command='where'

_get-help() {
	cmd=(${=BUFFER})
	zle push-line
	case "${cmd[1]}" in
		gh|hugo|npm|git) BUFFER="help ${cmd[1]}-${cmd[2]}" ;;
		*) BUFFER="get-help $cmd" ;;
	esac
	zle accept-line
}
zle -N get-help _get-help
bindkey '^[H' get-help

source "$SDOTDIR/aliasrc"
source "$SDOTDIR/shortcutrc"

case "$TERM" in *256*)
	if [ -x /bin/eza ] || [ -x /usr/bin/eza ]; then
		alias l='exa -aF --group-directories-first --color=always --icons'
		lt() { exa --group-directories-first --color=always \
			--icons -FaT "$@" | less -rF; }
	fi

	command -V starship >/dev/null && {
		eval "$(starship init zsh)"
		function set_win_title(){
				echo -ne "\033]0; $USER@$HOST:${PWD/$HOME/~} \007"
		}
		precmd_functions+=(set_win_title)
	}
	;;
esac

alias p='pacman'
alias sp='sudo pacman'
alias mmv='noglob zmv -W'
alias loop='loop '
alias sudo='sudo '
alias mirror='sudo reflector -f 30 -l 30 --number 10 --verbose --save /etc/pacman.d/mirrorlist'
alias mirrord='sudo reflector --latest 50 --number 20 --sort delay --save /etc/pacman.d/mirrorlist'
alias cleanup='sudo pacman -Rns $(pacman -Qtdq)'
alias fixpacman='sudo rm /var/lib/pacman/db.lck'

f() {
	ret=$?
	[ -n "$1" ] && { pacman -F "$@"; return; }
	[ "$ret" != 127 ] && echo "Return code of last command is not 127" >&2 && return 2
	pacman -F "$(fc -s 2>&1 | tail -1 | cut -d\  -f5-)"
}

fw() {
	export FZF_HIST="$HOME/.local/share/fzf/wiki_history"
	export FZF_HEADER="Search local wiki files"
	export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --delimiter='/' --with-nth=-1"
	fmd \
		/mnt/Storage/Media/Tech/ \
		/mnt/Storage/Library \
		/usr/share/doc/arch-wiki/html/en \
		/usr/share/doc/arduino \
		"$@" ! -name '*.css'
}

# Execute functions with sudo
# sudofu() {
#   [[ "$(type -w $1)" == "$1: function" ]] &&
#     ARGS="$@" && sudo bash -c "$(declare -f $1); $ARGS"
# }
# alias ssudo='sudofu '

stty -ixon
