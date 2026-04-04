# Setonix
alias setonix='ssh ohrw@setonix.pawsey.org.au'
export SETONIX='ohrw@setonix.pawsey.org.au'

# Java SDK
export JAVA_HOME=/usr/lib/jvm/java-16-openjdk-amd64

# Go Path
export GOPATH=${HOME}/go
export PATH=/usr/local/go/bin:${PATH}:${GOPATH}/bin

# Casacore and boost paths
export PATH=/home/olivia/casacore:${PATH}
export PATH=/home/olivia/boost_1_88_0:${PATH}
export PATH=/root/.local/bin:${PATH}

# OSKAR GUI Path
export OSKAR_INC_DIR=/home/olivia/.oskar/OSKAR-2.11.1
export OSKAR_LIB_DIR=/home/olivia/.oskar/OSKAR-2.11.1

# Pipx Path
export PATH="$PATH:/home/olivia/.local/bin"

# GTK Path
export GTK_PATH=$GTK_PATH:/usr/lib/x86_64-linux-gnu/gtk-2.0/modules
export GTK_PATH=$GTK_PATH:/usr/lib/x86_64-linux-gnu/gtk-3.0/modules
export GTK_MODULES=libcanberra-gtk-moduleexport GOPATH=${HOME}/go
export PATH=/usr/local/go/bin:${PATH}:${GOPATH}/bin