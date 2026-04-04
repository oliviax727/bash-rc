# ===== CUSTOM COMMANDS - QUICK SSH===== #

function sshcd () { ssh -t $1 "source ~/.bashrc; cd $2; bash --login"; }

function qssh() {
    if [[ ! -f ~/.config/qssh-list.txt ]]; then
        touch ~/.config/qssh-list.txt
    fi

    if [[ $1 == "help" ]]; then
        echo "=================================="
        echo "Connect to a predefined ssh server."
        echo "=================================="
        echo "Usage:"
        echo "qssh connect [(-n|--name) <host_name> | (-h|--home) <host_address>] [(-p|--pass) <password>]"
        echo "         [(-d|--dir) <cd_path> | (-l|--loc|--location) <cd_name>]"
        echo "qssh add-host (-n|--name) <host_name> [(-h|--home) <host_address>] [(-o|--force|--overwrite)]"
        echo " "
        echo "qssh add-path (-d|--dir) <cd_path> (-l|--loc|--location) <cd_name>"
        echo "              [(-n|--name) <host_name> | (-h|--home) <host_address>] [(-o|--force|--overwrite)]"
        echo "qssh remove ((-n|--name) <host_name> | (-l|--loc|--location) <cd_name>)"
        echo " "
        echo "qssh purge"
        echo " "
        echo "qssh scp [(-f|--from) [(-n|--name) <host_name> | (-h|--home) <host_address>]"
        echo "         [(-d|--dir) <cd_path> (-l|--loc|--location) <cd_name>] [(-p|--pass) <password>]]"
        echo "         [(-t|--to) [(-n|--name) <host_name> | (-h|--home) <host_address>]"
        echo "         [(-d|--dir) <cd_path> (-l|--loc|--location) <cd_name>] [(-p|--pass) <password>]]"
        echo "         [(-a|--args|--scp-args) <scp_args>]"
        echo "=================================="
        echo "Commands:"
        echo "connect:                Connect to an SSH host"
        echo "add-host:               Add/Modify an SSH host to the quick-access name list"
        echo "add-path:               Add/Modify a named file path on a given SSH host"
        echo "remove:                 Remove a named host or file path"
        echo "purge:                  Remove ALL named host or file path"
        echo "scp:                    Copy files to and from host"
        echo "help:                   Access the help menu"
        echo "=================================="
        echo "Options:"
        echo "-h --host:              An SSH server host, localhost or '-n' if none provided"
        echo "-d --dir:               A directory to cd into or copy to/from, CWD or '-l' if none provided"
        echo "-p --pass:              The password required to connect to the host"
        echo "-t --to:                File destination, local CWD if none provided"
        echo "-f --from:              File origin, local CWD if none provided"
        echo "-n --name               The name of a saved server or to save a server as"
        echo "-l --loc --location:    The name of a saved path location or to save a path as"
        echo "-o --force --overwrite: Overwite any existing name setting"
        echo "-a --args --scp-args:   Any arguments to include in the scp command. Must occur at end of command"
        echo "=================================="
    fi
}