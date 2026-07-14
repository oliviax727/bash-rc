# Customisation Guide

This guide covers how to modify, customise, and personalise this repository without breaking the expected workflow.

## Add Your Own Modules

You can add two module types:

- alias modules in `modules/*.bash_aliases`
- `.bashrc` modules in `modules/*.bashrc`

Recommended workflow:

1. Choose a clear module name.
2. Create the file in `modules/`.
3. Keep function names explicit and stable.
4. Source only what you need.
5. Keep external side effects minimal.

Example file names:

- `modules/my-tools.bash_aliases`
- `modules/my-runtime.bashrc`

Notes:

- Modules are autoloaded by `base.bash`.
- If needed, skip a module temporarily by adding its full path to `BASHRC_IGNORE_MODULES`.

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

## Test and Publish Custom Behaviour Using `test/`

Use `test/` as your staging area for behaviour you want to promote.

Staging files:

- `test/test_alias.bash_aliases`
- `test/test_rc.bashrc`
- `test/test_enter.bash`
- `test/test_exit.bash`
- `test/test_profile.bash_profile`

Publish staged behaviour with `bash-rc`:

```bash
bash-rc publish alias my_module
bash-rc publish rc my_module
bash-rc publish enter
bash-rc publish exit
bash-rc publish profile my_profile
```

After publishing:

1. Re-run the affected specs.
2. Update [specifications.md](specifications.md) if behaviour changed.
3. Re-run `ShellCheck`.

## Customisable Profiles

Profiles live in `profiles/*.bash_profile` and are selected by hostname matching.

A profile can define these hooks:

- `profile_enter`
- `profile_alias`
- `profile_rc`
- `profile_exit`

Practical profile customisation ideas:

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
