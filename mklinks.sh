#!/bin/bash

echo linking to .bashrc
ln -bs .settings/.bashrc .bashrc

echo linking to .screenrc
ln -bs .settings/.screenrc .screenrc

echo linking to .vimrc
ln -bs .settings/.vimrc .vimrc

echo linking to skel.sh
ln -bs .settings/skel.sh skel.sh
