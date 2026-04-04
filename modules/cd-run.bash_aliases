# ===== ICD-RUN FUNCTION ===== #

function cd-run() {
    pwd_save=$PWD

    cd $1

    exec $2

    cd $pwd_save
}