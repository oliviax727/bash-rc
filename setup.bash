#!/bin/bash

export BASHRC_PATH=$(pwd)

mkdir -p archive

source enter.bash
source modules/custom.bash_aliases
source modules/evalpath.bash_aliases
shopt -s expand_aliases

source modules/bash-rc.bashrc

if [ -z "$1" ]; then
    read -p "Would you like to install the clean version? (y/[n])? " response
else
    response="$1"
fi

version="main"

if [ "$response" == "-y" ]; then
    version="clean"
fi

echo "export BASHRC_PATH=" >> "${HOME}/.bashrc"

bash-rc-set-path $BASHRC_PATH

bash-rc build -c "$(git branch -r --list "origin/release/*-$version" | cut -c 10-)"
