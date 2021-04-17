#!/bin/sh

notes_dir=~/Documents/Notes

is_encrypted() {
    path="$1"
    if [ "${path##*.}" == "gpg" ]; then
        return 0
    else
        return 1
    fi
}

main() {
    echo -en "\0prompt\x1fNote\n"
    echo -en "\0message\x1f\n"
    IFS=$'\n'; for note in $(cd $notes_dir; find . -type f); do
        note="${note#*/}"

        if is_encrypted "$note"; then
            icon=object-locked
        else
            icon=object-unlocked
        fi
        
        echo -en "$note\0icon\x1f$icon\n"
    done
}

delete_prompt() {
    note="$@"
    
    echo -en "\0message\x1fAre you sure?\n"
    echo -en "Yes\0info\x1fdelete $note\n"
    echo -en "No\0info\x1fmain\n"
}

delete() {
    note="$@"

    rm "$notes_dir/$note"
    main
}

decrypt() {
    note="$@"
    note_path="$notes_dir/$note"
    mv_note="${note_path%.*}"

    coproc ( gpg -o "$mv_note" -d "$note_path" && \
             rm "$note_path" ) &>/dev/null 2>&1
}

encrypt() {
    note="$@"
    note_path="$notes_dir/$note"
    mv_note="$note_path".gpg

    gpg --default-recipient-self \
        -o "$mv_note" -e "$note_path" &>/dev/null 2>&1 && \
        rm $note_path

    main
}

menu() {
    note="$note"
    echo -en "\0message\x1f$note\n"

    echo -en "...\0icon\x1fup\x1finfo\x1fmain\n"

    echo -en "Delete\0icon\x1fremove\x1finfo\x1fdelete_prompt $note\n"
    
    if is_encrypted "$note"; then
        echo -en "Decrypt\0icon\x1fobject-unlock\x1finfo\x1fdecrypt $note\n"
    else
        echo -en "Encrypt\0icon\x1fobject-lock\x1finfo\x1fencrypt $note\n"
    fi
}

open() {
    note="$@"

    if [ $ROFI_RETV -eq 10 ]; then
        menu "$note"
    else
        coproc ( gvim "$notes_dir/$note" &> /dev/null 2>&1 )
    fi
}

if [ $ROFI_RETV -eq 0 ]; then
    main
else
    if [ ! -z "$ROFI_INFO" ]; then
        $ROFI_INFO
    else
        open "$@"
    fi
fi
