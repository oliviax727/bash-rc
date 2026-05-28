# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# ===== ENTER ===== #

# Define the path to this repository
export BASHRC_PATH="/Users/oliviahrwalters/Desktop/Fun/bash-rc"

# Run program enter bash file
. "${BASHRC_PATH}/enter.bash"

# ===== CHECK PROFILES ===== #

# Various operating systems use different hostnames, attempt each one

if command -v scutil >/dev/null 2>&1; then
    export device_name=$(scutil --get ComputerName) # MacOS
elif command -v hostnamectl >/dev/null 2>&1; then
    export device_name=$(hostnamectl | egrep -i "Static hostname" | awk '{print $NF}') # Linux
elif command -v hostname >/dev/null 2>&1; then
    export device_name=$(hostname) # Fallback
fi

if [ ! -z $BASHRC_TEST_MODE ] && [ $BASHRC_TEST_MODE -eq 1 ]; then
    device_name="test"
fi

# Order of the profiles matter!
profile_substrings=( "delll" "Sirius" "setonix" "nid" "MacBook" "test" )

# Structure of a profile file:
# Other code:    runs on load
# profile_enter: runs after initial sourcing
# profile_alias: runs during alias step
# profile_rc:    runs during bashrc step
# profile_exit:  runs on exit
. "${BASHRC_PATH}/profiles/none.bash_profile"

export BASH_PROFILE="none"

for profile in "${profile_substrings[@]}"; do
    if [[ "$device_name" =~ .*"$profile".* ]]; then
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
    if [[ ! ":$BASHRC_IGNORE_MODULES:" =~ .*":$alias:".* ]]; then
        . "${alias}"
    fi
done

profile_alias

shopt -s expand_aliases

# ===== RUN RCS ===== #

# Run all available .bashrc in main repo directory
bashrc_files=($BASHRC_PATH/modules/*.bashrc)

for bashrc in "${bashrc_files[@]}"; do
    if [[ ! ":$BASHRC_IGNORE_MODULES:" =~ .*":$bashrc:".* ]]; then
        . "${bashrc}"
    fi
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

