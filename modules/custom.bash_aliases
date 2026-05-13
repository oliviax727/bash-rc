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
alias breakpoint='
    while read -p"Debugging(Ctrl-d to exit)> " debugging_line
    do
        eval "$debugging_line"
    done'

# One-Way Diff
function diff-diode() {

    diff $1 $2 | grep '^<' | cut -c 3-

}

# CD Run
function cd-run() {

    local pwd_save="$PWD"

    cd "$1"

    eval $2

    cd "$pwd_save"
}

# Filename format friendly time
alias filename-date="date '+%F-%H%M-%Z'"

#Removes old revisions of snaps
#CLOSE ALL SNAPS BEFORE RUNNING THIS
function clean-snaps() {
    set -eu
    LANG=en_US.UTF-8 snap list --all | awk '/disabled/{print $1, $3}' |
        while read snapname revision; do
            snap remove "$snapname" --revision="$revision"
        done
}