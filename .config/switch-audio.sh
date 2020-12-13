#!/bin/sh
#
# This script is a bit dumb as it assumes a single sink,
# Wonder what happens when I plugin an HDMI cable?
#

export LC_ALL=C

HEADPHONES_SINK_INDEX=0
HEADPHONES_SINK_PORT=analog-output-headphones

HEADPHONES_SOURCE_INDEX=1
HEADPHONES_SOURCE_PORT=analog-input-headset-mic

# get_port_availablity <sink|source> NAME
get_port_availability() {
	pacmd list-${1}s | grep "${2}" | grep -oP 'available: \K\w+'
}

pactl subscribe | while read _ facility _ type index ; do
    if [[ "${facility}" == "'change'" && "${type}" == "card" ]]; then
    	if [[ "$(get_port_availability sink $HEADPHONES_SINK_PORT)" == "unknown" ]]; then
    		pacmd set-sink-port $HEADPHONES_SINK_INDEX $HEADPHONES_SINK_PORT
    	fi

    	if [[ "$(get_port_availability source $HEADPHONES_SOURCE_PORT)" == "unknown" ]]; then
    		pacmd set-source-port $HEADPHONES_SOURCE_INDEX $HEADPHONES_SOURCE_PORT
    	fi
    fi
done