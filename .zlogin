case "${XDG_VTNR}" in
    1)  if [ -z "${WAYLAND_DISPLAY}" ] && which sway &> /dev/null; then
            export MOZ_ENABLE_WAYLAND=1
            export QT_QPA_PLATFORM=wayland
            export QT_STYLE_OVERRIDE=kvantum
            export GTK_THEME=Arc-Dark-solid
            export _JAVA_AWT_WM_NONREPARENTING=1
            exec dbus-run-session sway --unsupported-gpu
        fi
        ;;
    *)
        ;;
esac
