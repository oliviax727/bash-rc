# shellcheck shell=bash

# shellcheck disable=SC1090
. "${BASHRC_PATH}/profiles/delll.bash_profile"

profile_enter() { 
    export BASHRC_IGNORE_MODULES=$BASHRC_IGNORE_MODULES:$BASHRC_PATH/modules/conda_setup.bashrc:$BASHRC_PATH/modules/boot-arch.bashrc

    # Quick-Jump/C
    export desktop="/Users/oliviahrwalters/Desktop"
    export documents="/Users/oliviahrwalters/Documents"

    export QUICK_JUMP_VARS="documents:desktop"

    # Uncomment if using default paths is prefered
    export force_set_TWD=yes

    # Use gnu-sed
    export PATH="/opt/homebrew/opt/gnu-sed/libexec/gnubin:${PATH}"
    export HOMEBREW_NO_ENV_HINTS=1

    # Auto-Update Brew
    alias update-brew='brew update && brew outdated && brew upgrade && brew cleanup'
}

profile_exit() {
    terminal_colour --pride
}