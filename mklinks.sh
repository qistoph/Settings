#!/bin/bash

if [ $HOME != $PWD ]; then
	echo "You are not running $0 in your home directory ($HOME)"
	read -p "Are you sure to continue? " ANS

	[ "$ANS" != "y" ] && [ "$ANS" != "yes" ] && exit

	echo "Continuing"
fi

DIRNAME=$(dirname "$0")

# Exit if undeclared variables are used
set -o nounset

# Exit if any command exits with error
set -o errexit

# Print each command to stdout before executing it
set -o verbose

ln -bs ${DIRNAME}/.bashrc .bashrc
ln -bs ${DIRNAME}/.screenrc .screenrc
ln -bs ${DIRNAME}/.vimrc .vimrc
ln -bs ${DIRNAME}/skel.sh skel.sh
ln -bs ${DIRNAME}/skel.pl skel.pl

# Vim colors
if [ ! -d .vim/colors ]; then
	mkdir -p .vim/colors
fi
ln -bs $PWD/${DIRNAME}/colorful256.vim .vim/colors/

# OS specific links
if [ $OSTYPE == "cygwin" ]; then
	ln -bs ${DIRNAME}/start-keychain
fi

if [ $OSTYPE == "linux-gnu" ]; then
	ln -bs ${DIRNAME}/fixssh
fi
