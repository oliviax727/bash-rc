#!/usr/bin/env bash

# shellcheck disable=SC1091,SC2155,SC2329

teardown() {
    rm -f ./test-profile-out.*
}

test_unpublished_test_enter_sources_without_error_or_output() {
    local output
    output="$(source ../test/test_enter.bash 2>&1)"
    assert_equals "0" "$?"
    assert_equals "" "$output"
}

test_unpublished_test_alias_sources_without_error_or_output() {
    local output
    output="$(source ../test/test_alias.bash_aliases 2>&1)"
    assert_equals "0" "$?"
    assert_equals "" "$output"
}

test_unpublished_test_rc_sources_without_error_or_output() {
    local output
    output="$(source ../test/test_rc.bashrc 2>&1)"
    assert_equals "0" "$?"
    assert_equals "" "$output"
}

test_unpublished_test_exit_sources_without_error_or_output() {
    local output
    output="$(source ../test/test_exit.bash 2>&1)"
    assert_equals "0" "$?"
    assert_equals "" "$output"
}

test_unpublished_test_profile_sources_and_runs_without_error_or_output() {
    export BASHRC_PATH="$(realpath -m ..)"
    terminal_colour() { :; }

    local output_file
    output_file=$(mktemp "./test-profile-out.XXXXXX")

    source ../test/test_profile.bash_profile > "$output_file" 2>&1
    local rc=$?

    profile_enter >> "$output_file" 2>&1
    profile_alias >> "$output_file" 2>&1
    profile_rc >> "$output_file" 2>&1
    profile_exit >> "$output_file" 2>&1

    local output
    output=$(cat "$output_file")

    assert_equals "0" "$rc"
    assert_equals "" "$output"
}
