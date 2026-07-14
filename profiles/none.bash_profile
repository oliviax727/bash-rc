# shellcheck shell=bash

profile_enter() {

    if [ "$BASH_PROFILE" == "none" ]; then
        printf '%s\n' "${INFORMATION_TEXT:-INFO}: No .bashrc profile recognised!"
    fi

}

profile_alias() { :; }

profile_rc() { :; }

profile_exit() {
    terminal_colour --basic
}
