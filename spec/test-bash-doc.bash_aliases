#!/usr/bin/env bash

# shellcheck disable=SC1091
source ../modules/bash-doc.bash_aliases

test_bash_doc_aliases_are_defined() {
    assert_status_code 0 "alias ss >/dev/null 2>&1"
    assert_status_code 0 "alias texclean >/dev/null 2>&1"
    assert_status_code 0 "alias h >/dev/null 2>&1"
    assert_status_code 0 "alias j >/dev/null 2>&1"
    assert_status_code 0 "alias l >/dev/null 2>&1"
    assert_status_code 0 "alias ll >/dev/null 2>&1"
    assert_status_code 0 "alias ls >/dev/null 2>&1"
    assert_status_code 0 "alias pu >/dev/null 2>&1"
    assert_status_code 0 "alias po >/dev/null 2>&1"
    assert_status_code 0 "alias c >/dev/null 2>&1"
    assert_status_code 0 "alias m >/dev/null 2>&1"
    assert_status_code 0 "alias unsetenv >/dev/null 2>&1"
}

test_setenv_exports_variables() {
    unset TEST_BASH_DOC_VALUE

    setenv TEST_BASH_DOC_VALUE hello

    assert_equals "hello" "$TEST_BASH_DOC_VALUE"
}

test_add_alias_writes_to_user_alias_file() {
    local test_home
    test_home=$(mktemp -d "./bash-doc-home.XXXXXX")
    trap 'rm -rf "$test_home"' RETURN

    HOME="$test_home" add-alias demo "echo demo"

    assert_status_code 0 "test -f \"$test_home/.bash_aliases\""
    assert_status_code 0 "grep -q \"alias demo='echo demo'\" \"$test_home/.bash_aliases\""
    assert_status_code 0 "alias demo >/dev/null 2>&1"
}

test_repeat_runs_command_the_requested_number_of_times() {
    local repeated_output
    repeated_output="$(repeat 3 printf foo)"

    assert_equals "foofoofoo" "$repeated_output"
}

test_seq_emits_the_expected_range() {
    local sequence
    sequence="$(_seq 1 4)"

    assert_equals "1 2 3 4" "$sequence"
}