fpath=($HOME/.zsh/comp $fpath)

autoload -Uz vcs_info
autoload -Uz compinit && compinit -d ${XDG_CACHE_HOME}/zsh/zcompdump-$ZSH_VERSION
autoload bashcompinit && bashcompinit

setopt rm_star_wait # Prompts for confirmation after commands like rm *
setopt auto_continue # Background processes aren't killed on exit of shell
setopt noclobber # Don’t write over existing files with >, use >! instead
setopt no_bg_nice # Don’t nice background processes
setopt auto_cd # Why 'cd dir' when you can just 'dir' ?
setopt auto_pushd # This makes cd=pushd
setopt pushdsilent # Silence pushd messages
setopt inc_append_history # New commands are written to the history file directly
setopt hist_ignore_all_dups # Removes older duplicates of the stored command
setopt hist_ignore_space # Don't store commands that begins with a blank
setopt hist_reduce_blanks # Remove superfluos blanks from remembered commands
setopt hist_verify # Expand commands involving history expansion
setopt prompt_subst # Enables parameter expansion in prompt string
unsetopt LIST_AMBIGUOUS # Enable completion for unambiguous pre- or suffix
setopt COMPLETE_IN_WORD # Complete from both ways when cursor is in the middle

# Say how long a command took, if it took more than 30 seconds
REPORTTIME=30

# Count background jobs on right prompt
RPROMPT='%(0j.%j.)'

# Enable right prompt VCS integration
if vcs_info &>/dev/null; then
    precmd_functions+=( vcs_info )
    RPROMPT+=' ${vcs_info_msg_0_}'
fi

# Sets prompts
PS1="%B%F{green}%n@%m%k %B%F{cyan}%(4~|...|)%3~%F{white} %F{magenta}[%F{white}%?%F{magenta}]%F{white} %# %b%f%k"
PS2="%B%F{green}%n@%m%k %B%F{cyan}%(4~|...|)%3~%F{white} %_> %b%f%k"
PS3="%B%F{green}%n@%m%k %B%F{cyan}%(4~|...|)%3~%F{white} ?# %b%f%k"
PS4="+%N:%i> "

export PS{1..4}

# Array of bash-completion scripts to attempt to enable
_bash_completions=(
    "${HOME}/.wp-cli/vendor/wp-cli/wp-cli/utils/wp-completion.bash"
)

for comp_script in ${_bash_completions}; do
    [ -f $comp_script ] && source $comp_script
done

# Prompt before overwrite or removal
alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'

# Colorize commands
alias ls='ls --color'
test -r ~/.config/dir_colors && eval $(dircolors ~/.config/dir_colors)

export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
    --color=fg:#e5e9f0,bg:#3b4252,hl:#81a1c1
    --color=fg+:#e5e9f0,bg+:#3b4252,hl+:#81a1c1
    --color=info:#eacb8a,prompt:#bf6069,pointer:#b48dac
    --color=marker:#a3be8b,spinner:#b48dac,header:#a3be8b'

alias grep='grep --color'
alias less='less -R'

TILDE_DIR="${XDG_STATE_DIR:-${HOME}/.local/state}/tilde.git"

if [ -d "${TILDE_DIR}" ]; then
    alias tilde='git --git-dir="${TILDE_DIR}" --work-tree=$HOME'
    compdef _git tilde
fi

diemf()
{
    local search_proc=$1
    kill -9 $(ps aux | grep "${search_proc}" | grep -v grep | awk '{print $2}')
}

if which makepkg &> /dev/null; then
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
fi
# Always use emacs bindings
bindkey -e

# Shift-tab do reverse menu completion
bindkey '^[[Z'  reverse-menu-complete

# Bind delete key properly
bindkey '^[[3~' delete-char

# Automatically replace > 2 dots with slashed paths
rationalise-dot() {
  if [[ $LBUFFER = *.. ]]; then
    LBUFFER+=/..
  else
    LBUFFER+=.
  fi
}

zle -N rationalise-dot
bindkey . rationalise-dot

# Makes longrunning completion hold with pending dots "..."
expand-or-complete-with-dots() {
  echo -n "\e[31m......\e[0m"
  zle expand-or-complete
  zle redisplay
}

zle -N expand-or-complete-with-dots
bindkey "^I" expand-or-complete-with-dots

_force_rehash() {
  (( CURRENT == 1 )) && rehash
  return 1  # Because we didn't really complete anything
}

# Completion styling
zstyle ':completion:*' menu select
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' verbose yes
zstyle ':completion:*' group-name ''
zstyle ':completion:*' completer _expand _force_rehash _complete _approximate _ignored
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' file-sort modification reverse
zstyle ':completion:*' list-colors "=(#b) #([0-9]#)*=36=31"
zstyle ':completion:*' ignore-parents parent pwd
zstyle ':completion:*' list-separator '--'
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion:*' cache-path ${XDG_CACHE_HOME}/zsh/zcompdump
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*:corrections' format '%B%d (errors %e)%b'
zstyle ':completion:*:default' list-prompt '%S%M matches%s'
zstyle ':completion:*:default' menu 'select=0'
zstyle ':completion:*:manuals' separate-sections true
zstyle ':completion:*:windows' menu on=0
zstyle ':completion:*:expand:*' tag-order all-expansions
zstyle ':completion:*:approximate:*' max-errors 'reply=(  $((  ($#PREFIX+$#SUFFIX)/3  ))  )'
zstyle ':completion::approximate*:*' prefix-needed false
zstyle ':completion::*:(rm|vi):*' ignore-line true
zstyle ':completion:*:kill:*' force-list always
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'

# VCS styling
zstyle ':vcs_info:*' enable svn hg bzr git
zstyle ':vcs_info:*' actionformats '[%F{green}%s:%b, %a%f]'
zstyle ':vcs_info:*' formats '[%F{green}%s:%b%f]'
zstyle ':vcs_info:(svn|bzr):*' branchformat '%b:%r'
zstyle ':vcs_info:git:*' check-for-changes false
zstyle ':vcs_info:svn:*' check-for-changes false

for _addon in ~/.zsh/addons/*; do
    source ${_addon}/${_addon##*/}.zsh
done

ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)

eval "$(register-python-argcomplete pipx)"
