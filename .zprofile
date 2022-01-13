# Set user paths

_paths_to_try=(
    "${HOME}/.bin"
    "${HOME}/.wp-cli/bin"
)

for path_to_try in ${_paths_to_try}; do
    if [ -d $path_to_try ]; then
        PATH="${path_to_try}:${PATH}"
    fi
done

if [ -d ~/.gem ]; then
    for _path in ~/.gem/ruby/*/bin; do 
        PATH="${_path}:${PATH}"
    done &>/dev/null
fi

if which brew &> /dev/null; then
    _brew_prefix="$(brew --prefix)"
    PATH="$PATH:${_brew_prefix}/bin:${_brew_prefix}/sbin"
fi

# Set a more restrictive umask
umask 0077

SUDO_ASKPASS=$HOME/.config/sudo-askpass.sh

export PATH
export SUDO_ASKPASS
