#!/usr/bin/env bash

test_enter_sources_without_error_or_output() {
    local output
    output="$(source ../enter.bash 2>&1)"

    assert_equals "0" "$?"
    assert_equals "" "$output"
}

test_enter_exports_expected_prompt_variables() {
    source ../enter.bash

    assert_equals '\033[1;34mINFORMATION\033[00m' "$INFORMATION_TEXT"
    assert_equals '\033[1;33mWARNING\033[00m' "$WARNING_TEXT"
    assert_equals '\033[1;31mERROR\033[00m' "$ERROR_TEXT"
    assert_equals ':' "$PROMPT_COMMAND"
}
