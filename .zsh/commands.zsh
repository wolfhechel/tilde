# Convenience for work
sql () mysql -u$1 -p$1 $1

# Remote execution
remote () ssh $1 -C "${@:2}"

# AUR helper function
aur()
{
    wget -qO- http://aur.archlinux.org/packages/$1/$1.tar.gz | tar zxf - -C .
}

mkpasswd()
{
    openssl rand -base64 ${1:-8}
}

