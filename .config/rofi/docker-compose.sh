#!/bin/sh

# The overall architecture of the menu is that entry info
# contians the code to be executed for the next step. This can also
# be bash functions, so we'll build menus by creating new functions.

# root level of the menu, info
main() {
    echo -en "\0prompt\x1fdocker\n"
    echo -en "\0message\x1f$msg\n"
    echo -en "\0use-hot-keys\x1ftrue\n"

    while read line; do
        name=$(echo $line | awk '{print $1}')
        status=$(echo $line | awk '{print $2}')
        config="$(echo $line | awk '{print $3}')"

        # dangling composer projects - how to even get rid of 'em?
        if [ "${config:0:1}" != "/" ]; then
            continue
        fi

        if [[ $status == running* ]]; then
            icon=vm-power-off
        elif [[ $status == paused* ]]; then
            icon=vm-power-on
        else
            icon=vm-power-on
        fi

        echo -en "${name} $status\0icon\x1f${icon}\x1finfo\x1f${config}:${status}\n"
    done < <(docker-compose ls -a | tail -n +2)
}

if [ $ROFI_RETV -eq 0 ]; then
    main
else
    IFS=: read config status <<< $ROFI_INFO

    if [ $ROFI_RETV -eq 1 ]; then
        case $status in
        running*)
            action=stop
            ;;

        exited*)
            action=start
            ;;

        paused*)
            action=unpause
            ;;
        *)
            action=
            ;;
        esac

        if [ ! -z "$action" ]; then
            coproc ( docker-compose -f $config $action > /dev/null 2>&1 )
        fi
    elif [ $ROFI_RETV -eq 10 ]; then
        # find first mapped port
        port=$(awk 'match($0,/[0-9]*:[0-9]/) {print substr($0, RSTART, RLENGTH-2); exit}' $config)
        coproc ( xdg-open http://127.0.0.1:${port} > /dev/null 2>&1 )
    fi
fi
