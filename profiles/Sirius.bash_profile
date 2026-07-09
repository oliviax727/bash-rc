profile_enter() { :; }

profile_alias() { :; }

profile_rc() { :; }

profile_exit() {
    # Fallback to trans colours
    terminal_colour --trans

    # If LM use aneco colours
    if  [[ "$(hostnamectl | grep -E -i 'Static hostname'  | awk '{print $NF}')" == "SiriusA" ]] || \
        [[ "$(hostnamectl | grep -E -i 'Operating System')" =~ .*"Linux Mint".* ]]
    then
        terminal_colour --aneco
    fi
}
