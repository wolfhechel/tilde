#!/bin/sh

setxkbmap -option "ctrl:nocaps" se

[ -f $HOME/.Xmodmap ] && xmodmap $HOME/.Xmodmap

[ -f $HOME/.Xresources ] && xrdb -merge $HOME/.Xresources

[ -f $HOME/.fehbg ] && source $HOME/.fehbg

exec dwm
