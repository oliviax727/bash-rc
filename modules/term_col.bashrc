# ===== CUSTOM COMMANDS - TERMINAL COLOURS ===== #

# Change preset terminal colour
function terminal_colour(){

    set_CWD

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
        echo "Pride/Id:   --bi --trans --bi-old --ancom --gay --pride"
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
    elif [[ $1 == "--pride" ]]; then
        export PS1='${debian_chroot:+($debian_chrooreset}\[\e[0;91m\]\u\[\e[38;5;166m\]@\[\e[0;93m\]\h\[\e[0;92m\]:\[\e[0;94m\]'"$CWD"'\[\e[38;5;57m\]\$\[\033[01;00m\] '
    elif [[ $1 == "--gay" ]]; then
        export PS1='${debian_chroot:+($debian_chrooreset}\[\e[38;2;229;0;0m\]\u\[\e[38;2;255;141;0m\]@\[\e[38;2;255;238;0m\]\h\[\e[38;2;2;129;33m\]:\[\e[38;2;0;76;255m\]'"$CWD"'\[\e[38;2;119;0;136m\]\$\[\033[01;00m\] '
    else
        echo "$1 is not a valid option. Here's the help menu:"
        terminal_colour --help
    fi
}

alias term_col="terminal_colour"