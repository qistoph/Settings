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
if [ -e /usr/bin/scren ]; then
	alias r='~/.settings/grabssh; screen -U -r $1'
	alias rd='~/.settings/grabssh; screen -U -d -r $1'
	alias rD='~/.settings/grabssh; screen -U -D -r $1'
elif [ -e /usr/bin/tmux ]; then
	alias r='~/.settings/grabssh; tmux a $1'
fi

# simple hexdump
alias hd='od -Ax -tx1z -v'

# asn1parse shortcuts
alias oad='openssl asn1parse -inform der -in'
alias oap='openssl asn1parse -inform pem -in'

# server management aliases
alias agu='sudo apt-get upgrade'
alias ckr='sudo checkrestart'

# remote IP address alias
alias myip='curl ipecho.net/plain'

# cygwin specific aliases
if [ $OSTYPE == "cygwin" ]; then
	# convert path to windows path
	wcd() { cd "$(cygpath -u "$*")"; };
fi

# Ubuntu on Windows 10 specific aliases
if [ -e '/mnt/c/Windows' ]; then
	wcd() {
		if [[ "$1" =~ ^([a-zA-Z]):\\(.*) ]]; then
			drive=$(echo "${BASH_REMATCH[1]}" | tr '[:upper:]' '[:lower:]')
			path=$(echo "${BASH_REMATCH[2]}" | tr '\\' '/')
			cd "/mnt/$drive/$path"
		fi
	};
fi

# cd and ls directory
cdl() {
  cd "$1" && ls
}

# create and enter a new directory
nd() {
  mkdir "$1" && cd "$1"
}

if [[ -e /usr/share/terminfo/x/xterm+256color || -e /usr/share/terminfo/78/xterm+256color || -e /usr/share/terminfo/78/xterm-256color ]]; then
	export TERM='xterm-256color'
else
	export TERM='xterm-color'
fi

# set a fancy prompt
case "$TERM" in
xterm*|screen)
	HAS_GIT_PS1=$(declare -F __git_ps1)
	if [ -n "$HAS_GIT_PS1" ]; then
		# Set a prompt of: user@host and current_directory (git branch)
		PS1='\n\[\e[32m\]\u@\h \[\e[33m\]\w \[\e[31m\]$(__git_ps1 "(%s)")\[\e[0m\]\n\$ '
	else
		# Set a prompt of: user@host and current_directory
		PS1='\n\[\e[32m\]\u@\h \[\e[33m\]\w\[\e[0m\]\n\$ '
	fi
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

if [ -z "$SSH_AUTH_SOCK" ]; then
	# SSH_AUTH_SOCK is not yet set (e.g. by forwarding)

	GPG_SSH_SOCK=$(gpgconf --list-dirs agent-ssh-socket 2>/dev/null)
	GPG_SSH_SOCK_ALT="$HOME/.gnupg/S.gpg-agent.ssh"

	if [ -S "$GPG_SSH_SOCK_ALT" ]; then
		export SSH_AUTH_SOCK="$GPG_SSH_SOCK_ALT"
	elif [ -n "$GPG_SSH_SOCK" ] && [ -S "$GPG_SSH_SOCK" ]; then
		export SSH_AUTH_SOCK="$GPG_SSH_SOCK"
	fi
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc).
#if [ -f /etc/bash_completion ]; then
#  . /etc/bash_completion
#fi

cls() { echo -n "[;H[2J"; }

hexdiff() { vimdiff <(hexdump -vC "$1") <(hexdump -vC "$2"); }

hex2bin() { perl -ne '$_=~s/[^0-9a-f]//ig; print pack("H*", $_)' "$@"; }

bin2hex() { perl -ne 'print unpack("H*", $_)' "$@"; }

grepl() { grep --color=always "$@" | less -r; }

jqdiff() {
	if [ $# -lt 3 ]; then
		echo "Usage: jqdiff <jq options> <file1> <file2>"
	else
		N=$[ $# - 2 ]
		FILE1="${*:(-2):1}"
		FILE2="${*:(-1):1}"
		ARGS=${*:1:$N}
		vimdiff <(jq $ARGS "$FILE1") <(jq $ARGS "$FILE2")
	fi
}

# CD into the (lexicographic) last directory matching the predicate
# e.g.
# /dir $ ls
# ...
# Backup-20170101
# Backup-20170201
# Backup-20170301
# ...
# /dir $ cdz Backup-
# /dir/Backup-20170301 $
cdz() {
	cd $(find "$1"* -maxdepth 0 -type d | sort -r | head -1)
}

kpcli() {
	# Start kpcli
	/usr/local/bin/kpcli --histfile /dev/null $*;
	# Clear onsceen scrollback
	clear;
	# Clear VTERM scrollback
	reset;
	# Clear screen scrollback (size: 0, size: 10000)
	screen -X eval 'scrollback 0' -X eval 'scrollback 10000';
	echo "Scrollback cleared";
}

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

git-url() {
	echo $(git remote -v | sed -En '/github/s/.*:(\S+)(\.git) \(push\).*/https:\/\/github.com\/\1\/commit\//p; /abu/s/.*:repos\/(\S+) \(push\)/https:\/\/bleq.nl\/gitlist\/\1\/commit\//p')$(git log -1 --format=format:'%H')
}

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # while symlink
	DIR="$(cd -P "$(dirname "$SOURCE")" && pwd)"
	SOURCE="$(readlink "$SOURCE")"
	[[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if SOURCE was rel.symlink, we need relative to path
done
DIR="$(cd -P "$(dirname "$SOURCE")" && pwd)"

[ -e "$DIR/.bashrc.local" ] && source "$DIR/.bashrc.local"
