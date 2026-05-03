# Test command output
function test-cmd(){
    eval "$1" > /dev/null 2>&1 && return 0 || return 1
}

# Realpath tilde alias
function evalpath() {
    arguments=""
    for arg in "$@"; do
        if test-cmd "realpath -m $arg"; then
            arguments="$arguments:${arg/#~/${HOME}}"
        else
            arguments="$arguments:$arg"
        fi
    done

    IFS=':' read -r -a args_array <<< "$arguments"
    
    realpath ${args_array[@]}
}

# Setonix
alias setonix='ssh ohrw@setonix.pawsey.org.au'
export SETONIX='ohrw@setonix.pawsey.org.au'

# Java SDK
export JAVA_HOME=/usr/lib/jvm/java-16-openjdk-amd64

# Go Path
export GOPATH=${HOME}/go
export PATH="/usr/local/go/bin:${PATH}:${GOPATH}/bin"

# Casacore and boost paths
export PATH="${HOME}/casacore:${PATH}"
export PATH="${HOME}/olivia/boost_1_88_0:${PATH}"
export PATH="/root/.local/bin:${PATH}"

# OSKAR GUI Path
export OSKAR_INC_DIR="${HOME}/.oskar/OSKAR-2.12.2"
export OSKAR_LIB_DIR="${HOME}/.oskar/OSKAR-2.12.2"

# Pipx Path
export PATH="$PATH:${HOME}/.local/bin"

# GTK Path
export GTK_PATH=$GTK_PATH:/usr/lib/x86_64-linux-gnu/gtk-2.0/modules
export GTK_PATH=$GTK_PATH:/usr/lib/x86_64-linux-gnu/gtk-3.0/modules
export GTK_MODULES=libcanberra-gtk-moduleexport GOPATH=${HOME}/go
export PATH=/usr/local/go/bin:${PATH}:${GOPATH}/bin