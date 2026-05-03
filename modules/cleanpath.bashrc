# ===== CUSTOM COMMANDS - CLEAN PATH ===== #

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