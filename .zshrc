fpath=($fpath $HOME/.zsh/comp)

for conf in config aliases bindings commands prompt completion virtualenv path gcloud node_modules; do
    . ~/.zsh/$conf.zsh
done

_host=$(hostname -s)

_more_zsh_file="$HOME/.zshrc.${_host}"

if [ -f ${_more_zsh_file} ]; then
    . ${_more_zsh_file}
fi
