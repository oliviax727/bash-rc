# shellcheck shell=bash

profile_enter() {

    # shellcheck disable=SC1090
    . "${BASHRC_PATH}/test/test_enter.bash"

}

profile_alias() {

    # shellcheck disable=SC1090
    . "${BASHRC_PATH}/test/test_alias.bash_aliases"

}

profile_rc() {

    # shellcheck disable=SC1090
    . "${BASHRC_PATH}/test/test_rc.bashrc"

}

profile_exit() {

    # shellcheck disable=SC1090
    . "${BASHRC_PATH}/test/test_exit.bash"

    terminal_colour --basic

    export PS1="[test] ${PS1}"
}