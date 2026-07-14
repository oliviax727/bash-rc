# Bash-rc Core Module

This document focuses on `modules/bash-rc.bashrc` and how it coordinates the repository.

## Purpose

`bash-rc` is the administrative command surface for this project. It handles repository validation, update and switch operations, install and build flow, archive management, and publication of test-stage files.

## Command Map

| Command | Primary Function | Interaction Surface |
| --- | --- | --- |
| `bash-rc build` | `bash-rc-build` | Uses `base.bash` to generate `ready.bashrc`, then installs into `~/.bashrc`. |
| `bash-rc update` | `bash-rc-update` | Calls `git fetch`/`git reset` against current `BASHRC_PATH`. |
| `bash-rc checkout` | `bash-rc-checkout` | Runs update then switches branch. |
| `bash-rc archive` | `bash-rc-archive` | Copies home `.bashrc` into `archive/`. |
| `bash-rc purge` | `bash-rc-purge` | Removes archived files in `archive/`. |
| `bash-rc test` | `bash-rc-test` | Starts a shell using test profile behaviour. |
| `bash-rc publish` | `bash-rc-publish` | Promotes files from `test/` into modules/profiles/entry scripts. |
| `bash-rc check-path` | `bash-rc-check-path` | Verifies selected path is a valid `bash-rc` git clone. |
| `bash-rc set-path` | `bash-rc-set-path` | Updates `BASHRC_PATH` in session and rewrites home `.bashrc` config. |
| `bash-rc change-path` | `bash-rc-change-path` | Internal targeted string replacement for path export lines. |

## Function Details

| Function | Responsibility |
| --- | --- |
| `bash-rc-sed-inplace` | Provides cross-platform `sed -i` behaviour for GNU/BSD. |
| `bash-rc-check-path` | Ensures path exists and points to repo with remote `basename` `bash-rc`; can prompt clone. |
| `bash-rc-change-path` | Rewrites a specific file line beginning with `export BASHRC_PATH=`. |
| `bash-rc-update` | Syncs local repository to `origin/main`. |
| `bash-rc-checkout` | Checks out the chosen branch after synchronisation. |
| `bash-rc-clone` | Clones repository using `SSH`/`HTTPS` fallback and attempts setup. |
| `bash-rc-archive` | Archives the current home `.bashrc`. |
| `bash-rc-test` | Runs isolated test-mode shell by setting `BASHRC_TEST_MODE=1`. |
| `bash-rc-publish` | Publishes test snippets to production module/profile files. |
| `bash-rc-build` | Assembles and installs the final `.bashrc`, with options for archive, append, pull, and checkout. |
| `bash-rc-purge` | Deletes archive contents or initialises archive folder. |
| `bash-rc-set-path` | Sets a validated repository path and updates active user `.bashrc` settings. |
| `bash-rc-help` | Emits command/option usage. |

## Interaction With Other Components

| Component | Interaction |
| --- | --- |
| `base.bash` | Source template for generating `ready.bashrc` during build. |
| `ready.bashrc` | Build artifact copied to `~/.bashrc`. |
| `enter.bash` / `exit.bash` | Included indirectly via `base.bash` in build output. |
| `modules/custom.bash_aliases` | `bash-rc-build` uses `diff-diode`; clone path uses `cd-run`. |
| `modules/path_manager.bashrc` | Path normalisation relies on `evalpath`. |
| `test/` | `bash-rc-publish` imports staged test snippets. |
| `profiles/` and `modules/` | Publication targets for profile, alias, and `.bashrc` modules. |
| `archive/` | Stores historical `.bashrc` snapshots and supports purge. |
| `Git` remote (`origin`) | Update/checkout workflows depend on repository connectivity. |

## Operational Notes

- Build defaults to archiving current `.bashrc` unless `-f` is passed.
- `-k` appends a one-way diff from previous `.bashrc` into new file.
- `-p` and `-c <branch>` allow update/switch during build flow.
- Dispatcher pattern (`bash-rc <cmd>`) resolves to `bash-rc-<cmd>` function names.
