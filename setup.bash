#!/bin/bash

export BASHRC_PATH=$(pwd)

mkdir -p archive

source modules/custom.bash_aliases
shopt -s expand_aliases

source modules/bash-rc.bashrc

#bash-rc build -c release/beta-1.0-main