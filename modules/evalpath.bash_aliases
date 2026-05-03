# Test command output
function test-cmd(){
    eval "$1" > /dev/null 2>&1 && return 0 || return 1
}

# Realpath tilde alias
function evalpath() {
    arguments=""
    for arg in "$@"; do
        if test-cmd "realpath -m $arg"; then
            arguments="$arguments:${arg/#~/${HOME}}"
        else
            arguments="$arguments:$arg"
        fi
    done

    IFS=':' read -r -a args_array <<< "$arguments"
    
    realpath ${args_array[@]}
}