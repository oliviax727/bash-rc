# Process Overview

This document describes the startup and maintenance flow for this repository.

## 1. Entry Behaviour

The main entry point is `base.bash`.

Load sequence:

1. `BASHRC_PATH` is expected to point at this repository.
2. `enter.bash` is sourced first to initialise shared prompt and status variables.
3. Hostname is detected (`scutil`, `hostnamectl`, then `hostname` as fallback).
4. If `BASHRC_TEST_MODE=1`, profile selection is forced to `test`.

## 2. Profiles

Profiles live in `profiles/*.bash_profile` and are selected by hostname substring matching in this order:

1. `delll`
2. `Sirius`
3. `setonix`
4. `nid`
5. `MacBook`
6. `test`

`profiles/none.bash_profile` is always sourced first as the baseline.

Profile load order:

1. `profile_enter` after profile selection.
2. `profile_alias` after alias modules are sourced.
3. `profile_rc` after `.bashrc` modules are sourced.
4. `profile_exit` after `exit.bash` runs.

## 3. Alias and `.bashrc` module loading

### Alias phase

`base.bash` sources every `modules/*.bash_aliases` file unless its full path appears in `BASHRC_IGNORE_MODULES`.

### `.bashrc` phase

`base.bash` sources every `modules/*.bashrc` file unless excluded by `BASHRC_IGNORE_MODULES`.

`shopt -s expand_aliases` is enabled between alias and `.bashrc` phases.

## 4. Exit Behaviour

Exit sequence:

1. `exit.bash` is sourced.
2. `cleanpath` is called.
3. `cleanpath BASHRC_IGNORE_MODULES` normalises ignore-list paths.
4. `profile_exit` runs final profile customisations (commonly prompt colours and aliases).

## 5. Testing and Specification

### Unit tests

- Test files live under `spec/` as `spec/test-*`.
- Tests are run with local `./bash_unit` (or installed `bash_unit` in CI).
- Tests focus on unit behaviour with stubs and fakes for external systems.

### Specification tracking

- Test-spec mapping and untestable-case notes are maintained in [specifications.md](specifications.md).

### CI

- CI runs `ShellCheck` first, then each spec independently with timeout isolation.
