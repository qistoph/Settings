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
