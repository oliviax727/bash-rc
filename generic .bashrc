# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

alias jpy='jupyter notebook'

# Fun Aliases
alias penis='echo "CBT also known as Cock and Ball Torture"'
alias capitalism='echo "More like Crapitalism amirite!"'
alias reuben='echo "ERRATA"'
alias cum='echo "Trans Rights are Human Rights"'
alias ios='echo "iPhone User Moment"'
alias anarchy='echo "No Gods No Masters!"'

export JAVA_HOME=/usr/lib/jvm/java-16-openjdk-amd64

# TOMCAT
alias tomcat_start='sudo systemctl start tomcat'
alias tomcat_status='sudo systemctl status tomcat'
alias tomcat_stop='sudo systemctl stop tomcat'
alias tomcat_restart='sudo systemctl restart tomcat'

alias open_tcp='sudo ufw allow 8080/tcp'

# GCC Compiler Settings

# Run C++ file with g++
CPPSTARTSTRING='#include <iostream>\n\nint main()\n{\n\tstd::cout << "Hello World" << std::endl;\n\treturn 0;\n}\n'

function init-cpp() {
    FNAME=$1

    if [[ $1 == "" ]]; then
        FNAME="main"
    fi

    if [[ ! -f "$FNAME.cpp" ]]; then
        touch "$FNAME.cpp"
        echo -e $CPPSTARTSTRING >> "$FNAME.cpp"
        g++ -o "$FNAME.out" "$FNAME.cpp"
        g++ -o "$FNAME.gdb.out" -g "$FNAME.cpp"
    else
        echo "Initialisation failed: file already exists"
    fi

}

function run-cpp() {
    g++ -o "$1.out" "$1.cpp"
    ./"$1.out"
}

function debug-cpp() {
    g++ -o "$1.gdb.out" -g "$1.cpp"
    gdb ./"$1.gdb.out"
}

# TERMINAL QOL

function terminal_colour(){
    if [[ $1 == "-bi" ]]; then
        export PS1='${debian_chroot:+($debian_chrooreset}\[\e[38;2;220;10;120m\]\u@\[\e[38;2;180;100;180m\]\h:\[\e[38;2;75;120;255m\]\w\[\033[01;00m\]\$ '
    elif [[ $1 == "-trans" ]]; then
        export PS1='${debian_chroot:+($debian_chrooreset}\[\e[38;2;91;206;250m\]\u\[\e[38;2;245;169;184m\]@\[\e[38;2;255;255;255m\]\h\[\e[38;2;245;169;184m\]:\[\e[38;2;91;206;250m\]\w\[\033[00m\]\$ '
    elif [[ $1 == "-green" ]]; then
        export PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
    elif [[ $1 == "-blue" ]]; then
        export PS1='${debian_chroot:+($debian_chroot)}\[\033[01;36m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
    elif [[ $1 == "-blank" ]]; then
        export PS1='${debian_chroot:+($debian_chroot)}\[\033[00m\]\u@\h:\w\$ '
    elif [[ $1 == "-basic" ]]; then
        export PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
    elif [[ $1 == "-bi-old" ]]; then
        export PS1='${debian_chroot:+($debian_chrooreset}\[\e[38;2;214;2;112m\]\u@\[\e[38;2;155;79;150m\]\h:\[\e[38;2;0;56;168m\]\w\[\033[01;00m\]\$ '
    elif [[ $1 == "-ancom" ]]; then
        export PS1='${debian_chroot:+($debian_chrooreset}\[\e[38;2;255;0;0m\]\u@\h\[\033[01;00m\]:\[\e[38;2;100;100;100m\]\w\[\033[01;00m\]\$ '
    fi
}

alias term_col="terminal_colour"
alias restart="reset && source ~/.bashrc && clear"

#Ubuntu Default: term_col -basic

term_col -trans

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/olivia/anaconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/olivia/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/home/olivia/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/olivia/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

export GOPATH=${HOME}/go
export PATH=/usr/local/go/bin:${PATH}:${GOPATH}/bin
export GOPATH=${HOME}/go
export PATH=/usr/local/go/bin:${PATH}:${GOPATH}/bin
export PATH=/home/olivia/casacore:${PATH}
export PATH=/home/olivia/boost_1_88_0:${PATH}
export PATH=/root/.local/bin:${PATH}

export OSKAR_INC_DIR=/home/olivia/.oskar/OSKAR-2.11.1
export OSKAR_LIB_DIR=/home/olivia/.oskar/OSKAR-2.11.1


# OSKAR Basic Command

# OSKAR Basic Command - add to .bashrc
function oskar_bash() {

    echo "Running custom OSKAR bash command ..."

    cflag=0
    gflag=0
    prog=""
    ofile=""
    outf="./"
    prevd=$PWD
    
    while [ $# -gt 0 ]; do
        case $1 in
            -g | --global | -s | --sample)
                gflag=1
            ;;
            -l | --local)
                gflag=0
            ;;
            -i | --intf)
                prog="oskar_sim_interferometer"
            ;;
            -b | --beam)
                prog="oskar_sim_beam_pattern"
            ;;
            -I | --image)
                prog="oskar_imager"
            ;;
            -f | --file)
                ofile=$2
                shift
            ;;
            -o | --output)
                outf=$2
                shift
            ;;
            -c | --clean)
                cflag=1
            ;;
            \?)
                
            ;;
        esac
        shift
    done

    if [ $cflag -eq 1 ]; then
        if [ $gflag -eq 1 ]; then
            find ~/.oskar -name '*.log' -type f -delete
        else
            find . -name '*.log' -type f -delete
        fi
        return 0
    fi

    if [ $gflag -eq 1 ]; then
        ofile="$prog.ini"

        cd ~/.oskar
    fi

    singularity exec --nv --bind $PWD --cleanenv --home $PWD ~/.oskar/OSKAR-2.8.3-Python3.sif $prog $ofile

    cd $prevd
}

