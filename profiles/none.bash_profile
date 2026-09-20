# shellcheck shell=bash

profile_enter() {

    if [ "$BASH_PROFILE" == "none" ]; then
        echo -e "${INFORMATION_TEXT}: No .bashrc profile recognised!\n"
    fi

}

profile_alias() { :; }

profile_rc() { :; }

profile_exit() { :; }
