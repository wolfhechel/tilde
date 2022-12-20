if [ -z "${DISPLAY}" ];then
    if [ "${XDG_VTNR}" -eq 1 ]; then
        export MOZ_ENABLE_WAYLAND=1
        export QT_QPA_PLATFORM=wayland
        exec dbus-run-session sway --unsupported-gpu
    elif [ "${XDG_VTNR}" -eq 2 ]; then
        exec ~/.config/startx "sh $HOME/.xinitrc"
    fi
fi
