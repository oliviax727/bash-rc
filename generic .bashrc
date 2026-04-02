# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# ===== PRE-EXECUTION COMMANDS ===== #
export WARNING='\033[93mWARNING\033[00m'
PROMPT_COMMAND=':'

# ===== DEFAULT COMMANDS ===== #

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
shopt -s globstar

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

# ===== ANACONDA SETUP ===== #

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

# ===== CUSTOM COMMANDS - HPC OPTIONS ===== #

# Quick-Jump/CD
export software="/software/projects/mwaeor/ohrw"
export scratch="/scratch/mwaeor/ohrw"
export home="/home/ohrw"

# Uncomment if using default paths is prefered
export no_TWD=yes

if [ -n "$no_TWD" ]; then
	use_TWD=
else
	use_TWD=yes
fi

# Change path variable
function find_TWD(){
    if [ -z "$use_TWD" ]; then
        export CWD="\w"
    else
        export ctop="$(echo $PWD | awk -F/ '{print FS $2}' | tr "\/" "\$")"
        export TWD=$(eval "echo $(echo $PWD | awk -F/ '{print FS $2}' | tr "\/" "\$")")
        relpath=$(realpath -s --relative-to=$TWD $PWD)
        export CWD="$(([[ $relpath == '.' ]] && echo "$ctop") || ([[ $relpath =~ '..' ]] && echo "$PWD") || echo "$ctop/$relpath")"
    fi
}

PROMPT_COMMAND="${PROMPT_COMMAND}; find_TWD"

unset no_TWD

# ===== CUSTOM COMMANDS - GCC COMPILER ===== #

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Run C++ file with g++
CPPSTARTSTRING='#include <iostream>\n\nint main()\n{\n\tstd::cout << "Hello World" << std::endl;\n\treturn 0;\n}\n'

# Initialise C++ file
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

# Run C++ file
function run-cpp() {
    g++ -o "$1.out" "$1.cpp"
    ./"$1.out"
}

# Debug C++ file
function debug-cpp() {
    g++ -o "$1.gdb.out" -g "$1.cpp"
    gdb ./"$1.gdb.out"
}

# ===== CUSTOM COMMANDS - TERMINAL COLOURS ===== #

# Change preset terminal colour
function terminal_colour(){

    find_TWD

    if [[ $1 == "--help" ]]; then
        echo "=================================="
        echo "Change terminal colour. Use --help to see options."
        echo "=================================="
        echo "Usage:"
        echo "terminal_colour|term_col [option]"
        echo "=================================="
        echo "Available Colours:"
        echo "Default:    --basic --blank"
        echo "Monochrome: --green --blue --yellow"
        echo "Pride/Id:   --bi --trans --bi-old --ancom"
        echo "=================================="
    elif [[ $1 == "--bi" ]]; then
        export PS1='${debian_chroot:+($debian_chrooreset}\[\e[38;2;220;10;120m\]\u@\[\e[38;2;180;100;180m\]\h:\[\e[38;2;75;120;255m\]'"$CWD"'\[\033[01;00m\]\$ '
    elif [[ $1 == "--trans" ]]; then
        export PS1='${debian_chroot:+($debian_chrooreset}\[\e[38;2;91;206;250m\]\u\[\e[38;2;245;169;184m\]@\[\e[38;2;255;255;255m\]\h\[\e[38;2;245;169;184m\]:\[\e[38;2;91;206;250m\]'"$CWD"'\[\033[00m\]\$ '
    elif [[ $1 == "--green" ]]; then
        export PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]'"$CWD"'\[\033[00m\]\$ '
    elif [[ $1 == "--blue" ]]; then
        export PS1='${debian_chroot:+($debian_chroot)}\[\033[01;36m\]\u@\h\[\033[00m\]:\[\033[01;34m\]'"$CWD"'\[\033[00m\]\$ '
    elif [[ $1 == "--yellow" ]]; then
        export PS1='${debian_chroot:+($debian_chroot)}\[\033[01;93m\]\u@\h\[\033[00m\]:\[\033[01;93m\]'"$CWD"'\[\033[00m\]\$ '
    elif [[ $1 == "--blank" ]]; then
        export PS1='${debian_chroot:+($debian_chroot)}\[\033[00m\]\u@\h:'"$CWD"'\$ '
    elif [[ $1 == "--basic" ]]; then
        export PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]'"$CWD"'\[\033[00m\]\$ '
    elif [[ $1 == "--bi-old" ]]; then
        export PS1='${debian_chroot:+($debian_chrooreset}\[\e[38;2;214;2;112m\]\u@\[\e[38;2;155;79;150m\]\h:\[\e[38;2;0;56;168m\]'"$CWD"'\[\033[01;00m\]\$ '
    elif [[ $1 == "--ancom" ]]; then
        export PS1='${debian_chroot:+($debian_chrooreset}\[\e[38;2;255;0;0m\]\u@\h\[\033[01;00m\]:\[\e[38;2;100;100;100m\]'"$CWD"'\[\033[01;00m\]\$ '
    else
        echo "$1 is not a valid option. Here's the help menu:"
        terminal_colour --help
    fi
}

alias term_col="terminal_colour"

# ===== CUSTOM COMMANDS - OSKAR ===== #

