# Always use emacs bindings
bindkey -e

# Shift-tab do reverse menu completion
bindkey '^[[Z' reverse-menu-complete

# Not sure I need these anymore.
# bindkey "\e[1~" beginning-of-line
# bindkey "\e[2~" quoted-insert
# bindkey "\e[3~" delete-char
# bindkey "\e[4~" end-of-line
# bindkey "\e[5~" beginning-of-history
# bindkey "\e[6~" end-of-history

# Bind delete key properly
bindkey    "^[[3~"          delete-char

# Insert sudo on beginning-of-line with Meta-s
insert_sudo () { zle beginning-of-line; zle -U "sudo " }
zle -N insert-sudo insert_sudo
bindkey "^[s" insert-sudo

# popd on Meta-p
go_back() {
    popd &> /dev/null
    zle reset-prompt
}

zle -N go-back go_back

bindkey "^[p" go-back

slash-backward-kill-word() {
    local WORDCHARS="${WORDCHARS:s@/@}"
    zle backward-kill-word
}
zle -N slash-backward-kill-word
bindkey '\e^?' slash-backward-kill-word