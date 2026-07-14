# Bash Alias Modules

This document covers all `modules/*.bash_aliases` files and every function defined in those files.

## Module Summary

| Module | Role |
| --- | --- |
| `modules/bash-doc.bash_aliases` | Common shell convenience aliases and compatibility helper functions. |
| `modules/custom.bash_aliases` | Project-specific aliases and small utility functions. |
| `modules/default.bash_aliases` | Interactive shell defaults adapted from common distro `.bashrc` patterns. |
| `modules/paths.bash_aliases` | Environment variable and `PATH` bootstrapping aliases and exports. |

## Function Inventory

| Module | Function | Description |
| --- | --- | --- |
| `modules/bash-doc.bash_aliases` | `setenv` | Exports a variable in `name=value` form. |
| `modules/bash-doc.bash_aliases` | `add-alias` | Adds an alias both to current shell and `~/.bash_aliases`. |
| `modules/bash-doc.bash_aliases` | `repeat` | Runs a command the requested number of times. |
| `modules/bash-doc.bash_aliases` | `_seq` | Internal integer sequence helper used by `repeat`. |
| `modules/custom.bash_aliases` | `diff-diode` | Prints lines present only in the left input file (one-way diff). |
| `modules/custom.bash_aliases` | `cd-run` | Temporarily changes directory, runs a command, then restores the previous directory. |
| `modules/custom.bash_aliases` | `clean-snaps` | Removes disabled snap revisions parsed from `snap list --all`. |
| `modules/default.bash_aliases` | Not applicable | No shell functions are defined; this module is alias/options/config only. |
| `modules/paths.bash_aliases` | Not applicable | No shell functions are defined; this module is env/path/alias exports only. |

## Notes

- `modules/default.bash_aliases` exits early for non-interactive shells.
- Multiple aliases with overlapping names can be overridden by load order in `base.bash`.
