#!/bin/bash

rofi_command="rofi -theme styles/powermenu.rasi"

# Options
shutdown="Poweroff"
reboot="Reboot"
suspend="Suspend"
lock="Lock"
logout="Logout"
bluetooth="Bluetooth"
wifi="Wi-Fi"

# Variable passed to rofi
options="$shutdown\n$reboot\n$suspend\n$lock\n$logout\n$wifi\n$bluetooth"

if btmgmt info | grep "current settings" | grep powered &>/dev/null; then
    bt_toggle=off
    urgent_rows=6,
else
    urgent_rows=
    bt_toggle=on
fi

if [ "$(nmcli -t -f WIFI radio)" == "enabled" ]; then
    urgent_rows=${urgent_rows},5
fi

chosen="$(echo -e "$options" | $rofi_command -dmenu -selected-row 5 -u "$urgent_rows")"

case $chosen in
    $shutdown)
        systemctl poweroff
        ;;
    $reboot)
        systemctl reboot
        ;;
    $suspend)
        systemctl suspend
        ;;
    $lock)
        xset s activate
        ;;
    $logout)
        wmctrl -lix | cut -d ' ' -f 1 | xargs -i% wmctrl -i -c %
        loginctl terminate-session $XDG_SESSION_ID
        ;;
    $bluetooth)
        bluetoothctl power $bt_toggle
        ;;
    $wifi)
        `dirname $(realpath $0)`/wifi.sh
        ;;
esac
