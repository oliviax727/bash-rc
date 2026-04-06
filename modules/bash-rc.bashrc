# ===== BASH-RC PACKAGE MODULES ===== #

function bash-rc() {

    # Load repository from upstream
    function bash-rc-update() {
        cd-run $BASHRC_PATH "(git fetch && git reset --hard origin/main) >/dev/null"
    }

    # Checkout different branch in bash-rc file
    function bash-rc-checkout() {
        bash-rc-update
        cd-run $BASHRC_PATH "git switch $1 >/dev/null"
    }

    # Archives current .bashrc from home directory
    function bash-rc-archive() {
        cp "${HOME}/.bashrc" "${BASHRC_PATH}/archive/archive-$(filename-date).bashrc"
    }

    # Purges archives
    function bash-rc-purge() {
        rm "${BASHRC_PATH}/archive"
    }

    # Enter testing mode profile
    function bash-rc-test() {
        export BASHRC_TEST_MODE=1
        cd-run $BASHRC_PATH 'bash --noprofile --rcfile "./base.bash"'
        export BASHRC_TEST_MODE=0
        exec bash
    }

    # Publishes a testing module function
    function bash-rc-publish() {

        local file=("${BASHRC_PATH}/test/test_$1.*")
        file="${file[0]}"
        filename=$(basename $file)
        local extension="${filename##*.}"
        
        case $1 in
            enter|exit)
                cat $file >> "${BASHRC_PATH}/modules/$1.bash"
            ;;
            rc|alias)  
                cp $file "${BASHRC_PATH}/modules/$2.${extension}"
            ;;
            profile)
                cp $file "${BASHRC_PATH}/profiles/$2.${extension}"
            ;;
            \?)
                echo "'$1' is not a valid option. Use \`bash-rc (--help|-h)\` to see what options are available."
            ;;
        esac
    }

    # Load repository base.bash file as bashrc
    function bash-rc-build() {

        archive_flag=1
        append_flag=0

        while [ $# -gt 0 ]; do
            
            case $1 in
                -f)
                    archive_flag=0
                ;;
                -k)
                    append_flag=1
                ;;
                -p)
                    update
                ;;
                -c)
                    shift
                    checkout $1
                ;;
                \?)
                    echo "'$1' is not a valid option. Use \`bash-rc (--help|-h)\` to see what options are available."
                ;;
            esac
            shift
        done

        if [ $archive_flag -eq 1 ]; then
            archive
        fi

        cp "${HOME}/.bashrc" "${HOME}/.bashrc_temp"

        cp "${BASHRC_PATH}/base.bash" "${HOME}/.bashrc"

        if [ $append_flag -eq 1 ]; then
            diff-diode "${BASHRC_PATH}/base.bash" "${HOME}/.bashrc_temp" >> "~/.bashrc"
        fi

        rm "${HOME}/.bashrc_temp"

        local echo_statement='echo "EXEC_BASE"'
        local replace_string='echo "EXEC_BASHRC"'
        sed -i "s/^${echo_statement}.*/${replace_string}/" "${HOME}/.bashrc"

        restart
    }

    function bash-rc-set-path() {

        local repo_name=$(basename -s .git `git config --get remote.origin.url`)
        local error_text="${ERROR_TEXT}: The path you wish to set as the bashrc directory does not contain the correct .git files."
        local check_string="export BASHRC_PATH"
        local replace_string="export BASHRC_PATH=$1"

        sed -i "s/^${check_string}.*/${replace_string}/" "~/.bashrc"

        [ repo_name -eq "bashrcs" ] && export BASHRC_PATH=$1 || printf $error_text
    }

    # Help
    function bash-rc-help() {
        echo "=================================="
        echo "Load and alter the .bashrc file from the bash-rc repository."
        echo "=================================="
        echo "Usage:"
        echo "bash-rc build [-k] [-f] [-p] [-c <branch_name>]"
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
        echo "bash-rc publish (enter|exit|alias <module_name>|rc <module_name>|profile <profile_name>)"
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
        echo "-p                   Force pull from github remote"
        echo "-c                   Checkout branch from git remote"
        echo "=================================="
    }

    local sel_cmd=$1
    shift

    eval '"bash-rc-$sel_cmd" $@'

}