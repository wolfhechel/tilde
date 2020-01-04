#!/bin/sh

setxkbmap -option "ctrl:nocaps" se

[ -f $HOME/.Xmodmap ] && xmodmap $HOME/.Xmodmap

[ -f $HOME/.Xresources ] && xrdb -merge $HOME/.Xresources

[ -f $HOME/.fehbg ] && source $HOME/.fehbg

(bash $HOME/.config/battery-status.sh | while read LINE; do xsetroot -name "${LINE}"; done) &

exec dwm
