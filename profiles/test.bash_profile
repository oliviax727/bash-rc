profile_enter() {

    . "${BASHRC_PATH}/test/test_enter.bash"

}

profile_alias() {

    . "${BASHRC_PATH}/test/test_alias.bash_aliases"

}

profile_rc() {

    . "${BASHRC_PATH}/test/test_rc.bashrc"

}

profile_exit() {

    . "${BASHRC_PATH}/test/test_exit.bash"
    terminal_colour --basic

}