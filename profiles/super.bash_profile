# shellcheck shell=bash

profile_enter() { :; }

profile_alias() { :; }

profile_rc() { :; }

profile_exit() {

    su="$(whoami || echo 'su')"
    export PS1="[${su}] ${PS1}"
}
