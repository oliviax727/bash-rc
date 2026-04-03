cd .. # Remove when compiling

# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# ===== ENTER ===== #

. ./bashrcs/enter.bash

# ===== CHECK PROFILES ===== #
device_name=$(hostnamectl | egrep -i "Static hostname" | awk '{print $NF}' || hostname)

profile_substrings=( "delll" "sirius" "setonix" )

for profile in "${profile_substrings[@]}"; do
    if [[ ${device_name,,} =~ ${profile,,} ]]; then
        . "bashrcs/${profile}.bash_profile"
        break
    fi
done

# ===== RUN ALIASES ===== #

alias_files=(bashrcs/*.bash_aliases)

for alias in "${alias_files[@]}"; do
    . $alias
done

shopt -s expand_aliases

# ===== RUN RCS ===== #

bashrc_files=(bashrcs/*.bashrc)

for bashrc in "${bashrc_files[@]}"; do
    . $bashrc
done

# ===== EXIT ===== #

. ./bashrcs/exit.bash

cd bashrcs # Remove when compiling