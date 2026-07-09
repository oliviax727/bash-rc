profile_enter() { :; }

profile_alias() { :; }

profile_rc() { :; }

profile_exit() {
    # Fallback to trans colours
    terminal_colour --trans

    local static_hostname=""
    local os_name=""

    if command -v hostnamectl >/dev/null 2>&1 && [[ -d /run/systemd/system ]]; then
        static_hostname="$(hostnamectl --static 2>/dev/null)"
        os_name="$(hostnamectl --operating-system 2>/dev/null)"
    fi

    if [[ -z "$static_hostname" ]] && command -v hostname >/dev/null 2>&1; then
        static_hostname="$(hostname 2>/dev/null)"
    fi

    if [[ -z "$os_name" ]] && [[ -r /etc/os-release ]]; then
        os_name="$(grep -E '^PRETTY_NAME=' /etc/os-release | head -n 1 | cut -d= -f2- | tr -d '"')"
    fi

    # If LM use aneco colours
    if  [[ "$static_hostname" == "SiriusB" ]] || \
        [[ "$os_name" =~ .*"Linux Mint".* ]]
    then
        terminal_colour --aneco
    fi

    alias boot-arch='admiral boot -r sda2 -e sda1'
    alias boot-mint='admiral boot -r sdb3 -e sdb2'
}
