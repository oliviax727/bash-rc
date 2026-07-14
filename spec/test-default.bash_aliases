#!/usr/bin/env bash

test_default_module_skips_non_interactive_shells() {
    assert_status_code 1 "bash --noprofile --norc -c 'source ../modules/default.bash_aliases; alias ll >/dev/null 2>&1'"
}

test_default_module_defines_core_ls_aliases_interactively() {
    assert_status_code 0 "bash --noprofile --norc -ic 'source ../modules/default.bash_aliases; alias ll >/dev/null 2>&1'"
    assert_status_code 0 "bash --noprofile --norc -ic 'source ../modules/default.bash_aliases; alias la >/dev/null 2>&1'"
    assert_status_code 0 "bash --noprofile --norc -ic 'source ../modules/default.bash_aliases; alias l >/dev/null 2>&1'"
}

test_default_module_defines_alert_alias_interactively() {
    assert_status_code 0 "bash --noprofile --norc -ic 'source ../modules/default.bash_aliases; alias alert >/dev/null 2>&1'"
}

test_default_module_sources_user_bash_aliases_file() {
    local test_home
    test_home=$(mktemp -d "./default-home.XXXXXX")
    trap 'rm -rf "$test_home"' RETURN

    cat > "$test_home/.bash_aliases" <<'EOF'
alias from_user_aliases="echo loaded"
EOF

    assert_status_code 0 "HOME=\"$test_home\" bash --noprofile --norc -ic 'source ../modules/default.bash_aliases; alias from_user_aliases >/dev/null 2>&1'"
}