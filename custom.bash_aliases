# ===== BASIC ALIAS COMMANDS ===== #

# Jupyter Notebook
alias jpy='jupyter notebook'

# Restart
alias restart="reset && source ~/.bashrc && clear"

# History Search
alias hgrep="history | grep"

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