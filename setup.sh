#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export BASHRC_PATH="${SCRIPT_DIR}"

mkdir -p "archive_$(whoami)"

source "${BASHRC_PATH}/enter.bash"
source "${BASHRC_PATH}/modules/custom.bash_aliases"
source "${BASHRC_PATH}/modules/path_manager.bashrc"
shopt -s expand_aliases

source "${BASHRC_PATH}/modules/bash-rc.bashrc"

if [ -z "$1" ]; then
    read -r -p "Would you like to install the unstable version? (y/[n])? " response
else
    response="${1#-}"
fi

if [ "$response" == "y" ]; then
    bash-rc build -f -p -c "$(git branch -r --list "origin/main" | cut -c 10-)"
else
    bash-rc build -f
fi

if [[ $- == *i* ]]; then
    # shellcheck source=/dev/null
    reset && source ~/.bashrc
fi
