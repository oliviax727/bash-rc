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

# Pipx Path
export PATH="$PATH:${HOME}/.local/bin"

# Pylint Path
export PYLINT_VENV_PATH=.venv:.virtualenv
export PYTHONPATH=/usr/bin/python3:$PWD/.venv/bin/python3

# Clipboard
alias "cc=xclip -selection clipboard"