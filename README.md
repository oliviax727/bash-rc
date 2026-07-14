# Bash-rc

A modular `Bash` setup with profile-aware startup, utility command packs, and reproducible setup and testing.

## Installation

### Standard user setup

1. Clone the repository:

```bash
git clone https://github.com/oliviax727/bash-rc.git
cd bash-rc
```

2. Run setup:

```bash
./setup.sh
```

3. Optional unstable install (same as choosing the unstable prompt option):

```bash
./setup.sh -y
```

### Root-assisted setup

If you want setup to run through `su`:

```bash
./setup_root.sh
```

## Module overview

### Alias modules (`modules/*.bash_aliases`)

| Module | Purpose |
| --- | --- |
| `modules/bash-doc.bash_aliases` | Classic convenience aliases and helper functions such as `setenv`, `repeat`, and `add-alias`. |
| `modules/custom.bash_aliases` | Custom workflow helpers including `diff-diode`, `cd-run`, and snap cleanup. |
| `modules/default.bash_aliases` | Interactive shell defaults (history, shell options, prompt/completion, and common aliases). |
| `modules/paths.bash_aliases` | Environment variable exports and `PATH`/bootstrap aliases (`Java`, `Go`, `OSKAR`, clipboard, and more). |

### `.bashrc` modules (`modules/*.bashrc`)

| Module | Purpose |
| --- | --- |
| `modules/admiral.bashrc` | Mount/`chroot` and file-copy helper commands for alternate Linux installs. |
| `modules/bash-rc.bashrc` | Core command surface for building, archiving, updating, publishing, and path management. |
| `modules/cpp_modules.bashrc` | `C++` initialise/build/run/debug shortcuts using `g++`/`gdb`. |
| `modules/git_helpers.bashrc` | `Git` automation helper (`git-propagate`) for branch propagation. |
| `modules/oskar.bashrc` | Wrapper for `OSKAR` local/global/singularity command execution. |
| `modules/path_manager.bashrc` | Path normalisation, prompt path rendering, terminal colour, and `PATH` deduplication helpers. |
| `modules/python.bashrc` | `Conda` initialisation block. |
| `modules/qssh.bashrc` | Named `SSH` host/path manager and quick connect/`scp` tooling. |

## CI overview

The GitHub Actions workflow in `.github/workflows/bash_unit.yml` does the following:

1. Check out the repository.
2. Install `ShellCheck`.
3. Lint tracked shell scripts with repository `ShellCheck` settings (`--norc --rcfile=.shellcheckrc --exclude=SC1091 -S info`).
4. Install and run `bash_unit` against each `spec/test-*` file individually.
5. Enforce a per-spec timeout (`15s`) and fail with explicit timeout or test-failure annotations.

## Documentation

All project documentation is in `documents/`:

- [Process overview](documents/process-overview.md)
- [Bash alias modules](documents/bash-aliases-modules.md)
- [Bash-rc modules](documents/bashrc-modules.md)
- [Bash-rc core module](documents/bash-rc-core-module.md)
- [Customisation guide](documents/customisation-guide.md)
- [Miscellaneous notes](documents/miscellaneous-notes.md)
- [Test specifications](documents/specifications.md)

## License

GNU GPLv3. See `LICENSE`.
