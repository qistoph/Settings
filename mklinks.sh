#!/bin/bash

if [ $HOME != $PWD ]; then
	echo "You are not running $0 in your home directory ($HOME)"
	read -p "Are you sure to continue? " ANS

	[ "$ANS" != "y" ] && [ "$ANS" != "yes" ] && exit

	echo "Continuing"
fi

# Exit if undeclared variables are used
set -o nounset

# Exit if any command exits with error
set -o errexit

# Print each command to stdout before executing it
set -o verbose

ln -bs .settings/.bashrc .bashrc
ln -bs .settings/.screenrc .screenrc
ln -bs .settings/.vimrc .vimrc
ln -bs .settings/skel.sh skel.sh
ln -bs .settings/skel.pl skel.pl

# Vim colors
if [ ! -d .vim/colors ]; then
	mkdir -p .vim/colors
fi
ln -bs $PWD/.settings/colorful256.vim .vim/colors/

# OS specific links
if [ $OSTYPE == "cygwin" ]; then
	ln -bs .settings/start-keychain
fi
