# `.bashrc` Modules

This document covers all `modules/*.bashrc` files and all functions defined in those files.

## Module Summary

| Module | Role |
| --- | --- |
| `modules/admiral.bashrc` | `chroot`/mount and copy tooling for alternate Linux installations. |
| `modules/bash-rc.bashrc` | Core repository management and build/publish command interface. |
| `modules/cpp_modules.bashrc` | `C++` compile/run/debug shortcut commands. |
| `modules/git_helpers.bashrc` | `Git` branch-propagation helper. |
| `modules/oskar.bashrc` | `OSKAR` command wrapper for global/local/singularity execution modes. |
| `modules/path_manager.bashrc` | Path `eval`, prompt path rendering, terminal colouring, and `PATH` sanitisation. |
| `modules/python.bashrc` | `Conda` initialisation block for Python tooling. |
| `modules/qssh.bashrc` | Quick `SSH` host/path registration and transport helpers. |

## Function Inventory

| Module | Function | Description |
| --- | --- | --- |
| `modules/admiral.bashrc` | `admiral` | Dispatcher for admiral subcommands. |
| `modules/admiral.bashrc` | `admiral-normalize-dev` | Validates and normalises partition identifiers (`sdXn`/`/dev/sdXn`). |
| `modules/admiral.bashrc` | `admiral-mount-target` | Mounts target root/`efi`/home and optional runtime bind mounts under safe `/mnt/*` target. |
| `modules/admiral.bashrc` | `admiral-unmount-target` | Safely unmounts previously mounted admiral resources. |
| `modules/admiral.bashrc` | `admiral-resolve-mcp-path` | Resolves `root:`, `target:`, `host:`, `sda:`, and `sdb:` path prefixes. |
| `modules/admiral.bashrc` | `admiral-boot` | Boots into mounted target OS via `chroot` and user shell handoff. |
| `modules/admiral.bashrc` | `cleanup_admiral` | Internal cleanup helper for `admiral-boot`. |
| `modules/admiral.bashrc` | `admiral-mcp` | Copies files between host/target contexts after validated mounts. |
| `modules/admiral.bashrc` | `cleanup_admiral_mcp` | Internal cleanup helper for `admiral-mcp`. |
| `modules/admiral.bashrc` | `admiral-help` | Usage/help output for admiral commands. |
| `modules/bash-rc.bashrc` | `bash-rc` | Dispatcher for `bash-rc` subcommands. |
| `modules/bash-rc.bashrc` | `bash-rc-sed-inplace` | Portable in-place `sed` wrapper for GNU/BSD compatibility. |
| `modules/bash-rc.bashrc` | `bash-rc-check-path` | Validates whether a path is a usable `bash-rc` repository clone. |
| `modules/bash-rc.bashrc` | `bash-rc-change-path` | Rewrites `export BASHRC_PATH=` in target `.bashrc` and `base.bash` files. |
| `modules/bash-rc.bashrc` | `bash-rc-update` | Fetches and hard-resets local repository to `origin/main`. |
| `modules/bash-rc.bashrc` | `bash-rc-checkout` | Updates and then switches to the requested branch. |
| `modules/bash-rc.bashrc` | `bash-rc-clone` | Clones repository into destination and attempts setup. |
| `modules/bash-rc.bashrc` | `bash-rc-archive` | Archives current home `.bashrc` into repository archive folder. |
| `modules/bash-rc.bashrc` | `bash-rc-test` | Runs a test-profile shell session (`BASHRC_TEST_MODE=1`). |
| `modules/bash-rc.bashrc` | `bash-rc-publish` | Publishes files from `test/` into main module/profile entry points. |
| `modules/bash-rc.bashrc` | `bash-rc-build` | Builds `ready.bashrc` from `base.bash` and installs to `~/.bashrc`. |
| `modules/bash-rc.bashrc` | `bash-rc-purge` | Clears archive files (or creates archive folder if missing). |
| `modules/bash-rc.bashrc` | `bash-rc-set-path` | Validates and sets new `BASHRC_PATH`, including home `.bashrc` rewrite. |
| `modules/bash-rc.bashrc` | `bash-rc-help` | Usage/help output for `bash-rc` commands. |
| `modules/cpp_modules.bashrc` | `init-cpp` | Creates boilerplate `C++` source and builds normal/debug binaries. |
| `modules/cpp_modules.bashrc` | `run-cpp` | Builds and executes target `C++` source. |
| `modules/cpp_modules.bashrc` | `debug-cpp` | Builds debug binary and opens `gdb`. |
| `modules/git_helpers.bashrc` | `git-propagate` | Cherry-picks current commit across remote branches and pushes. |
| `modules/oskar.bashrc` | `oskar-bash` | Runs `OSKAR` workflows with local/global/`sif` options and cleanup support. |
| `modules/path_manager.bashrc` | `test-cmd` | Executes command text and returns success/failure only. |
| `modules/path_manager.bashrc` | `evalpath` | Expands/sanitises path arguments and delegates to `realpath`. |
| `modules/path_manager.bashrc` | `set_CWD` | Sets compact prompt path (`CWD`) with optional quick-jump compression. |
| `modules/path_manager.bashrc` | `terminal_colour` | Sets prompt style/colour themes and shows style help. |
| `modules/path_manager.bashrc` | `cleanpath` | Deduplicates and validates `PATH`-like variables. |
| `modules/python.bashrc` | Not applicable | No project-defined shell functions; contains `Conda` initialisation logic. |
| `modules/qssh.bashrc` | `sshcd` | `SSH` helper that opens a remote shell after changing the remote directory. |
| `modules/qssh.bashrc` | `qssh` | Dispatcher and runtime initialiser for `qssh` subcommands. |
| `modules/qssh.bashrc` | `qssh-sed-inplace` | Portable in-place `sed` wrapper for GNU/BSD compatibility. |
| `modules/qssh.bashrc` | `qssh-import` | Loads and optionally overwrites `qssh` config CSV into map. |
| `modules/qssh.bashrc` | `qssh-split-by-colon` | Splits `host:path` strings for `qssh` internals. |
| `modules/qssh.bashrc` | `qssh-connect` | Connects to named host/path using stored identity key. |
| `modules/qssh.bashrc` | `qssh-add` | Adds/overwrites host and path entries, including key setup path. |
| `modules/qssh.bashrc` | `qssh-remove` | Removes host/path entries and associated keys. |
| `modules/qssh.bashrc` | `qssh-purge` | Clears all `qssh` config data and keys. |
| `modules/qssh.bashrc` | `qssh-eval-scp-path` | Resolves local/remote path references for `scp` operations. |
| `modules/qssh.bashrc` | `qssh-scp` | Secure-copy wrapper using `qssh` path resolution. |
| `modules/qssh.bashrc` | `qssh-get-key` | Copies saved public key contents to clipboard (`xclip`). |
| `modules/qssh.bashrc` | `qssh-list` | Lists saved `qssh` entries in tabular form. |
| `modules/qssh.bashrc` | `qssh-help` | Usage/help output for `qssh` commands. |

## Notes

- Several command suites are nested inside dispatcher functions (`admiral`, `bash-rc`, and `qssh`).
- Runtime or system-touching commands (`mount`/`chroot`/`ssh`/network/`git push`) should be treated as integration behaviour during tests.
