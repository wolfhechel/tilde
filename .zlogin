case "${XDG_VTNR}" in
    1)  if [ -z "${WAYLAND_DISPLAY}" ] && which sway &> /dev/null; then
            export MOZ_ENABLE_WAYLAND=1
            export QT_QPA_PLATFORM=wayland
            exec dbus-run-session sway --unsupported-gpu
        fi
        ;;
    2)  if [ -z "${DISPLAY}" ] && which Xorg &> /dev/null; then
            exec ~/.config/startx "sh $HOME/.xinitrc"
        fi
        ;;
    *)
        ;;
esac
