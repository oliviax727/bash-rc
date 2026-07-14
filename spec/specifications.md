# Module Unit Test Specifications

## OSKAR-bash

| Function | Description |
| --- | --- |
| `test_oskar_bash_help_runs_without_error` | Confirms `oskar-bash -h` and `oskar-bash --help` execute successfully. |
| `test_oskar_bash_global_interferometer_runs_without_error` | Verifies global interferometer mode can run when command lookup/execution is stubbed. |
| `test_oskar_bash_local_binary_runs_without_error` | Creates a temporary local binary path and checks `-l ... -i` executes without failure. |
| `test_oskar_bash_singularity_runs_without_error` | Stubs singularity execution path and verifies `-s ... -i` branch runs successfully. |
| `test_oskar_bash_clean_removes_log_files` | Checks `-c` cleans `.log` files in a temporary working directory. |

## Admiral

| Function | Description |
| --- | --- |
| `test_admiral_help_runs_without_error` | Confirms `admiral help` executes successfully. |
| `test_admiral_unknown_command_fails` | Verifies unknown subcommands are rejected with non-zero status. |
| `test_admiral_normalize_dev_accepts_kernel_and_absolute_names` | Checks device normalisation for both `sda1` and `/dev/sda1` forms. |
| `test_admiral_normalize_dev_rejects_invalid_names` | Confirms invalid device names are rejected. |
| `test_admiral_resolve_mcp_path_maps_supported_prefixes` | Verifies `root:`, `target:`, `sda:`, `host:`, `sdb:`, and absolute paths map correctly. |
| `test_admiral_resolve_mcp_path_rejects_invalid_values` | Confirms invalid non-prefixed relative paths fail path resolution. |
| `test_admiral_boot_requires_a_root_partition` | Checks `admiral boot` fails when required root partition is missing. |
| `test_admiral_boot_rejects_missing_root_value` | Checks `admiral boot -r` fails when option value is missing. |
| `test_admiral_boot_rejects_unknown_options` | Confirms unknown `boot` options are rejected. |
| `test_admiral_mcp_requires_a_root_partition` | Checks `admiral mcp` fails when required root partition is missing. |
| `test_admiral_mcp_rejects_missing_root_value` | Checks `admiral mcp -r` fails when option value is missing. |
| `test_admiral_mcp_rejects_too_few_path_arguments` | Confirms `mcp` requires both source and destination path arguments. |
| `test_admiral_mount_target_rejects_unsafe_targets` | Verifies mount helper refuses non-`/mnt/*` mount targets for safety. |
| `test_admiral_unmount_target_rejects_unsafe_targets` | Verifies unmount helper refuses non-`/mnt/*` targets for safety. |

## Bash-Doc Aliases

| Function | Description |
| --- | --- |
| `test_bash_doc_aliases_are_defined` | Checks core aliases in the module are defined after sourcing. |
| `test_setenv_exports_variables` | Verifies `setenv` exports the provided variable and value. |
| `test_add_alias_writes_to_user_alias_file` | Confirms `add-alias` creates/updates `~/.bash_aliases` and registers the alias in-shell. |
| `test_repeat_runs_command_the_requested_number_of_times` | Checks `repeat` runs the command exactly the requested number of iterations. |
| `test_seq_emits_the_expected_range` | Verifies `_seq` emits an inclusive integer range. |

## Custom Bash Aliases

| Function | Description |
| --- | --- |
| `test_custom_aliases_are_defined` | Checks custom utility aliases are defined after sourcing. |
| `test_diff_diode_reports_left_only_lines` | Verifies `diff-diode` returns lines present only in the left file. |
| `test_cd_run_executes_command_in_target_directory` | Confirms `cd-run` executes command in target directory and returns control to caller. |
| `test_clean_snaps_removes_disabled_revisions` | Validates `clean-snaps` removes only revisions marked `disabled` in `snap list --all` output. |

## Default Bash Aliases

| Function | Description |
| --- | --- |
| `test_default_module_skips_non_interactive_shells` | Checks module exits early in non-interactive shells. |
| `test_default_module_defines_core_ls_aliases_interactively` | Verifies `ll`, `la`, and `l` are available in interactive shell loading. |
| `test_default_module_defines_alert_alias_interactively` | Verifies `alert` alias is defined in interactive shell loading. |
| `test_default_module_sources_user_bash_aliases_file` | Confirms module sources user `~/.bash_aliases` when present. |

