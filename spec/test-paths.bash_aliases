#!/usr/bin/env bash

# shellcheck disable=SC1091
source ../modules/paths.bash_aliases

test_paths_exports_core_variables() {
    assert_equals "/usr/lib/jvm/java-16-openjdk-amd64" "$JAVA_HOME"
    assert_equals "$HOME/go" "$GOPATH"
    assert_equals "$HOME/.oskar/OSKAR-2.12.2" "$OSKAR_INC_DIR"
    assert_equals "$HOME/.oskar/OSKAR-2.12.2" "$OSKAR_LIB_DIR"
    assert_equals ".venv:.virtualenv" "$PYLINT_VENV_PATH"
    assert_equals "/usr/bin/python3:$PWD/.venv/bin/python3" "$PYTHONPATH"
}

test_paths_prepends_expected_go_binary_path() {
    case "$PATH" in
        /usr/local/go/bin:*)
            assert_status_code 0 "true"
        ;;
        *)
            fail "expected PATH to begin with /usr/local/go/bin but was: $PATH"
        ;;
    esac
}

test_paths_defines_clipboard_alias() {
    assert_status_code 0 "alias cc >/dev/null 2>&1"
}