# OSKAR Generic command
function oskar_bash() {
    cflag=0
    gflag=0
    bflag=0
    prog=""
    ofile=""
    prevd=$PWD
    sifs=(${HOME}/.oskar/*.sif)
    sfile="${sifs[0]}"

    if [[ ! -d ~/.oskar ]]; then
        mkdir ~/.oskar
        printf "$WARNING: OSKAR directory has just been created. This means that there is no existing OSKAR version on this device that can be recognised. Please download a binary or SIF file into ~/.oskar before continuing.\n"
    fi

    if [[ ! -f sfile ]]; then
        printf "$WARNING: There does not appear to be any SIF files in the ~/.oskar directory. Please make sure at least one sif file exists in the directory.\n"
    fi

    if [[ $1 == "--help" || $1 == "-h" ]]; then
        echo "=================================="
        echo "Run OSKAR with a custom generic bash command. By default it will run the first singularity image it"
        echo "finds in ~/.oskar. If there is no singularity image it will throw an error."
        echo "=================================="
        echo "Usage:"
        echo "oskar_bash [(-p|--prog)|(-s|--sif) <exec_file>] "
        echo "=================================="
        echo "Options:"
        echo "-g --global -s --sample: Run OSKAR with sample settings"
        echo "-l --local:              (Default) Run OSKAR in current directory with custom settings"
        echo "-i --intif:              Run OSKAR's interferometer simulation"
        echo "-I --img:                Run OSKAR's dirty imager simulation"
        echo "-b --beam:               Run OSKAR's beam simulation"
        echo "-f --file:               Settings file to use"
        echo "-c --clean:              Clean directory of OSKAR logs"
        echo "-s --sif:                If running singularity, what sif file to use"
        echo "-p --prog:               If running a binary or application, the location of the binary or application"
        echo "=================================="

        return 0
    fi

    echo "Running custom OSKAR bash command ..."
    
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
            -c | --clean)
                cflag=1
            ;;
            -s | --sif)
                sfile=$2
                bflag=0
                shift
            ;;
            -p | --prog)
                prog=$2
                bflag=1
                shift
            ;;
            \?)
                echo "'$1' is not a valid option. Use --help or -h to see what options are available."
            ;;
        esac
        shift
    done

    if [ $cflag -eq 1 ]; then
        if [ $gflag -eq 1 ]; then
            find ${HOME}/.oskar -name '*.log' -type f -delete
        else
            find . -name '*.log' -type f -delete
        fi
        return 0
    fi

    if [ $gflag -eq 1 ]; then
        ofile="$prog.ini"

        cd ${HOME}/.oskar
    fi

    if [ $bflag -eq 1 ]; then
        $prog $ofile
    else
        singularity exec --nv --bind $PWD --cleanenv --home $PWD $sfile $prog $ofile
    fi

    cd $prevd
}

# ===== CUSTOM COMMANDS - CLEAN PATH ===== #

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

# ===== CUSTOM COMMANDS - QUICK SSH===== #

function sshcd () { ssh -t $1 "source ~/.bashrc; cd $2; bash --login"; }

function qssh() {
    if [[ ! -f ~/.config/qssh-list.txt ]]; then
        touch ~/.config/qssh-list.txt
    fi

    if [[ $1 == "help" ]]; then
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

# ===== BASIC ALIAS COMMANDS ===== #

# Jupyter Notebook
alias jpy='jupyter notebook'

# Restart
alias restart="reset && source ~/.bashrc && clear"

# History Search
alias hgrep="history | grep"

# Fun Aliases
alias penis='echo "CBT also known as Cock and Ball Torture"'
alias capitalism='echo "More like Crapitalism amirite!"'
alias reuben='echo "ERRATA"'
alias cum='echo "Trans Rights are Human Rights"'
alias ios='echo "iPhone User Moment"'
alias anarchy='echo "No Gods No Masters!"'

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

# Setonix
alias setonix='ssh ohrw@setonix.pawsey.org.au'
export SETONIX='ohrw@setonix.pawsey.org.au'

# EXPAND ALL ALIASES
shopt -s expand_aliases

# Java SDK
export JAVA_HOME=/usr/lib/jvm/java-16-openjdk-amd64

# Go Path
export GOPATH=${HOME}/go
export PATH=/usr/local/go/bin:${PATH}:${GOPATH}/bin

# Casacore and boost paths
export PATH=/home/olivia/casacore:${PATH}
export PATH=/home/olivia/boost_1_88_0:${PATH}
export PATH=/root/.local/bin:${PATH}

# OSKAR GUI Path
export OSKAR_INC_DIR=/home/olivia/.oskar/OSKAR-2.11.1
export OSKAR_LIB_DIR=/home/olivia/.oskar/OSKAR-2.11.1

# Pipx Path
export PATH="$PATH:/home/olivia/.local/bin"

# GTK Path
export GTK_PATH=$GTK_PATH:/usr/lib/x86_64-linux-gnu/gtk-2.0/modules
export GTK_PATH=$GTK_PATH:/usr/lib/x86_64-linux-gnu/gtk-3.0/modules
export GTK_MODULES=libcanberra-gtk-moduleexport GOPATH=${HOME}/go
export PATH=/usr/local/go/bin:${PATH}:${GOPATH}/bin

# ===== EXIT EXECUTION ===== #

#Ubuntu Default: terminal_colour --basic
terminal_colour --trans

cleanpath
