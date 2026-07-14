#!/usr/bin/env bash

# shellcheck disable=SC1091,SC2329
source ../modules/cpp_modules.bashrc

test_init_cpp_creates_source_and_binaries() {
    local workdir
    workdir=$(mktemp -d "./cpp-test.XXXXXX")
    trap 'rm -rf "$workdir"' RETURN

    g++() {
        local output=''
        while [[ $# -gt 0 ]]; do
            if [[ "$1" == "-o" ]]; then
                output="$2"
                shift 2
                continue
            fi
            shift
        done

        printf '#!/usr/bin/env bash\necho run-ok\n' > "$output"
        chmod +x "$output"
        return 0
    }

    pushd "$workdir" >/dev/null || return 1
    init-cpp hello

    assert_status_code 0 "test -f hello.cpp"
    assert_status_code 0 "test -f hello.out"
    assert_status_code 0 "test -f hello.gdb.out"
    assert_status_code 0 "grep -q 'int main' hello.cpp"
    popd >/dev/null || return 1
}

test_run_cpp_compiles_and_executes_output_binary() {
    local workdir
    workdir=$(mktemp -d "./cpp-test.XXXXXX")
    trap 'rm -rf "$workdir"' RETURN

    g++() {
        local output=''
        while [[ $# -gt 0 ]]; do
            if [[ "$1" == "-o" ]]; then
                output="$2"
                shift 2
                continue
            fi
            shift
        done

        printf '#!/usr/bin/env bash\necho run-ok\n' > "$output"
        chmod +x "$output"
        return 0
    }

    pushd "$workdir" >/dev/null || return 1
    printf '%s\n' 'int main() { return 0; }' > hello.cpp

    assert_equals "run-ok" "$(run-cpp hello)"
    popd >/dev/null || return 1
}

test_debug_cpp_invokes_gdb_with_debug_binary() {
    local workdir
    local gdb_log
    workdir=$(mktemp -d "./cpp-test.XXXXXX")
    gdb_log=$(mktemp "./gdb-log.XXXXXX")
    trap 'rm -rf "$workdir"; rm -f "$gdb_log"' RETURN

    g++() {
        local output=''
        while [[ $# -gt 0 ]]; do
            if [[ "$1" == "-o" ]]; then
                output="$2"
                shift 2
                continue
            fi
            shift
        done

        : > "$output"
        return 0
    }

    gdb() {
        printf '%s\n' "$1" > "$gdb_log"
        return 0
    }

    pushd "$workdir" >/dev/null || return 1
    printf '%s\n' 'int main() { return 0; }' > hello.cpp

    assert_status_code 0 "debug-cpp hello >/dev/null 2>&1"
    assert_equals "./hello.gdb.out" "$(cat "$gdb_log")"
    popd >/dev/null || return 1
}
