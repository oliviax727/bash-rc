# ===== CUSTOM COMMANDS - HPC OPTIONS ===== #

if [ "$force_set_TWD" == "yes" ]; then
	set_TWD=yes
else
	set_TWD=
fi

# Change path variable
function set_CWD(){
    if [ -z "$set_TWD" ]; then
        export CWD="\w"
    else
        export ctop="$(echo $PWD | awk -F/ '{print FS $2}' | tr "\/" "\$")"
        export TWD=$(eval "echo $(echo $PWD | awk -F/ '{print FS $2}' | tr "\/" "\$")")
        relpath=$(evalpath -sm --relative-to=$TWD $PWD)
        export CWD="$(([[ $relpath == '.' ]] && echo "$ctop") || ([[ $relpath =~ '..' ]] && echo "$PWD") || echo "$ctop/$relpath")"
    fi
}

PROMPT_COMMAND="${PROMPT_COMMAND}; set_CWD"

unset force_use_TWD