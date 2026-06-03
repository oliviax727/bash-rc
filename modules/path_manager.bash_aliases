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
                local latter_path="$(echo "$arg" | awk -F= '{print $2}')"
                local eval_latter_path="$(evalpath -m "${latter_path}")"
                arg_replaced_path="${arg/"$latter_path"/"$eval_latter_path"}"
            fi

            arguments="$arguments:$arg_replaced_path"
        elif [[ "$arg" =~ $VALID_PATH ]]; then
            # Replace all instances of HOME with ~
            local arg_no_home="${arg/#~/${HOME}}"
            

            # First remove all protected spaces
            local arg_unsafe="${arg_no_home/\\\ /\ }"

            # Then add back all protected spaces
            local arg_safe=${arg_unsafe/ /\\ }
            
            arguments="$arguments:$arg_safe"
        fi
    done

    IFS=':' read -r -a args_array <<< "$arguments"

    eval '"realpath${args_array[@]}"'
}

if [ "$force_set_TWD" == "yes" ]; then
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

            export TWD="$(eval "echo \$${VAR}")"
            local relpath="$(evalpath -sm --relative-to="$TWD" "$PWD")"

            if [[ "$relpath" =~ '..' ]]; then
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
