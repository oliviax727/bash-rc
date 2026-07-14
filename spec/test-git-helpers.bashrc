#!/usr/bin/env bash

# shellcheck disable=SC1091,SC2329
source ../modules/git_helpers.bashrc

test_git_propagate_runs_without_error_with_stubbed_git() {
    local git_log
    git_log=$(mktemp "./git-propagate-log.XXXXXX")
    trap 'rm -f "$git_log"' RETURN

    git() {
        if [[ "$1" == "branch" && "$2" == "-r" ]]; then
            printf '%s\n' \
                '  origin/HEAD -> origin/main' \
                '  origin/main' \
                '  origin/feature'
            return 0
        fi

        if [[ "$1" == "rev-parse" && "$2" == "HEAD" ]]; then
            printf '%s\n' 'abc123'
            return 0
        fi

        if [[ "$1" == "rev-parse" && "$2" == "--abbrev-ref" && "$3" == "HEAD" ]]; then
            printf '%s\n' 'main'
            return 0
        fi

        printf '%s\n' "$*" >> "$git_log"
        return 0
    }

    assert_status_code 0 "git-propagate >/dev/null 2>&1"
    assert_status_code 0 "grep -q '^stash$' \"$git_log\""
    assert_status_code 0 "grep -q '^stash apply$' \"$git_log\""
}

test_git_propagate_attempts_cherry_pick_when_other_branches_exist() {
    local git_log
    git_log=$(mktemp "./git-propagate-log.XXXXXX")
    trap 'rm -f "$git_log"' RETURN

    git() {
        if [[ "$1" == "branch" && "$2" == "-r" ]]; then
            printf '%s\n' \
                '  origin/HEAD -> origin/main' \
                '  origin/main' \
                '  origin/feature' \
                '  origin/release'
            return 0
        fi

        if [[ "$1" == "rev-parse" && "$2" == "HEAD" ]]; then
            printf '%s\n' 'abc123'
            return 0
        fi

        if [[ "$1" == "rev-parse" && "$2" == "--abbrev-ref" && "$3" == "HEAD" ]]; then
            printf '%s\n' 'main'
            return 0
        fi

        printf '%s\n' "$*" >> "$git_log"
        return 0
    }

    assert_status_code 0 "git-propagate >/dev/null 2>&1"
    assert_status_code 0 "grep -q '^cherry-pick abc123$' \"$git_log\""
    assert_status_code 0 "grep -q '^push$' \"$git_log\""
}
