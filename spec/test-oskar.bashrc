#!/usr/bin/env bash

# shellcheck disable=SC1091
source ../modules/oskar.bashrc

setup_oskar_fake_type() {
    type() {
        return 0
    }
}

setup_oskar_fake_evalpath() {
    evalpath() {
        printf '%s\n' "$1"
    }
}

setup_oskar_fake_singularity() {
    singularity() {
        return 0
    }
}

test_oskar_bash_help_runs_without_error() {
    assert_status_code 0 "oskar-bash -h >/dev/null 2>&1"
    assert_status_code 0 "oskar-bash --help >/dev/null 2>&1"
}

test_oskar_bash_global_interferometer_runs_without_error() {
    setup_oskar_fake_type

    oskar_sim_interferometer() {
        return 0
    }

    assert_status_code 0 "oskar-bash -i >/dev/null 2>&1"
}

test_oskar_bash_local_binary_runs_without_error() {
    setup_oskar_fake_type
    setup_oskar_fake_evalpath

    local test_root
    test_root=$(mktemp -d "./oskar-local.XXXXXX")
    trap 'rm -rf "$test_root"' RETURN

    mkdir -p "$test_root/bin"
    cat > "$test_root/bin/oskar_sim_interferometer" <<'EOF'
#!/usr/bin/env bash
exit 0
EOF
    chmod +x "$test_root/bin/oskar_sim_interferometer"

    assert_status_code 0 "oskar-bash -l \"$test_root\" -i >/dev/null 2>&1"
}

test_oskar_bash_singularity_runs_without_error() {
    setup_oskar_fake_evalpath
    setup_oskar_fake_singularity

    local test_sif
    test_sif=$(mktemp "./oskar-sif.XXXXXX")
    trap 'rm -f "$test_sif"' RETURN

    assert_status_code 0 "oskar-bash -s \"$test_sif\" -i >/dev/null 2>&1"
}

test_oskar_bash_clean_removes_log_files() {
    setup_oskar_fake_type

    oskar_sim_interferometer() {
        return 0
    }

    local test_root
    test_root=$(mktemp -d "./oskar-clean.XXXXXX")
    trap 'rm -rf "$test_root"' RETURN

    touch "$test_root/sample.log"
    pushd "$test_root" >/dev/null

    assert_status_code 0 "oskar-bash -c -i >/dev/null 2>&1"
    assert_status_code 0 "test ! -e sample.log"

    popd >/dev/null
}