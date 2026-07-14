# ===== CUSTOM COMMANDS - QUICK SSH===== #

function sshcd () { ssh -t $1 "source ~/.bashrc; cd $2; \$SHELL --login"; }

function qssh() {
    
    local CONFIG_FILE="${HOME}/.config/qssh/qssh.csv"
    local CONFIG_DIR="${HOME}/.config/qssh"
    
    # Load a specific configuration file from the environment
    function qssh-import() {
        if [[ "$1" == "-o" ]] || [[ "$1" == "--force" ]] || [[ "$1" == "-overwrite" ]]; then
            shift
            cp -f $1 "${CONFIG_FILE}"
        fi

        while IFS=, read -r name addr
        do
            echo "$name and $addr"
        done < $1
    }
    
    if [[ ! -f "${CONFIG_FILE}" ]]; then
        echo -e "${INFORMATION_TEXT}: No pre-existing configuration file was found. This means qssh will"
        echo -e "assume an empty configuration. Creating a new empty config file: ${CONFIG_FILE}."
        
        touch "${CONFIG_FILE}"
    fi

    if [[ ! -d "${CONFIG_DIR}" ]]; then
        echo -e "${INFORMATION_TEXT}: No pre-existing configuration directory was found. This means qssh will"
        echo -e "assume an no ssh keys exist. Creating a new empty config directory: ${CONFIG_DIR}."
        
        mkdir -p "${CONFIG_DIR}"
    fi
    
    # Load the configuration of the config file into a dict
    
    # Config file structure (it's a CSV): ~/.config/qssh.csv;
    # <config_file>={NAME,SERVER\n}
    #                            ^ Important to have newline after every entry and before EOF

    declare -A SSH_HOSTS
    qssh-import "${CONFIG_FILE}"

    # Split qssh name/addres
    function qssh-split-by-colon() {
        local outarr
        IFS=':' read -r -a outarr <<< "$1"
        echo "${outarr[@]}"
    }
    
    # Connect to qssh host
    function qssh-connect() {
        if [[ "$1" =~ ':' ]]; then
            local remote_arr="$(qssh-split-by-colon "$1")"
            sshcd "${remote_arr[@]}"
        else
            ssh "${SSH_HOSTS["$1"]}"
        fi
    }
    
    alias qsc='qssh-connect'
    
    # Add or modify a qssh host
    function qssh-add() {
        # 1. Generate new SSH key
        # 2. Copy ID (User Input Required)
        # 3. Add name to config
        
        # Check override
        [[ "$1" == "-o" ]] || [[ "$1" == "--force" ]] || [[ "$1" == "-overwrite" ]]
        local overwrite_flag="$?"

        [[ "$overwrite_flag" == "1" ]] && shift

        local name="$1"
        local addr="$2"

        # Check path
        [[ ! "$2" =~ ":" ]]
        local path_flag="$?"

        # Only create a key if the path flag is false
        if [[ "${path_flag}" == "0" ]]; then

            # Generate SSH key, run ssh-copy-id, and add to config file
            if [[ ! -f "${HOME}/.ssh/${name}.pub" ]]; then
                echo -e "${WARNING_TEXT}: The SSH key already exists in the configuration directory!"
                echo -e "Skipping creation of SSH key and addition to remote host."
            elif [[ ! -z "${SSH_HOSTS[${name}]}" ]]; then
                echo -e "${WARNING_TEXT}: The host name already exists in the configuration file!"
                echo -e "Skipping creation of SSH key and addition to remote host."
            else
                ssh-keygen -t ed25519 <<< "${CONFIG_DIR}/${name}\n\n\n" && \
                    ssh-copy-id -f -i "${CONFIG_DIR}/${name}" "${addr}" && \
                    echo "${name},${addr}" >> "${CONFIG_FILE}"
                
                # Delete key if the op failed
                [[ "$?" == "1" ]] && rm -rf "${CONFIG_DIR}/${name}" "${CONFIG_DIR}/${name}.pub"
            fi

        else

            local remote_arr="$(qssh-split-by-colon "$1")"
            local host_name="${remote_arr[0]}"
            local host_path="${remote_arr[1]}"

            # Add remote path to config file. Does not check if it's a valid directory
            if [[ ! -z "${SSH_HOSTS["${host_name}:${name}"]}" ]]; then
                echo -e "${WARNING_TEXT}: The path name already exists in the configuration file!"
                echo -e "Skipping addition of path to configuration file."
            elif [[ "$(ssh -t $SETONIX "[[ -d \"${host_path}\" ]]; echo $?")" == "0" ]]; then
                echo -e "${ERROR_TEXT}: Remote directory doesn't exist on host!"
                echo -e "Skipping addition of path to configuration file."
            else
                echo "${host_name}:${name},${addr}" >> "${CONFIG_FILE}"
            fi

        fi
    }
    
    # Remove a key, host, or filepath
    function qssh-remove() {
        # 1. Remove SSH key
        # 2. Remove name from config

        if [[ ! "$1" =~ ":" ]]; then
            rm -rf "${CONFIG_DIR}/$1" "${CONFIG_DIR}/$1.pub"
            sed -i "/^$1/d" "${CONFIG_FILE}"
        else
            sed -i "/^$1/d" "${CONFIG_FILE}"
        fi
    }
    
    # Purge the qssh config file
    function qssh-purge() {
        rm -rf "${CONFIG_DIR}/*"
        touch "${CONFIG_FILE}"
    }

    # Evaluate and return a valid qssh scp path
    function qssh-eval-scp-path() {
        local full_name
        local host_name
        local path_name

        if [[ "$1" =~ ":" ]]; then
            full_name="$1"
            remote_arr="$(qssh-split-by-colon "${full_name}")"
            host_name="${remote_arr[0]}"
            path_name="${remote_arr[1]}"
        else
            full_name="$1"
            host_name="$1"
            path_name=""
        fi

        if [[ ! -z "${SSH_HOSTS["${full_name}"]}" ]]; then
            # Host AND directory are valid names
            echo "${SSH_HOSTS["${full_name}"]}"
        elif [[ ! -z "${SSH_HOSTS["${host_name}"]}" ]]; then
            # Host is a valid name AND path is an actual path
            echo "${SSH_HOSTS["${host_name}"]}:${path_name}"
        elif [[ -d "$(evalpath "${full_name}")" ]]; then
            # Parameter is a valid local path
            echo "$(evalpath "${full_name}")"
        else
            echo "${ERROR_TEXT}: Specified origin is neither a valid local or remote directory."
            return 1
        fi
    }
    
    # Secure copy a file to or from a qssh host
    function qssh-scp() {
        local from_file="$(qssh-eval-scp-path "$1")"
        local to_file="$(qssh-eval-scp-path "$2")"

        shift; shift; shift;

        scp "$@" "${from_file}" "${to_file}"
    }
    
    # Copy an ssh key to clipboard
    function qssh-get-key() {
        local pub_key="$(cat "${CONFIG_DIR}/$1.pub")"
        echo "${pub_key}" | xclip -selection clipboard
        echo "${INFORMATION_TEXT}: Contents of ${CONFIG_DIR}/$1.pub copied to clipboard."
    }
    
    # List available host/path names
    function qssh-list() {
        column -s ',' -t < "${CONFIG_FILE}"
    }
    
    # Help
    function qssh-help() {
        echo "=================================="
        echo "Connect to a predefined ssh server."
        echo "=================================="
        echo "Usage:"
        echo "qsc <host_name>:[<path>|<path_name>]"
        echo " "
        echo "qssh connect <host_name>:[<path>|<path_name>]"
        echo " "
        echo "qssh add [-o] (<host_name> <host_address> | <path_name> <host_name>:<path>)"
        echo " "
        echo "qssh scp (<local_path> | <host_name>:[<path>|<path_name>])"
        echo "         (<local_path> | <host_name>:[<path>|<path_name>])"
        echo "         [-- <scp_args>]"
        echo " "
        echo "qssh remove <host_name>[:<path_name>]"
        echo " "
        echo "qssh import [-o] <config_file>"
        echo " "
        echo "qssh get-key <host_name>[:<path_name>]"
        echo " "
        echo "qssh list"
        echo " "
        echo "qssh purge"
        echo " "
        echo "=================================="
        echo "Commands:"
        echo "connect                Connect to an SSH host"
        echo "add                    Add/Modify an SSH host or directory to the quick-access name list"
        echo "scp                    Copy files to and from host"
        echo "remove                 Remove a named host (and all associated file paths) or specific file path"
        echo "import                 Import a pre-existing configuration file and create relevant keys"
        echo "get-key                Copy host/path SSH key to clipboard (requires xclip)"
        echo "list                   List existing saved hosts and paths"
        echo "purge                  Remove ALL named hosts, file paths, and default key options"
        echo "help                   Access the help menu"
        echo "=================================="
        echo "Options:"
        echo "-n --name              Generic alphanumeric name field"
        echo "-t --to                File destination, local CWD if none provided"
        echo "-f --from              File origin, local CWD if none provided"
        echo "-o --force --overwrite Overwite any existing name setting or overwrite config file"
        echo "=================================="
        echo "Notes:"
        echo "Hyphenating the first argument instead of using space (e.g. qssh-help instead of qssh help)"
        echo "will also call the desired function."
        echo "=================================="
    }
    
    # Execute command
    local sel_cmd=$1
    shift
    
    local error_text="${ERROR_TEXT}: Command doesn't exist. Use \`qssh help\` or \`qssh-help\` to see what commands exist"
    
    if [ "$(type -t "qssh-$sel_cmd")" == "function" ]; then
        eval '"qssh-$sel_cmd" $@'
    else
        echo -e "$error_text"
        return 1
    fi
}
