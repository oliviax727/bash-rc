profile_enter() {
    # Quick-Jump/CD
    export software="/software/projects/mwaeor/ohrw"
    export scratch="/scratch/mwaeor/ohrw"
    export home="/home/ohrw"

    # Uncomment if using default paths is prefered
    export force_set_TWD=yes
}

profile_alias() { :; }

profile_rc() { :; }

profile_exit() {
    terminal_colour --ancom
}
