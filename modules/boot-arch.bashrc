# ===== CUSTOM COMMANDS - BOOT INTO ARCH ===== #

function boot-arch() {
    local ROOT_DEV="/dev/sda3"
    local EFI_DEV="/dev/sda2"
    local CHROOT_DIR="/mnt/arch"
    local ARCH_USER="mint"
    local mounted_root=0
    local mounted_efi=0
    local p
    
    cleanup_arch() {
        local rc=$?
        set +e

        for p in run sys proc dev; do
            mountpoint -q "$CHROOT_DIR/$p" && sudo umount -R "$CHROOT_DIR/$p"
        done
        
        if [[ $mounted_efi -eq 1 ]]; then
            sudo umount "$CHROOT_DIR/boot/efi"
        fi
        
        if [[ $mounted_root -eq 1 ]]; then
            sudo umount "$CHROOT_DIR"
        fi
        
        trap - EXIT INT TERM
        return "$rc"
    }
    
    sudo -v || return 1
    sudo mkdir -p "$CHROOT_DIR"
    trap cleanup_arch EXIT INT TERM
    
    if ! mountpoint -q "$CHROOT_DIR"; then
        sudo mount "$ROOT_DEV" "$CHROOT_DIR" || return 1
        mounted_root=1
    fi
    
    if [[ -b "$EFI_DEV" ]] && [[ -d "$CHROOT_DIR/boot/efi" ]] && ! mountpoint -q "$CHROOT_DIR/boot/efi"; then
        sudo mount "$EFI_DEV" "$CHROOT_DIR/boot/efi" && mounted_efi=1
    fi
    
    for p in dev proc sys run; do
        sudo mkdir -p "$CHROOT_DIR/$p"
        mountpoint -q "$CHROOT_DIR/$p" || sudo mount --rbind "/$p" "$CHROOT_DIR/$p" || return 1
    done
    
    if sudo chroot "$CHROOT_DIR" id -u "$ARCH_USER" >/dev/null 2>&1; then
        # Avoid login-shell profile tty noise by using non-login su,
        # and enter from the user's home directory.
        sudo chroot "$CHROOT_DIR" /bin/bash -c 'user="$1"; home="$(getent passwd "$user" | cut -d: -f6)"; [ -n "$home" ] || home="/home/$user"; cd "$home" || cd /; exec /bin/su "$user"' _ "$ARCH_USER"
    else
        echo "User '$ARCH_USER' not found in Arch; opening root shell in chroot."
        sudo chroot "$CHROOT_DIR" /bin/bash
    fi
}

function mcp() {
    local ARCH_CHROOT_DIR="/mnt/arch"
    local ARCH_ROOT_DEV="/dev/sda3"
    local opts=()
    local src_raw
    local dst_raw
    local src
    local dst
    local need_arch_mount=0

    mcp_resolve_path() {
        local raw="$1"

        case "$raw" in
            sda:*)
                printf "%s" "${ARCH_CHROOT_DIR}${raw#sda:}"
            ;;
            sdb:*)
                printf "%s" "${raw#sdb:}"
            ;;
            *)
                return 1
            ;;
        esac
    }

    if [[ $# -lt 2 ]]; then
        echo "Usage: mcp [cp_flags...] sda:/source/path sdb:/destination/path"
        echo "   or: mcp [cp_flags...] sdb:/source/path sda:/destination/path"
        return 1
    fi

    src_raw="${@: -2:1}"
    dst_raw="${@: -1}"

    if [[ "$src_raw" == sda:* ]] || [[ "$dst_raw" == sda:* ]]; then
        need_arch_mount=1
    fi

    if [[ $# -gt 2 ]]; then
        opts=("${@:1:$#-2}")
    fi

    src="$(mcp_resolve_path "$src_raw")" || {
        echo "mcp: invalid source '$src_raw' (expected sda:... or sdb:...)"
        return 1
    }

    dst="$(mcp_resolve_path "$dst_raw")" || {
        echo "mcp: invalid destination '$dst_raw' (expected sda:... or sdb:...)"
        return 1
    }

    if [[ $need_arch_mount -eq 1 ]] && ! mountpoint -q "$ARCH_CHROOT_DIR"; then
        sudo mkdir -p "$ARCH_CHROOT_DIR" || return 1
        sudo mount "$ARCH_ROOT_DEV" "$ARCH_CHROOT_DIR" || return 1
    fi

    sudo cp "${opts[@]}" -- "$src" "$dst"
}