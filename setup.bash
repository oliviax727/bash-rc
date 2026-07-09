export BASHRC_PATH=$(pwd)

mkdir -p archive

source enter.bash
source modules/custom.bash_aliases
source modules/path_manager.bash_aliases
shopt -s expand_aliases

source modules/bash-rc.bashrc

if [ -z "$1" ]; then
    read -p "Would you like to install the clean version? (y/[n])? " response
else
    response="$(echo $1 | cut -c 2-)"
fi

version="main"

if [ "$response" == "y" ]; then
    version="clean"
fi

bash-rc build -p -c "$(git branch -r --list "origin/$version" | cut -c 10-)"

reset && source ~/.bashrc