## Paths

| Function | Description |
| --- | --- |
| `test_paths_exports_core_variables` | Checks expected environment variables are exported with expected values. |
| `test_paths_prepends_expected_go_binary_path` | Verifies `PATH` begins with `/usr/local/go/bin` after sourcing. |
| `test_paths_defines_clipboard_alias` | Confirms `cc` clipboard alias is defined. |

## Path Manager

| Function | Description |
| --- | --- |
| `test_test_cmd_returns_success_for_true_expression` | Verifies `test-cmd` returns success for true shell expressions. |
| `test_test_cmd_returns_failure_for_false_expression` | Verifies `test-cmd` returns failure for false shell expressions. |
| `test_evalpath_expands_home_tilde` | Checks `evalpath` expands `~` to `HOME` under `realpath -m` behaviour. |
| `test_evalpath_handles_paths_with_spaces` | Confirms `evalpath` can resolve paths containing spaces safely. |
| `test_set_cwd_uses_home_shortening_when_twd_disabled` | Verifies `set_CWD` shortens paths under `HOME` to `~` when compression mode is disabled. |
| `test_set_cwd_compresses_prefix_using_quick_jump_vars` | Verifies `set_CWD` compresses path prefixes using `QUICK_JUMP_VARS` (e.g. `$WORKROOT/...`). |
| `test_terminal_colour_help_runs_without_error` | Confirms `terminal_colour --help` runs without error. |
| `test_term_col_alias_is_defined` | Confirms `term_col` alias is defined. |
| `test_cleanpath_removes_duplicates_and_invalid_entries` | Verifies `cleanpath` removes blank/invalid entries and duplicates while preserving valid order. |

## Python

| Function | Description |
| --- | --- |
| `N/A` | No unit tests were added by request; [spec/test-python.bashrc](spec/test-python.bashrc) is intentionally blank. |

## Git Helpers

| Function | Description |
| --- | --- |
| `test_git_propagate_runs_without_error_with_stubbed_git` | Verifies `git-propagate` runs successfully with a stubbed git backend. |
| `test_git_propagate_attempts_cherry_pick_when_other_branches_exist` | Confirms propagation attempts to cherry-pick and push operations when additional branches are present. |

## CPP Modules

| Function | Description |
| --- | --- |
| `test_init_cpp_creates_source_and_binaries` | Verifies `init-cpp` creates source and both normal/debug binaries. |
| `test_run_cpp_compiles_and_executes_output_binary` | Verifies `run-cpp` compiles and executes the generated output binary. |
| `test_debug_cpp_invokes_gdb_with_debug_binary` | Verifies `debug-cpp` calls `gdb` with the expected debug executable path. |

## QSSH

| Function | Description |
| --- | --- |
| `test_qssh_help_runs_without_error` | Confirms `qssh help` runs without error. |
| `test_qssh_unknown_command_fails` | Verifies unknown `qssh` subcommands fail with non-zero status. |
| `test_qssh_add_creates_entry_with_stubbed_key_setup` | Verifies `qssh add` writes host entries using stubbed key generation/copy commands. |
| `test_qssh_connect_uses_saved_host` | Confirms `qssh connect` resolves saved host names and invokes SSH with expected arguments. |
| `test_qssh_scp_resolves_remote_and_local_paths` | Verifies `qssh scp` resolves saved-host remote paths and local paths before calling `scp`. |
| `test_qssh_get_key_pipes_pubkey_to_xclip` | Confirms `qssh get-key` reads the `.pub` key and pipes it to `xclip`. |


# Additional Unit Test Specifications

No parent-directory test files recorded yet.


# Untestable Cases

- `admiral` integration paths requiring real block devices, mounts, `sudo`, and `chroot` user switching are not unit-testable in current harness.
- `oskar-bash` end-to-end execution against real OSKAR binaries/singularity images is treated as integration testing and is stubbed in unit tests.
- `python.bashrc` conda initialisation path is intentionally left without unit tests by request (would otherwise require conda executable/environment integration checks).
- `qssh` live host connectivity, real key exchange, and real `scp` network transfer behaviour are integration-level and are stubbed in unit tests.