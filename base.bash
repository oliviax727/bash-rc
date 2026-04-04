# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# ===== ENTER ===== #

# Define the path to this repository
export BASHRC_PATH="${HOME}/Desktop/Fun/bashrcs"

# Run program enter bash file
. "${BASHRC_PATH}/enter.bash"

# ===== CHECK PROFILES ===== #
export device_name=$(hostnamectl | egrep -i "Static hostname" | awk '{print $NF}' || hostname)

# Order of the profiles matter!
profile_substrings=( "delll" "sirius" "setonix" "test" )

# Structure of a profile file:
# Other code:    runs on load
# profile_enter: runs after initial sourcing
# profile_alias: runs during alias step
# profile_rc:    runs during bashrc step
# profile_exit:  runs on exit
. "${BASHRC_PATH}/profiles/none.bash_profile"

export BASH_PROFILE="none"

for profile in "${profile_substrings[@]}"; do
    if [[ ${device_name,,} =~ ${profile,,} ]]; then
        . "${BASHRC_PATH}/profiles/${profile}.bash_profile"
        export BASH_PROFILE="${profile}"
        break
    fi
done

profile_enter

# ===== RUN ALIASES ===== #

# Run all available bash aliases in main repo directory
alias_files=($BASHRC_PATH/modules/*.bash_aliases)

for alias in "${alias_files[@]}"; do
    . "${alias}"
done

profile_alias

shopt -s expand_aliases

# ===== RUN RCS ===== #

# Run all available .bashrc in main repo directory
bashrc_files=($BASHRC_PATH/modules/*.bashrc)

for bashrc in "${bashrc_files[@]}"; do
    . "${bashrc}"
done

# Run profile-specific bashrc code
profile_rc

# ===== EXIT ===== #

# Run default exit code
. "${BASHRC_PATH}/exit.bash"

# Run profile-specific exit code
profile_exit

# Clean variable space
unset profile_substrings alias_files bashrc_files
