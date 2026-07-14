# shellcheck shell=bash disable=SC2329

# ===== CUSTOM COMMANDS - BOOT INTO OTHER OS ===== #

function admiral() {
    local ADMIRAL_MOUNTED_ROOT=0
    local ADMIRAL_MOUNTED_EFI=0
    local ADMIRAL_MOUNTED_HOME=0

    admiral-normalize-dev() {
        local dev="$1"
        if [[ "$dev" =~ ^/dev/sd[a-z][0-9]+$ ]]; then
            printf "%s" "$dev"
            return 0
        fi

        if [[ "$dev" =~ ^sd[a-z][0-9]+$ ]]; then
            printf "%s" "/dev/$dev"
            return 0
        fi

        return 1
    }

    admiral-mount-target() {
        local root_dev="$1"
        local efi_dev="$2"
        local chroot_dir="$3"
        local bind_runtime="$4"
        local current_source=""
        local current_fstype=""
        local current_options=""
        local root_subvol=""
        local home_subvol=""
        local p

        ADMIRAL_MOUNTED_ROOT=0
        ADMIRAL_MOUNTED_EFI=0
        ADMIRAL_MOUNTED_HOME=0

        if [[ -z "$chroot_dir" ]] || [[ "$chroot_dir" == "/" ]] || [[ "$chroot_dir" != /mnt/* ]]; then
            echo "admiral: refusing unsafe mount target '$chroot_dir'"
            return 1
        fi

        sudo -v || return 1
        sudo mkdir -p "$chroot_dir" || return 1

        if mountpoint -q "$chroot_dir"; then
            current_source="$(findmnt -n -o SOURCE --target "$chroot_dir" 2>/dev/null)"
            if [[ "$current_source" != "$root_dev" ]]; then
                if [[ "$bind_runtime" -eq 1 ]]; then
                    for p in run sys proc dev; do
                        mountpoint -q "$chroot_dir/$p" && sudo umount -R -l "$chroot_dir/$p"
                    done
                fi
                sudo umount -R -l "$chroot_dir" || return 1
            fi
        fi

        if ! mountpoint -q "$chroot_dir"; then
            sudo mount "$root_dev" "$chroot_dir" || return 1
            ADMIRAL_MOUNTED_ROOT=1
        fi

        current_fstype="$(findmnt -n -o FSTYPE --target "$chroot_dir" 2>/dev/null)"
        current_options="$(findmnt -n -o OPTIONS --target "$chroot_dir" 2>/dev/null)"

        # For btrfs installs, users often mount the top-level tree (subvolid=5)
        # by device. If '@' exists, remount into that root subvolume automatically.
        if [[ "$current_fstype" == "btrfs" ]] && \
           [[ "$current_options" == *"subvolid=5"* || "$current_options" == *"subvol=/"* ]] && \
           sudo test -d "$chroot_dir/@"; then
            sudo umount -R -l "$chroot_dir" || return 1
            sudo mount -o subvol=@ "$root_dev" "$chroot_dir" || return 1
            ADMIRAL_MOUNTED_ROOT=1
            current_options="$(findmnt -n -o OPTIONS --target "$chroot_dir" 2>/dev/null)"
        fi

        # If fstab specifies explicit btrfs subvolumes, honor them for / and /home.
        if [[ "$current_fstype" == "btrfs" ]] && sudo test -r "$chroot_dir/etc/fstab"; then
            root_subvol="$(sudo awk '$2=="/" {print $4}' "$chroot_dir/etc/fstab" 2>/dev/null | tr ',' '\n' | sed -n 's/^subvol=//p' | head -n 1)"

            if [[ -n "$root_subvol" ]] && [[ "$current_options" != *"subvol=$root_subvol"* ]]; then
                sudo umount -R -l "$chroot_dir" || return 1
                sudo mount -o "subvol=$root_subvol" "$root_dev" "$chroot_dir" || return 1
                ADMIRAL_MOUNTED_ROOT=1
            fi

            home_subvol="$(sudo awk '$2=="/home" {print $4}' "$chroot_dir/etc/fstab" 2>/dev/null | tr ',' '\n' | sed -n 's/^subvol=//p' | head -n 1)"

            if [[ -n "$home_subvol" ]]; then
                sudo mkdir -p "$chroot_dir/home" || return 1
                if ! mountpoint -q "$chroot_dir/home"; then
                    sudo mount -o "subvol=$home_subvol" "$root_dev" "$chroot_dir/home" || return 1
                    ADMIRAL_MOUNTED_HOME=1
                fi
            fi
        fi

        if [[ -n "$efi_dev" ]] && [[ -d "$chroot_dir/boot/efi" ]] && ! mountpoint -q "$chroot_dir/boot/efi"; then
            sudo mount "$efi_dev" "$chroot_dir/boot/efi" || return 1
            ADMIRAL_MOUNTED_EFI=1
        fi

        if [[ "$bind_runtime" -eq 1 ]]; then
            for p in dev proc sys run; do
                sudo mkdir -p "$chroot_dir/$p"
                if ! mountpoint -q "$chroot_dir/$p"; then
                    sudo mount --rbind "/$p" "$chroot_dir/$p" || return 1
                fi
                sudo mount --make-rslave "$chroot_dir/$p" || return 1
            done
        fi
    }

    admiral-unmount-target() {
        local chroot_dir="$1"
        local mounted_root="$2"
        local mounted_efi="$3"
        local mounted_home="$4"
        local bind_runtime="$5"
        local p

        if [[ -z "$chroot_dir" ]] || [[ "$chroot_dir" == "/" ]] || [[ "$chroot_dir" != /mnt/* ]]; then
            echo "admiral: refusing unsafe unmount target '$chroot_dir'"
            return 1
        fi

        if [[ "$bind_runtime" -eq 1 ]]; then
            for p in run sys proc dev; do
                mountpoint -q "$chroot_dir/$p" && sudo -n umount -R -l "$chroot_dir/$p" 2>/dev/null || true
            done
        fi

        if [[ "$mounted_home" -eq 1 ]]; then
            sudo -n umount -l "$chroot_dir/home" 2>/dev/null || true
        fi

        if [[ "$mounted_efi" -eq 1 ]]; then
            sudo -n umount -l "$chroot_dir/boot/efi" 2>/dev/null || true
        fi

        if [[ "$mounted_root" -eq 1 ]]; then
            sudo -n umount -l "$chroot_dir" 2>/dev/null || true
        fi
    }

    admiral-resolve-mcp-path() {
        local raw="$1"
        local chroot_dir="$2"

        case "$raw" in
            root:*|target:*|sda:*)
                printf "%s" "${chroot_dir}${raw#*:}"
            ;;
            host:*|sdb:*)
                printf "%s" "${raw#*:}"
            ;;
            /*)
                printf "%s" "$raw"
            ;;
            *)
                return 1
            ;;
        esac
    }

    function admiral-boot() {
        local ROOT_DEV=""
        local EFI_DEV=""
        local CHROOT_DIR="/mnt/admiral"
        local TARGET_USER="admiral"
        local mounted_root=0
        local mounted_efi=0
        local mounted_home=0
        local cmd_rc=0
        
        cleanup_admiral() {
            set +e
            admiral-unmount-target "$CHROOT_DIR" "$mounted_root" "$mounted_efi" "$mounted_home" 1
        }
        
        while [[ $# -gt 0 ]]; do
            case "$1" in
                -r|--root)
                    [[ -n "$2" ]] || {
                        echo "admiral: option '$1' requires a value"
                        admiral-help
                        return 1
                    }
                    ROOT_DEV="$(admiral-normalize-dev "$2")" || {
                        echo "admiral: invalid root partition '$2'"
                        admiral-help
                        return 1
                    }
                    shift 2
                ;;
                -e|--efi)
                    [[ -n "$2" ]] || {
                        echo "admiral: option '$1' requires a value"
                        admiral-help
                        return 1
                    }
                    EFI_DEV="$(admiral-normalize-dev "$2")" || {
                        echo "admiral: invalid EFI partition '$2'"
                        admiral-help
                        return 1
                    }
                    shift 2
                ;;
                --)
                    shift
                    break
                ;;
                -*)
                    echo "admiral: unknown option '$1'"
                    admiral-help
                    return 1
                ;;
                *)
                    echo "admiral: unexpected argument '$1'"
                    admiral-help
                    return 1
                ;;
            esac
        done
        
        if [[ $# -gt 0 ]]; then
            echo "admiral: unexpected argument '$1'"
            admiral-help
            return 1
        fi
        
        if [[ -z "$ROOT_DEV" ]]; then
            echo "admiral: missing required root partition (-r|--root)"
            admiral-help
            return 1
        fi
        
        if [[ ! -b "$ROOT_DEV" ]]; then
            echo "admiral: root device '$ROOT_DEV' does not exist"
            return 1
        fi
        
        if [[ -n "$EFI_DEV" ]] && [[ ! -b "$EFI_DEV" ]]; then
            echo "admiral: EFI device '$EFI_DEV' does not exist"
            return 1
        fi

        admiral-mount-target "$ROOT_DEV" "$EFI_DEV" "$CHROOT_DIR" 1 || return 1
        mounted_root="$ADMIRAL_MOUNTED_ROOT"
        mounted_efi="$ADMIRAL_MOUNTED_EFI"
        mounted_home="$ADMIRAL_MOUNTED_HOME"
        
        if sudo chroot "$CHROOT_DIR" id -u "$TARGET_USER" >/dev/null 2>&1; then
            sudo chroot "$CHROOT_DIR" /bin/bash -c 'user="$1"; home="$(getent passwd "$user" | cut -d: -f6)"; [ -n "$home" ] || home="/home/$user"; cd "$home" || cd /; exec /bin/su "$user"' _ "$TARGET_USER"
            cmd_rc=$?
        else
            echo "User '$TARGET_USER' not found on target OS; opening root shell in chroot."
            sudo chroot "$CHROOT_DIR" /bin/bash
            cmd_rc=$?
        fi

        cleanup_admiral
        return "$cmd_rc"
    }
    
    function admiral-mcp() {
        local ROOT_DEV=""
        local EFI_DEV=""
        local CHROOT_DIR="/mnt/admiral"
        local mounted_root=0
        local mounted_efi=0
        local mounted_home=0
        local src_raw=""
        local dst_raw=""
        local src=""
        local dst=""
        local cp_opts=()
        local path_args=()
        local cmd_rc=0

        cleanup_admiral_mcp() {
            set +e

            admiral-unmount-target "$CHROOT_DIR" "$mounted_root" "$mounted_efi" "$mounted_home" 0
        }

        while [[ $# -gt 0 ]]; do
            case "$1" in
                -r|--root)
                    [[ -n "$2" ]] || {
                        echo "admiral mcp: option '$1' requires a value"
                        admiral-help
                        return 1
                    }
                    ROOT_DEV="$(admiral-normalize-dev "$2")" || {
                        echo "admiral mcp: invalid root partition '$2'"
                        admiral-help
                        return 1
                    }
                    shift 2
                ;;
                -e|--efi)
                    [[ -n "$2" ]] || {
                        echo "admiral mcp: option '$1' requires a value"
                        admiral-help
                        return 1
                    }
                    EFI_DEV="$(admiral-normalize-dev "$2")" || {
                        echo "admiral mcp: invalid EFI partition '$2'"
                        admiral-help
                        return 1
                    }
                    shift 2
                ;;
                -o|-m|--mcp-options)
                    shift
                    cp_opts=("$@")
                    break
                ;;
                --)
                    shift
                    while [[ $# -gt 0 ]]; do
                        path_args+=("$1")
                        shift
                    done
                ;;
                -*)
                    echo "admiral mcp: cp options must appear only after -o|-m|--mcp-options"
                    admiral-help
                    return 1
                ;;
                *)
                    path_args+=("$1")
                    shift
                ;;
            esac
        done

        if [[ -z "$ROOT_DEV" ]]; then
            echo "admiral mcp: missing required root partition (-r|--root)"
            admiral-help
            return 1
        fi

        if [[ ${#path_args[@]} -ne 2 ]]; then
            echo "admiral mcp: expected source and destination paths"
            admiral-help
            return 1
        fi

        if [[ ! -b "$ROOT_DEV" ]]; then
            echo "admiral mcp: root device '$ROOT_DEV' does not exist"
            return 1
        fi

        if [[ -n "$EFI_DEV" ]] && [[ ! -b "$EFI_DEV" ]]; then
            echo "admiral mcp: EFI device '$EFI_DEV' does not exist"
            return 1
        fi

        src_raw="${path_args[0]}"
        dst_raw="${path_args[1]}"

        src="$(admiral-resolve-mcp-path "$src_raw" "$CHROOT_DIR")" || {
            echo "admiral mcp: invalid source '$src_raw'"
            echo "Use root:/..., target:/..., sda:/..., host:/..., sdb:/..., or absolute /path"
            return 1
        }

        dst="$(admiral-resolve-mcp-path "$dst_raw" "$CHROOT_DIR")" || {
            echo "admiral mcp: invalid destination '$dst_raw'"
            echo "Use root:/..., target:/..., sda:/..., host:/..., sdb:/..., or absolute /path"
            return 1
        }

        admiral-mount-target "$ROOT_DEV" "$EFI_DEV" "$CHROOT_DIR" 0 || return 1
        mounted_root="$ADMIRAL_MOUNTED_ROOT"
        mounted_efi="$ADMIRAL_MOUNTED_EFI"
        mounted_home="$ADMIRAL_MOUNTED_HOME"

        sudo cp "${cp_opts[@]}" -- "$src" "$dst"
        cmd_rc=$?

        cleanup_admiral_mcp
        return "$cmd_rc"
    }
    
    # Help
    function admiral-help() {
        echo "=================================="
        echo "Connect to a mountable operating system located on a connected disk."
        echo "=================================="
        echo "Usage:"
        echo "admiral boot (-r|--root) sdXn [(-e|--efi) sdXm]"
        echo " "
        echo "admiral mcp (-r|--root) sdXn [(-e|--efi) sdXm] (-o|--mcp-options)"
        echo " "
        echo "=================================="
        echo "Commands:"
        echo "boot                   Boot into an operating system's admiral acocunt"
        echo "mcp                    Copy files between mounts"
        echo "help                   Access the Help menu"
        echo "=================================="
        echo "Options:"
        echo "-o -m --mcp-options   Provide all cp options after this flag. NB: MUST OCCUR AT END"
        echo "-r --root             Root partition (required), e.g. sda3"
        echo "-e --efi              EFI partition (optional), e.g. sda2"
        echo "=================================="
        echo "Notes:"
        echo "Hyphenating the first argument instead of using space (e.g. admiral-boot instead of admiral boot)"
        echo "will also call the desired function."
        echo "Target OS must contain a user named 'admiral'."
        echo "=================================="
    }
    
    # Execute command
    local sel_cmd=$1
    shift
    
    local error_text="${ERROR_TEXT:-ERROR}: Command doesn't exist. Use \`admiral help\` or \`admiral-help\` to see what commands exist"
    
    if [ "$(type -t "admiral-$sel_cmd")" == "function" ]; then
        eval '"admiral-$sel_cmd" $@'
    else
        echo -e "$error_text"
        return 1
    fi
}