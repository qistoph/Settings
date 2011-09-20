# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# This script is provided by Chris van Marle on GitHub
# https://github.com/qistoph

# If not running interactively, don't do anything
[[ "$-" != *i* ]] && return

# don't put duplicate lines in the history. See bash(1) for more options
export HISTCONTROL=ignoredups
export HISTSIZE=1000

export EDITOR=vim

# enable color support of ls and also add handy aliases
eval `dircolors -b`
alias ls='ls --color=auto'
alias dir='ls --color=auto --format=vertical'
alias vdir='ls --color=auto --format=long'

# some more ls aliases
alias l='ls -l'
alias ll='ls -l'
alias la='ls -A'
alias l.='ls -d .*'

alias gcc='gcc -Wall'

alias r='screen -r $1'

alias hd='od -Ax -tx1z -v'

# I want core dumps
#ulimit -c unlimited

nd() {
  mkdir "$1" && cd "$1"
}

# set a fancy prompt
case "$TERM" in
xterm*|screen)
	# Set a prompt of: user@host and current_directory
	PS1='\[\e]0;\w\a\]\n\[\e[32m\]\u@\h \[\e[33m\]\w\[\e[0m\]\n\$ '
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

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc).
#if [ -f /etc/bash_completion ]; then
#  . /etc/bash_completion
#fi

wt() {
	echo -n "]2;${@}"
}

it() {
	echo -n "]0;${@}"
}

defwt() {
	echo -n "]2;$(whoami) @ $(hostname)"
}

cls() {
	echo "[;H[2J"
}
