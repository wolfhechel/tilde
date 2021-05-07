#!/bin/sh

# The overall architecture of the menu is that entry info
# contians the code to be executed for the next step. This can also
# be bash functions, so we'll build menus by creating new functions.

# root level of the menu, info
main() {
    last_upgrade_time=$(grep "\[PACMAN\] starting full system upgrade" /var/log/pacman.log | tail -1 | grep -oP '\[\K[^\]]+' | head -1)
    last_upgrade_utime=$(date '+%s' -d "$last_upgrade_time")
    current_utime=$(date '+%s')

    time_diff=$(( $current_utime - $last_upgrade_utime ))
    day_diff=$(( $time_diff / 86400 ))
    hour_diff=$(( ($time_diff - 86400 * $day_diff) / 3600 ))

    if [ $day_diff -eq 0 ]; then
        msg="System is up to date";
    else
        msg="Last update: $day_diff days, $hour_diff hours"
    fi

    echo -en "\0prompt\x1fSystem\n"
    echo -en "\0message\x1f$msg\n"

    if wifi_power_on; then
        wifi_icon=network-wireless
    else
        wifi_icon=network-wireless-offline-symbolic
    fi

    echo -en "Wi-Fi\0icon\x1f$wifi_icon\x1finfo\x1fwifi_main\n"

    if bt_power_on; then
        bt_icon=bluetooth-symbolic
    else
        bt_icon=bluetooth-disabled-symbolic
    fi

    echo -en "Bluetooth\0icon\x1f$bt_icon\x1finfo\x1fbluetooth_main\n"
    echo -en "Power Options\0icon\x1fgnome-power-manager-symbolic\x1finfo\x1fpoweroptions_main\n"
    echo -en "Lock\0icon\x1fsystem-lock-screen-symbolic\x1finfo\x1fxset s activate\n"
    echo -en "Logout\0icon\x1fsystem-log-out-symbolic\x1finfo\x1flogout\n"
    echo -en "Suspend\0icon\x1fsystem-suspend-symbolic\x1finfo\x1fsystemctl suspend\n"
    echo -en "Hibernate\0icon\x1fsystem-hibernate-symbolic\x1finfo\x1fsystemctl hibernate\n"
    echo -en "Reboot\0icon\x1fsystem-reboot-symbolic\x1finfo\x1fsystemctl reboot\n"
    echo -en "Shutdown\0icon\x1fsystem-shutdown-symbolic\x1finfo\x1fsystemctl poweroff\n"
}

# Kills all active clients before terminating the current session
logout() {
    wmctrl -lix | cut -d ' ' -f 1 | xargs -i% wmctrl -i -c %
    loginctl terminate-session $XDG_SESSION_ID
}

# Bluetooth subsystem
# @return bool, 0 for on and 1 for off
bt_power_on() {
    if bluetoothctl show | grep "Powered: yes" &>/dev/null; then
        return 0
    else
        return 1
    fi
}

bluetooth_power() {
    if bt_power_on; then
        bluetoothctl power off &>/dev/null
    else
        rfkill unblock bluetooth &> /dev/null

        bluetoothctl power on &>/dev/null
    fi

    bluetooth_main
}

bluetooth_device() {
    local address="$1"

    if bluetoothctl info "$address" | grep "Connected: yes" &>/dev/null; then
        bluetoothctl disconnect "$address" &>/dev/null
    else
        bluetoothctl connect "$address" &>/dev/null
    fi

    bluetooth_main
}


bluetooth_main() {
    echo -en "\0prompt\x1fBluetooth\n"
    echo -en "\0no-custom\x1ftrue\n"

    if bt_power_on; then
        bt_toggle=off

        bluetoothctl paired-devices | while IFS= read line; do
            address=$(echo $line | cut -d ' ' -f 2)
            name=$(echo $line | cut -d ' ' -f 3-)

            if bluetoothctl info "$address" | grep "Connected: yes" &>/dev/null; then
                icon=bluetooth-active-symbolic
            else
                icon=bluetooth-disabled-symbolic
            fi

            echo -en "$name\0icon\x1f$icon\x1finfo\x1fbluetooth_device $address\n"
        done 

        echo -en " \0nonselectable\n"
    else
        bt_toggle=on
    fi

    echo -en "Power $bt_toggle\0info\x1fbluetooth_power\n"
    echo -en "...\0info\x1fmain\x1ficon\x1fup\n"
}

# Wifi subsystem

# Connect to previous profile

wifi_power_on() {
    if rfkill list wlan -o SOFT | grep "unblocked" &> /dev/null; then
        return 0
    else
        return 1
    fi
}

wifi_power_toggle() {
    if wifi_power_on; then
        rfkill block wlan
    else
        rfkill unblock wlan
    fi

    wifi_main
}

wifi_bssid_tmp() {
    echo /run/user/$(id -u $USER)/rofi-bssid
}

wifi_connect() {
    bssid="$1"

    nmcli d wifi connect $bssid &> /dev/null

    wifi_main
}

