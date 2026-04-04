# ===== BASH-RC PACKAGE MODULES ===== #

bash-rc() {

    # Load repository from upstream
    function update() {
        :
    }

    # Checkout different branch in bash-rc file
    function checkout() {
        :

    }

    # Archives current .bashrc from home directory
    function archive() {
        :
    }

    # Purges archives
    function purge() {
        :
    }

    # Enter testing mode profile
    function test() {
        :
    }

    # Publishes a testing module function
    function publish() {
        :
    }

    # Load repository base.bash file as bashrc
    function build() {
        shift
        while [ $# -gt 0 ]; do
            archive_flag=1
            extra=""
            case $1 in
                -k)
                    archive_flag=0
                ;;
                -f)
                    extra=$(diff "${BASHRC_PATH}/base.bash" "~/.bashrc")
                ;;
                -p)
                    cd-run "${BASHRC_PATH}" "git pull"
                ;;
                \?)
                    echo "'$1' is not a valid option. Use --help or -h to see what options are available."
                ;;
            esac
            shift
        done

        if [ archive_flag -eq 1 ]; then
            archive
        fi

        cp "${BASHRC_PATH}/base.bash" "~/.bashrc"

        printf "\n${extra}\n"
    }

    # Help
    function help() {
        echo "=================================="
        echo "Load and alter the .bashrc file from the bash-rc repository."
        echo "=================================="
        echo "Usage:"
        echo "bash-rc build [-k] [-f] [-p]"
        echo " "
        echo "bash-rc update"
        echo " "
        echo "bash-rc checkout <branch_name>"
        echo " "
        echo "bash-rc archive"
        echo " "
        echo "bash-rc purge"
        echo " "
        echo "bash-rc test"
        echo " "
        echo "bash-rc publish (enter|exit|alias|rc) <name>"
        echo " "
        echo "=================================="
        echo "Commands:"
        echo "build                Update the bashrc"
        echo "update               Pull the bash-rc repository from upstream"
        echo "checkout             Checkout a different bash-rc branch"
        echo "archive              Archive the current bash-rc file"
        echo "purge                Remove all archived bashrcs"
        echo "test                 Run the testing account environment"
        echo "publish              Publish the current testing module"
        echo "help                 Access the help menu"
        echo "=================================="
        echo "Options:"
        echo "-f                   Do not archive the existing bashrc"
        echo "-k                   Run diff check and keep the difference in the bashrc"
        echo "-p                   Pull from github remote"
        echo "=================================="
    }

    exec $1

}