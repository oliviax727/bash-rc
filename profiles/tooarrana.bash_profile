# shellcheck shell=bash

profile_enter() {
    # Quick-Jump/CD
    export fred="/fred/oz113/owalters"

    export QUICK_JUMP_VARS="fred"

    # Uncomment if using default paths is prefered
    export force_set_TWD=yes

    export BASHRC_IGNORE_MODULES=$BASHRC_IGNORE_MODULES:$BASHRC_PATH/modules/boot-arch.bashrc
}

profile_alias() { :; }

profile_rc() {
    export GSL_INC="/fred/oz113/owalters/gsl-2.8/include"
    export GSL_LIB="/fred/oz113/owalters/gsl-2.8/lib"
    export LD_LIBRARY_PATH="/fred/oz113/owalters/gsl-2.8/lib:$LD_LIBRARY_PATH"
}

profile_exit() { :; }
