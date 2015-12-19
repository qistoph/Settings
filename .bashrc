# ~/.bashrc: executed by bash(1) for non-login shells.

# This script is provided by Chris van Marle on GitHub
# https://github.com/qistoph

# If not running interactively, don't do anything
[[ "$-" != *i* ]] && return

# Prevent accidental closing of last shell with C-d (don't export the IGNOREEOF)
[[ "$BASHOPTS" == *:login_shell:* ]] && IGNOREEOF=1 

# don't put duplicate lines in the history
# don't put lines starting with space in the history
export HISTCONTROL="ignoreboth"
export HISTSIZE=1000

# preferred editor: vim
export EDITOR=vim
export SHELL

# if I want core dumps
#ulimit -c unlimited

# regurly check the window size
shopt -s checkwinsize

# enable color support of ls and also add handy aliases
eval `dircolors -b`
alias ls='ls --color=auto'
alias dir='ls --color=auto --format=vertical'
alias vdir='ls --color=auto --format=long'
alias grep='grep --color=auto'

# some more ls aliases
alias l='ls -l'
alias ll='ls -l'
alias la='ls -A'
alias l.='ls -d .*'

# show warnings when calling gcc
alias gcc='gcc -Wall'

# easy reconnect to screen with r
alias r='~/.settings/grabssh; screen -r $1'

# simple hexdump
alias hd='od -Ax -tx1z -v'

# asn1parse shortcuts
alias oad='openssl asn1parse -inform der -in'
alias oap='openssl asn1parse -inform pem -in'

# cygwin specific aliases
if [ $OSTYPE == "cygwin" ]; then
	# convert path to windows path
	wcd() { cd "$(cygpath -u "$*")"; };
fi

# create and enter a new directory
nd() {
  mkdir "$1" && cd "$1"
}

# set a fancy prompt
case "$TERM" in
xterm*|screen)
	# Set a prompt of: user@host and current_directory
	PS1='\n\[\e[32m\]\u@\h \[\e[33m\]\w\[\e[0m\]\n\$ '
	;;
*)
	PS1='\u@\h:\w\$ '
	;;
esac

# If this is an xterm set the title to user@host:dir
case $TERM in
xterm*)
	PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD}\007"'
	;;
*)
	;;
esac

if [[ -e /usr/share/terminfo/x/xterm+256color || -e /usr/share/terminfo/78/xterm+256color || -e /usr/share/terminfo/78/xterm-256color ]]; then
	export TERM='xterm-256color'
else
	export TERM='xterm-color'
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc).
#if [ -f /etc/bash_completion ]; then
#  . /etc/bash_completion
#fi

cls() { echo -n "[;H[2J"; }

hexdiff() { diff <(hexdump -C "$1") <(hexdump -C "$2"); }

hex2bin() { perl -ne '$_=~s/[^0-9a-f]//ig; print pack("H*", $_)' "$@"; }

bin2hex() { perl -ne 'print unpack("H*", $_)' "$@"; }

grepl() { grep --color=always "$@" | less -r; }

# Git helpers
# Perform passed git command on all git repositories found in supplied path
git-all() {
	if [ ${#*} -lt 2 ]; then
		echo "$FUNCNAME <path> <git-commmand> [git-arguments...]";
		return;
	fi
	find "$1" -name '.git' |\
		while read GIT; do
			WD=${GIT%/.git};
			git --work-tree "$WD" --git-dir "$GIT" ${@:2} | \
				awk "{print\"$WD:\"\$0}";
		done;
}

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # while symlink
	DIR="$(cd -P "$(dirname "$SOURCE")" && pwd)"
	SOURCE="$(readlink "$SOURCE")"
	[[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if SOURCE was rel.symlink, we need relative to path
done
DIR="$(cd -P "$(dirname "$SOURCE")" && pwd)"

[ -e "$DIR/.bashrc.local" ] && source "$DIR/.bashrc.local"
