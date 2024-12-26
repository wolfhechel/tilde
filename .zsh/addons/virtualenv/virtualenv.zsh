# -------------------------------------
# Automatic virtual environment
# -------------------------------------

# Deactivate Virtual Environment
deactivate () {
    if [ ! -n "$VIRTUAL_ENV" ]; then
        return 1
    fi

    unset pydoc

    if [ -n "$_OLD_VIRTUAL_PATH" ] ; then
        PATH="$_OLD_VIRTUAL_PATH"
        export PATH
        unset _OLD_VIRTUAL_PATH
    fi

    rehash

    if [ -n "$_OLD_VIRTUAL_RPROMPT" ] ; then
        RPROMPT="$_OLD_VIRTUAL_RPROMPT"
        export PS1
        unset _OLD_VIRTUAL_PS1
    fi

    unset VIRTUAL_ENV
}

awk_env () {
    awk "/^setenv $1 / {print \$3}" bin/activate.csh
}

# Activate Virtual Environment
activate () {
    if [ -n "$VIRTUAL_ENV" ]; then
        return 1
    fi

    VIRTUAL_ENV="$(awk_env VIRTUAL_ENV)"

    if [ -z "${VIRTUAL_ENV}" ]; then
        return 2
    fi

    export VIRTUAL_ENV

    _OLD_VIRTUAL_PATH="$PATH"
    PATH="$VIRTUAL_ENV/bin:$PATH"
    export PATH

    VIRTUAL_ENV_PROMPT="$(awk_env VIRTUAL_ENV_PROMPT)"

    _OLD_VIRTUAL_RPROMPT="$RPROMPT"
    RPROMPT="{$VIRTUAL_ENV_PROMPT} $RPROMPT"
    export RPROMPT

    rehash
}

# Test if current directory is a virtual environment, if so ask for activation
do_virtualenv()
{
    # If bin/active is a file and VIRTUAL_ENV is unset
    # then ask for activation.
    if [ ! -n "$VIRTUAL_ENV" ] && [ -f bin/activate.csh ]; then
        activate
    fi

    # If we've left our virtual environment ask for deactivation, but only
    # once, if virtual_env_prompt_deactivate_ != no
    if [ "${PWD:0:${#VIRTUAL_ENV}}" != "${VIRTUAL_ENV}" ]; then
        deactivate
    fi
}

precmd_functions+=( do_virtualenv )
