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

# Export language preferences
LANG=en_US.UTF-8
LC_CTYPE=en_US.UTF-8
LC_MESSAGES=en_US.UTF-8
LC_TIME=sv_SE.UTF-8
LC_NUMERIC=sv_SE.UTF-8
LC_MONETARY=sv_SE.UTF-8
LC_MEASUREMENT=sv_SE.UTF-8
LC_COLLATE=C
LC_PAPER=C
LC_NAME=C
LC_ADDRESS=C
LC_TELEPHONE=C
LC_IDENTIFICATION=C

# Set a more restrictive umask
umask 0077

export PATH \
       LANG \
       LC_CTYPE \
       LC_MESSAGES \
       LC_TIME \
       LC_NUMERIC \
       LC_MONETARY \
       LC_MEASUREMENT \
       LC_COLLATE \
       LC_PAPER \
       LC_NAME \
       LC_ADDRESS \
       LC_TELEPHONE \
       LC_IDENTIFICATION
