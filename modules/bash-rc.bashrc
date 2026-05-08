# ===== BASH-RC PACKAGE MODULES ===== #

function bash-rc() {

    function bash-rc-check-path() {

        local check_null=0

        if [ "$1" == '-n' ]; then
            check_null=1
            shift
        fi

        local check_path=$([ -z $1 ] && echo "$BASHRC_PATH" || echo "$(evalpath -sm $1)")

        local repo_string='[ -d "$check_path" ]
            && [ "$(git rev-parse --is-inside-work-tree 2> /dev/null)" == true ]
            && basename -s ".git" `git config --get remote.origin.url`
            || echo "error"'

        local repo_name=$(cd-run "${check_path}" "$repo_string")

        if [ ! "${repo_name}" == 'bash-rc' ]; then
            [ $check_null -eq 1 ] && return 0
 
            echo $check_path
            bash-rc-check-path -n "${check_path}/bash-rc" || return 0

            echo -e "${ERROR_TEXT}: chosen \$BASHRC_PATH points to a directory (${check_path}) that does not exist"
            echo "or is not a clone of the bash-rc git repository."
            printf "%s" "Clone bash-rc repository into directory and reset BASHRC_PATH? (y/[n]): " 
            read confirm

            if [ "$confirm" == 'y' ]; then
                bash-rc-clone "${check_path}"

                if [ $? -eq 0 ]; then
                    bash-rc-set-path "${check_path}/bash-rc"
                fi

            else
                echo 'Please make sure to change the BASHRC_PATH to a working git clone using `bash-rc set-path`.'
            fi

            return 1
        fi

        return $check_null
    }

    # Replace the bashrc or base file's BASHRC_PATH variable setting
    function bash-rc-change-path() {
        check_string='export BASHRC_PATH='
        replace_string=$(echo "export BASHRC_PATH=\"$1\"" | sed 's/\//\\\//g')

        sed -i -e "s/^${check_string}.*/${replace_string}/" $2
    }

    # Load repository from upstream
    function bash-rc-update() {
        cd-run "$BASHRC_PATH" "(git fetch && git reset --hard origin/main) >/dev/null"
    }

    # Checkout different branch in bash-rc file
    function bash-rc-checkout() {
        bash-rc-update
        cd-run "$BASHRC_PATH" "git switch $1 >/dev/null"
    }

    # Clone repository in chosen directory
    function bash-rc-clone() {
        local check_string='export BASHRC_PATH='
        local replace_string='export BASHRC_PATH='

        local clone_parent_dir="$([ -z $1 ] && echo '.' || echo "$(evalpath -sm $1)")"

        bash-rc-check-path -n "${clone_parent_dir}"

        if [ $? -eq 0 ]; then
            cd-run  "${clone_parent_dir}" '
            (git clone git@github.com:oliviax727/bash-rc.git
            || git clone https://github.com/oliviax727/bash-rc.git)
            && bash-rc-change-path "$clone_parent_dir" "./bash-rc/base.bash"
            || (echo -e "${ERROR_TEXT}: Something went wrong when trying to clone the repo."
            && return 1)'
        else
            echo -e "${ERROR_TEXT}: Repository or directory already exists here!"
        fi
    }

    # Archives current .bashrc from home directory
    function bash-rc-archive() {
        cp "${HOME}/.bashrc" "${BASHRC_PATH}/archive/archive-$(filename-date).bashrc"
    }

    # Enter testing mode profile
    function bash-rc-test() {
        export BASHRC_TEST_MODE=1
        cd-run "$BASHRC_PATH" 'bash --noprofile --rcfile "./base.bash"'
        export BASHRC_TEST_MODE=0
        exec bash
    }

    # Publishes a testing module function
    function bash-rc-publish() {

        if [ -z $1 ]; then
            echo "Please provide an option"
            return 1
        fi

        local file="$(find "${BASHRC_PATH}/test" -type f -name "test_$1.*")"
        filename=$(basename "$file")
        local extension="${filename##*.}"
        
        case $1 in
            enter|exit)
                printf "\n\n" >> "${BASHRC_PATH}/$1.bash"
                cat "$file" >> "${BASHRC_PATH}/$1.bash"
            ;;
            rc|alias)  
                cp "$file" "${BASHRC_PATH}/modules/$2.${extension}"
            ;;
            profile)
                cp "$file" "${BASHRC_PATH}/profiles/$2.${extension}"
            ;;
            \?)
                echo "'$1' is not a valid option. Use \`bash-rc help\` or \`bash-rc-help\` to see"
                echo "what options are available."
            ;;
        esac
    }

    # Load repository base.bash file as bashrc
    function bash-rc-build() {

        bash-rc-change-path  "$(evalpath -sm "${BASHRC_PATH}")" "${BASHRC_PATH}/base.bash"

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
                    bash-rc-update
                ;;
                -c)
                    shift
                    bash-rc-checkout $1
                ;;
                \?)
                    echo "'$1' is not a valid option. Use \`bash-rc (--help|-h)\` to see what options are available."
                ;;
            esac
            shift
        done

        if [ "$archive_flag" -eq 1 ]; then
            bash-rc-archive
        fi

        cp "${HOME}/.bashrc" "${HOME}/.bashrc_temp"

        cp "${BASHRC_PATH}/base.bash" "${HOME}/.bashrc"

        if [ "$append_flag" -eq 1 ]; then
            diff-diode "${HOME}/.bashrc_temp" "${BASHRC_PATH}/base.bash" >> "${HOME}/.bashrc"
        fi

        rm "${HOME}/.bashrc_temp"

    }

    # Purges archives
    function bash-rc-purge() {

        if [ -d "${BASHRC_PATH}/archive" ]; then
            if [ "${BASHRC_PATH}/archive" ]; then
                rm $BASHRC_PATH/archive/*
            else
                echo -e "${INFORMATION_TEXT}: Archive directory is empty!"
            fi
        else
            echo -e "${WARNING_TEXT}: Archive directory does not exist! Creating a new one ..."
            mkdir "${BASHRC_PATH}/archive"
        fi
    }

    # Set a new BASHRC_PATH variable
    function bash-rc-set-path() {
        local set_path="$(evalpath -sm $1)"

        if [ -d "${set_path}/bash-rc" ]; then
            echo -e "${INFORMATION_TEXT}: A sub-directory name bash-rc already exists in specified directory. Using sub-directory as the path instead"
            set_path="${set_path}/bash-rc"
        fi

        bash-rc-check-path "${set_path}"

        if [ $? -eq 0 ]; then
            export BASHRC_PATH="${set_path}"
            echo -e "${INFORMATION_TEXT}: Updating \$BASHRC_PATH to ${set_path} ..."
            bash-rc-change-path "${set_path}" "${HOME}/.bashrc"
        else
            return 1
        fi
        
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
        echo "bash-rc check-path [-n] [<path_to_repo>]"
        echo " "
        echo "bash-rc set-path <path_to_repo>"
        echo " "
        echo "bash-rc change-path <path_to_repo> <rc_file>"
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
        echo "check-path           Check if current BASHRC_PATH is working"
        echo "set-path             Set a new BASHRC_PATH"
        echo "change-path          Change the BASHRC_PATH export within a specific file"
        echo "help                 Access the help menu"
        echo "=================================="
        echo "Options:"
        echo "-f                   Do not archive the existing bashrc"
        echo "-k                   Run diff check and keep the difference in the bashrc"
        echo "-p                   Force pull from github remote"
        echo "-c                   Checkout branch from git remote"
        echo "=================================="
        echo "Notes:"
        echo "Hyphenating the first argument instead of using space (e.g. bash-rc-test instead of bash-rc test)"
        echo "will also call the desired function."
        echo "=================================="
    }

    # Execute command
    local sel_cmd=$1
    shift

    local error_text="${ERROR_TEXT}: Command doesn't exist. Use \`bash-rc help\` or \`bash-rc-help\` to see what commands exist"

    if [ "$(type -t "bash-rc-$sel_cmd")" == "function" ]; then
        eval '"bash-rc-$sel_cmd" $@'
    else
        echo -e "$error_text"
        return 1
    fi
}

bash-rc check-path