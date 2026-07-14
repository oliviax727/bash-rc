#!/usr/bin/env bash

# shellcheck disable=SC1091
source ../modules/admiral.bashrc

setup() {
    admiral help >/dev/null 2>&1
}

test_admiral_help_runs_without_error() {
    assert_status_code 0 "admiral help >/dev/null 2>&1"
}

test_admiral_unknown_command_fails() {
    assert_status_code 1 "admiral nope >/dev/null 2>&1"
}

test_admiral_normalize_dev_accepts_kernel_and_absolute_names() {
    local normalized_kernel
    normalized_kernel="$(admiral-normalize-dev sda1)"

    local normalized_absolute
    normalized_absolute="$(admiral-normalize-dev /dev/sda1)"

    assert_equals "/dev/sda1" "$normalized_kernel"
    assert_equals "/dev/sda1" "$normalized_absolute"
}

test_admiral_normalize_dev_rejects_invalid_names() {
    assert_status_code 1 "admiral-normalize-dev nope >/dev/null 2>&1"
}

test_admiral_resolve_mcp_path_maps_supported_prefixes() {
    local chroot_dir="/mnt/admiral"

    assert_equals "/mnt/admiral/etc/passwd" "$(admiral-resolve-mcp-path root:/etc/passwd "$chroot_dir")"
    assert_equals "/mnt/admiral/home/ohrf" "$(admiral-resolve-mcp-path target:/home/ohrf "$chroot_dir")"
    assert_equals "/mnt/admiral/var/log" "$(admiral-resolve-mcp-path sda:/var/log "$chroot_dir")"
    assert_equals "/home/ohrf" "$(admiral-resolve-mcp-path host:/home/ohrf "$chroot_dir")"
    assert_equals "/home/ohrf" "$(admiral-resolve-mcp-path sdb:/home/ohrf "$chroot_dir")"
    assert_equals "/tmp/file" "$(admiral-resolve-mcp-path /tmp/file "$chroot_dir")"
}

test_admiral_resolve_mcp_path_rejects_invalid_values() {
    assert_status_code 1 "admiral-resolve-mcp-path relative/path /mnt/admiral >/dev/null 2>&1"
}

test_admiral_boot_requires_a_root_partition() {
    assert_status_code 1 "admiral boot >/dev/null 2>&1"
}

test_admiral_boot_rejects_missing_root_value() {
    assert_status_code 1 "admiral boot -r >/dev/null 2>&1"
}

test_admiral_boot_rejects_unknown_options() {
    assert_status_code 1 "admiral boot --bogus >/dev/null 2>&1"
}

test_admiral_mcp_requires_a_root_partition() {
    assert_status_code 1 "admiral mcp >/dev/null 2>&1"
}

test_admiral_mcp_rejects_missing_root_value() {
    assert_status_code 1 "admiral mcp -r >/dev/null 2>&1"
}

test_admiral_mcp_rejects_too_few_path_arguments() {
    assert_status_code 1 "admiral mcp -r sda1 /tmp/source >/dev/null 2>&1"
}

test_admiral_mount_target_rejects_unsafe_targets() {
    assert_status_code 1 "admiral-mount-target /dev/sda1 /dev/sda2 /tmp 0 >/dev/null 2>&1"
}

test_admiral_unmount_target_rejects_unsafe_targets() {
    assert_status_code 1 "admiral-unmount-target /tmp 0 0 0 0 >/dev/null 2>&1"
}