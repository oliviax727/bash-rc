# ===== CUSTOM COMMANDS - QUICK SSH===== #

function sshcd () { ssh -t $1 "source ~/.bashrc; cd $2; bash --login"; }

function qssh() {

    local QSSH_DEFAULT_KEY_NAME="id_ed25519"

    # Switch the QSSH_DEFAULT_KEY_NAME variable
    function qssh-switch() {
        :
    }

    # Load a specific configuration file from the environment
    function qssh-load-config() {
        :
    }

    if [[ ! -f "${HOME}/.config/qssh-list.json" ]]; then
        echo "${INFORMATION_TEXT}: No pre-existing configuration file was found. This means qssh will operate under"
        echo "the default settings. Creating a new config file: ${HOME}/.config/qssh-list.json."
        
        touch "${HOME}/.config/qssh-list.txt"
    else
        qssh-load-config "${HOME}/.config/qssh-list.txt"
    fi

    # Connect to qssh host
    function qssh-connect() {
        :
    }

    # Add or modify a qssh host
    function qssh-add-host() {
        :
    }

    # Add or modify a qssh filepath
    function qssh-add-path() {
        :
    }
    
    # Add or modify an ssh key
    function qssh-add-key() {
        :
    }

    # Remove a key, host, or filepath
    function qssh-remove() {
        :
    }

    # Purge the qssh config file
    function qssh-purge() {
        :     
    }

    # Secure copy a file to or from a qssh host
    function qssh-scp() {
        :
    }

    # Copy an ssh key to clipboard
    function qssh-copy-key() {
        :
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
        echo "qssh connect [(-n|--name) <host_name> | (-h|--home) <host_address>] [(-p|--password) <password>]"
        echo "             [(-d|--dir) <cd_path> | (-l|--loc|--location) <cd_name>]"
        echo " "
        echo "qssh add-host (-n|--name) <host_name> [(-h|--home) <host_address>] [(-o|--force|--overwrite)]"
        echo "              [(-k|--key) <key_name>]"
        echo " "
        echo "qssh add-path (-d|--dir) <cd_path> (-l|--loc|--location) <cd_name>"
        echo "              [(-n|--name) <host_name> | (-h|--home) <host_address>] [(-o|--force|--overwrite)]"
        echo " "
        echo "qssh add-key (-k|--key) <key_name> [(-o|--force|--overwrite)] [(-p|--password)]"
        echo " "
        echo "qssh switch (-k|--key) <key_name>"
        echo " "
        echo "qssh remove ((-n|--name) <host_name> | (-l|--loc|--location) <cd_name> | (-k|--key) <key_name>)"
        echo " "
        echo "qssh purge"
        echo " "
        echo "qssh scp [(-f|--from) [(-n|--name) <host_name> | (-h|--home) <host_address>]"
        echo "         [(-d|--dir) <cd_path> (-l|--loc|--location) <cd_name>] [(-p|--password) <password>]]"
        echo "         [(-t|--to) [(-n|--name) <host_name> | (-h|--home) <host_address>]"
        echo "         [(-d|--dir) <cd_path> (-l|--loc|--location) <cd_name>] [(-p|--password) <password>]]"
        echo "         [(-a|--args|--scp-args) <scp_args>]"
        echo " "
        echo "qssh load-config <config_file>"
        echo " "
        echo "qssh copy-key <key_name>"
        echo " "
        echo "=================================="
        echo "Commands:"
        echo "connect                Connect to an SSH host"
        echo "add-host               Add/Modify an SSH host to the quick-access name list"
        echo "add-path               Add/Modify a named file path on a given SSH host"
        echo "add-key                Add/Modify an existing ssh key"
        echo "switch                 Switch default SSH key"
        echo "remove                 Remove a named host or file path or ssh key"
        echo "purge                  Remove ALL named hosts, file paths, and default key options"
        echo "scp                    Copy files to and from host"
        echo "load-config            Load specified qssh configuration file into current environment"
        echo "copy-key               Copy SSH key"
        echo "help                   Access the help menu"
        echo "=================================="
        echo "Options:"
        echo "-h --host              An SSH server host, localhost or '-n' if none provided"
        echo "-d --dir               A directory to cd into or copy to/from, CWD or '-l' if none provided"
        echo "-p --password          The password required to connect to the host"
        echo "-t --to                File destination, local CWD if none provided"
        echo "-f --from              File origin, local CWD if none provided"
        echo "-n --name              The name of a saved server or to save a server as"
        echo "-k --key               The name of a saved key in HOME/.ssh directory"
        echo "-l --loc --location    The name of a saved path location or to save a path as"
        echo "-o --force --overwrite Overwite any existing name setting"
        echo "-a --args --scp-args   Any arguments to include in the scp command. Must occur at end of command"
        echo "=================================="
        echo "Notes:"
        echo "Hyphenating the first argument instead of using space (e.g. qssh-test instead of qssh test)"
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