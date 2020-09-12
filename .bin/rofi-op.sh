#!/bin/sh

SESSION_KEY_FILE="$(systemd-path user-runtime)/op-session.key"

vault_name=my

[ ! -f $SESSION_KEY_FILE ] && touch $SESSION_KEY_FILE

function load_session_key() {
    export OP_SESSION_my=$(cat $SESSION_KEY_FILE)
}

function request_new_session() {
    rofi -p "Password" \
         -dmenu -input /dev/null \
         -password \
         -lines 0 \
         -disable-history \
         | op signin --raw > $SESSION_KEY_FILE
}

_failed=0

set -o pipefail

function list_items() {
    op list items | \
        jq '.[] | .overview.title + " (" + .overview.ainfo + ") | " + .uuid'
}

load_session_key

items=$(list_items)

if [ $? -gt 0 ]; then
    request_new_session
    load_session_key
    items=$(list_items)
fi

selected=$(echo "$items" \
           | tr -d '"' \
           | rofi -dmenu -p "op" -lines 40 -async-pre-read 0 -i)

item=$(echo $selected | sed 's/"//g' | cut -d '|' -f2 | tr -d '[:space:]')


if [ "$item" != "" ]; then
    op get item "$item" \
        | jq '.details.fields[] | select(.designation == "password").value' \
        | sed 's/"//g' \
        | xclip -i -sel p -f \
        | xclip -i -sel c
fi

