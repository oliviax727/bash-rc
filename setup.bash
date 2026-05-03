#!/bin/bash

export BASHRC_PATH=$(pwd)

mkdir -p archive

source enter.bash

source modules/custom.bash_aliases
source modules/evalpath.bash_aliases
shopt -s expand_aliases

source modules/bash-rc.bashrc

bash-rc-set-path $BASHRC_PATH
bash-rc build