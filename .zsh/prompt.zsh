autoload -Uz vcs_info

# Enables parameter expansion in prompt string
setopt prompt_subst

# VCS styling
zstyle ':vcs_info:*' enable svn hg bzr git
zstyle ':vcs_info:*' actionformats '[%F{green}%s:%b, %a%f]'
zstyle ':vcs_info:*' formats '[%F{green}%s:%b%f]'
zstyle ':vcs_info:(svn|bzr):*' branchformat '%b:%r'
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:svn:*' check-for-changes true

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
