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
    gcloud
    zsh-autosuggestions/zsh-autosuggestions
    zsh-syntax-highlighting/zsh-syntax-highlighting
)

for conf in ${extra_confs[*]}; do
    [ -f ~/.zsh/$conf.zsh ] && . ~/.zsh/$conf.zsh
done

ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)

_host=$(hostname -s)

_more_zsh_file="$HOME/.zshrc.${_host}"

if [ -f ${_more_zsh_file} ]; then
    . ${_more_zsh_file}
fi
