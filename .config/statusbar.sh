#!/bin/sh

battery_status() {
    BAT_dir=/sys/class/power_supply/$1
    AC_dir=/sys/class/power_supply/AC

    charge_now=$(cat ${BAT_dir}/charge_now)
    charge_full=$(cat ${BAT_dir}/charge_full)

    level=`echo "scale=2;(${charge_now}/${charge_full})*100" | bc | cut -d'.' -f1`

    AC_online=$(cat ${AC_dir}/online)

    if [ "${AC_online}" == "1" ]; then
        if [ "${level}" == "100" ]; then
            charging="="
        else
            charging="+"
        fi
    else
        charging="-"
    fi

    echo "[${charging}] ${level}%"
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
        *)  # Unknonw
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

line() {
    echo "CPU: $(coretemp 1) | GPU: $(nv_temp) [$(nv_powermizer)] | $(wifi_ssid wlp2s0) ($(wifi_signal_level wlp2s0)) | $(pamixer --get-volume-human) | $(battery_status BAT0) | $(date +%H:%M)"
}

while true; do 
    if ! xsetroot -name "$(line)"; then
        exit
    else
        sleep 1
    fi
done
