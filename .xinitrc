#!/bin/sh

# Load system-wide xinitrc configurations
for xinitrc in /etc/X11/xinit/xinitrc.d/*; do
    . $xinitrc
done

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

# For socket activated rxvt
export RXVT_SOCKET="$XDG_RUNTIME_DIR/urxvtd-$(uname -n)"

systemctl --user import-environment
systemctl --user start user-graphical-session.target

exec dwm &> ${XDG_RUNTIME_DIR}/dwm.log
