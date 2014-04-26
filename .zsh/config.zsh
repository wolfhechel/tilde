# Prompts for confirmation after 'rm *' etc
# Helps avoid mistakes like 'rm * o' when 'rm *.o' was intended
setopt rm_star_wait

# Background processes aren't killed on exit of shell
setopt auto_continue

# Don’t write over existing files with >, use >! instead
setopt noclobber

# Don’t nice background processes
setopt no_bg_nice

# Why 'cd dir' when you can just 'dir' ?
setopt auto_cd

# This makes cd=pushd
setopt auto_pushd

# Silence pushd messages
setopt pushdsilent

# Set default editor to vim if vim is present
if [[ -x $(which vim) ]]; then
    export EDITOR="vim"
    export USE_EDITOR=$EDITOR
    export VISUAL=$EDITOR
fi

# Set default pager to less if available
if [[ -x $(which less) ]]; then
    export PAGER="less"
    export LESS="--ignore-case --LONG-PROMPT --QUIET --chop-long-lines -Sm --RAW-CONTROL-CHARS --quit-if-one-screen --no-init"
fi

# Zsh settings for history
export HISTIGNORE="&:ls:[bf]g:exit:reset:clear:cd:cd ..:cd.."
export HISTSIZE=25000
export HISTFILE=~/.zsh_history
export SAVEHIST=10000

# New commands are written to the history file directly rather than on shell
# exit
setopt inc_append_history

# Removes older duplicates of the stored command
setopt hist_ignore_all_dups

# Don't store commands that begins with a blank
setopt hist_ignore_space

# Remove superfluos blanks from remembered commands
setopt hist_reduce_blanks

# If command involves history expansion, don't execute the line directly but
# expand the line.
setopt hist_verify

# Say how long a command took, if it took more than 30 seconds
export REPORTTIME=30

# Perl environtment configuration (not that I use it frequently)
PERL_LOCAL_LIB_ROOT="${HOME}/.perl5";
PERL_MB_OPT="--install_base ${PERL_LOCAL_LIB_ROOT}";
PERL_MM_OPT="INSTALL_BASE=${PERL_LOCAL_LIB_ROOT}";
PERL5LIB="${PERL_LOCAL_LIB_ROOT}/lib/perl5/x86_64-linux-thread-multi:${PERL_LOCAL_LIB_ROOT}/lib/perl5";
PATH="${PERL_LOCAL_LIB_ROOT}/bin:$PATH";

export PERL_LOCAL_LIB_ROOT \
       PERL_MB_OPT \
       PERL_MM_OPT \
       PERL5LIB

export PYTHONSTARTUP=$HOME/.pythonrc.py

# Locale settings, always go English!
LANG="en_US.UTF-8"
LC_ALL="en_US.UTF-8"
export LC_ALL LANG

# Which is a bit different on a Mac
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced
