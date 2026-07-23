# shellcheck shell=bash

# ===== BASIC ALIAS COMMANDS ===== #

# Jupyter Notebook
alias jpy='jupyter notebook'

# Restart
alias restart='reset && source ${HOME}/.bashrc && clear'

# History Search
alias hgrep='history | grep'

# Tomcat
alias tomcat_start='sudo systemctl start tomcat'
alias tomcat_status='sudo systemctl status tomcat'
alias tomcat_stop='sudo systemctl stop tomcat'
alias tomcat_restart='sudo systemctl restart tomcat'

alias open_tcp='sudo ufw allow 8080/tcp'

# Breakpoint code
# shellcheck disable=SC2154
alias breakpoint='
    echo "Entering debugging (Ctrl-d to exit):"
    while read -p"Debugging> " debugging_line
    do
        eval "$debugging_line"
    done
    echo -e "\nExiting debugging."'

# One-Way Diff
function diff-diode() {

    diff "$1" "$2" | grep '^<' | cut -c 3-

}

# CD Run
function cd-run() {

    local pwd_save="$PWD"

    cd "$1"

    eval "$2"

    cd "$pwd_save"
}

# Filename format friendly time
alias filename-date="date '+%F-%H%M-%Z'"

# Removes old revisions of snaps
function clean-snaps() {
    set -eu
    while read -r snapname revision; do
        snap remove "$snapname" --revision="$revision"
    done < <(
        LANG=en_US.UTF-8 snap list --all | awk 'NR > 1 && $6 == "disabled" {print $1, $3}'
    )
}

# Disk usage aliases
alias dus='du . -h --max-depth=1 | sort -h'
