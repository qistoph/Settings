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
ln -bs ${DIRNAME}/.tmux.conf .tmux.conf
ln -bs ${DIRNAME}/.vimrc .vimrc
ln -bs ${DIRNAME}/.jq .jq
ln -bs ${DIRNAME}/skel.sh skel.sh
ln -bs ${DIRNAME}/skel.pl skel.pl
ln -bs ${DIRNAME}/skel-recursive-dir.pl skel-recursive-dir.pl
ln -bs ${DIRNAME}/skel-xpath.pl skel-xpath.pl

# Vim colors
if [ ! -d .vim/colors ]; then
	mkdir -p .vim/colors
fi
ln -bs $PWD/${DIRNAME}/colorful256.vim .vim/colors/

# Vim pathogen
if [ ! -d .vim/autoload ]; then
	mkdir -p .vim/autoload
fi
ln -bs $PWD/${DIRNAME}/vim-pathogen/autoload/pathogen.vim .vim/autoload

# Git config
GIT_CONFIG=${DIRNAME}/gitconfig
if git config --global -l | grep -q -F "include.path=${GIT_CONFIG}"; then
	echo "$GIT_CONFIG already included in git config (global)"
else
	echo "Adding $GIT_CONFIG to git config (global)"
	git config --global --add include.path "${GIT_CONFIG}"
fi

# OS specific links
if [ $OSTYPE == "cygwin" ]; then
	ln -bs ${DIRNAME}/start-keychain
fi

if [ $OSTYPE == "linux-gnu" ]; then
	ln -bs ${DIRNAME}/fixssh
fi
