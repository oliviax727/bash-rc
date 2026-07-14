#!/usr/bin/env bash

run_profile_file() {
    local profile_file="$1"
    local repo_root
    repo_root=$(realpath -m ..)

    export BASHRC_PATH="$repo_root"
    export BASH_PROFILE="test"
    export BASHRC_IGNORE_MODULES=""
    export INFORMATION_TEXT="INFO"

    terminal_colour() { :; }

    local output_file
    output_file=$(mktemp "./profile-out.XXXXXX")

    source "$profile_file" > "$output_file" 2>&1
    local rc=$?

    if declare -F profile_enter >/dev/null 2>&1; then profile_enter >> "$output_file" 2>&1; fi
    if declare -F profile_alias >/dev/null 2>&1; then profile_alias >> "$output_file" 2>&1; fi
    if declare -F profile_rc >/dev/null 2>&1; then profile_rc >> "$output_file" 2>&1; fi
    if declare -F profile_exit >/dev/null 2>&1; then profile_exit >> "$output_file" 2>&1; fi

    local output
    output=$(cat "$output_file")

    assert_equals "0" "$rc"
    assert_equals "" "$output"
}

test_profiles_none_sources_and_runs_without_output() {
    run_profile_file ../profiles/none.bash_profile
}

test_profiles_delll_sources_and_runs_without_output() {
    run_profile_file ../profiles/delll.bash_profile
}

test_profiles_sirius_sources_and_runs_without_output() {
    run_profile_file ../profiles/Sirius.bash_profile
}

test_profiles_setonix_sources_and_runs_without_output() {
    run_profile_file ../profiles/setonix.bash_profile
}

test_profiles_nid_sources_and_runs_without_output() {
    run_profile_file ../profiles/nid.bash_profile
}

test_profiles_macbook_sources_and_runs_without_output() {
    run_profile_file ../profiles/MacBook.bash_profile
}

test_profiles_test_sources_and_runs_without_output() {
    run_profile_file ../profiles/test.bash_profile
}
