# ===== CUSTOM COMMANDS - QUICK SSH===== #

function sshcd () { ssh -t $1 "source ~/.bashrc; cd $2; bash --login"; }

function qssh() {

    local CONFIG_FILE="${HOME}/.config/qssh.csv"

    # Load a specific configuration file from the environment
    function qssh-import() {
        :
    }

    if [[ ! -f "${CONFIG_FILE}" ]]; then
        echo "${INFORMATION_TEXT}: No pre-existing configuration file was found. This means qssh will operate under"
        echo "the default settings. Creating a new empty config file: ${CONFIG_FILE}"
        
        touch "${CONFIG_FILE}"
    else
        qssh-import "${CONFIG_FILE}"
    fi

    # Load the configuration of the config file into a dict
    
    # Config file structure (it's a CSV): ~/.config/qssh.csv
    # NAME,SERVER

    : # Put Code Here

    # Connect to qssh host
    function qssh-connect() {
        :
    }

    alias qsc='qssh-connect'

    # Add or modify a qssh host
    function qssh-add() {
        # 1. Generate new SSH key
        # 2. Copy ID (User Input Required)
        # 3. Add name to config
        :
    }

    # Remove a key, host, or filepath
    function qssh-remove() {
        # 1. Remove SSH key
        # 2. Remove name from config
        :
    }

    # Purge the qssh config file
    function qssh-purge() {
        > "${CONFIG_FILE}"
    }

    # Secure copy a file to or from a qssh host
    function qssh-scp() {
        :
    }

    # Copy an ssh key to clipboard
    function qssh-get-key() {
        :
    }

    # List available host/path names
    function qssh-list() {
        column -s ',' -t < "${CONFIG_FILE}"
    }

    if [[ ! -f "${HOME}/.ssh/${QSSH_DEFAULT_KEY_NAME}" || ! -f "${HOME}/.ssh/${QSSH_DEFAULT_KEY_NAME}.pub" ]]; then
        echo "${WARNING_TEXT}: Default SSH key does not exist in ${HOME}/.ssh, please create an ssh key using:"
        echo "qssh-add-key or switch to an existing ssh key qssh-switch."
    fi

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
        echo "qssh add (<host_name> <host_address> | <path_name> <host_name>:<path>)"
        echo " "
        echo "qssh scp (<local_path> | <host_name>:[<path>|<path_name>])"
        echo "         (<local_path> | <host_name>:[<path>|<path_name>])"
        echo "         [-- <scp_args>]"
        echo " "
        echo "qssh remove <host_or_path_name>"
        echo " "
        echo "qssh import <config_file>"
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
        echo "remove                 Remove a named host or file path or ssh key"
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
        echo "-o --force --overwrite Overwite any existing name setting"
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
