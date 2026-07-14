#!/usr/bin/env bash

# shellcheck disable=SC2329

teardown() {
    rm -rf ./qssh-home.* ./qssh-bin.*
    rm -f ./qssh-ssh-log.* ./qssh-scp-log.* ./qssh-local.* ./qssh-clip-log.*
}

test_qssh_help_runs_without_error() {
    local test_home
    test_home=$(mktemp -d "./qssh-home.XXXXXX")
    test_home=$(realpath -m "$test_home")

    export HOME="$test_home"
    mkdir -p "$HOME/.config/qssh"

    # shellcheck disable=SC1091
    source ../modules/qssh.bashrc

    assert_status_code 0 "qssh help >/dev/null 2>&1"
}

test_qssh_unknown_command_fails() {
    local test_home
    test_home=$(mktemp -d "./qssh-home.XXXXXX")
    test_home=$(realpath -m "$test_home")

    export HOME="$test_home"
    mkdir -p "$HOME/.config/qssh"

    # shellcheck disable=SC1091
    source ../modules/qssh.bashrc

    assert_status_code 1 "qssh does-not-exist >/dev/null 2>&1"
}

test_qssh_add_creates_entry_with_stubbed_key_setup() {
    local test_home
    test_home=$(mktemp -d "./qssh-home.XXXXXX")
    test_home=$(realpath -m "$test_home")

    export HOME="$test_home"
    mkdir -p "$HOME/.config/qssh"

    # shellcheck disable=SC1091
    source ../modules/qssh.bashrc

    ssh-keygen() {
        local target=''
        while [[ $# -gt 0 ]]; do
            if [[ "$1" == "-f" ]]; then
                target="$2"
                break
            fi
            shift
        done

        : > "$target"
        : > "$target.pub"
        return 0
    }

    ssh-copy-id() {
        return 0
    }

    assert_status_code 0 "qssh add devbox dev@server >/dev/null 2>&1"
    assert_status_code 0 "grep -q '^devbox,dev@server$' \"$HOME/.config/qssh/qssh.csv\""
}

test_qssh_connect_uses_saved_host() {
    local test_home
    local ssh_log
    test_home=$(mktemp -d "./qssh-home.XXXXXX")
    test_home=$(realpath -m "$test_home")
    ssh_log=$(mktemp "./qssh-ssh-log.XXXXXX")
    export TEST_QSSH_SSH_LOG="$ssh_log"

    export HOME="$test_home"

    mkdir -p "$HOME/.config/qssh"
    printf '%s\n' 'devbox,dev@server' > "$HOME/.config/qssh/qssh.csv"

    # shellcheck disable=SC1091
    source ../modules/qssh.bashrc

    ssh() {
        printf '%s\n' "$*" > "$TEST_QSSH_SSH_LOG"
        return 0
    }

    assert_status_code 0 "qssh connect devbox >/dev/null 2>&1"
    assert_status_code 0 "grep -q -- '-i $HOME/.config/qssh/devbox dev@server' \"$TEST_QSSH_SSH_LOG\""
    unset TEST_QSSH_SSH_LOG
}

test_qssh_scp_resolves_remote_and_local_paths() {
    local test_home
    local scp_log
    local local_file
    local stub_bin
    test_home=$(mktemp -d "./qssh-home.XXXXXX")
    test_home=$(realpath -m "$test_home")
    scp_log=$(mktemp "./qssh-scp-log.XXXXXX")
    local_file=$(mktemp "./qssh-local.XXXXXX")
    stub_bin=$(mktemp -d "./qssh-bin.XXXXXX")
    export TEST_QSSH_SCP_LOG="$scp_log"

    export HOME="$test_home"
    export PATH="$stub_bin:$PATH"

    mkdir -p "$HOME/.config/qssh"
    printf '%s\n' 'devbox,dev@server' > "$HOME/.config/qssh/qssh.csv"

    # shellcheck disable=SC1091
    source ../modules/qssh.bashrc

    evalpath() {
        printf '%s\n' "$1"
    }

    cat > "$stub_bin/scp" <<'EOF'
#!/usr/bin/env bash
printf '%s\n' "$*" > "$TEST_QSSH_SCP_LOG"
EOF
    chmod +x "$stub_bin/scp"

    qssh scp devbox:/remote/path "$local_file" >/dev/null 2>&1
    assert_equals "0" "$?"
    assert_status_code 0 "grep -q -- 'dev@server:/remote/path $local_file' \"$TEST_QSSH_SCP_LOG\""
    unset TEST_QSSH_SCP_LOG
}

test_qssh_get_key_pipes_pubkey_to_xclip() {
    local test_home
    local clip_log
    local stub_bin
    test_home=$(mktemp -d "./qssh-home.XXXXXX")
    test_home=$(realpath -m "$test_home")
    clip_log=$(mktemp "./qssh-clip-log.XXXXXX")
    stub_bin=$(mktemp -d "./qssh-bin.XXXXXX")
    export TEST_QSSH_CLIP_LOG="$clip_log"

    export HOME="$test_home"
    export PATH="$stub_bin:$PATH"
    mkdir -p "$HOME/.config/qssh"
    printf '%s\n' 'ssh-ed25519 AAAATESTKEY devbox' > "$HOME/.config/qssh/devbox.pub"
    : > "$HOME/.config/qssh/qssh.csv"

    # shellcheck disable=SC1091
    source ../modules/qssh.bashrc

    cat > "$stub_bin/xclip" <<'EOF'
#!/usr/bin/env bash
cat > "$TEST_QSSH_CLIP_LOG"
EOF
    chmod +x "$stub_bin/xclip"

    qssh get-key devbox >/dev/null 2>&1
    assert_equals "0" "$?"
    assert_equals "ssh-ed25519 AAAATESTKEY devbox" "$(cat "$TEST_QSSH_CLIP_LOG")"
    unset TEST_QSSH_CLIP_LOG
}