# Export hgrep
alias hgrep="history | grep"

# Created by `pipx` on 2026-02-05 09:15:01
export PATH="$PATH:/home/olivia/.local/bin"

# GTK Path
export GTK_PATH=$GTK_PATH:/usr/lib/x86_64-linux-gnu/gtk-2.0/modules
export GTK_PATH=$GTK_PATH:/usr/lib/x86_64-linux-gnu/gtk-3.0/modules
export GTK_MODULES=libcanberra-gtk-moduleexport GOPATH=${HOME}/go
export PATH=/usr/local/go/bin:${PATH}:${GOPATH}/bin

# Clean Path
function cleanpath() {

    declare -A SPATH
    local RET_VAL
    local A

    local OIFS=$IFS
    IFS=':'
    for A in ${PATH}
    do
        [ -z "${SPATH[${A}]}" ] || continue

        # By this point no dupe was found
        SPATH[${A}]=${#SPATH[*]}

        # Reconstruct the $PATH
        if [ -z "$RET_VAL" ]
        then RET_VAL="$A"
        else RET_VAL="${RET_VAL}:${A}"
        fi

    done
    IFS=$OIFS
    PATH=$RET_VAL
    export PATH
}

# GOPATH
export GOPATH=${HOME}/go
export PATH=/usr/local/go/bin:${PATH}:${GOPATH}/bin

# Breakpoint code
alias breakpoint='
    while read -p"Debugging(Ctrl-d to exit)> " debugging_line
    do
        eval "$debugging_line"
    done'

# Setonix
alias setonix='ssh ohrw@setonix.pawsey.org.au'
export SETONIX='ohrw@setonix.pawsey.org.au'

# Quick ssh
function sshcd () { ssh -t $1 "source ~/.bashrc; cd $2; bash --login"; }

function qssh() {
    if [[ -f "~/.config/qssh-list.txt" ]]; then
        touch "~/.config/qssh-list.txt"
    fi

    if [[ $1 == "--help" ]]; then
        echo "=================================="
        echo "Connect to a predefined ssh server."
        echo "=================================="
        echo "Usage:"
        echo "qssh connect [(-n|--name) <host_name> | (-h|--home) <host_address>] [(-p|--pass) <password>]"
        echo "         [(-d|--dir) <cd_path> | (-l|--loc|--location) <cd_name>]"
        echo "qssh add-host (-n|--name) <host_name> [(-h|--home) <host_address>] [(-o|--force|--overwrite)]"
        echo " "
        echo "qssh add-path (-d|--dir) <cd_path> (-l|--loc|--location) <cd_name>"
        echo "              [(-n|--name) <host_name> | (-h|--home) <host_address>] [(-o|--force|--overwrite)]"
        echo "qssh remove ((-n|--name) <host_name> | (-l|--loc|--location) <cd_name>)"
        echo " "
        echo "qssh purge"
        echo " "
        echo "qssh scp [(-f|--from) [(-n|--name) <host_name> | (-h|--home) <host_address>]"
        echo "         [(-d|--dir) <cd_path> (-l|--loc|--location) <cd_name>] [(-p|--pass) <password>]]"
        echo "         [(-t|--to) [(-n|--name) <host_name> | (-h|--home) <host_address>]"
        echo "         [(-d|--dir) <cd_path> (-l|--loc|--location) <cd_name>] [(-p|--pass) <password>]]"
        echo "         [(-a|--args|--scp-args) <scp_args>]"
        echo "=================================="
        echo "Commands:"
        echo "connect:                Connect to an SSH host"
        echo "add-host:               Add/Modify an SSH host to the quick-access name list"
        echo "add-path:               Add/Modify a named file path on a given SSH host"
        echo "remove:                 Remove a named host or file path"
        echo "purge:                  Remove ALL named host or file path"
        echo "scp:                    Copy files to and from host"
        echo "help:                   Access the help menu"
        echo "=================================="
        echo "Options:"
        echo "-h --host:              An SSH server host, localhost or '-n' if none provided"
        echo "-d --dir:               A directory to cd into or copy to/from, CWD or '-l' if none provided"
        echo "-p --pass:              The password required to connect to the host"
        echo "-t --to:                File destination, local CWD if none provided"
        echo "-f --from:              File origin, local CWD if none provided"
        echo "-n --name               The name of a saved server or to save a server as"
        echo "-l --loc --location:    The name of a saved path location or to save a path as"
        echo "-o --force --overwrite: Overwite any existing name setting"
        echo "-a --args --scp-args:   Any arguments to include in the scp command. Must occur at end of command"
        echo "=================================="
    fi
}


cleanpath


