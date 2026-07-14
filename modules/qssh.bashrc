# ===== CUSTOM COMMANDS - QUICK SSH===== #

declare -gA QSSH_HOSTS=()

function sshcd () { ssh -t $1 "source ~/.bashrc; cd $2; \$SHELL --login"; }

function qssh() {
    
    QSSH_CONFIG_FILE="${HOME}/.config/qssh/qssh.csv"
    QSSH_CONFIG_DIR="${HOME}/.config/qssh"

    # Load a specific configuration file from the environment
    function qssh-import() {
        if [[ "$1" == "-o" ]] || [[ "$1" == "--force" ]] || [[ "$1" == "-overwrite" ]]; then
            shift
            cp -f $1 "${QSSH_CONFIG_FILE}"
        fi

        # Rebuild map from file to avoid stale entries after add/remove/import.
        QSSH_HOSTS=()

        while IFS=, read -r name addr
        do
            QSSH_HOSTS["$name"]="$addr"
        done < $1
    }
    
    if [[ ! -f "${QSSH_CONFIG_FILE}" ]]; then
        echo -e "${INFORMATION_TEXT}: No pre-existing configuration file was found. This means qssh will"
        echo -e "assume an empty configuration. Creating a new empty config file: ${QSSH_CONFIG_FILE}."
        
        touch "${QSSH_CONFIG_FILE}"
    fi

    if [[ ! -d "${QSSH_CONFIG_DIR}" ]]; then
        echo -e "${INFORMATION_TEXT}: No pre-existing configuration directory was found. This means qssh will"
        echo -e "assume an no ssh keys exist. Creating a new empty config directory: ${QSSH_CONFIG_DIR}."
        
        mkdir -p "${QSSH_CONFIG_DIR}"
    fi
    
    # Load the configuration of the config file into a dict
    
    # Config file structure (it's a CSV): ~/.config/qssh.csv;
    # <config_file>={NAME,SERVER\n}
    #                            ^ Important to have newline after every entry and before EOF

    qssh-import "${QSSH_CONFIG_FILE}"

    # Split qssh name/addres
    function qssh-split-by-colon() {
        local outarr
        IFS=':' read -r -a outarr <<< "$1"
        echo "${outarr[@]}"
    }
    
    # Connect to qssh host
    function qssh-connect() {
        if [[ "$1" =~ ':' ]]; then
            local -a remote_arr
            IFS=' ' read -r -a remote_arr <<< "$(qssh-split-by-colon "$1")"
            local host_name="${remote_arr[0]}"
            local host_path="${remote_arr[1]}"
            ssh -i "${QSSH_CONFIG_DIR}/${host_name}" -t "${QSSH_HOSTS["${host_name}"]}" "source ~/.bashrc; cd ${host_path}; \$SHELL --login"
        else
            ssh -i "${QSSH_CONFIG_DIR}/$1" "${QSSH_HOSTS["$1"]}"
        fi
    }
    
    alias qsc='qssh connect'
    
    # Add or modify a qssh host
    function qssh-add() {
        # 1. Generate new SSH key
        # 2. Copy ID (User Input Required)
        # 3. Add name to config
        
        # Check override
        local overwrite_flag="0"

        if [[ "$1" == "-o" ]] || [[ "$1" == "--force" ]] || [[ "$1" == "--overwrite" ]]; then
            overwrite_flag="1"
        fi

        [[ "$overwrite_flag" == "1" ]] && shift

        local name="$1"
        local addr="$2"

        # Check path
        local path_flag="0"
        if [[ "$2" =~ ":" ]]; then
            path_flag="1"
        fi

        # Only create a key if the path flag is false
        if [[ "${path_flag}" == "0" ]]; then

            # Generate SSH key, run ssh-copy-id, and add to config file
            if [[ ! -z "${QSSH_HOSTS[${name}]}" ]] && [[ "${overwrite_flag}" == "0" ]]; then
                echo -e "${WARNING_TEXT}: The host name already exists in the configuration file!"
                echo -e "Skipping creation of SSH key and addition to remote host."
            else
                if [[ ! -f "${QSSH_CONFIG_DIR}/${name}.pub" ]]; then
                    ssh-keygen -t ed25519 -f "${QSSH_CONFIG_DIR}/${name}" -N "" || return 1
                fi

                ssh-copy-id -f -i "${QSSH_CONFIG_DIR}/${name}.pub" "${addr}" || return 1

                if [[ "${overwrite_flag}" == "1" ]]; then
                    sed -i "/^${name},/d" "${QSSH_CONFIG_FILE}"
                fi

                [[ -z "${QSSH_HOSTS[${name}]}" ]] && echo "${name},${addr}" >> "${QSSH_CONFIG_FILE}"
            fi

        else

            local -a remote_arr
            IFS=' ' read -r -a remote_arr <<< "$(qssh-split-by-colon "$1")"
            local host_name="${remote_arr[0]}"
            local host_path="${remote_arr[1]}"

            # Add remote path to config file. Does not check if it's a valid directory
            if [[ ! -z "${QSSH_HOSTS["${host_name}:${name}"]}" ]]; then
                echo -e "${WARNING_TEXT}: The path name already exists in the configuration file!"
                echo -e "Skipping addition of path to configuration file."
            elif [[ ! -z "${QSSH_HOSTS["${host_name}"]}" ]] || \
                 [[ "$(ssh -t "${QSSH_HOSTS["${host_name}"]}" "[[ -d \"${host_path}\" ]]; echo $?")" == "0" ]]
            then
                echo -e "${ERROR_TEXT}: Remote directory doesn't exist on host!"
                echo -e "Skipping addition of path to configuration file."
            else
                echo "${host_name}:${name},${addr}" >> "${QSSH_CONFIG_FILE}"
            fi

        fi
    }
    
    # Remove a key, host, or filepath
    function qssh-remove() {
        # 1. Remove SSH key
        # 2. Remove name from config

        if [[ ! "$1" =~ ":" ]]; then
            rm -rf "${QSSH_CONFIG_DIR}/$1" "${QSSH_CONFIG_DIR}/$1.pub"
            sed -i "/^$1/d" "${QSSH_CONFIG_FILE}"
        else
            sed -i "/^$1/d" "${QSSH_CONFIG_FILE}"
        fi
    }
    
    # Purge the qssh config file
    function qssh-purge() {
        rm -rf "${QSSH_CONFIG_DIR}/*"
        touch "${QSSH_CONFIG_FILE}"
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

        if [[ ! -z "${QSSH_HOSTS["${full_name}"]}" ]]; then
            # Host AND directory are valid names
            echo "${QSSH_HOSTS["${full_name}"]}"
        elif [[ ! -z "${QSSH_HOSTS["${host_name}"]}" ]]; then
            # Host is a valid name AND path is an actual path
            echo "${QSSH_HOSTS["${host_name}"]}:${path_name}"
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
        local pub_key="$(cat "${QSSH_CONFIG_DIR}/$1.pub")"
        echo "${pub_key}" | xclip -selection clipboard
        echo "${INFORMATION_TEXT}: Contents of ${QSSH_CONFIG_DIR}/$1.pub copied to clipboard."
    }
    
    # List available host/path names
    function qssh-list() {
        column -s ',' -t < "${QSSH_CONFIG_FILE}"
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

    qssh-import "${QSSH_CONFIG_FILE}"
}

qssh help 2>&1 > /dev/null
