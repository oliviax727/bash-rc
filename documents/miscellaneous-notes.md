# Miscellaneous Notes

This document captures project behaviour that does not belong to a single module reference.

## Setup behaviour

### `setup.sh`

- Sets `BASHRC_PATH` to repository directory.
- Defines a compatibility `sed` wrapper for BSD/GNU in-place edit behaviour.
- Ensures `archive_<user>/` exists.
- Sources minimal dependencies (`enter.bash`, `modules/custom.bash_aliases`, `modules/path_manager.bashrc`, `modules/bash-rc.bashrc`).
- Runs `bash-rc build -f` by default, or the unstable branch flow when selected.
- If shell is interactive, resets and sources resulting `~/.bashrc`.

### `setup_root.sh`

- Invokes `setup.sh` through `su` from repository directory.
- Passes through the optional argument to preserve setup mode selection.

## Archiving and Build Artifacts

- Active archive location used by core module: `archive/`.
- Archive file naming format uses `filename-date`, e.g. `archive-YYYY-MM-DD-HHMM-TZ.bashrc`.
- Build artifact generated in repo: `ready.bashrc`.
- Final installation target: `${HOME}/.bashrc`.

## `ShellCheck` policy

Current linting baseline is designed to be deterministic across local editor and CI:

- Command form: `shellcheck --norc --rcfile=.shellcheckrc --exclude=SC1091 -S info ...`
- Config file: `.shellcheckrc`
- VS Code `args`: `.vscode/settings.json`
- CI command source: `.github/workflows/bash_unit.yml`

## CI and Quality Gates

Primary gates:

1. `ShellCheck` lint pass over tracked shell files.
2. `bash_unit` test run over every `spec/test-*` file.
3. Per-spec timeout handling with explicit timeout and failure reporting.

## Testing Conventions

- Keep tests unit-level with stubs/fakes for network/system-level commands.
- Prefer deterministic, local file-system behaviour in temporary directories.
- Reserve real mounts/`chroot`/`SSH`/`scp`/`git`-network actions for integration contexts.

## Repository Layout Notes

- Runtime startup chain: `base.bash`, then `enter.bash`, then modules, then `exit.bash`.
- Profile-specific behaviour is injected via `profiles/*.bash_profile` hooks.
- Test support snippets are staged under `test/` and can be promoted with `bash-rc publish`.
