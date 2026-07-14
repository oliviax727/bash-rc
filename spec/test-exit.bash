#!/usr/bin/env bash

# shellcheck disable=SC1091,SC2329

teardown() {
    rm -f ./exit-log.*
}

test_exit_sources_without_error_or_output() {
    local log_file
    log_file=$(mktemp "./exit-log.XXXXXX")
    export TEST_EXIT_LOG_FILE="$log_file"

    cleanpath() {
        printf '%s\n' "$1" >> "$TEST_EXIT_LOG_FILE"
    }

    local output
    output="$(source ../exit.bash 2>&1)"

    assert_equals "0" "$?"
    assert_equals "" "$output"
    assert_equals $'\nBASHRC_IGNORE_MODULES' "$(cat "$TEST_EXIT_LOG_FILE")"

    unset TEST_EXIT_LOG_FILE
}
