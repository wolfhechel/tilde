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
