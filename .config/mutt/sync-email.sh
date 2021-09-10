#!/bin/sh

if [ "$1" == "quiet" ]; then
    out=/dev/null
else
    out=/dev/stdout
fi

(
    if mbsync -R -a; then
        notmuch new
        notmuch tag +deleted folder:Trash
    fi
) 1>$out
