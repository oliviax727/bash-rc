#!/usr/bin/env bash

prepare_base_harness() {
    local root
    root=$(mktemp -d "./base-test.XXXXXX")
    root=$(realpath -m "$root")

    mkdir -p "$root/profiles" "$root/modules" "$root/test"

    cp ../test/test_profile.bash_profile "$root/profiles/test.bash_profile"

    cat > "$root/profiles/none.bash_profile" <<'EOF'
profile_enter() { :; }
profile_alias() { :; }
profile_rc() { :; }
profile_exit() { :; }
EOF

    cat > "$root/enter.bash" <<'EOF'
printf '%s\n' "enter" >> "$BASE_TEST_LOG"
EOF

    cat > "$root/exit.bash" <<'EOF'
printf '%s\n' "exit" >> "$BASE_TEST_LOG"
EOF

    cat > "$root/modules/01-first.bash_aliases" <<'EOF'
printf '%s\n' "alias-first" >> "$BASE_TEST_LOG"
EOF

    cat > "$root/modules/02-second.bash_aliases" <<'EOF'
printf '%s\n' "alias-second" >> "$BASE_TEST_LOG"
EOF

    cat > "$root/modules/03-skip.bash_aliases" <<'EOF'
printf '%s\n' "alias-skip" >> "$BASE_TEST_LOG"
EOF

    cat > "$root/modules/11-first.bashrc" <<'EOF'
printf '%s\n' "rc-first" >> "$BASE_TEST_LOG"
EOF

    cat > "$root/modules/12-skip.bashrc" <<'EOF'
printf '%s\n' "rc-skip" >> "$BASE_TEST_LOG"
EOF

    cp ../base.bash "$root/ready.bashrc"
    sed -i "s|export BASHRC_PATH=\"\"|export BASHRC_PATH=\"$root\"|" "$root/ready.bashrc"

    printf '%s\n' "$root"
}

test_base_sources_without_error_or_output_in_test_mode() {
    local root
    local output_file
    local output
    local rc
    root="$(prepare_base_harness)"
    export BASE_TEST_LOG="$root/load.log"
    export BASHRC_TEST_MODE=1
    export BASHRC_IGNORE_MODULES="$root/modules/03-skip.bash_aliases:$root/modules/12-skip.bashrc"
    output_file=$(mktemp "./base-output.XXXXXX")

    source "$root/ready.bashrc" > "$output_file" 2>&1
    rc=$?
    output="$(cat "$output_file")"

    assert_equals "0" "$rc"
    assert_equals "" "$output"
    assert_equals "test" "$BASH_PROFILE"
}

test_base_loads_in_expected_order_and_honours_ignore_modules() {
    local root
    root="$(prepare_base_harness)"
    export BASE_TEST_LOG="$root/load.log"
    export BASHRC_TEST_MODE=1
    export BASHRC_IGNORE_MODULES="$root/modules/03-skip.bash_aliases:$root/modules/12-skip.bashrc"

    source "$root/ready.bashrc"

    assert_equals $'enter\nalias-first\nalias-second\nrc-first\nexit' "$(cat "$BASE_TEST_LOG")"
}
