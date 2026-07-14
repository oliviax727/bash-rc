#!/usr/bin/env bash

# shellcheck disable=SC2329

teardown() {
    rm -rf ./bash-rc-test.*
}

setup_bash_rc_test_env() {
    TEST_BRC_ROOT=$(mktemp -d "./bash-rc-test.XXXXXX")
    TEST_BRC_ROOT=$(realpath -m "$TEST_BRC_ROOT")
    export TEST_BRC_ROOT

    export HOME="$TEST_BRC_ROOT/home"
    export BASHRC_PATH="$TEST_BRC_ROOT/repo"

    mkdir -p "$HOME" "$BASHRC_PATH/archive" "$BASHRC_PATH/test" "$BASHRC_PATH/modules" "$BASHRC_PATH/profiles"
    printf '%s\n' 'export BASHRC_PATH="/tmp/placeholder"' > "$BASHRC_PATH/base.bash"
    printf '%s\n' 'user-bashrc' > "$HOME/.bashrc"

    evalpath() {
        local last
        for last in "$@"; do :; done
        realpath -m "$last"
    }

    git() {
        if [[ "$*" == *"config --get remote.origin.url"* ]]; then
            printf '%s\n' 'https://github.com/oliviax727/bash-rc.git'
            return 0
        fi

        if [[ "$*" == *"rev-parse --is-inside-work-tree"* ]]; then
            printf '%s\n' 'true'
            return 0
        fi

        if [[ "$*" == *"rev-parse HEAD"* ]]; then
            printf '%s\n' 'abc123'
            return 0
        fi

        if [[ "$*" == *"rev-parse --abbrev-ref HEAD"* ]]; then
            printf '%s\n' 'main'
            return 0
        fi

        if [[ "$*" == *"branch -r"* ]]; then
            printf '%s\n' '  origin/HEAD -> origin/main' '  origin/main' '  origin/feature'
            return 0
        fi

        return 0
    }

    cd-run() {
        local saved="$PWD"
        cd "$1" || return 1
        eval "$2"
        local rc=$?
        cd "$saved" || return 1
        return "$rc"
    }

    diff-diode() {
        return 0
    }

    filename-date() {
        printf '%s\n' '2026-07-14-TEST'
    }

    sed() {
        return 0
    }

    # shellcheck disable=SC1091
    source ../modules/bash-rc.bashrc
}

test_bash_rc_help_runs_without_error() {
    setup_bash_rc_test_env
    bash-rc help >/dev/null 2>&1
    assert_equals "0" "$?"
}

test_bash_rc_unknown_command_fails() {
    setup_bash_rc_test_env
    bash-rc does-not-exist >/dev/null 2>&1
    assert_equals "1" "$?"
}

test_bash_rc_archive_copies_home_bashrc() {
    setup_bash_rc_test_env

    bash-rc archive >/dev/null 2>&1
    assert_equals "0" "$?"
    assert_status_code 0 "test -f \"$BASHRC_PATH/archive/archive-2026-07-14-TEST.bashrc\""
    assert_equals "user-bashrc" "$(cat "$BASHRC_PATH/archive/archive-2026-07-14-TEST.bashrc")"
}

test_bash_rc_publish_alias_copies_test_file_into_modules() {
    setup_bash_rc_test_env
    printf '%s\n' 'alias demo="echo demo"' > "$BASHRC_PATH/test/test_alias.bash_aliases"

    bash-rc publish alias demo >/dev/null 2>&1
    assert_equals "0" "$?"
    assert_status_code 0 "test -f \"$BASHRC_PATH/modules/demo.bash_aliases\""
    assert_equals "alias demo=\"echo demo\"" "$(cat "$BASHRC_PATH/modules/demo.bash_aliases")"
}

test_bash_rc_purge_clears_archive_files() {
    setup_bash_rc_test_env
    printf '%s\n' 'old1' > "$BASHRC_PATH/archive/one.bashrc"
    printf '%s\n' 'old2' > "$BASHRC_PATH/archive/two.bashrc"

    bash-rc purge >/dev/null 2>&1
    assert_equals "0" "$?"
    assert_equals "0" "$(find "$BASHRC_PATH/archive" -type f | wc -l)"
}

test_bash_rc_build_replaces_home_bashrc_from_ready_file() {
    setup_bash_rc_test_env
    printf '%s\n' 'built-bashrc' > "$BASHRC_PATH/base.bash"

    bash-rc build -f >/dev/null 2>&1
    assert_equals "0" "$?"
    assert_equals "built-bashrc" "$(cat "$HOME/.bashrc")"
}
