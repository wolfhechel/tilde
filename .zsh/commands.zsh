# Convenience for work
sql () mysql -u$1 -p$1 $1

# Remote execution
remote () ssh $1 -C "${@:2}"

mkpasswd()
{
    openssl rand -base64 ${1:-8}
}

diemf()
{
    local search_proc=$1
    kill -9 $(ps aux | grep "${search_proc}" | grep -v grep | awk '{print $2}')
}

aur()
{
    (
        cd $HOME/.local/packages

        if [ ! -d "${1}" ]; then
            git clone "https://aur.archlinux.org/${1}.git"
            cd "${1}"
        else
            cd "${1}"
            git pull
        fi

        makepkg -ic
    )
}
