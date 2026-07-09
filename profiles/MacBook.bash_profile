. "${BASHRC_PATH}/profiles/delll.bash_profile"

profile_enter() { 
    export BASHRC_IGNORE_MODULES=$BASHRC_IGNORE_MODULES:$BASHRC_PATH/modules/conda_setup.bashrc:$BASHRC_PATH/modules/boot-arch.bashrc

    # Quick-Jump/C
    export desktop="/Users/oliviahrwalters/Desktop"
    export documents="/Users/oliviahrwalters/Documents"

    export QUICK_JUMP_VARS="documents:desktop"

    # Uncomment if using default paths is prefered
    export force_set_TWD=yes
}

profile_exit() {
    terminal_colour --pride
}