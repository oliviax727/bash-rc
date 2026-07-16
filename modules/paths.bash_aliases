# shellcheck shell=bash

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

export GOPATH=${HOME}/go
export PATH="/usr/local/go/bin:${PATH}:${GOPATH}/bin"

# Pylint Path
export PYLINT_VENV_PATH=.venv:.virtualenv
export PYTHONPATH=/usr/bin/python3:$PWD/.venv/bin/python3

# Clipboard
alias "cc=xclip -selection clipboard"