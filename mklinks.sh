#!/bin/bash

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
