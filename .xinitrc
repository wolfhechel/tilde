#!/bin/sh

MACBOOK_DISPALY=eDP1

xrandr | grep ${MACBOOK_DISPLAY}

if [ $? -eq 0 ]; then
    xrandr --output ${MACBOOK_DISPLAY} --mode 1920x1200
fi

setxkbmap -option ctrl:nocaps

[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources

exec dwm
