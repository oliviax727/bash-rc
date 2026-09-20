# shellcheck shell=bash

profile_enter() { :; }

profile_alias() { :; }

profile_rc() { :; }

profile_exit() {

    alias boot-arch='admiral boot -r nvme0n1p3 -e nvme0n1p1'
    alias boot-steam='admiral boot -r nvme0n1p4 -e nvme0n1p1'
}
