# shellcheck shell=bash
# shellcheck disable=SC2154

# ===== CUSTOM COMMANDS - Evalpath ===== #

# Test command output
function test-cmd(){
    eval "$1" > /dev/null 2>&1 && return 0 || return 1
}

# Valid path and realpath commands
export VALID_PATH='(((((\\\s)*|[^\0\s]+)+))+)'
export VALID_REALPATH_CMD_ARG='(\-[EmLPqsz]+)|(\-\-((canonicalize)|(canonicalize\-existing)|(canonicalize\-missing)|(logical)|(physical)|(quiet)|(relative\-to='"$VALID_PATH"')|(relative\-base='"$VALID_PATH"')|(strip)|(no\-symlinks)|(zero)|(help)|(version)))'

# Realpath tilde alias
function evalpath() {
    local arguments=""

    for arg in "$@"; do
        if [[ "$arg" =~ $VALID_REALPATH_CMD_ARG ]]; then
            local arg_replaced_path="$arg"

            if [[ "$arg" =~ "=" ]]; then
                local latter_path
                local eval_latter_path
                latter_path="$(echo "$arg" | awk -F= '{print $2}')"
                eval_latter_path="$(evalpath -m "${latter_path}")"
                arg_replaced_path="${arg/"$latter_path"/"$eval_latter_path"}"
            fi

            arguments="$arguments:$arg_replaced_path"
        elif [[ "$arg" =~ $VALID_PATH ]]; then
            # Replace all instances of HOME with ~
            local arg_no_home="${arg/#~/${HOME}}"

            # First remove all protected unsafe characters
            local arg_unsafe="${arg_no_home/(\\)([^a-zA-Z0-9\_\-\.])/\2/g}"

            # Then add back all protected spaces
            local arg_safe="${arg_unsafe/([^a-zA-Z0-9\_\-\.])/\\\1}"

            arguments="$arguments:$arg_safe"
        fi
    done

    # shellcheck disable=SC2034
    IFS=':' read -r -a args_array <<< "$arguments"

    eval '"realpath${args_array[@]}"'
}

if [ "${force_set_TWD:-}" == "yes" ]; then
	set_TWD=yes
else
	set_TWD=
fi

# Change path variable
function set_CWD(){
    if [ -z "$set_TWD" ]; then
        export CWD="${PWD/${HOME}/\~}"
    else

        local QJ_VARS=""
        IFS=':' read -r -a QJ_VARS <<< "$QUICK_JUMP_VARS"

        # Always order QUICK_JUMP_VARS in order of precedence
        for VAR in "${QJ_VARS[@]}"; do

            local relpath
            local twd_value
            twd_value="$(eval "echo \$${VAR}")"
            export TWD="$twd_value"
            relpath="$(evalpath -sm --relative-to="$TWD" "$PWD")"

            if [[ "$relpath" =~ \.\. ]]; then
                export CWD="${PWD/${HOME}/\~}"
            elif [[ "$relpath" == '.' ]]; then
                export CWD="\$$VAR"
                break
            else
                export CWD="\$$VAR/$relpath"
                break
            fi
        done
    fi
}

PROMPT_COMMAND="${PROMPT_COMMAND}; set_CWD"

