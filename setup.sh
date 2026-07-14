export BASHRC_PATH=$(pwd)

mkdir -p "archive_$(whoami)"

source enter.bash
source modules/custom.bash_aliases
source modules/path_manager.bash_aliases
shopt -s expand_aliases

source modules/bash-rc.bashrc

if [ -z "$1" ]; then
    read -p "Would you like to install the unstable version? (y/[n])? " response
else
    response="$(echo $1 | cut -c 2-)"
fi

version="main"

if [ "$response" == "y" ]; then
    bash-rc build -p -c "$(git branch -r --list "origin/main" | cut -c 10-)"
else
    bash-rc build
fi

reset && source ~/.bashrc
