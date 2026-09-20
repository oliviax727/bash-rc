# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# shellcheck shell=bash

# ===== ENTER ===== #

# Define the path to this repository
export BASHRC_PATH=""

# Run program enter bash file
. "${BASHRC_PATH}/enter.bash"

# ===== CHECK PROFILES ===== #

# Various operating systems use different hostnames, attempt each one

username="$(whoami)"

if [[ -n "${BASHRC_TEST_MODE:-}" ]] && [[ "${BASHRC_TEST_MODE}" -eq 1 ]]; then
    username="test"
fi

# Generate map from csv file
declare -gA PROFILE_NAMES=()

while IFS=, read -r uname cname tname tcolor fname
do
    PROFILE_NAMES["$uname"]="$cname:$tname:$tcolor:$fname"
done < "${BASHRC_PATH}/profiles.csv"

# Structure of a profile file:
# Other code:    runs on load
# profile_enter: runs after initial sourcing
# profile_alias: runs during alias step
# profile_rc:    runs during bashrc step
# profile_exit:  runs on exit
. "${BASHRC_PATH}/profiles/none.bash_profile"

export BASH_PROFILE="none"
export PROFILE_DATA=()

if [[ -n "${PROFILE_NAMES["$username"]}" ]]; then
    IFS=: read -ra PROFILE_DATA <<< "${PROFILE_NAMES["$username"]}"
    # shellcheck disable=SC1090
    . "${BASHRC_PATH}/profiles/${PROFILE_DATA[3]}.bash_profile"
    export BASH_PROFILE="${PROFILE_DATA[3]}"
fi

profile_enter

# ===== RUN ALIASES ===== #

# Run all available bash aliases in main repo directory
alias_files=("$BASHRC_PATH"/modules/*.bash_aliases)

for alias in "${alias_files[@]}"; do
    if [[ ! ":${BASHRC_IGNORE_MODULES:-}:" =~ :"$alias": ]]; then
        # shellcheck disable=SC1090
        . "${alias}"
    fi
done

profile_alias

shopt -s expand_aliases

# ===== RUN RCS ===== #

# Run all available .bashrc in main repo directory
bashrc_files=("$BASHRC_PATH"/modules/*.bashrc)

for bashrc in "${bashrc_files[@]}"; do
    if [[ ! ":${BASHRC_IGNORE_MODULES:-}:" =~ :"$bashrc": ]]; then
        # shellcheck disable=SC1090
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
