# Process Overview

This document describes the startup and maintenance work involved in this repository.

## Shell Startup Behaviour

### 1. Entry

Load sequence:

1. `BASHRC_PATH` is expected to point at this repository.
2. `enter.bash` is sourced first.
3. Hostname is detected (`scutil`, `hostnamectl`, then `hostname` as fallback).
4. If `BASHRC_TEST_MODE=1`, profile selection is forced to `test`.

### 2. Profiles

Profiles live in `profiles/*.bash_profile` and are selected by hostname substring in-order.

`profiles/none.bash_profile` is always sourced first as the baseline.

Profile function load order:

1. `profile_enter` after profile selection.
2. `profile_alias` after alias modules are sourced.
3. `profile_rc` after `.bashrc` modules are sourced.
4. `profile_exit` after `exit.bash` runs.

### 3. Alias and `.bashrc` module loading

The program sources every `modules/*.bash_aliases` file unless its full path appears in `BASHRC_IGNORE_MODULES`. Then it sources every `modules/*.bashrc` file. The program will skip over files listed in `BASHRC_IGNORE_MODULES`.

`shopt -s expand_aliases` is enabled between the alias and `.bashrc` phases.

## 4. Exit Behaviour

Exit sequence:

1. `exit.bash` is sourced.
   1. `cleanpath` is called.
   2. `cleanpath BASHRC_IGNORE_MODULES` normalises ignore-list paths.
2. `profile_exit` runs final profile customisations (commonly prompt colours and aliases).

## Testing and Specification

### Unit tests

- Test files live under `spec/` as `spec/test-*`.
- Tests are run with local `./bash_unit` (or installed `bash_unit` in CI).
- Tests use stubs and fakes for external systems.

### Specification tracking

Unit test specifications and untestable-case notes are maintained in [specifications.md](specifications.md).

### CI

CI runs `ShellCheck` first, then each unit test file independently with a 15-second timeout.
