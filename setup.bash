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
    response=$(echo "$1" | cut -c 1- )
fi

version="main"

if [ "$response" == "y" ]; then
    version="clean"
fi

bash-rc build -k -c "$(git branch --list "release/*-$version")"
