# ===== CUSTOM COMMANDS - GCC COMPILER ===== #

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Run C++ file with g++
export CPPSTARTSTRING='#include <iostream>\n\nint main()\n{\n\tstd::cout << "Hello World" << std::endl;\n\treturn 0;\n}\n'

# Initialise C++ file
function init-cpp() {
    local FNAME=$1

    if [[ $1 == "" ]]; then
        FNAME="main"
    fi

    if [[ ! -f "$FNAME.cpp" ]]; then
        touch "$FNAME.cpp"
        echo -e $CPPSTARTSTRING >> "$FNAME.cpp"
        g++ -o "$FNAME.out" "$FNAME.cpp"
        g++ -o "$FNAME.gdb.out" -g "$FNAME.cpp"
    else
        echo "Initialisation failed: file already exists"
    fi

}

# Run C++ file
function run-cpp() {
    g++ -o "$1.out" "$1.cpp"
    ./"$1.out"
}

# Debug C++ file
function debug-cpp() {
    g++ -o "$1.gdb.out" -g "$1.cpp"
    gdb ./"$1.gdb.out"
}