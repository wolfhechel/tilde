fpath=($fpath $HOME/.zsh/comp)

<<<<<<< HEAD
for conf in config aliases bindings commands prompt completion virtualenv path; do
=======
for conf in config aliases bindings commands prompt completion virtualenv path gcloud node_modules; do
>>>>>>> a77c68258b6176d4677508d865ed5364d7f4912d
    . ~/.zsh/$conf.zsh
done

_host=$(hostname -s)

_more_zsh_file="$HOME/.zshrc.${_host}"

if [ -f ${_more_zsh_file} ]; then
    . ${_more_zsh_file}
fi
