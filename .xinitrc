#!/bin/sh

# Load system-wide xinitrc configurations
for xinitrc in /etc/X11/xinit/xinitrc.d/*; do
    . $xinitrc
done

# Use caps as ctrl, because why caps
setxkbmap -option "ctrl:nocaps" se

# Load custom keymap
[ -f $HOME/.Xmodmap ] && xmodmap $HOME/.Xmodmap

# Load local .xresources
[ -f $HOME/.Xresources ] && xrdb -merge $HOME/.Xresources

# Set our fancy wallpaper
[ -f $HOME/.fehbg ] && source $HOME/.fehbg

# Android Studio fix on DWM
export _JAVA_AWT_WM_NONREPARENTING=1

# QT and GTK theme setup
export QT_STYLE_OVERRIDE=kvantum
export GTK_THEME=Arc-Dark-solid

# This is pretty much to load xss-lock
systemctl --user start xss-lock.service

$HOME/.config/statusbar.sh &>/dev/null &
STATUSBAR_PID=$!

exec dwm &> $HOME/.local/dwm.log

kill -9 $STATUSBAR_PID
