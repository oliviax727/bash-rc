. "${BASHRC_PATH}/profiles/delll.bash_profile"

profile_enter() { 
    export BASHRC_IGNORE_MODULES=$BASHRC_IGNORE_MODULES:$BASHRC_PATH/modules/conda_setup.bashrc
}

profile_exit() {
    terminal_colour --trans
}