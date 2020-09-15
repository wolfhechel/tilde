#!/bin/sh

setxkbmap -option "ctrl:nocaps" se

[ -f $HOME/.Xmodmap ] && xmodmap $HOME/.Xmodmap

[ -f $HOME/.Xresources ] && xrdb -merge $HOME/.Xresources

[ -f $HOME/.fehbg ] && source $HOME/.fehbg

(bash $HOME/.config/statusbar.sh | while read LINE; do xsetroot -name "${LINE}" &>/dev/null; done) &

# Android Studio fix on DWM
export _JAVA_AWT_WM_NONREPARENTING=1

exec dwm
