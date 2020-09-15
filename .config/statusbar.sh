#!/bin/sh

read_battery() {
    BAT0_dir=/sys/class/power_supply/BAT0
    AC_dir=/sys/class/power_supply/AC

    charge_now=$(cat ${BAT0_dir}/charge_now)
    charge_full=$(cat ${BAT0_dir}/charge_full)

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

get_nmcli_parameter() {
    iface="$1"
    param="$2"

    nmcli -t -f $param device show $iface \
        | cut -d':' -f2 \
        | tr -d '[:space:]'
}


while true; do
    echo "$(get_nmcli_parameter wlp2s0 GENERAL.CONNECTION) | $(read_battery) | $(date +%H:%M)"
    sleep 1
done
