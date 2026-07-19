# Customisation Guide

This guide covers how to modify, customise, and personalise this repository.

## Add Your Own Modules

You can add two module types:

- Alias modules are found in `modules/*.bash_aliases`
- `.bashrc` modules are found in `modules/*.bashrc`

It is recommended that you first add your code to the files in the `test` directory and publish them using `bash-rc publish`.

## Customise Existing Modules Safely

When editing an existing module:

1. Make small changes.
2. Keep command names and function entry points compatible where practical.
3. Update or add tests in `spec/test-*` for changed behaviour.
4. Run tests before committing.

Quick local checks:

```bash
for s in spec/test-*; do ./bash_unit "$s" || exit 1; done
shellcheck --norc --rcfile=.shellcheckrc --exclude=SC1091 -S info $(git ls-files '*.sh' '*.bash' '*.bashrc' '*.bash_aliases' '*.bash_profile' 'bash_unit')
```

If a change cannot be unit-tested (for example, network, mount, or `chroot` behaviour), document it in [specifications.md](specifications.md).

After publishing:

1. Re-run the affected specs.
2. Update [specifications.md](specifications.md) if behaviour changed.
3. Re-run `ShellCheck`.

## Customisable Profiles

Files associated with different profiles are found in `profiles/*.bash_profile` and are selected by looking at a computer's hostname.

A profile must contain these four functions:

- `profile_enter`
- `profile_alias`
- `profile_rc`
- `profile_exit`

Some common profile-specific actions:

- set prompt style in `profile_exit`
- set `QUICK_JUMP_VARS` in `profile_enter`
- append ignored modules to `BASHRC_IGNORE_MODULES`
- add host-specific aliases or paths

Profile safety tips:

1. Keep host-specific assumptions inside profile files.
2. Prefer environment variables over hardcoded logic in shared modules.
3. Keep fallback behaviour valid through `profiles/none.bash_profile`.

## Final Checklist

Before you push custom changes:

1. Specs pass for affected modules.
2. `ShellCheck` is clean under project flags.
3. Any integration-only behaviour is noted in [specifications.md](specifications.md).
4. Documentation is updated if command or profile behaviour changed.
