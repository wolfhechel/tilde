#!/bin/sh

# 
active_window=$(xprop -root _NET_ACTIVE_WINDOW | grep -o '\([^ ]*\)$')
active_pid=$(xprop -id $active_window _NET_WM_PID | grep -o '\([0-9]*\)$')

SinkInput=$(pactl list sink-inputs | \
    grep -e 'Sink Input' -e application.process.id | \
    sed -e 's/\s//g' -e 's/#/=/g' | \
    while read LINE; do
    
    PROP=${LINE%%=*}
    VALUE=${LINE##*=}

    case "$PROP" in
        SinkInput)
            SinkInput=$VALUE
        ;;

        application.process.id)
            VALUE=$(echo $VALUE | tr -d '"')
            if [ "$VALUE" == "$active_pid" ]; then
                echo $SinkInput
                break
            fi
        ;;

        *)
        ;;
    esac
done)

if [ ! -z "$SinkInput" ]; then
    if [ "$1" == "mute" ]; then
        pactl set-sink-input-mute $SinkInput toggle
    else
        pactl set-sink-input-volume $SinkInput "$1"
    fi
fi
