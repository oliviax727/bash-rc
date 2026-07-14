#!/usr/bin/env bash

load_path_manager() {
    # shellcheck disable=SC1091
    source ../modules/path_manager.bashrc
}

test_test_cmd_returns_success_for_true_expression() {
    load_path_manager
    assert_status_code 0 "test-cmd 'test 1 -eq 1'"
}

test_test_cmd_returns_failure_for_false_expression() {
    load_path_manager
    assert_status_code 1 "test-cmd 'test 1 -eq 2'"
}

test_evalpath_expands_home_tilde() {
    load_path_manager
    assert_equals "$HOME" "$(evalpath -m '~')"
}

test_evalpath_handles_paths_with_spaces() {
    load_path_manager
    local spaced_dir
    spaced_dir=$(mktemp -d "./path-manager-space-dir.XXXXXX")
    trap 'rm -rf "$spaced_dir"' RETURN

    local target_path
    target_path="$spaced_dir/inner dir"
    mkdir -p "$target_path"

    assert_equals "$(realpath -m "$target_path")" "$(evalpath -m "$target_path")"
}

test_set_cwd_uses_home_shortening_when_twd_disabled() {
    load_path_manager
    local original_pwd
    local original_home
    local temp_home
    original_pwd="$PWD"
    original_home="$HOME"
    temp_home=$(mktemp -d "./path-manager-home.XXXXXX")
    temp_home=$(realpath -m "$temp_home")
    trap 'cd "$original_pwd"; export HOME="$original_home"; rm -rf "$temp_home"' RETURN

    export HOME="$temp_home"
    mkdir -p "$HOME/base/sub"
    cd "$HOME/base/sub"

    set_TWD=
    set_CWD

    assert_equals "~/base/sub" "$CWD"
}

test_set_cwd_compresses_prefix_using_quick_jump_vars() {
    load_path_manager
    local original_pwd
    local base_dir
    original_pwd="$PWD"
    base_dir=$(mktemp -d "./path-manager-qj.XXXXXX")
    base_dir=$(realpath -m "$base_dir")
    trap 'cd "$original_pwd"; rm -rf "$base_dir"' RETURN

    mkdir -p "$base_dir/project/src"
    export WORKROOT="$base_dir/project"
    export QUICK_JUMP_VARS="WORKROOT"

    cd "$base_dir/project/src"

    set_TWD=yes
    set_CWD

    assert_equals "\$WORKROOT/src" "$CWD"
}

test_terminal_colour_help_runs_without_error() {
    load_path_manager
    assert_status_code 0 "terminal_colour --help >/dev/null 2>&1"
}

test_term_col_alias_is_defined() {
    load_path_manager
    assert_status_code 0 "alias term_col >/dev/null 2>&1"
}

test_cleanpath_removes_duplicates_and_invalid_entries() {
    load_path_manager
    local d1
    local d2
    d1=$(mktemp -d "./path-manager-cleanpath-1.XXXXXX")
    d2=$(mktemp -d "./path-manager-cleanpath-2.XXXXXX")
    trap 'rm -rf "$d1" "$d2"' RETURN

    export TEST_PATH_VAR="$d1::/definitely/not/a/dir:$d2:$d1"

    cleanpath TEST_PATH_VAR

    assert_equals "$(realpath -m "$d1"):$(realpath -m "$d2")" "$TEST_PATH_VAR"
}