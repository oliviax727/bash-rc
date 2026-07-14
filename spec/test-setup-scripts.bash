#!/usr/bin/env bash

# shellcheck disable=SC2030,SC2031

teardown() {
  rm -rf ./setup-sandbox.* ./setup-home.* ./setup-bin.*
  rm -f ./setup-su-log.*
}

run_with_5s_timeout() {
  if command -v timeout >/dev/null 2>&1; then
    timeout 5 "$@"
  elif command -v gtimeout >/dev/null 2>&1; then
    gtimeout 5 "$@"
  else
    "$@"
  fi
}

prepare_setup_sandbox() {
    local sandbox
    local repo
    sandbox=$(mktemp -d "./setup-sandbox.XXXXXX")
    sandbox=$(realpath -m "$sandbox")
    repo="$sandbox/repo"

    mkdir -p "$repo/modules" "$repo/profiles" "$repo/test"
    cp ../setup.sh ../setup_root.sh ../enter.bash ../exit.bash ../base.bash "$repo/"
    cp -a ../modules/. "$repo/modules/"
    cp -a ../profiles/. "$repo/profiles/"
    cp -a ../test/. "$repo/test/"

    printf '%s\n' "$repo"
}

test_setup_sh_runs_without_error_or_output() {
    local repo
    local temp_home
  local temp_home_abs
    local stub_bin
    repo="$(prepare_setup_sandbox)"
    temp_home=$(mktemp -d "./setup-home.XXXXXX")
  temp_home_abs=$(realpath -m "$temp_home")
    stub_bin=$(mktemp -d "./setup-bin.XXXXXX")
    stub_bin=$(realpath -m "$stub_bin")
  printf '%s\n' 'export BASHRC_PATH=""' > "$temp_home_abs/.bashrc"

    cat > "$stub_bin/git" <<'EOF'
#!/usr/bin/env bash
if [[ "$*" == *"config --get remote.origin.url"* ]]; then
  echo "https://github.com/oliviax727/bash-rc.git"
  exit 0
fi
if [[ "$*" == *"rev-parse --is-inside-work-tree"* ]]; then
  echo "true"
  exit 0
fi
if [[ "$*" == *"branch -r --list origin/main"* ]]; then
  echo "  origin/main"
  exit 0
fi
exit 0
EOF
    chmod +x "$stub_bin/git"

    local output
    output="$(cd "$repo" && PATH="$stub_bin:$PATH" && export PATH && hash -r && HOME="$temp_home_abs" run_with_5s_timeout bash ./setup.sh -n 2>&1)"
    local rc=$?

    assert_not_equals "124" "$rc"
    assert_equals "0" "$rc"
    assert_equals "" "$output"
}

test_setup_root_sh_invokes_setup_sh_without_error_or_output() {
    local repo
    local stub_bin
    local su_log
    repo="$(prepare_setup_sandbox)"
    stub_bin=$(mktemp -d "./setup-bin.XXXXXX")
    stub_bin=$(realpath -m "$stub_bin")
    su_log=$(mktemp "./setup-su-log.XXXXXX")
    su_log=$(realpath -m "$su_log")
    export TEST_SETUP_SU_LOG="$su_log"

    cat > "$stub_bin/su" <<'EOF'
#!/usr/bin/env bash
echo "$*" > "$TEST_SETUP_SU_LOG"
exit 0
EOF
    chmod +x "$stub_bin/su"

    local output
    output="$(cd "$repo" && PATH="$stub_bin:$PATH" && export PATH && hash -r && run_with_5s_timeout bash ./setup_root.sh -n 2>&1)"
    local rc=$?

    assert_not_equals "124" "$rc"
    assert_equals "0" "$rc"
    assert_equals "" "$output"
    assert_status_code 0 "grep -q './setup.sh \"-n\"' \"$TEST_SETUP_SU_LOG\""
}
