#!/bin/bash

export BASHRC_PATH=$(pwd)

mkdir -p archive

source enter.bash

source modules/custom.bash_aliases
source modules/evalpath.bash_aliases
shopt -s expand_aliases

source modules/bash-rc.bashrc

bash-rc-set-path $BASHRC_PATH

read -p "Would you like to install the clean version? (y/[n])? " response

version="main"

if [ "$response" -eq "y" ]; then
    version="main"
fi

bash-rc build -k "$(git branch --list "release/*-$version")"