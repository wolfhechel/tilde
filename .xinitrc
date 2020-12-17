#!/bin/sh

setxkbmap -option "ctrl:nocaps" se

[ -f $HOME/.Xmodmap ] && xmodmap $HOME/.Xmodmap

[ -f $HOME/.Xresources ] && xrdb -merge $HOME/.Xresources

[ -f $HOME/.fehbg ] && source $HOME/.fehbg

# Android Studio fix on DWM
export _JAVA_AWT_WM_NONREPARENTING=1

# Set adaptable QT theme
export QT_QPA_PLATFORMTHEME=qt5ct

systemctl --user start xss-lock.service

$HOME/.config/statusbar.sh &
STATUSBAR_PID=$!

exec dwm &> $HOME/.local/dwm.log

kill $STATUSBAR_PID
