#!/bin/bash

# Exit if undeclared variables are used
set -o nounset

# Exit if any command exits with error
set -o errexit

# Print each command to stdout before executing it
# set -o verbose

function control_c() {
	exit 1
}

trap control_c SIGINT

function yesno() {
	if [ $# -ge 2 ]; then
		case $2 in
			y|Y) default="y"; opts="Y/n";;
			n|N) default="n"; opts="y/N";;
			*)   default="";  opts="y/n";;
		esac
	else
		default=""
		opts="y/n"
	fi

	while [ 1 ]; do
		echo -n "$1 [$opts]: "
		read ans

		[ -z "$ans" ] && ans="$default"

		case "$ans" in
			y|Y) return 0;; # Return non-error
			n|N) return 1;; # Return error
		esac
	done
}
