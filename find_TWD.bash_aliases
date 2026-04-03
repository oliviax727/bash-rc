# ===== CUSTOM COMMANDS - HPC OPTIONS ===== #

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