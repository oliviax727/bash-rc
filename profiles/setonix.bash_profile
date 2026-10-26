# shellcheck shell=bash

profile_enter() {
    # Quick-Jump/CD
    export software="/software/projects/mwaeor/ohrw"
    export scratch="/scratch/mwaeor/ohrw"

    export QUICK_JUMP_VARS="software:scratch"

    # Uncomment if using default paths is prefered
    export force_set_TWD=yes

    sacct_mem() {
        sacct -j "$1" --format=JobID,JobName%20,MaxRSS,MaxVMSize,Elapsed,Start,End,State,ExitCode --units=G
    }

    sstat_mem() {
        sstat -j "$1" --format=JobID,MaxRSS,MaxVMSize,AveRSS,AveCPU,NTasks
    }

    export BASHRC_IGNORE_MODULES=$BASHRC_IGNORE_MODULES:$BASHRC_PATH/modules/boot-arch.bashrc
}

profile_alias() { :; }

profile_rc() { :; }

profile_exit() { :; }
