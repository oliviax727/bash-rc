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