# Git abbreviations
alias checkout="git checkout"
alias rebase="git rebase"
alias merge="git merge"
alias pull="git pull"
alias push="git push"

# Sprunge alias
alias sprunge="curl --url sprunge.us -F sprunge=@"

# Convenience aliases
alias dj='python2 manage.py'
alias djangoproject='django-admin.py startproject -e py,txt --template=https://github.com/wolfhechel/django-boilerplate/archive/master.zip'
alias mkdir='mkdir -p'

# Run pacman as superuser by default
alias pacman="sudo /usr/bin/pacman"

# Play it safe!
alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'

# Color support on ls and grep

if [ "$(uname)" != "Darwin" ]; then
    alias ls='ls --color'
fi

alias grep='grep --color'

# Make less accept color lines and output them as well
alias less='less -R'

# Make unified diff syntax the default
alias diff="diff -u"

# JSON prettify
alias json="python -m json.tool"

if [ "$(uname)" = "Darwin" ]; then
    _n_cpus=$(sysctl -n hw.ncpu)
else;
    _n_cpus=$(nproc)
fi

alias make="make -j${_n_cpus}"

# Alias a virtualenv command that uses Python 3 interpreter, if available
_python3_path=$(which python3)

[ $? -eq 0 ] && alias virtualenv3="virtualenv -p ${_python3_path}"
