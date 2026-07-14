# shellcheck shell=bash

# ===== CUSTOM COMMANDS - OSKAR ===== #

# OSKAR Generic command
function oskar-bash() {
    local exes=""
    local cflag=0
    local gflag=1
    local bflag=1
    local prog=""
    local ofile=""

    if [[ $1 == "--help" || $1 == "-h" ]]; then
        echo "=================================="
        echo "Run OSKAR with a custom generic bash command. By default it will run the first singularity image it"
        echo "finds in ~/.oskar. If there is no singularity image it will throw an error."
        echo "=================================="
        echo "Usage:"
        echo "oskar-bash ((-g|--global)|((-l|--local|-s|--sif) <program>)) (-i|--intif|-I|--img|-b|--beam)"
        echo "  (-f|--file) <ini_file> [(-c|--clean)]"
        echo "=================================="
        echo "Options:"
        echo "-g --global             (Default) Run OSKAR as an installed CLI applet"
        echo "-l --local              Run OSKAR from a specified binary directory"
        echo "-s --sif                If running singularity, what sif file to use"
        echo "-i --intif              Run OSKAR's interferometer simulation"
        echo "-I --img                Run OSKAR's dirty imager simulation"
        echo "-b --beam               Run OSKAR's beam simulation"
        echo "-f --file               Settings file to use"
        echo "-c --clean              Clean directory of OSKAR logs"
        echo "=================================="

        return 0
    fi

    echo "Running custom OSKAR bash command ..."
    
    while [ $# -gt 0 ]; do
        case $1 in
            -g | --global)
                gflag=1
            ;;
            -l | --local)
                exes=$(evalpath "$2/bin")
                gflag=0
                shift
            ;;
            -s | --sif)
                exes=$(evalpath "$2")
                bflag=0
                shift
            ;;
            -i | --intf)
                prog="oskar_sim_interferometer"
            ;;
            -b | --beam)
                prog="oskar_sim_beam_pattern"
            ;;
            -I | --image)
                prog="oskar_imager"
            ;;
            -f | --file)
                ofile=$(evalpath "$2")
                shift
            ;;
            -c | --clean)
                cflag=1
            ;;
            \?)
                echo "'$1' is not a valid option. Use --help or -h to see what options are available."
            ;;
        esac
        shift
    done
    
    # Check if files exist
    if [[ $bflag -eq 1 && $gflag -eq 1 ]] && ! type "$prog" > /dev/null; then
        printf '%s\n' "${ERROR_TEXT:-ERROR}: A CLI OSKAR applet/command on this system does not exist."
    elif [[ $bflag -eq 1 && $gflag -eq 0 ]] && ! type "$exes/$prog" > /dev/null; then
        printf '%s\n' "${ERROR_TEXT:-ERROR}: There is no $prog executable file in $exes or the directory does not exist."
    elif [[ $bflag -eq 0 && ! -f $exes ]]; then
        printf '%s\n' "${ERROR_TEXT:-ERROR}: There does not appear to be any OSKAR SIF files in the given directory."
    fi

    # Execute commands
    if [ $cflag -eq 1 ]; then
        find . -name '*.log' -type f -delete
    fi

    if [[ $bflag -eq 1 && $gflag -eq 1 ]]; then
        if [[ -n "$ofile" ]]; then
            "$prog" "$ofile"
        else
            "$prog"
        fi
    elif [[ $bflag -eq 1 && $gflag -eq 0 ]]; then
        if [[ -n "$ofile" ]]; then
            "$exes/$prog" "$ofile"
        else
            "$exes/$prog"
        fi
    else
        singularity exec --nv --bind "$PWD" --cleanenv --home "$PWD" "$exes" "$prog" "$ofile"
    fi

}