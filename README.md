# Bash-rc

A bash project that contains helper modules to use in your terminal.

## Installation

### Required Software

Note that the project is designed to work with both GNU/Linux, BSD, and macOS environments. Some basic software is required to be able to use this repository to the fullest extent.

Required:
- `bash`
- `GNU sed` (as the system's `sed` default)
- `git`

Recommended:
- `sudo`
- `openssh`
- `xclip`
- `g++`/`gdb`
- `jupyter`
- `anaconda`
- `python3`

Esoteric:
- `tomcat`
- `pyenv`
- `snap`

Development:
- `shellcheck`
- `bash_unit`

Esoteric modules are usually present for my own end-user purposes and don't need to be installed. There are likely more modules that need to be installed depending on the specifics of the operating system.

### Setup

Clone the repository:

```bash
git clone https://github.com/oliviax727/bash-rc.git
cd bash-rc
```

Run the setup file:

```bash
./setup.sh
```

### Setup (Unstable)

You can optionally install the unstable version (most recent):

```bash
./setup.sh -y
```

Or by entering 'y' when prompted.

### Setup (root user)

To set up the repository for the root user:

```bash
./setup_root.sh
```

## Module overview

### Alias modules (`modules/*.bash_aliases`)

| Module | Purpose |
| --- | --- |
| `modules/bash-doc.bash_aliases` | Copied helper functions from `bash-doc`: `setenv`, `repeat`, and `add-alias`. |
| `modules/custom.bash_aliases` | Custom additional functions like `diff-diode`, `cd-run`, and snap cleanup. |
| `modules/default.bash_aliases` | The default shell configuration when `bash` is first installed. |
| `modules/paths.bash_aliases` | Environment variable exports and `PATH` aliases (`Java`, `Go`, `pylint`, clipboard, and more). |

### Bash-rc modules (`modules/*.bashrc`)

| Module | Purpose |
| --- | --- |
| `modules/admiral.bashrc` | Mount/`chroot` and file-copy into adjacent local Linux installs. |
| `modules/bash-rc.bashrc` | Primary modules for modifying and updating this project repository. |
| `modules/cpp_modules.bashrc` | `C++` shortcuts using `g++`/`gdb`. |
| `modules/git_helpers.bashrc` | `Git` helper functions like `git-propagate` for branch propagation. |
| `modules/path_manager.bashrc` | Modifying and managing path environment variables, terminal prompts, and path strings. |
| `modules/python.bashrc` | Any and all things Python. |
| `modules/qssh.bashrc` | An SSH host/path manager to make connecting to hosts easier. |

## CI overview

The GitHub Actions workflow in `.github/workflows/bash_unit.yml` does the following:

1. Check out the repository.
2. Install `ShellCheck`.
3. Lint the project with `shellcheck`.
4. Install and run `bash_unit` against each `spec/test-*` file individually.

The CI enforces a per-test timeout of 15 seconds, to ensure all modules are responsive.

## Documentation

All project documentation is in `documents/`:

- [Process overview](documents/process-overview.md)
- [Bash alias modules](documents/bash-aliases-modules.md)
- [Bash-rc modules](documents/bashrc-modules.md)
- [Bash-rc core module](documents/bash-rc-core-module.md)
- [Customisation guide](documents/customisation-guide.md)
- [Miscellaneous notes](documents/miscellaneous-notes.md)
- [Test specifications](documents/specifications.md)
