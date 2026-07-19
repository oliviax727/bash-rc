# Miscellaneous Notes

This document notes any other stuff that does not belong to a single module reference.

## Setup behaviour

### `setup.sh`

- Sets `BASHRC_PATH` to repository directory.
- Ensures `archive_<user>/` exists.
- Sources minimal dependencies (`enter.bash`, `modules/custom.bash_aliases`, `modules/path_manager.bashrc`, `modules/bash-rc.bashrc`).
- Runs `bash-rc build -f` by default, or pulls the most recent branch if told to.
- If shell is interactive, resets and sources resulting `~/.bashrc`.

### `setup_root.sh`

- Invokes `setup.sh` through `su` from repository directory.
- Passes through the optional argument to preserve setup mode selection.

## Archiving

- Archive location: `archive_*/`.
- Archive file naming format uses `filename-date`, e.g. `archive-YYYY-MM-DD-HHMM-TZ.bashrc`.
- A temporary file is generated in the repository: `ready.bashrc`.
- Final installation target: `${HOME}/.bashrc`.

## Linting

Current linting behaviour is designed to be universally deterministic:

- Command form: `shellcheck --norc --rcfile=.shellcheckrc --exclude=SC1091 -S info ...`
- Config file: `.shellcheckrc`
- VS Code `args`: `.vscode/settings.json`
- CI command source: `.github/workflows/bash_unit.yml`

## Testing Conventions

- Keep tests unit-level with stubs/fakes for network/system-level commands.
- Prefer deterministic, local file-system behaviour in temporary directories.
- Reserve real mounts/`chroot`/`SSH`/`scp`/`git`-network actions for integration contexts.
