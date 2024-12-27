# XDG Default Paths
export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
export XDG_CACHE_HOME=${XDG_CACHE_HOME:-$HOME/.cache}
export XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}
export XDG_STATE_HOME=${XDG_STATE_HOME:-$HOME/.local/state}
export XDG_RUNTIME_DIR=${XDG_RUNTIME_DIR:-/run/user/$UID}

# Move legacy paths to XDG

# Golang
export GOPATH="$XDG_DATA_HOME/go"
export GOMODCACHE="$XDG_CACHE_HOME/go-mod"

# Docker
export DOCKER_CONFIG="$XDG_CONFIG_HOME/docker"

# npm
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"

# screen
export SCREENRC="$XDG_CONFIG_HOME/screen/screenrc"
export SCREENDIR="$XDG_RUNTIME_DIR/screen"

# Wine
export WINEPREFIX="$XDG_DATA_HOME/wine/default"

# W3M
export W3M_DIR="$XDG_CONFIG_HOME/w3m"

# R
R_HOME_USER="${XDG_CONFIG_HOME}/R"
R_PROFILE_USER="${R_HOME_USER}/profile"
R_ENVIRON_USER="${R_HOME_USER}/environ"
R_HISTFILE="${XDG_STATE_HOME}/Rhistory"

# Perl environment configuration
export PERL_LOCAL_LIB_ROOT="${XDG_STATE_HOME}/perl5";
export PERL_MB_OPT="--install_base ${PERL_LOCAL_LIB_ROOT}";
export PERL_MM_OPT="INSTALL_BASE=${PERL_LOCAL_LIB_ROOT}";
export PERL5LIB="${PERL_LOCAL_LIB_ROOT}/lib/perl5/x86_64-linux-thread-multi:${PERL_LOCAL_LIB_ROOT}/lib/perl5";

# Set user paths
_paths_to_try=(
    "${HOME}/.bin"
    "${HOME}/.wp-cli/bin"
    "${HOME}/.local/bin"
    "${PERL_LOCAL_LIB_ROOT}/bin"
)

for path_to_try in ${_paths_to_try}; do
    if [ -d $path_to_try ]; then
        PATH="${path_to_try}:${PATH}"
    fi
done

if which brew &> /dev/null; then
    _brew_prefix="$(brew --prefix)"
    PATH="$PATH:${_brew_prefix}/bin:${_brew_prefix}/sbin"
fi

if [ -d $HOME/.gem ]; then
    for _path in $HOME/.gem/ruby/*/bin; do 
        PATH="${_path}:${PATH}"
    done &>/dev/null
fi

[ ! -d ${XDG_STATE_HOME}/zsh ] && mkdir -p "${XDG_STATE_HOME}/zsh"

# History configuration
export HISTIGNORE="&:ls:[bf]g:exit:reset:clear:cd:cd ..:cd.."
export HISTSIZE=25000
export HISTFILE=${XDG_STATE_HOME}/zsh/history
export SAVEHIST=10000

# Set a more restrictive umask
umask 0077

# Set default editor to vim if vim is present
if which vim &> /dev/null; then
    export EDITOR="vim"
    export USE_EDITOR=$EDITOR
    export VISUAL=$EDITOR
fi

# Set default pager to less if available
if which less &> /dev/null; then
    export PAGER="less"
    export LESS="--ignore-case --LONG-PROMPT --QUIET --chop-long-lines -Sm --RAW-CONTROL-CHARS --quit-if-one-screen --no-init"
fi

[ "${TTY}" != "/dev/tty" ] && export GPG_TTY="${TTY}"

unset SSH_AGENT_PID

if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
  export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
fi
