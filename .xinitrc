#!/bin/sh

setxkbmap -option "lv3:alt_switch,ctrl:nocaps" se

xmodmap ~/.Xmodmap

[[ -f $HOME/.Xresources ]] && xrdb -merge $HOME/.Xresources

[[ -f $HOME/.fehbg ]] && source $HOME/.fehbg

exec qtile
