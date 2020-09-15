fpath=($fpath $HOME/.zsh/comp)

declare -a extra_confs=(
    config
    aliases
    bindings
    commands
    prompt
    completion
    virtualenv
    path
    zsh-autosuggestions/zsh-autosuggestions
    zsh-syntax-highlighting/zsh-syntax-highlighting
)

for conf in ${extra_confs[*]}; do
    [ -f ~/.zsh/$conf.zsh ] && . ~/.zsh/$conf.zsh
done

ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)
