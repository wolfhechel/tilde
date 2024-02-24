#!/bin/sh

target=$1
area=$2

if [ "${area}" == "window" ]; then
    area_cmd="-g $(swaymsg -t get_tree | jq -j '.. | select(.type?) | select(.focused).rect | "\(.x),\(.y) \(.width)x\(.height)"')"
    area="window"
elif [ "${area}" == "select" ]; then
    area_cmd="-g $(slurp)"
    area="selection"
else
    area_cmd="-o $(swaymsg -t get_outputs | jq -r '.[] | select(.focused) | .name')"
    area="display"
fi

if [ "${target}" != "clipboard" ]; then
    target=$(date +'%s_grim.png')
    grim $area_cmd "$(xdg-user-dir PICTURES)/${target}"
else
    grim $area_cmd - | wl-copy
fi

echo "Saved ${area} to ${target}"
