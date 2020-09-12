#!/bin/sh

selected=$(nmcli -f SSID,BARS,SECURITY -t dev wifi list | while read LINE; do
    ssid="$(echo $LINE | cut -d':' -f1)"
    bars="$(echo $LINE | cut -d':' -f2)"
    security="$(echo $LINE | cut -d':' -f3)"

    if [ "$ssid" != "" ]; then
        echo -n "$bars $ssid"

        if [ "$security" != "" ]; then
            security=$(echo $security | grep -o '[^ ]*$')

            echo " ($security)"
        else
            echo ""
        fi
    fi
done | rofi -dmenu -async-pre-read 0 -theme styles/wifi)

if [ -z "$selected" ]; then
    exit
fi

ssid=$(echo $selected | cut -d' ' -f2)

security=$(echo $selected| cut -d' ' -f3 | tr -d '()')

if nmcli -t -f name c | grep "$ssid" &>/dev/null; then
    # Profile exists already, no pw needed
    NEED_PASSWORD=0
elif [ -z "$security" ]; then
    # Network is not protected, no pw needed
    NEED_PASSWORD=0
else
    NEED_PASSWORD=1
fi

if [ $NEED_PASSWORD -eq 1 ]; then
    password="$(rofi -dmenu -p Password -password -lines 0)"

    if [ -z "$password" ]; then
        exit
    else
        pass="password $password"
    fi
else
    pass=""
fi

nmcli d wifi connect "$ssid" $pass &
