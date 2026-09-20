# shellcheck shell=bash

profile_enter() { :; }

profile_alias() { :; }

profile_rc() { :; }

profile_exit() {
    
    alias boot-manj='admiral boot -r sda2 -e sda1'
    alias boot-mint='admiral boot -r sdb3 -e sdb2'
}
