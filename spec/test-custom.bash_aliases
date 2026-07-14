#!/usr/bin/env bash

# shellcheck disable=SC1091,SC2329
source ../modules/custom.bash_aliases

test_custom_aliases_are_defined() {
    assert_status_code 0 "alias jpy >/dev/null 2>&1"
    assert_status_code 0 "alias restart >/dev/null 2>&1"
    assert_status_code 0 "alias hgrep >/dev/null 2>&1"
    assert_status_code 0 "alias tomcat_start >/dev/null 2>&1"
    assert_status_code 0 "alias tomcat_status >/dev/null 2>&1"
    assert_status_code 0 "alias tomcat_stop >/dev/null 2>&1"
    assert_status_code 0 "alias tomcat_restart >/dev/null 2>&1"
    assert_status_code 0 "alias open_tcp >/dev/null 2>&1"
    assert_status_code 0 "alias breakpoint >/dev/null 2>&1"
    assert_status_code 0 "alias filename-date >/dev/null 2>&1"
}

test_diff_diode_reports_left_only_lines() {
    local left_file
    local right_file
    left_file=$(mktemp "./custom-left.XXXXXX")
    right_file=$(mktemp "./custom-right.XXXXXX")
    trap 'rm -f "$left_file" "$right_file"' RETURN

    cat > "$left_file" <<'EOF'
alpha
beta
gamma
EOF

    cat > "$right_file" <<'EOF'
alpha
gamma
EOF

    assert_equals "beta" "$(diff-diode "$left_file" "$right_file")"
}

test_cd_run_executes_command_in_target_directory() {
    local target_dir
    target_dir=$(mktemp -d "./custom-cd-run.XXXXXX")
    trap 'rm -rf "$target_dir"' RETURN

    cd-run "$target_dir" "touch sentinel"

    assert_status_code 0 "test -f \"$target_dir/sentinel\""
    assert_equals "$PWD" "$(pwd)"
}

test_clean_snaps_removes_disabled_revisions() {
    snap() {
        if [[ "$1" == "list" && "$2" == "--all" ]]; then
            printf '%s\n' \
                'Name    Version   Rev    Tracking       Publisher   Notes' \
                'core    1.0       111    latest/stable  canonical   disabled' \
                'core    1.1       112    latest/stable  canonical   -' \
                'foo     7.0       7      latest/stable  canonical   disabled'
            return 0
        fi

        if [[ "$1" == "remove" ]]; then
            printf '%s:%s\n' "$2" "$3"
            return 0
        fi

        return 1
    }

    local removed
    removed="$(clean-snaps)"

    assert_equals $'core:--revision=111\nfoo:--revision=7' "$removed"
}