# Change preset terminal colour
function terminal_colour(){
    # shellcheck disable=SC2154

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
        echo "Pride:      --bi --trans --bi-old --demi --gay --pride"
        echo "Political:  --aneco --ancom"
        echo "=================================="
    elif [[ $1 == "--bi" ]]; then
        export PS1='${debian_chroot:+($debian_chrooreset}\[\e[38;2;220;10;120m\]\u@\[\e[38;2;180;100;180m\]\h:\[\e[38;2;75;120;255m\]$CWD\[\033[01;00m\]\$ '
    elif [[ $1 == "--trans" ]]; then
        export PS1='${debian_chroot:+($debian_chrooreset}\[\e[38;2;91;206;250m\]\u\[\e[38;2;245;169;184m\]@\[\e[38;2;255;255;255m\]\h\[\e[38;2;245;169;184m\]:\[\e[38;2;91;206;250m\]$CWD\[\033[00m\]\$ '
    elif [[ $1 == "--green" ]]; then
        export PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]$CWD\[\033[00m\]\$ '
    elif [[ $1 == "--blue" ]]; then
        export PS1='${debian_chroot:+($debian_chroot)}\[\033[01;36m\]\u@\h\[\033[00m\]:\[\033[01;34m\]$CWD\[\033[00m\]\$ '
    elif [[ $1 == "--yellow" ]]; then
        export PS1='${debian_chroot:+($debian_chroot)}\[\033[01;93m\]\u@\h\[\033[00m\]:\[\033[01;93m\]$CWD\[\033[00m\]\$ '
    elif [[ $1 == "--blank" ]]; then
        export PS1='${debian_chroot:+($debian_chroot)}\[\033[00m\]\u@\h:$CWD\$ '
    elif [[ $1 == "--basic" ]]; then
        export PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]$CWD\[\033[00m\]\$ '
    elif [[ $1 == "--bi-old" ]]; then
        export PS1='${debian_chroot:+($debian_chrooreset}\[\e[38;2;214;2;112m\]\u@\[\e[38;2;155;79;150m\]\h:\[\e[38;2;0;56;168m\]$CWD\[\033[01;00m\]\$ '
    elif [[ $1 == "--ancom" ]]; then
        export PS1='${debian_chroot:+($debian_chrooreset}\[\e[38;2;255;0;0m\]\u@\h\[\033[01;00m\]:\[\e[38;2;100;100;100m\]$CWD\[\033[01;00m\]\$ '
    elif [[ $1 == "--pride" ]]; then
        export PS1='${debian_chroot:+($debian_chrooreset}\[\e[0;91m\]\u\[\e[38;5;166m\]@\[\e[0;93m\]\h\[\e[0;92m\]:\[\e[0;94m\]$CWD\[\e[38;5;165m\]\$\[\033[01;00m\] '
    elif [[ $1 == "--gay" ]]; then
        export PS1='${debian_chroot:+($debian_chrooreset}\[\e[38;2;229;0;0m\]\u\[\e[38;2;255;141;0m\]@\[\e[38;2;255;238;0m\]\h\[\e[38;2;2;129;33m\]:\[\e[38;2;0;76;255m\]$CWD\[\e[38;2;119;0;136m\]\$\[\033[01;00m\] '
    elif [[ $1 == "--demi" ]]; then
        export PS1='\[\e[38;2;127;127;127m\]${debian_chroot:+($debian_chrooreset}\[\e[38;2;185;185;185m\]\u\[\e[38;2;255;170;203m\]@\[\e[38;2;255;255;255m\]\h\[\e[38;2;255;170;203m\]:\[\e[38;2;185;185;185m\]$CWD\[\e[38;2;127;127;127m\]\$\[\033[01;00m\] '
    elif [[ $1 == "--aneco" ]]; then
        export PS1='${debian_chroot:+($debian_chrooreset}\[\e[38;2;4;221;33m\]\u@\h\[\033[01;00m\]:\[\e[38;2;100;100;100m\]$CWD\[\033[01;00m\]\$ '
    else
        echo "$1 is not a valid option. Here's the help menu:"
        terminal_colour --help
    fi
}

alias term_col="terminal_colour"

# Clean Path - first argument is the path variable, by default it is PATH
function cleanpath() {

    local PATH_VAR_NAME=PATH

    if [ ! $# -eq 0 ]; then
        local PATH_VAR_NAME=$1
    fi

    declare -A SPATH
    local RET_VAL
    local PATH_ENTRY
    local PATH_ARR

    IFS=':' read -r -a PATH_ARR <<< "$(eval "echo \$$PATH_VAR_NAME")"
    
    for PATH_ENTRY in "${PATH_ARR[@]}"
    do
        # Skip if entry is blank
        [ ! -z "$PATH_ENTRY" ] || continue

        # Use absolute pathing
        ABS_PATH=$(evalpath -m "$PATH_ENTRY")

        # Check if directory exists
        [ -d "$ABS_PATH" ]  || continue

        # Check duplicate
        [ -z "${SPATH[${ABS_PATH}]}" ] || continue

        # By this point no dupe was found and directory exists
        SPATH[${ABS_PATH}]=${#SPATH[*]}

        # Reconstruct the $PATH
        if [ -z "$RET_VAL" ]
        then RET_VAL="$ABS_PATH"
        else RET_VAL="${RET_VAL}:${ABS_PATH}"
        fi
    done

    eval "$PATH_VAR_NAME=$RET_VAL"
    eval "export $PATH_VAR_NAME"
}