wifi_password_prompt() {
    bssid="$1"

    echo -en "\0prompt\x1fPassword\n"
    echo -en "\0message\x1fWarning, passwords will be clear-text\n"
    echo -en "\0no-custom\x1ffalse\n"

    echo "$bssid" > $(wifi_bssid_tmp)

    echo -en "...\0info\x1fmain\n"
}

wifi_connect_password() {
    password="$1"
    bssid=$(cat $(wifi_bssid_tmp))

    nmcli d wifi connect $bssid password "$password" &> /dev/null

    wifi_main
}

wifi_rescan() {
    nmcli device wifi rescan &> /dev/null

    wifi_main
}

wifi_main() {
    echo -en "\0prompt\x1fWi-Fi\n"
    echo -en "\0message\x1f\n"
    echo -en "\0no-custom\x1ftrue\n"

    echo -en "...\0info\x1fmain\x1ficon\x1fup\n"

    if wifi_power_on; then
        echo -en "Power off\0info\x1fwifi_power_toggle\n"
    else
        echo -en "Power on\0info\x1fwifi_power_toggle\n"
        return
    fi

    echo -en "Rescan\0icon\x1freload\x1finfo\x1fwifi_rescan\n"

    nmcli -f SSID,BSSID,SECURITY,BARS -t dev wifi list | while IFS= read line; do
        ssid="$(echo $line | cut -d ':' -f 1)"
        bssid="$(echo $line | cut -d ':' -f 2-7)"
        security="$(echo $line | cut -d ':' -f 8)"
        bars="$(echo $line | cut -d ':' -f 9)"

        if [ "$ssid" == "" ]; then
            continue
        fi

        security="$(echo $security | grep -o '[^ ]*$')"

        case "$bars" in
            "****")
                icon=excellent
                ;;
            "***")
                icon=good
                ;;
            "**")
                icon=ok
                ;;
            "*")
                icon=weak
                ;;
            *)
                icon=none
                ;;
        esac

        name="$ssid"

        if [ "$security" != "" ]; then
            name="$name [$security]"
        fi

        if nmcli --get-value name c | grep "$ssid" &> /dev/null; then
            method=wifi_connect
        elif [ -z "$security" ]; then
            method=wifi_connect
        else
            method=wifi_password_prompt
        fi

        echo -en "$name\0icon\x1fnetwork-wireless-signal-$icon\x1finfo\x1f$method $bssid\n"
    done
}

# xrandr
# TODO
xrandr_mode() {
    mode=`xrandr -q | sed -n -e "/$1/,/connected/ p" \
          | tail -n+2 | head -n1 | tr -d '+*'`

    resolution=`echo $mode | cut -d' ' -f1`

    preferred_rate=0.0

    for rate in `echo $mode | cut -d' ' -f2-`; do
        if (( $(echo "$rate > $preferred_rate" | bc -l) )); then
            preferred_rate=$rate
        fi
    done

    echo --mode $resolution --rate $preferred_rate
}

display() {
    local opts
    local output=HDMI-1

    off="Off"
    only="Only"
    mirror="Mirror"
    left="Left"
    right="Right"

    opts="$off\n$only\n$mirror\n$left\n$right"


    choice=$(echo -e $opts | $rofi_command -dmenu -selected-row 1)

    args="--output eDP-1 $(xrandr_mode eDP-1) --output $output $(xrandr_mode HDMI-1)"

    case $choice in
        $off)
            args="--output $output --off"
            ;;
        $mirror)
            args="$args --same-as eDP-1"
            ;;
        $right)
            args="$args --right-of eDP-1"
            ;;
        $left)
            args="$args --left-of eDP-1"
            ;;
        $only)
            args="--output eDP-1 --off --output $output $(xrandr_mode HDMI-1)"
            ;;
    esac

    xrandr $args
}

# Power Options Menu

poweroptions_main() {
    echo -en "\0prompt\x1fPower Options\n"
    echo -en "\0message\x1f\n"
    echo -en "\0no-custom\x1ftrue\n"

    echo -en "...\0info\x1fmain\x1ficon\x1fup\n"
    echo -en "GPU\0info\x1fpowermizer_main\n"
}

## Powermizer stuff
powermizer_main() {
    echo -en "...\0info\x1fpoweroptions_main\x1ficon\x1fup\n"
    echo -en "\0prompt\x1fGPU\n"
    echo -en "Adaptive\0info\x1fpowermizer_set 0\n"
    echo -en "Maximum\0info\x1fpowermizer_set 1\n"
    echo -en "Auto\0info\x1fpowermizer_set 2\n"
}

powermizer_set() {
    nvidia-settings -a \[gpu:0\]/GpuPowerMizerMode=$1 &>/dev/null
}

if [ $ROFI_RETV -eq 0 ]; then
    main
elif [ -z "$ROFI_INFO" ]; then
    # This is uggly but works, for now the only time we're looking at freetext
    # input is when dealing with wifi passwords.

    wifi_connect_password "$1"
else
    $ROFI_INFO
fi
