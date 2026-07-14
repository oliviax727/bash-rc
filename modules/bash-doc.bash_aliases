# shellcheck shell=bash

# Program reader
alias ss="ps -aux"

# Some useful aliases.
alias texclean='rm -f *.toc *.aux *.log *.cp *.fn *.tp *.vr *.pg *.ky'
alias h='history'
alias j="jobs -l"
alias l="ls -l "
alias ll="ls -l"
alias ls="ls -F"
alias pu="pushd"
alias po="popd"

alias c="clear"
alias m="more"
alias j="jobs"

#
# Csh compatibility:
#
alias unsetenv=unset
function setenv () {
    export "$1=$2"
}

# Function which adds an alias to the current shell and to
# the ~/.bash_aliases file.
add-alias ()
{
   local name=$1 value="$2"
    echo "alias $name='$value'" >>~/.bash_aliases
    eval "alias $name='$value'"
    alias "$name"
}

# "repeat" command.  Like:
#
#	repeat 10 echo foo
repeat ()
{ 
    local count="$1"
    shift;
    for _ in $(_seq 1 "$count");
    do
        "$@"
    done
}

# Subfunction needed by `repeat'.
_seq ()
{ 
    local lower upper;
    lower=$1 upper=$2;

    if [ "$lower" -ge "$upper" ]; then return; fi
    while [ "$lower" -lt "$upper" ];
    do
	echo -n "$lower "
        lower=$(($lower + 1))
    done
    echo "$lower"
}