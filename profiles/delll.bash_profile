profile_enter() { 
    export BASHRC_IGNORE_MODULES=$BASHRC_IGNORE_MODULES:$BASHRC_PATH/modules/boot-arch.bashrc; 
}

profile_alias() {
    :
}

profile_rc() { :; }

profile_exit() {
    terminal_colour --bi
}
