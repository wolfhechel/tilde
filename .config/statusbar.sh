#!/bin/sh

battery_status() {
    BAT_dir=/sys/class/power_supply/$1
    AC_dir=/sys/class/power_supply/AC

    charge_now=$(cat ${BAT_dir}/charge_now)
    charge_full=$(cat ${BAT_dir}/charge_full)

    level=`echo "scale=2;(${charge_now}/${charge_full})*100" | bc | cut -d'.' -f1`

    AC_online=$(cat ${AC_dir}/online)

    if [ "${AC_online}" == "1" ]; then
        charging="~"
    else
        charging=""
    fi

    echo "${level}%${charging}"
}


wifi_ssid() {
    nmcli -t -f GENERAL.CONNECTION device show $1 \
        | cut -d':' -f2
}

wifi_signal_level() {
    interface=$1
    
    cat /proc/net/wireless | awk -F' ' '$1 == "wlp2s0:" { print $4 }' \
        | sed 's/\./dBm/g'
}

function wifi_signal_strength() {
    interface=wlp2s0
    worst_rssi=-85
    perfect_rssi=-20

    current_rssi=$(cat /proc/net/wireless | grep $interface | tr -s ' ' | tr -d '.' | cut -d' ' -f4)

    nr=$(( $perfect_rssi - $worst_rssi ))
    dr=$(( $perfect_rssi - $current_rssi ))

    quality=$(( $(( 100 * $nr * $nr - $dr * $(( 15 * $nr + 62 * $dr )) )) / $(( $nr * $nr )) ))

    echo "${quality}%"
}

nv_temp() {
    nvidia-smi stats -d temp -c 1 | cut -d' ' -f8
}

nv_powermizer() {
    case $(nvidia-settings -t -q \[gpu:0\]/GpuPowerMizerMode) in
        0)  # Adaptive
            echo "~"
            ;;
        1)  # Maximum
            echo !
            ;;
        2)  # Auto
            echo A
            ;;
        *)  # Unknown
            echo ?
            ;;
    esac
}

coretemp_hwmon=

for file in /sys/class/hwmon/hwmon*/name; do
    name=$(cat $file)

    if [ "${name}" == "coretemp" ]; then
        coretemp_hwmon=${file%/*}
    fi
done

coretemp() {
    echo $(cat ${coretemp_hwmon}/temp${1}_input) / 1000 | bc
}

bt_power() {
    if bluetoothctl show | grep "Powered: yes" &>/dev/null; then
        echo "1"
    else
        echo "0"
    fi
}

new_mail() {
    notmuch count folder:INBOX AND tag:unread
}

date_() {
    date "+%m/%d %H:%M"
}

function cpufreq() {
    count=0
    total=0

    values="$(cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_cur_freq)"

    min=$(echo $values | cut -d' ' -f1)
    max=0

    for hz in $values; do
        if [ "$hz" -lt "$min" ]; then
            min="$hz"
        fi

        if [ "$hz" -gt "$max" ]; then
            max="$hz"
        fi

        total=$(echo $total+$hz/10^6| bc)
        ((count++))
    done

    min=$(echo "scale=1; $min/10^6" | bc | xargs printf '%.1f')
    max=$(echo "scale=1; $max/10^6" | bc | xargs printf '%.1f')

    mean=$(echo "scale=1; $total/$count" | bc | xargs printf '%.1f')

    echo $min $mean $max
}

function freemem() {
    cat /proc/meminfo | \
        grep MemFree | tr -s ' ' | cut -d' ' -f2 \
        | xargs -I {} echo 'scale=1; {}/1024^2' | bc
}

line() {
    echo "$(cpufreq) | $(freemem)G | $(coretemp 1) | $(nv_temp) [$(nv_powermizer)] | $(wifi_ssid wlp2s0) ($(wifi_signal_strength wlp2s0)) | $(pamixer --get-volume-human) | $(battery_status BAT0) | $(date_)"
}

while true; do 
    if ! xsetroot -name "$(line)"; then
        exit
    else
        sleep 1
    fi
done
