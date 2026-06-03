. "${BASHRC_PATH}/profiles/delll.bash_profile"

profile_enter() { 
    export BASHRC_IGNORE_MODULES=$BASHRC_IGNORE_MODULES:$BASHRC_PATH/modules/conda_setup.bashrc

    # Quick-Jump/CD
    export projects="/Users/oliviahrwalters/Desktop/Work/remote-work"
    export desktop="/Users/oliviahrwalters/Desktop"

    export QUICK_JUMP_VARS="projects:desktop"

    # Uncomment if using default paths is prefered
    export force_set_TWD=yes
}

profile_exit() {
    terminal_colour --pride
}