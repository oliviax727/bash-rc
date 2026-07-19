#!/usr/bin/env bash

# shellcheck disable=SC1091
source ../modules/paths.bash_aliases

test_paths_defines_clipboard_alias() {
    assert_status_code 0 "alias cc >/dev/null 2>&1"
}