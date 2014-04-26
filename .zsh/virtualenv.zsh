# -------------------------------------
# Automatic virtual environment
# -------------------------------------


# Deactivate Virtual Environment
deactivate () {
    if [ ! -n "$VIRTUAL_ENV" ]; then
        echo "There's no active virtual environment to deactivate!" 1>&2
        return 1
    fi

    unset pydoc

    if [ -n "$_OLD_VIRTUAL_PATH" ] ; then
        PATH="$_OLD_VIRTUAL_PATH"
        export PATH
        unset _OLD_VIRTUAL_PATH
    fi

    if [ -n "$_OLD_VIRTUAL_PYTHONHOME" ] ; then
        PYTHONHOME="$_OLD_VIRTUAL_PYTHONHOME"
        export PYTHONHOME
        unset _OLD_VIRTUAL_PYTHONHOME
    fi

    rehash

    if [ -n "$_OLD_VIRTUAL_RPROMPT" ] ; then
        RPROMPT="$_OLD_VIRTUAL_RPROMPT"
        export PS1
        unset _OLD_VIRTUAL_PS1
    fi

    unset VIRTUAL_ENV
}

# Activate Virtual Environment
activate () {
    if [ -n "$VIRTUAL_ENV" ]; then
        echo Another Virtual Environment is already in use! 1>&2
        return 1
    fi

    if [ -n "${1}" ]; then
        VIRTUAL_ENV="$(sed -e '/VIRTUAL_ENV=/!d' -e 's/VIRTUAL_ENV=\"\(.*\)\"/\1/' bin/activate)"
    else
        VIRTUAL_ENV="${1}"
    fi
    export VIRTUAL_ENV

    _OLD_VIRTUAL_PATH="$PATH"
    PATH="$VIRTUAL_ENV/bin:$PATH"
    export PATH

    if [ -n "$PYTHONHOME" ] ; then
        _OLD_VIRTUAL_PYTHONHOME="$PYTHONHOME"
        unset PYTHONHOME
    fi

    _OLD_VIRTUAL_RPROMPT="$RPROMPT"
    RPROMPT="{`basename \"$VIRTUAL_ENV\"`} $RPROMPT"
    export RPROMPT

    alias pydoc="python -m pydoc"

    rehash
}

# Test if current directory is a virtual environment, if so ask for activation
do_virtualenv()
{
    # If bin/active is a file and both VIRTUAL_ENV and virtual_env_ignore_ is unset
    # then ask for activation.
    if [ ! -n "$VIRTUAL_ENV" ] && [ ! -n "${virtual_env_ignore_}" ] && [ -f bin/activate ]; then
        VIRTUAL_ENV_NAME="$(sed -e '/VIRTUAL_ENV=/!d' -e 's/VIRTUAL_ENV=\"\(.*\)\"/\1/' bin/activate)"

        activate "$VIRTUAL_ENV_NAME" 
    fi

    # If we've left our virtual environment ask for deactivation, but only
    # once, if virtual_env_prompt_deactivate_ != no
    if [ "${PWD:0:${#VIRTUAL_ENV}}" != "${VIRTUAL_ENV}" ]; then
        deactivate
    fi
}

precmd_functions+=( do_virtualenv )
